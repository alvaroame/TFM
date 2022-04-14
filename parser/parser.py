#!/usr/bin/python
# coding: iso-8859-15


import xml.etree.ElementTree as ET
from datetime import datetime
import re
import logging

NAMESPACES = {'xmlns': 'http://www.w3.org/2005/Atom',
              'at': 'http://purl.org/atompub/tombstones/1.0',
              'cac-place-ext': 'urn:dgpe:names:draft:codice-place-ext:schema:xsd:CommonAggregateComponents-2',
              'cbc-place-ext': 'urn:dgpe:names:draft:codice-place-ext:schema:xsd:CommonBasicComponents-2',
              'cbc': 'urn:dgpe:names:draft:codice:schema:xsd:CommonBasicComponents-2',
              'cac': 'urn:dgpe:names:draft:codice:schema:xsd:CommonAggregateComponents-2'}

SEPARATOR = ' '

logger = logging.getLogger(__name__)
class Licitacion:

    def __init__(self, id):
        self.id = id
        self.id_licitacion = id[id.rindex('/') + 1:]  # obtenemos solo el identificador númerico
        self.link = None
        self.titulo = None
        self.objeto_contrato = None
        self.numero_expediente = None
        self.organo_contratacion = None
        self.estatus = None
        self.fecha_actualizacion = None
        self.fecha_eliminacion = None
        self.cpvs = []
        self.presupuesto_sin_imp_cantidad = None
        self.presupuesto_sin_imp_moneda = None
        self.presupuesto_sin_imp = None

    def set_presupuesto(self, budget):
        presupuesto_sinimpuestos = budget.find('cbc:TaxExclusiveAmount', NAMESPACES)
        self.presupuesto_sin_imp_cantidad = presupuesto_sinimpuestos.text
        self.presupuesto_sin_imp_moneda = presupuesto_sinimpuestos.get('currencyID')
        self.presupuesto_sin_imp = self.presupuesto_sin_imp_cantidad + SEPARATOR + self.presupuesto_sin_imp_moneda

    def set_cpvs(self, project):
        for elements in project.findall('cac:RequiredCommodityClassification', NAMESPACES):
            cpv = elements.find('cbc:ItemClassificationCode', NAMESPACES).text
            self.cpvs.append(cpv)

    def imprimir(self):
        logger.info('LICITACION: %s %s %s %s %s %s %s %s %s %s %s %s', self.id, self.id_licitacion,self.link, self.titulo, self.objeto_contrato, self.numero_expediente,
              self.organo_contratacion,  self.estatus, self.cpvs, self.fecha_actualizacion, self.fecha_eliminacion,
              self.presupuesto_sin_imp)


class LicitacionesParser:

    def __init__(self):
        self.licitaciones_eliminadas = {}
        self.licitaciones_procesadas = set()
        self.siguente_archivo = None

    def parse(self, file):
        tree = ET.parse(file)
        root = tree.getroot()
        self.siguente_archivo = self.__get_sig_archivo(root)
        self.__procesar_eliminadas(root)
        return self.__get_licitaciones(root)


    def __get_sig_archivo(self, root):
        for link in root.findall('xmlns:link', NAMESPACES):
            if link.get('rel') == 'next':
                return link.get('href')

    def __procesar_eliminadas(self, root):
        logger.info("Procesando licitaciones marcadas como eliminadas")
        for eliminadas in root.findall('at:deleted-entry', NAMESPACES):
            referencia = eliminadas.get('ref')
            fecha_eliminacion = eliminadas.get('when')
            fecha_eliminacion_dt = datetime.fromisoformat(fecha_eliminacion)
            if referencia not in self.licitaciones_eliminadas:
                logger.info("Licitacion marcada como eliminada: %s ", referencia)
                self.licitaciones_eliminadas[referencia] = fecha_eliminacion_dt

    def __get_licitaciones(self, root):
        logger.info("Procesando licitaciones")
        licitaciones = []
        for licitacion_entry in root.findall('xmlns:entry', NAMESPACES):
            id = licitacion_entry.find('xmlns:id', NAMESPACES).text
            index = id.rindex('/') + 1
            id_licitacion = id[index:]  # obtenemos solo el identificador númerico
            if id_licitacion not in self.licitaciones_procesadas:
                logger.info('Parseando licitacion ID: %s', id_licitacion)
                licitacion = self.__parsear_licitacion(licitacion_entry)
                licitaciones.append(licitacion)
                self.licitaciones_procesadas.add(id_licitacion)
            else:
                licitacion_procesada = self.__parsear_licitacion(licitacion_entry)
                logger.info('Licitacion previamente procesada ID: %s', id_licitacion)
                licitacion_procesada.imprimir()
        return licitaciones


    def __parsear_licitacion(self, licitacion_entry):
        id = licitacion_entry.find('xmlns:id', NAMESPACES).text
        link = licitacion_entry.find('xmlns:link', NAMESPACES).get('href')
        titulo = licitacion_entry.find('xmlns:title', NAMESPACES).text
        fecha_actualizacion = licitacion_entry.find('xmlns:updated', NAMESPACES).text
        fecha_actualizacion_dt = datetime.fromisoformat(fecha_actualizacion)
        fecha_eliminacion = self.licitaciones_eliminadas.get(id, None)

        contract = licitacion_entry.find('cac-place-ext:ContractFolderStatus', NAMESPACES)
        expediente = contract.find('cbc:ContractFolderID', NAMESPACES)
        numero_expediente = expediente.text if expediente is not None else 'NULL'
        estatus = contract.find('cbc-place-ext:ContractFolderStatusCode', NAMESPACES).text

        contracting_party = contract.find('cac-place-ext:LocatedContractingParty', NAMESPACES)
        organo = contracting_party.find('./cac:Party/cac:PartyName/cbc:Name', NAMESPACES).text

        projecto = contract.find('cac:ProcurementProject', NAMESPACES)
        objeto_contrato = projecto.find('cbc:Name', NAMESPACES).text

        licitacion = Licitacion(id)
        licitacion.numero_expediente = re.sub('\s+', " ", numero_expediente)
        licitacion.estatus = estatus
        licitacion.organo_contratacion = re.sub('\s+', " ", organo)
        licitacion.objeto_contrato = re.sub('\s+', " ", objeto_contrato)
        licitacion.link = link
        licitacion.titulo = re.sub('\s+', " ", titulo)
        licitacion.fecha_actualizacion = fecha_actualizacion_dt
        licitacion.fecha_eliminacion = fecha_eliminacion
        licitacion.set_cpvs(projecto)
        licitacion.set_presupuesto(projecto.find('cac:BudgetAmount', NAMESPACES))

        return licitacion
