#
# para vc, EMG es una copia de LOG
#
ejecutable_espectro <- function(data_dir, central_dir, dir_res, result_dir, nom_dir, nom_arch, nom_facil, grupo_de, frecuenciasss, dur_epoca){
  setwd(central_dir)
  source('multi_espectro_integrado02_mio.R' ) 
  
  for(sujeto in 1:length(nom_dir)){
    nombre   = nom_arch[sujeto]
    work_dir = paste0(data_dir,nom_dir[sujeto])
    print(work_dir)
    res_dir  = paste0(result_dir,nom_dir[sujeto])
    
    etiqueta = nom_facil[sujeto]
    
    setwd(work_dir)
    
    w_dir = work_dir
    
    multiespectro(nombre,work_dir,dir_res,
                  frecuenciasss[sujeto],dur_epoca, etiqueta)
    
  }
}
