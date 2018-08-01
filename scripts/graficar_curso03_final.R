#################################################
# volver a la carpeta central
#setwd('~/TESIS/TESIS/img_ejemplos')
setwd('C:/Users/EQUIPO 1/Desktop/julio/scripts')
#data.dir = '~/TESIS/graf_datos'
data.dir = 'C:/Users/EQUIPO 1/Desktop/julio/DATOS/'

###############################################################################
# parametros del script, ver documantacion

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

epoca_ini = c(712 -30,
              183 -10,
              108 -10,
              1184-30,
              824 -30,
              166 -10,
              242 -10,
              697 -30,
              368 -10,
              276 -10,
              0,
              202 -30)
epoca_fin = c(741 +1,
              192 +1,
              140 +1,
              1213+1,
              853 +1,
              176 +1,
              251 +1,
              726 +1,
              378 +1,
              289 +1,
              0,
              231 +1)

h_ini = c( 1, 1, 0, 3, 2, 1, 1, 1, 3, 2, 1, 1)
m_ini = c(55,28,51,14,13,19,57,53, 0,14,55,37)
s_ini = c( 0, 0, 0, 0,30,30,30, 0,30,30,30,30)

h_fin = c( 2, 1, 1, 3, 2, 1, 2, 2, 3, 2, 2, 1)
m_fin = c(15,48,11,34,33,39,17,13,20,34,15,57)
s_fin = c( 0, 0, 0, 0,30,30,30, 0,30,30,30,30)

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

nombre      = nom_arch[sujeto]
etiqueta    = nom_facil[sujeto]
dir_datos   = paste0(data.dir,nom_dir[sujeto])
dir_res     = getwd()

stam        = T
orden_stam  = c(9,8,7,6,5,4,17,16,2,1,19,18,14,13,12,11,10,3,15,20,21,22)

reemplazar  = TRUE
fr_muestreo = frecuenciasss[sujeto]
dur_epoca   = 30
canales     = 'PSG'
# canales     = c( 'C3', 'C4', 'CZ', 'F3', 'F4',
#                  'F7', 'F8','FP1','FP2', 'FZ',
#                  'O1', 'O2', 'P3', 'P4', 'PZ',
#                 'ROG', 'T3', 'T4', 'T5', 'T6')

reemplazar  = TRUE
grabar      = T
anotaciones = ''

zoom           = TRUE
unidad_par_t   = 'tiempo'
ajuste_ini_hms = c(0,0,0)
min_hms        = c(h_ini[sujeto],m_ini[sujeto],s_ini[sujeto]+30*cual)
max_hms        = min_hms + c(0,0,30)
#unidad_par_t   = 'puntos'
#ajuste_ini_epo = 0
#min_epo        = 0
#max_epo        = 0

if(min_hms[3]>=60){
  min_hms[2] = min_hms[2] + floor(min_hms[3]/60)
  min_hms[3] = min_hms[3] - floor(min_hms[3]/60)*60
}
if(min_hms[2]>=60){
  min_hms[1] = min_hms[1] + floor(min_hms[2]/60)
  min_hms[2] = min_hms[2] - floor(min_hms[2]/60)*60
}

if(max_hms[3]>=60){
  max_hms[2] = max_hms[2] + floor(max_hms[3]/60)
  max_hms[3] = max_hms[3] - floor(max_hms[3]/60)*60
}
if(max_hms[2]>=60){
  max_hms[1] = max_hms[1] + floor(max_hms[2]/60)
  max_hms[2] = max_hms[2] - floor(max_hms[2]/60)*60
}

#################################################
# parametros de dibujo
escala_mv  = 7.5
salto      = 8
sep_lineas = 1
n_tiempos  = 5

#################################################
# procesamiento parametros opcionales
if(reemplazar){
  if(canales=='10-20'){
    canales = c( 'C3', 'C4', 'CZ', 'F3', 'F4',
                 'F7', 'F8','FP1','FP2', 'FZ',
                 'O1', 'O2', 'P3', 'P4', 'PZ',
                 'T3', 'T4', 'T5', 'T6')
  }
  if(canales=='PSG'){
    canales = c( 'C3', 'C4', 'CZ', 'F3', 'F4',
                 'F7', 'F8','FP1','FP2', 'FZ',
                 'O1', 'O2', 'P3', 'P4', 'PZ',
                 'T3', 'T4', 'T5', 'T6', 'LOG',
                 'ROG','EMG')
    if(stam){
      canales = canales[orden_stam]
    }
  }
}
if(length(canales)<1){
  stop('ERROR: Lista de canales tiene longitud cero')
}

#################################################
# parametros que dependen de los datos
n_canales = length(canales)
ventana   = dur_epoca*fr_muestreo

#################################################
# procesamiento parametros opcionales (ajuste)
if(unidad_par_t =='tiempo'){
  ini_t   = ajuste_ini_hms[1]*60*60
           +ajuste_ini_hms[2]*60
           +ajuste_ini_hms[3]
  ini_epo = ini_t/dur_epoca
  ini_pt  = floor(ini_t*fr_muestreo)
}
if(unidad_par_t =='epoca'){
  ini_epo = ajuste_ini_epo
  ini_t   = ini_epo*dur_epoca
  ini_pt  = ini_epo*ventana
}
str_t   = 0
str_epo = 0
str_pt  = 1

# ini : cuando inicia el archivo, util si es un fragmento
# str : cuando inicia el zoom, evita la confusion provocada por ini

# procesamiento parametros opcionales (zoom)
if(zoom){
  confirma_zoom = FALSE
  if(unidad_par_t == 'tiempo'){
    min_t  = min_hms[1]*60*60 + min_hms[2]*60 + min_hms[3] -ini_t
    max_t  = max_hms[1]*60*60 + max_hms[2]*60 + max_hms[3] -ini_t
    
    min_e  = (min_t+ini_t)/dur_epoca -ini_epo
    max_e  = (max_t+ini_t)/dur_epoca -ini_epo
    
    confirma_zoom = TRUE
  }
  if(unidad_par_t == 'puntos'){
    min_t = min_epo*dur_epoca -ini_t
    max_t = max_epo*dur_epoca -ini_t
    
    min_e = (min_epo+ini_t) -ini_epo
    max_e = (max_epo+ini_t) -ini_epo
    
    confirma_zoom = TRUE
  }
  if(!confirma_zoom){
    warning('WARNING: Indique unidad de tiempo para zoom (epocas o segundos)')
  }
  min_pt = floor(min_t*fr_muestreo)
  max_pt = ceiling(max_t*fr_muestreo)
  
  str_t   = max(min_t, 0)
  str_epo = max(min_e, 0)
  str_pt  = max(min_pt,1)
}

#################################################
# inicia guardado de los graficos
if(grabar){
  tag = ''
  #if(stam){
  #  tag = '_stam'
  #}
  
  hh.txt = toString(min_hms[1])
  if(min_hms[1]<10){
    hh.txt = paste0('0',hh.txt)
  }
  mm.txt = toString(min_hms[2])
  if(min_hms[2]<10){
    mm.txt = paste0('0',mm.txt)
  }
  ss.txt = toString(min_hms[3])
  if(min_hms[3]<10){
    ss.txt = paste0('0',ss.txt)
  }
  
  setwd(dir_res)
  png(
  #pdf(
    paste0(etiqueta,'_epoca',tag,
           hh.txt,mm.txt,ss.txt,
           #toString(cual),
           #'.pdf'),width=6,height=3.5)
           '.png'),units='in',res=150,width=6,height=3.5)
}

#################################################
# modo seguro: revisa si estan los archivos
correctos = rep(FALSE,n_canales)
n_datos   = Inf

setwd(dir_datos)
for(ch in 1:n_canales){
  ch_actual = canales[ch]
  if(file.exists(paste0(nombre,'_',ch_actual,'.txt'))){
    correctos[ch] =TRUE
  }else{
    warning('ERROR: En canal ',ch_actual,'no se encontro el archivo ',
            paste0(nombre,'_',ch_actual,'.txt'))
  }
}
canales   = canales[correctos]
n_canales = length(canales)

#################################################
# graficacion

# carga los datos para inicializar la ventana
setwd(dir_datos)
ch        = 1
ch_actual = canales[ch]
nom_arch  = paste0(nombre,'_',ch_actual,'.txt')
DATA      = scan(nom_arch)
n_datos   = length(DATA)

# ajustes en el tiempo
if(zoom){
  end_t   = min(max_t, n_datos/fr_muestreo)
  end_epo = min(max_e, n_datos/ventana)
  end_pt  = min(max_pt,n_datos)
  
  DATA    = DATA[str_pt:end_pt]
  
  ini_t   = ini_t   + str_t
  ini_epo = ini_epo + str_epo
  ini_pt  = ini_pt  + str_pt
  n_datos   = length(DATA)
} 
# end : cuando termina el zoom, evita la confusion provocada por ini

# miscelanea de indices para detalles tecnicos
n_puntos  = floor(n_datos/salto)
ind_t     = floor(seq(0,n_puntos,by=n_puntos/n_tiempos))+1
ind_pt    = seq(0,n_datos,by=salto)
ind_pt[1] = 1
ind_linea = seq(0,n_datos,by=sep_lineas*fr_muestreo)
ind_linea[1] = 1

# creacion etiquetas de tiempo
num_t  = (0:n_puntos)*(salto/fr_muestreo) + ini_t
num_t  = num_t[ind_t]
num_hh = floor(num_t/(60*60))
num_mm = floor( (num_t - num_hh*60*60)/60 )
num_ss = floor(  num_t - num_hh*60*60 - num_mm*60 )
num_ms = num_t - num_hh*60*60 - num_mm*60 - num_ss
txt_t  = character(length(num_t))
for(i in 1:(length(num_t))){
  txt_mm = toString(num_mm[i])
  if(num_mm[i]<10){
    txt_mm = paste0('0',num_mm[i])
  }
  txt_ss = toString(num_ss[i])
  if(num_ss[i]<10){
    txt_ss = paste0('0',num_ss[i])
  }
  txt_t[i] = paste0(toString(num_hh[i]),':',txt_mm,':',txt_ss)
}

#################################################
# colores del grafico
vec_colores = c(rgb(132,120, 32,maxColorValue=255),  # C3
                rgb(132,120, 32,maxColorValue=255),  # C4
                rgb(132,120, 32,maxColorValue=255),  # CZ
                rgb(166, 58, 40,maxColorValue=255),  # F3
                rgb(166, 58, 40,maxColorValue=255),  # F4
                rgb(166, 58, 40,maxColorValue=255),  # F7
                rgb(166, 58, 40,maxColorValue=255),  # F8
                rgb(128,  0,128,maxColorValue=255),  # FP1
                rgb(128,  0,128,maxColorValue=255),  # FP2
                rgb(166, 58, 40,maxColorValue=255),  # FZ
                rgb( 72, 64, 65,maxColorValue=255),  # O1
                rgb( 72, 64, 65,maxColorValue=255),  # O1
                rgb( 29,118, 68,maxColorValue=255),  # P3
                rgb( 29,118, 68,maxColorValue=255),  # P4
                rgb( 29,118, 68,maxColorValue=255),  # PZ
                rgb( 64, 35,113,maxColorValue=255),  # T3
                rgb( 64, 35,113,maxColorValue=255),  # T4
                rgb( 64, 35,113,maxColorValue=255),  # T5
                rgb( 64, 35,113,maxColorValue=255),  # T3
                rgb( 50,116,  0,maxColorValue=255),  # LOG
                rgb( 50,116,  0,maxColorValue=255),  # ROG
                rgb( 31, 62,119,maxColorValue=255)  # EMG
                )
if(stam){
  vec_colores = vec_colores[orden_stam]
}

#################################################
# graficacion
#par(bg = 'NA', mar = c(0,1.5,0,0))
par(bg = 'white', mar = c(0,1.5,0,0))
par(cex.axis=.75, cex.lab=.8, cex.main=1)

plot(c(1,max(ind_pt)),
  type='o',col='white',
  ylim=c(.5*escala_mv,(n_canales-.5)*escala_mv),
  xlim=c(1,max(ind_pt)),
  #xlab = 'Tiempo [hh:mm:ss]',
  ylab = '',
  yaxt='n',xaxt='n',
  #main=paste0('Sujeto : ',etiqueta,anotaciones),
  main='',
  mgp=c(2,1,0),
  bty='n'
)
for(i in ind_linea){
 abline(v=i,col='gray')
}
#axis(1,at=ind_t*salto,labels=txt_t)
#axis(3,at=c(min(ind_t),max(ind_t))*salto,labels=F)

#################################################
# inicio ciclo que recorre canales
setwd(dir_datos)
for(ch in 1:n_canales){
  # cargar los datos
  ch_actual = canales[ch]
  nom_ar    = paste0(nombre,'_',ch_actual,'.txt')
  DATA      = scan(nom_ar)
  if(zoom){
    DATA    = DATA[str_pt:end_pt]
  }
  agregado = (n_canales-ch)*escala_mv+escala_mv/2 - mean(DATA)
  lines(ind_pt,DATA[ind_pt] + agregado,
        type='l',col=vec_colores[ch])
  axis(2,at=(n_canales-ch)*escala_mv+escala_mv/2,
       labels=ch_actual,las=1,#col.axis=vec_colores[ch],
       mgp=c(0,0,-1.75),tick=F)
}
# fin ciclo que recorre canales
#################################################

lines(sep_lineas*fr_muestreo*c(.5,1.5),
      escala_mv*c(1,1),
      type='l',lwd=1.5)
lines(sep_lineas*fr_muestreo*.5*c(1,1),
      escala_mv+c(0,10),
      type='l',lwd=1.5)

if(grabar){
  dev.off()
}
# inicia guardado de los graficos
#################################################