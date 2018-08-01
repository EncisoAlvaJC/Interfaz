###############################################################################
# parametros

ver_avance  = T
no_repetir  = F
filtrar     = F
usar_loess  = T

canales = kanales$Nombre_archivo

#################################################
# inicio del ciclo que recorre los canales
for(ch in 1:n_canales){
  
  # construye el nombre del archivo
  ch_actual   = canales[ch]
  nom_archivo = paste0(nombre,'_',ch_actual,'.txt')
  
  # cargar los datos
  setwd(dir_datos)
  if(!file.exists(nom_archivo)){
    warning('ERROR: En canal ',ch_actual,
            ', no se encontro el archivo ',nom_archivo)
    next()
  }
  
  DATOS = read.csv(nom_archivo)
  DATOS = as.numeric(unlist(DATOS))

}
# fin del ciclo que recorre canales
#################################################

# fin del script
###############################################################################