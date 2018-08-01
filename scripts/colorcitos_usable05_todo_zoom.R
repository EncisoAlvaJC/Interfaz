###############################################################################
# directorio de trabajo
dir_actual = 'C:/Users/EQUIPO 1/Desktop/julio/tesis_respaldo/TESIS/scripts_graf'
dir_graf   = 'C:/Users/EQUIPO 1/Desktop/julio/tesis_respaldo/TESIS/scripts_graf_res'
info_dir   = 'C:/Users/EQUIPO 1/Desktop/julio/tesis_respaldo/TESIS/articulo_dfa'
dir_datos  = 'C:/Users/EQUIPO 1/Desktop/julio/estacionariedad_180408'

setwd(dir_actual)
source('utileria.R')

###############################################################################
# parametros

orden_stam = T
dur_epoca = 30

###############################################################################
# librerias
require('readxl')

require('ggplot2')
require('ggpubr')

require('Rmisc')
require('reshape')

require('scales')

require('hms')

###############################################################################
# datos generales
info     = read_excel(paste0(info_dir,'/info_tecnico.xlsx'))

orden_k  = read_excel(paste0(info_dir,'/info_canales.xlsx'),
                      sheet='Alfabetico')
kanales  = read_excel(paste0(info_dir,'/info_canales.xlsx'),
                      sheet='Alfabetico')
if(orden_stam){
  kanales  = read_excel(paste0(info_dir,'/info_canales.xlsx'),
                        sheet='Stam')
}
n.canales    = length(kanales$Etiqueta)
canales.arch = kanales$Nombre_archivo

###############################################################################
# parametros del script
nombre      = info$Nombre_archivo[sujeto]
etiqueta    = info$Nombre[sujeto]
dir_res_mid = dir_datos
fr_muestreo = info$Fr_muestreo[sujeto]

binario = T

#################################################
# parametros que dependen del sujeto
if(info$Grupo_n[sujeto]==0){
  grupo = 'CTL'
}
if(info$Grupo_n[sujeto]==1){
  grupo = 'MCI'
}
if(info$Grupo_n[sujeto]==-1){
  grupo = 'EX'
}

###############################################################################
# meta-graficacion

setwd(dir_actual)
source('colorcitos_usable05_zoom_zoom.R')

###############################################################################