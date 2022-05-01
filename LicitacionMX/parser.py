#!/usr/bin/python
# coding: iso-8859-15

import datetime
import json
import logging
import time
from pathlib import Path
import re
import sys
import psycopg2
import requests

from configuration import config
from models import LicitacionMX

log_file = "logs/parserMX" + datetime.datetime.now().strftime("%Y%m%d-%H-%M-%S") + '.log'
logging.basicConfig(filename=log_file, encoding='utf-8', level=logging.DEBUG)

DATETIME_FORMAT = '%Y-%m-%dT%H:%M:%SZ'
RAMO_ROLE = 'buyer'
UC_ROLE = 'procuringEntity'
CUCOP_LABEL = 'Partida Específica'
URL_API_MX = 'https://api.datos.gob.mx/v2/contratacionesabiertas'
DELAY = 1.5
MAX_PAGE = 3003

def get_from_web(url):
    response = requests.get(url)
    todos = json.loads(response.text)
    return todos

def get_from_file(file_name):
    with open(file_name, "r") as read_file:
        data = json.load(read_file)
        return data

def save_json(data_json, file_name):
    # Write filtered TODOs to file.
    with open(file_name, "w") as data_file:
        json.dump(data_json, data_file, indent=2)

def insert_licitaciones(licitaciones):
    """ Insertar una licitacion en la tabla SQL """
    sql = """INSERT INTO licitacion_mx(id_licitacion_mx, id_cucop, identificador, id_publicacion, ocid, titulo, descripcion, 
    cucops, clave_dependencia, dependencia, clave_unidad_compradora, unidad_compradora, estatus, uri, fecha, origen) 
    VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s) ON CONFLICT DO NOTHING;"""


    conn = None
    student_id = None
    try:
        # read database configuration
        params = config.config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a new cursor
        cur = conn.cursor()
        # execute the INSERT statement

        for licitacion in licitaciones:
            logging.info('Guardando licitacion: %s', licitacion.codigo_expediente)
            cucop = None
            cucops = None
            if len(licitacion.cucops) == 1:
                cucop = licitacion.cucops[0]
            if len(licitacion.cucops) > 1:
                cucops = ";".join(licitacion.cucops)
            if len(licitacion.cucops) == 0:
                logging.warning('Licitacion OCID: %s No contiene CUCOPS', licitacion.ocid)
            cur.execute(sql, (licitacion.codigo_expediente, cucop, licitacion.id, licitacion.id_publicacion,
                              licitacion.ocid, licitacion.titulo, licitacion.descripcion, cucops, licitacion.id_dependencia,
                              licitacion.dependencia, licitacion.clave_uc, licitacion.nombre_uc, licitacion.estatus,
                              licitacion.uri, licitacion.fecha, licitacion.origen))

        # commit the changes to the database
        conn.commit()
        # close communication with the database
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        logging.error(error)
    finally:
        if conn is not None:
            conn.close()

    return student_id

def get_licitaciones_from_json_file(file_name):
    data = get_from_file(file_name)
    licitaciones = []
    for result in data.get('results'):
        record = result.get('records')[0]
        licitacion = LicitacionMX(result.get('_id'), file_name)

        compiledRelease = record.get('compiledRelease')
        tender = compiledRelease.get('tender')
        contracts = compiledRelease.get('contracts')
        parties = compiledRelease.get('parties')

        licitacion.ocid = compiledRelease.get('ocid')
        licitacion.uri = result.get('uri')
        licitacion.id_publicacion = compiledRelease.get('id')
        licitacion.fecha = datetime.datetime.strptime(compiledRelease.get('date'), DATETIME_FORMAT)
        licitacion.codigo_expediente = tender.get('id')
        licitacion.titulo = re.sub('\s+', " ", tender.get('title')) if tender.get('title') else None
        licitacion.descripcion = re.sub('\s+', " ", tender.get('description')) if tender.get('description') else None
        licitacion.estatus = tender.get('status')

        logging.info('Procesando licitacion: %s - %s',licitacion.ocid, licitacion.codigo_expediente)
        for partie in parties:
            if RAMO_ROLE in partie.get('roles', []):
                licitacion.id_dependencia = partie.get('id')
                licitacion.dependencia = re.sub('\s+', " ", partie.get('name')) if partie.get('name') else None
            if UC_ROLE in partie.get('roles', []):
                licitacion.clave_uc = partie.get('id')
                licitacion.nombre_uc = re.sub('\s+', " ", partie.get('name')) if partie.get('name') else None

        if contracts:
            for contract in contracts:
                for item in contract.get('items', []):
                    if 'classification' in item:
                        cucop = item.get('classification').get('id')
                        if cucop not in licitacion.cucops:
                            licitacion.cucops.append(cucop)

        if not licitacion.has_objeto_contrato():
            logging.warning('Licitacion sin objeto del contrato')
            if contracts and len(contracts) == 1:
                licitacion.titulo = re.sub('\s+', " ", contracts[0].get('title')) if contracts[0].get('title') else None

        if not licitacion.has_buyer():
            logging.warning('Licitacion sin unidad compradora')
            if contracts and len(contracts) == 1:
                buyers = contracts[0].get('buyers')
                if buyers:
                    licitacion.clave_uc = buyers[0].get('id')
                    licitacion.nombre_uc = re.sub('\s+', " ", buyers[0].get('name')) if buyers[0].get('name') else None

        if not licitacion.has_cucops():
            logging.warning('Licitacion sin cucops')
            if contracts and len(contracts) == 1:
                budgetBreakdown = contracts[0].get('implementation', {}).get('budgetBreakdown', None)
                if budgetBreakdown:
                    for budget in budgetBreakdown[0].get('budgetClassification'):
                        if budget.get('levelLabel') == CUCOP_LABEL:
                            cucop = budget.get('id')
                            if cucop is not None:
                                licitacion.cucops.append(cucop)
        if not licitacion.has_objeto_contrato() and not licitacion.has_cucops():
            logging.warning('Licitacion sin cucops ni objeto del contrato %s',licitacion.codigo_expediente)
            licitacion.imprimir()
        licitaciones.append(licitacion)
    return licitaciones

def main():
    directorio = sys.argv[1]
    if directorio:
        logging.info('Iniciando proceso')
        for page in range(1, MAX_PAGE + 1):
            url = "{}?page={}".format(URL_API_MX, page)
            filename = '{}/data_file_page_{}.json'.format(directorio,page)
            logging.info('Verificando el archivo %s', filename)
            archivo_procesar = Path(filename)
            print(filename, url)

            if archivo_procesar.is_file():
                logging.info('El archivo ya ha sido descargado previamente, no se descarga desde la API')
            else:
                logging.info('El archivo no existe, se descarga desde la API')
                data_json = get_from_web(url)
                save_json(data_json, filename)
                time.sleep(DELAY)

            #Se parsean las licitaciones del archivo descargado previamente
            licitaciones = get_licitaciones_from_json_file(filename)
            insert_licitaciones(licitaciones)
            logging.info('Licitaciones parseadas %s', len(licitaciones))
    else:
        logging.error('Se debe especificar el directorio a procesar y el archivo principal')

if __name__ == '__main__':
    main()