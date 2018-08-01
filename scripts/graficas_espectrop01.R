require(plotrix)
require(beepr)

data_dir    = 'C:/Users/EQUIPO 1/Desktop/julio/espectrop/'
central_dir = 'C:/Users/EQUIPO 1/Desktop/julio/scripts'
result_dir  = 'C:/Users/EQUIPO 1/Desktop/julio/graficos170807'

nom_dir  = c('VCNNS',
             'MJNNVIGILOScCanal',
             'JANASUE_revisado',
             'GH',
             'GURM_revisado',
             'CLMN10SUE',
             'RLMN',
             'RRMNS_2',
             'JGMN6SUE',
             'FGH_EEGdescompuesto',
             'MGNA',
             'EMNN'
)
nom_arch = c('VCNNS1',
             'MJNNVIGILOS',
             'JANASUE',
             'GH24031950SUEÑO',
             'GURM251148SUE',
             'CLMN10SUE',
             'RLMN10SUE',
             'RRMNS',
             'JGMN6SUE',
             'FGHSUE',
             'MGNA5SUE',
             'EMNNS')
nom_facil = c('VCR',
              'MJH',
              'JAE',
              'GHA',
              'MFGR',
              'CLO',
              'RLO',
              'RRU',
              'JGZ', 
              'FGH',
              'MGG',
              'EMT')

grupo_de = c(0,0,0,0,0,1,1,1,1,-1,-1,-1)

frecuenciasss = c(200,
                  512,512,
                  200,
                  200,#segun valeria GUR=200 Hz
                  #512, #segun la libreta GURM=512
                  512,512,
                  200,#solo tiene 3 horas
                  512,
                  512,512,
                  200)

tag_filtro = '_stl_'

{
  sujeto = 1
  
  setwd(central_dir)
  
  nombre   = nom_arch[sujeto]
  
  dir_datos   = paste0(data_dir,nom_dir[sujeto])
  dir_res     = result_dir
  
  fr_muestreo = frecuenciasss[sujeto]
  dur_epoca   = 30
  
  reemplazar  = T
  canales     = 'PSG'
  
  ver_avance  = F
  no_repetir  = F
  usar_loess  = F
  filtrar     = T
  
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
  
  #{
    # contenedor de los datos
    ch = 1
    ch_actual   = canales[ch]
    
    setwd(dir_datos)
    
    espec = read.table(paste0('SPEC_',nombre,'_',ch_actual,
                              tag_filtro,'.txt'))
    beep()
    espec = as.matrix(espec)
    tiemp = read.table(paste0('TIME_',nombre,'_',ch_actual,
                              tag_filtro,'.txt'))
    tiemp = unlist(tiemp)
    frecu = read.table(paste0('FREC_',nombre,'_',ch_actual,
                              tag_filtro,'.txt'))
    frecu = unlist(frecu)
    
    plot(frecu,espec[,1],type='l')
    lines(frecu,espec[,2],type='l')
    
    #for(i in 2:100){
    #  lines(frecu,espec[,i],type='l',col=rainbow(100)[i])
    #}
    
    #abline(v = 0.5,col='red')
    #abline(v = 3.5,col='red')
    #abline(v =  7 ,col='red')
    #abline(v = 12 ,col='red')
    #abline(v = 30 ,col='red')
    #abline(v = 100,col='red')
    
    require(plotrix)
    
    minni = 3
    maxxi
    N = length(tiemp)
    
    color2D.matplot(-espec[,1:N],border=NA,yrev=F,axes=F,
                    main=paste0(nom_facil[sujeto],' : ',ch_actual))
    skip = seq(1,N+1,by=N/20)
    axis(1,at=floor(skip),floor(tiemp[skip]))
    skip = seq(1,length(frecu),by=5)
    axis(2,at=(skip),floor(frecu[skip]),las=2)
    
    le = length(frecu)-1
    esp = frecu[1:le+1]-frecu[1:le]
    m = 1/mean(esp)
    
    abline(h = 0.5*m +m,col='red')
    abline(h = 3.5*m +m,col='red')
    abline(h =   7*m +m,col='red')
    abline(h =  12*m +m,col='red')
    abline(h =  30*m +m,col='red')
    abline(h = 100*m +m,col='red')
  #}
  
  #################################################
  # inicio del ciclo que recorre los canales
  # for(ch in 1:n_canales){
  #   # construye el nombre del archivo
  #   ch_actual   = canales[ch]
  #   nom_archivo = paste0(nombre,'_',ch_actual,extension)
  #   
  #   setwd(dir_datos)
  #   
  #   espec = read.table(file=paste0('SPEC_',nombre,'_',ch_actual,
  #                                  tag_filtro,'.txt'))
  #   
  #   frecu = read.table(file=paste0('FREC_',nombre,'_',ch_actual,
  #                                  tag_filtro,'.txt'))
  #   tiemp = read.table(file=paste0('TIME_',nombre,'_',ch_actual,
  #                                  tag_filtro,'.txt'))
  # }
}

