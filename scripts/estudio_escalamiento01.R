###############################################################################
# PARCHE : volver a la carpeta central
dir_actual  = getwd()

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

###############################################################################
# FACILITADOR : nombres y directorios de los sujetos que analizo
v.nombres    = c('VCNNS1',
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
v.etiqueta   = c('VCR',
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
v.directorio = c('VCNNS',
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
                 'EMNN')

###############################################################################
# parametros del script, ver documantacion para mas informacion
#sujeto = 6
nombre      = v.nombres[sujeto]
etiqueta    = v.etiqueta[sujeto]
#dir_res_mid  = paste0('C:/Users/EQUIPO 1/Desktop/julio/estacionariedad_promedio/',
#                      v.directorio[sujeto])
dir_graf     = paste0(getwd(),'/graficos_promedio')
fr_muestreo  = frecuenciasss[sujeto]
#dur_epoca    = 30

grabar      = FALSE
anotaciones = ''

reemplazar  = TRUE
canales     = 'PSG'

duraciones  = 2**c(-2:6)
#pvalores    = c(.1,.05,.01,.005,.001,.005)
pvalores    = c(.1,.05,.01)

#################################################
# procesamiento parametros opcionales
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

#################################################
# paramtros que dependen de los datos
N           = length(duraciones)
P           = length(pvalores)
porcentajes = matrix(ncol=P,nrow=N)
setwd("C:/Users/EQUIPO 1/Desktop/julio/escalamientop")

#ch = 1

#################################################
# cargar los datos referentes al canal
for(i in 1:N){
  d = read.csv(paste0('PE_',nombre,'_EMG_',
                      toString(duraciones[i]),
                      '.csv'))
  d = as.matrix(d)
  porcentajes[i,] = d[ch,1:P+1]
}

#plot(0,type='n',
#     ylim=c(0,100),xlim=c(min(duraciones),max(duraciones)),
#     xlab='Duracion epoca (s)',
#     ylab='% epocas estacionarias',
#     main=paste0('Sujeto : ',etiqueta,'  |  Canal : ',canales[ch]),bty='n')
#for(j in 1:6){
#  lines(duraciones,100*porcentajes[,j],type='o')
#}

plot(0,type='n',
     ylim=c(0,100),xlim=log(c(min(duraciones),max(duraciones))),
     xlab='Duracion epoca (s)',
     ylab='% epocas estacionarias',
     xaxt='n',
     main=paste0('Sujeto : ',etiqueta,'  |  Canal : ',canales[ch]),bty='n')
for(j in 1:P){
  lines(log(duraciones),100*porcentajes[,j],type='o')
}
numeritos = rep('no',N)
for(i in 1:N){
  numeritos[i] = toString(duraciones[i])
}
axis(1,at=log(duraciones),label=numeritos)

