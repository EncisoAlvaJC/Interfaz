###############################################################################
# directorios de trabajo
data_dir    = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS_corregido/'
central_dir = 'C:/Users/EQUIPO 1/Desktop/julio/scripts/'
result_dir  = 'C:/Users/EQUIPO 1/Desktop/julio/estacionariedad_180319/'
dir_info    = 'C:/Users/EQUIPO 1/Desktop/julio/tesis_respaldo/TESIS/articulo_dfa'
dir_scripts = 'C:/Users/EQUIPO 1/Desktop/julio/tesis_respaldo/TESIS/articulo_dfa/scripts/'

###############################################################################
# parametros
duraciones = 30*(2**rev(-4:2))
orden_stam = T

###############################################################################
# librerias: sonidito y test PSR
require('beepr')
require('fractal')
# librerias: paralelizar
require('foreach')
require('doParallel')
require('parallel')
#leer de excel
require('readxl')

# sub-rutinas que acortan el codigo
source(paste0(dir_scripts,'/utileria.R'))

###############################################################################
# datos generales
info     = read_excel(paste0(dir_info,'/info_tecnico.xlsx'))

canales  = read_excel(paste0(dir_info,'/info_canales.xlsx'),
                      sheet='Alfabetico')
if(orden_stam){
  canales  = read_excel(paste0(dir_info,'/info_canales.xlsx'),
                        sheet='Stam')
}
n.canales = length(canales$Etiqueta)

###############################################################################
# datos generales
nom_dir   = info$Nombre_directorio
nom_arch  = info$Nombre_archivo
nom_facil = info$Nombre
grupo_de  = info$Grupo_n
frecuenciasss = info$Fr_muestreo

n_sujetos = length(nom_facil)

beep()

###############################################################################
# inicio ciclo doble
for(sujeto in (6:n_sujetos)){
  for(dur_epoca in duraciones){
    setwd(central_dir)
    
    nombre   = nom_arch[sujeto]
    etiqueta = nom_facil[sujeto]
    
    dir_datos   = paste0(data_dir,nom_dir[sujeto])
    dir_res     = paste0(result_dir)
    
    fr_muestreo = frecuenciasss[sujeto]
    #dur_epoca   = 30
    
    source('multipsr03_paralelizado.R' ) 
    
    beep()
  }
  beep()
  beep()
}
# fin ciclo doble
###############################################################################

beep()
beep()