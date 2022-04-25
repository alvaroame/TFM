#!/usr/bin/python
# coding: iso-8859-15

import logging


class LicitacionMX():
    def __init__(self, id, origen):
        self.id = id
        self.ocid = None
        self.uri = None
        self.id_publicacion = None
        self.fecha = None
        self.codigo_expediente = None
        self.titulo = None
        self.descripcion = None
        self.estatus = None
        self.cucops = []

        self.id_dependencia = None
        self.dependencia = None
        self.clave_uc = None
        self.nombre_uc = None

        self.origen = origen

    def has_objeto_contrato(self):
        return (self.titulo is not None or self.descripcion is not None)

    def has_buyer(self):
        return (self.dependencia is not None or self.nombre_uc is not None)

    def has_cucops(self):
        return len(self.cucops) > 0

    def imprimir(self):
        values = 'id: {} ocid: {} uri: {} idPublicacion: {} fecha: {} CodigoExpediente: {} TituloExpediente: {} ' \
                 'DescExpediente: {} Estatus: {} Cucops: {} Dependencia: {} - {} Unidad Compradora: {} - {}'.format(
            self.id,
            self.ocid, self.uri, self.id_publicacion, self.fecha, self.codigo_expediente, self.titulo,
            self.descripcion, self.estatus, self.cucops, self.id_dependencia, self.dependencia,
            self.clave_uc, self.nombre_uc)
        logging.info(values)
