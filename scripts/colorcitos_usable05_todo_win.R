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
grabar_tot  = T
grabar      = F
anotaciones = ''

orden_stam = T

#dur_epoca = 30

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

factor.extra = 1
if(fr_muestreo==200){
  factor.extra = 3
}
zoom           = T
unidad_par_t   = 'tiempo'
ajuste_ini_hms = c(0,0,0)
#min_hms        = c(3,17,20)
#max_hms        = c(3,19,10)
#unidad_par_t   = 'puntos'
#ajuste_ini_epo = 0
#min_epo        = epoca_ini[sujeto]
#max_epo        = epoca_fin[sujeto]-1
#min_epo        = 0

#epo_0   =  925
#epo_f   = 1002
#min_hms = t2hms(dur_epoca*(epo_0-1)/factor.extra)
#max_hms = t2hms(dur_epoca* epo_f   /factor.extra)

min_hms        = c( 5,30, 0)
max_hms        = c( 6,40, 0)

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

stop()

setwd(dir_actual)
source('colorcitos_usable05_parte.R')

###############################################################################