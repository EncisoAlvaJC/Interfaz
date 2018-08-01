#################################################
# libreria que contiene unestimador espectral
require('psd')

multiespectro <- function(nombre,dir_datos,dir_res,
                          fr_muestreo,dur_epoca, etiqueta){
  
  ###############################################################################
  # parametros del script
  
  extension   = '.txt'
  reemplazar  = TRUE   #  <-
  canales     = 'PSG'
  
  ver_avance  = T
  no_repetir  = F
  haz_carpeta = F
  usar_loess  = F
  filtrar     = F
  
  #################################################
  # parametros opcionales
  if(reemplazar){
    if(canales=='10-20'){
      canales = c('C3','C4','CZ','F3','F4','F7','F8','FP1','FP2','FZ','O1','O2',
                  'P3','P4','PZ','T3','T4','T5','T6')
    }
    if(canales=='PSG'){
      canales = c('C3','C4','CZ','F3','F4','F7','F8','FP1','FP2','FZ','O1','O2',
                  'P3','P4','PZ','T3','T4','T5','T6','LOG','ROG','EMG')
    }
  }
  if(length(canales)<1){
    stop('ERROR: Lista de canales tiene longitud cero')
  }
  
  #################################################
  # parametros dependientes de los datos
  ventana   = fr_muestreo*dur_epoca
  n_canales = length(canales)
  usar_stl  = T
  if(dur_epoca<=2){
    usar_stl = F
  }
  if(usar_loess){
    usar_stl = F
  }
  
  #################################################
  # inicio del ciclo que recorre los canales
  for(ch in 1:n_canales){
    
    # construye el nombre del archivo
    ch_actual   = canales[ch]
    nom_archivo = paste0(nombre,'_',ch_actual,extension)
    
    # cargar los datos
    setwd(dir_datos)
    if(!file.exists(nom_archivo)){
      warning('ERROR: En canal ',ch_actual,
              ', no se encontro el archivo ',nom_archivo)
      next()
    }
    DATOS = read.csv(nom_archivo)
    DATOS = as.numeric(unlist(DATOS))
    
    # cuantas epocas pueden formarse
    max_epoca = floor(length(DATOS)/ventana)
    if(max_epoca==0){
      warning(paste0('ERROR: En canal ',ch_actual,
                     ', no se pudieron leer datos'))
      next()
    }
    
    #################################################
    # conenedor de datos
    banda.. = rep(0,max_epoca)
    banda.d = rep(0,max_epoca)
    banda.t = rep(0,max_epoca)
    banda.a = rep(0,max_epoca)
    banda.b = rep(0,max_epoca)
    banda.g = rep(0,max_epoca)
    banda._ = rep(0,max_epoca)
    banda.S = rep(0,max_epoca)
    
    #informacion sobre el progreso, si fue requerida
    if(ver_avance){
      print( paste0('  Sujeto : ',etiqueta) )
      print( paste0('   Canal : ',ch_actual,
                    ' (',toString(ch),'/',toString(n_canales),')') )
    }
    
    signo = -1
    if(ch_actual=='EMG'){
      signo = 1
    }
    
    #################################################
    # inicio del ciclo que recorre las epocas
    for ( i in 0:(max_epoca-1) ){
      tmp   = DATOS[ (i*ventana+1) : ((i+1)*ventana) ]
      tmp.t = ts(tmp,frequency=fr_muestreo,start=c(0,0))
      
      if(filtrar){
        # filtro STL, robusto y forzado a periodico estandar
        if(usar_stl){
          tmp.s = stl(tmp.t,robust=T,s.window='periodic')
          tmp.r = tmp.s$time.series[,'remainder']
          tmp   = as.numeric(unclass(tmp.r))
        }else{
          tmp.l = loess(tmp~time(tmp.t))
          tmp.s = predict(tmp.l,time(tmp.t))
          tmp   = tmp - tmp.s$fit
        }
        tmp.t = ts(tmp,frequency=fr_muestreo,start=c(0,0))
      }
      
      # espectro de potencias usando el metodo este
      sss = pspectrum(tmp.t,plot=F,verbose=F)
      fff = sss$freq
      spp = abs(sss$spec)
      d.f = fff[2]-fff[1]
      
      banda..[i] = sum(spp[fff<=  0.5])*d.f
      {
        mini = min(fff[fff>=0.5])
        maxi = max(fff[fff<=3.5])
        banda.d[i] = sum(spp[mini:maxi])*d.f
      }
      {
        mini = min(fff[fff>=3.5])
        maxi = max(fff[fff<=7  ])
        banda.t[i] = sum(spp[mini:maxi])*d.f
      }
      {
        mini = min(fff[fff>= 7])
        maxi = max(fff[fff<=12])
        banda.a[i] = sum(spp[mini:maxi])*d.f
      }
      {
        mini = min(fff[fff>=12])
        maxi = max(fff[fff<=30])
        banda.b[i] = sum(spp[mini:maxi])*d.f
      }
      {
        mini = min(fff[fff>=30])
        maxi = max(fff[fff<=100])
        banda.g[i] = sum(spp[mini:maxi])*d.f
      }
      {
        mini = min(fff[fff>=100])
        banda._[i] = sum(spp[mini:length(spp)])*d.f
      }
      
      banda.S[i] = sum(spp)*d.f
    }
    # fin del ciclo que recorre las epocas
    #################################################
    
    # los resultados se guardan en un archivo .csv
    setwd(dir_res)
    write.table(banda..,paste0('SP_INT_',nombre,'_',ch_actual,'_SUB.txt'  ),
                row.names=FALSE,col.names=FALSE)
    write.table(banda.d,paste0('SP_INT_',nombre,'_',ch_actual,'_DELTA.txt'  ),
                row.names=FALSE,col.names=FALSE)
    write.table(banda.t,paste0('SP_INT_',nombre,'_',ch_actual,'_THETA.txt'  ),
                row.names=FALSE,col.names=FALSE)
    write.table(banda.a,paste0('SP_INT_',nombre,'_',ch_actual,'_ALFA.txt'  ),
                row.names=FALSE,col.names=FALSE)
    write.table(banda.b,paste0('SP_INT_',nombre,'_',ch_actual,'_BETA.txt'  ),
                row.names=FALSE,col.names=FALSE)
    write.table(banda.g,paste0('SP_INT_',nombre,'_',ch_actual,'_GAMMA.txt'  ),
                row.names=FALSE,col.names=FALSE)
    write.table(banda._,paste0('SP_INT_',nombre,'_',ch_actual,'_SUPER.txt'  ),
                row.names=FALSE,col.names=FALSE)
    write.table(banda.S,paste0('SP_INT_',nombre,'_',ch_actual,'_TOTAL.txt'  ),
                row.names=FALSE,col.names=FALSE)
  }
  # fin del ciclo que recorre canales
  #################################################
}
# fin del script
###############################################################################