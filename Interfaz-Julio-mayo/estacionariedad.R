#
# para vc, EMG es una copia de LOG
#
estacionariedad <- function(data_dir, central_dir, result_dir, nom_dir, nom_arch, nom_facil, grupo_de, frecuenciasss, sizeEpoc){
  setwd(central_dir)
  
  ## Pararelizacion
  library(doParallel)
  
  myCluster <- makeCluster(detectCores() - 1, # nucleos a usar
                           type = "PSOCK") # PSOCK solo disponible en Windows
  registerDoParallel(myCluster)
  
  source('multipsr08.R' ) 
  source('colorcitos_usable02.R')
  
  for(sujeto in 1:length(nom_dir)){
    print(sujeto)
    nombre   = nom_arch[sujeto]
    print(nombre)
    work_dir = paste0(data_dir,nom_dir[sujeto])
    print(work_dir)
    res_dir  = paste0(result_dir)
    print(res_dir)
    
    setwd(work_dir)
    
    w_dir = work_dir
    ch = 1
    z=1
    
    r <- foreach(c = 1:22, .export='multipsr') %dopar% {
      multipsr(c,nombre,work_dir,central_dir,res_dir,frecuenciasss[sujeto],sizeEpoc)
    }
    
    im <- colorcitos(sujeto, frecuenciasss, nom_arch, nom_facil, nom_dir, result_dir, sizeEpoc)
  }
  stopCluster(myCluster)
}
