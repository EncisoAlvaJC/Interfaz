#duraciones = c(0.25,0.5,1:43)
duraciones = 2**c(-3:6)
N = length(duraciones)

porcentajes = matrix(ncol=3,nrow=N)

setwd("C:/Users/EQUIPO 1/Desktop/julio/escalamiento")

for(i in 1:N){
  d = scan(paste0('EST_CLMN10SUE_T5_T',
                  toString(duraciones[i]),
                  's.txt'))
  porcentajes[i,1] = sum(d>0.05)/length(d)
  porcentajes[i,2] = sum(d>0.01)/length(d)
  porcentajes[i,3] = sum(d>0.001)/length(d)
}

plot(duraciones,
     100*porcentajes[,1],type='o',ylim=c(0,100),
     xlab='Duracion epoca (s)',
     ylab='% epocas estacionarias',
     main='Sujeto : CLO  |  Canal : T5')
lines(duraciones,100*porcentajes[,2],type='o')
lines(duraciones,100*porcentajes[,3],type='o')

plot(log2(duraciones),
     100*porcentajes[,1],type='o',ylim=c(0,100),
     xlab='log - Duracion epoca (s)',
     ylab='% epocas estacionarias',
     main='Sujeto : CLO  |  Canal : T5')
lines(log2(duraciones),100*porcentajes[,2],type='o')
lines(log2(duraciones),100*porcentajes[,3],type='o')
