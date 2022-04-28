#!/usr/bin/python
# coding: iso-8859-15

import psycopg2

from configuration.config import config
from models import LicitacionesParser
from pathlib import Path
import datetime
import logging
import sys

log_file = "logs/parserES" + datetime.datetime.now().strftime("%Y%m%d-%H-%M-%S") + '.log'
logging.basicConfig(filename=log_file, encoding='utf-8', level=logging.DEBUG)


def insert_licitaciones(licitaciones):
    """ Insertar una licitacion en la tabla SQL """
    sql = """INSERT INTO licitacion_es(id_licitacion_es, id_cpv, identificador, expediente, estatus, presupuesto, moneda, 
    objeto, titulo, link, organo, cpvs, fecha_actualizacion, fecha_eliminacion)
             VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s) ON CONFLICT DO NOTHING;"""

    conn = None
    student_id = None
    try:
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a new cursor
        cur = conn.cursor()
        # execute the INSERT statement

        for licitacion in licitaciones:
            logging.info('Guardando licitacion: %s', licitacion.id_licitacion)
            cpv = None
            cpvs = None
            if len(licitacion.cpvs) == 1:
                cpv = licitacion.cpvs[0]
            if len(licitacion.cpvs) > 1:
                cpvs = ";".join(licitacion.cpvs)
            if len(licitacion.cpvs) == 0:
                logging.warning('ID: %s Estatus: %s Mensaje: No contiene CPVS', licitacion.id_licitacion,
                                licitacion.estatus)
            cur.execute(sql, (licitacion.id_licitacion, cpv, licitacion.id, licitacion.numero_expediente,
                              licitacion.estatus, licitacion.presupuesto_sin_imp_cantidad,
                              licitacion.presupuesto_sin_imp_moneda, licitacion.objeto_contrato,
                              licitacion.titulo, licitacion.link, licitacion.organo_contratacion, cpvs,
                              licitacion.fecha_actualizacion, licitacion.fecha_eliminacion))

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

def main():
    directorio = sys.argv[1]
    archivo_principal = sys.argv[2]

    if directorio and archivo_principal:
        logging.info('Se procesara el directorio: %s empezando con el archivo: %s ', directorio, archivo_principal)
        parser = LicitacionesParser()
        archivos = []
        archivo_procesar = Path(directorio, archivo_principal)
        for archivo in sorted(Path(directorio).glob("*.atom")):
            if archivo.is_file():
                archivos.append(archivo)
        logging.info('Iniciando proceso')
        while archivo_procesar in archivos:
            logging.info('Procesando archivo: %s', archivo_procesar)
            print('Procesando archivo:', archivo_procesar)
            licitaciones = parser.parse(archivo_procesar)
            insert_licitaciones(licitaciones)
            archivos.remove(archivo_procesar)
            siguente_archivo = parser.siguente_archivo
            if siguente_archivo is None:
                break
            archivo_procesar = Path(directorio, siguente_archivo)
        logging.info('Proceso terminado con exito')
    else:
        logging.error('Se debe especificar el directorio a procesar y el archivo principal')


if __name__ == '__main__':
    main()