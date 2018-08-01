###############################################################################
# parametros
quienes     = (1:14)

orden_stam  = T

###############################################################################
# directorios de trabajo
#
dir_info       = 'C:/Users/EQUIPO 1/Desktop/julio/tesis_respaldo/TESIS/articulo_dfa'
dir_scripts    = 'C:/Users/EQUIPO 1/Desktop/julio/tesis_respaldo/TESIS/articulo_dfa/scripts'
dir_registro   = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS_corregido/'

###############################################################################
# librerias
require('beepr')
require('readxl')

# sub-rutinas que acortan el codigo
source(paste0(dir_scripts,'/utileria.R'))

###############################################################################
# datos generales
info     = read_excel(paste0(dir_info,'/info_tecnico.xlsx'))

kanales  = read_excel(paste0(dir_info,'/info_canales.xlsx'),
                      sheet='Alfabetico')
if(orden_stam){
  kanales  = read_excel(paste0(dir_info,'/info_canales.xlsx'),
                        sheet='Stam')
}
n.canales = length(kanales$Etiqueta)

nom_dir   = info$Nombre_directorio
nom_arch  = info$Nombre_archivo
nom_facil = info$Nombre

frecuenciasss = info$Fr_muestreo
grupo_de      = info$Grupo_n

h_ini = info$hh_0
m_ini = info$mm_0
s_ini = info$ss_0

h_fin = info$hh_f
m_fin = info$mm_f
s_fin = info$ss_f

beep()

#################################################
# inicia ciclo que recorre sujetos
for(sujeto in quienes){
  nombre   = nom_arch[sujeto]
  etiqueta = nom_facil[sujeto]
  
  dir_datos = paste0(dir_registro,nom_dir[sujeto])
  #dir_res   = dir_resultados
  
  fr_muestreo = frecuenciasss[sujeto]
  
  
  setwd(dir_datos)

  canales = kanales$Nombre_archivo
  ch = 15
  
  # construye el nombre del archivo
  ch_actual   = canales[ch]
  nom_archivo = paste0(nombre,'_',ch_actual,'.txt')
  
  DATOS = read.csv(nom_archivo)
  DATOS = as.numeric(unlist(DATOS))
  
  print(nombre)
  print(fr_muestreo)
  print(length(DATOS))
  print(length(DATOS)/fr_muestreo)
  print(t2hms(length(DATOS)/fr_muestreo))
  
  invisible(readline(prompt = "Press <Enter> to continue..."))
  
  # freno de emergencia
  #stopCluster(closter)
}
# fin cilco que recorre sujetos
#################################################