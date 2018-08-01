abline(v=100,col='gray')
for(i in 1:lt){
lines(frecu,espec[,i],type='l',col=arco[i])
}
###################################################
}
p_fin = fr_muestreo*60*5
sp    = specgram(DATOS[1:p_fin],Fs=fr_muestreo)
espec = Mod(sp$S)
frecu = sp$f
tiemp = sp$t
dt = tiemp[2]-tiemp[1]
df = frecu[2]-frecu[1]
lf = length(frecu)
sup_l = (100/df) +1
lf    = min(lf,sup_l)
espec = espec[1:sup_l,]
espec = espec[1:lf,]
frecu = frecu[1:lf]
lt = length(tiemp)
lf = length(frecu)
arco  = rainbow(lf)
plot(frecu,espec[,1],type='l',
main=paste0(nombre,' | ',ch_actual,' | 5 min'),
xlab='Frecuencia (Hz)',ylab='Amplitud',
xaxt='n',
col=arco[1],
ylim=c(0,quantile(espec[1,],.75)),
bty='n')
abline(v=0.5,col='gray')
abline(v=3.5,col='gray')
abline(v=  7,col='gray')
abline(v= 12,col='gray')
abline(v= 30,col='gray')
abline(v= 12,col='gray')
abline(v= 30,col='gray')
abline(v=100,col='gray')
for(i in 1:lt){
lines(frecu,espec[,i],type='l',col=arco[i])
}
}
par(mar=c(3,3,0,1),mgp=c(2,1,0))
setwd(epocas_dir)
mor    = scan(paste0('epocas_mor_',nombre,'.txt'))
epoca1 = mor[1]*dur_epoca
p_ini  = epoca1*fr_muestreo
p_fin  = p_ini + fr_muestreo*60*5
sp    = specgram(DATOS[p_ini:p_fin],Fs=fr_muestreo)
espec = Mod(sp$S)
frecu = sp$f
tiemp = sp$t
dt = tiemp[2]-tiemp[1]
df = frecu[2]-frecu[1]
lf = length(frecu)
sup_l = (100/df) +1
lf    = min(lf,sup_l)
espec = espec[1:lf,]
frecu = frecu[1:lf]
lt = length(tiemp)
lf = length(frecu)
arco  = rainbow(lf)
plot(frecu,espec[,1],type='l',
main=paste0(nombre,' | ',ch_actual,' | MOR'),
xlab='Frecuencia (Hz)',ylab='Amplitud',
#xaxt='n',
col=arco[1],
ylim=c(0,quantile(espec[1,],.75)),
bty='n')
abline(v=0.5,col='gray')
abline(v=3.5,col='gray')
abline(v=  7,col='gray')
abline(v= 12,col='gray')
abline(v= 30,col='gray')
abline(v=100,col='gray')
for(i in 1:lt){
lines(frecu,espec[,i],type='l',col=arco[i])
}
par(mfrow=c(2,1),mar=c(2,3,1,1),mgp=c(2,1,0))
{
###################################################
# los primeros 5 minutos
p_fin = fr_muestreo*60*5
#sp    = specgram(DATOS[1:p_fin]-mean(DATOS[1:p_fin]),Fs=fr_muestreo)
sp    = specgram(DATOS[1:p_fin],Fs=fr_muestreo)
espec = Mod(sp$S)
frecu = sp$f
tiemp = sp$t
dt = tiemp[2]-tiemp[1]
df = frecu[2]-frecu[1]
lf = length(frecu)
sup_l = (100/df) +1
lf    = min(lf,sup_l)
espec = espec[1:lf,]
frecu = frecu[1:lf]
lt = length(tiemp)
lf = length(frecu)
arco  = rainbow(lf)
plot(frecu,espec[,1],type='l',
main=paste0(nombre,' | ',ch_actual,' | 5 min'),
xlab='Frecuencia (Hz)',ylab='Amplitud',
xaxt='n',
col=arco[1],
#ylim=c(0,quantile(espec[1,],.75)),
bty='n')
abline(v=0.5,col='gray')
abline(v=3.5,col='gray')
abline(v=  7,col='gray')
abline(v= 12,col='gray')
abline(v= 30,col='gray')
abline(v=100,col='gray')
for(i in 1:lt){
lines(frecu,espec[,i],type='l',col=arco[i])
}
###################################################
}
plot(frecu,espec[,1],type='l',
main=paste0(nombre,' | ',ch_actual,' | 5 min'),
xlab='Frecuencia (Hz)',ylab='Amplitud',
xaxt='n',
col=arco[1],
#ylim=c(0,quantile(espec[1,],.75)),
ylim=c(0,max(espec)),
bty='n')
abline(v=0.5,col='gray')
abline(v=3.5,col='gray')
abline(v=  7,col='gray')
abline(v= 12,col='gray')
abline(v= 30,col='gray')
abline(v=100,col='gray')
for(i in 1:lt){
lines(frecu,espec[,i],type='l',col=arco[i])
}
plot(frecu,espec[,1],type='l',
main=paste0(nombre,' | ',ch_actual,' | 5 min'),
xlab='Frecuencia (Hz)',ylab='Amplitud',
xaxt='n',
col=arco[1],
#ylim=c(0,quantile(espec[1,],.75)),
ylim=c(0,max(espec[2,])),
bty='n')
abline(v=0.5,col='gray')
abline(v=3.5,col='gray')
abline(v=  7,col='gray')
abline(v= 12,col='gray')
abline(v= 30,col='gray')
abline(v=100,col='gray')
for(i in 1:lt){
lines(frecu,espec[,i],type='l',col=arco[i])
}
plot(frecu,espec[,1],type='l',
main=paste0(nombre,' | ',ch_actual,' | 5 min'),
xlab='Frecuencia (Hz)',ylab='Amplitud',
xaxt='n',
col=arco[1],
ylim=c(0,quantile(espec[1,],.95)),
#ylim=c(0,max(espec[2,])),
bty='n')
abline(v=0.5,col='gray')
abline(v=3.5,col='gray')
abline(v=  7,col='gray')
abline(v= 30,col='gray')
abline(v= 12,col='gray')
abline(v=100,col='gray')
for(i in 1:lt){
lines(frecu,espec[,i],type='l',col=arco[i])
}
plot(frecu,espec[,1],type='l',
main=paste0(nombre,' | ',ch_actual,' | 5 min'),
xlab='Frecuencia (Hz)',ylab='Amplitud',
xaxt='n',
col=arco[1],
ylim=c(0,quantile(espec[1,],.9)),
#ylim=c(0,max(espec[2,])),
bty='n')
abline(v=0.5,col='gray')
abline(v=3.5,col='gray')
abline(v=  7,col='gray')
abline(v= 12,col='gray')
abline(v= 30,col='gray')
abline(v=100,col='gray')
for(i in 1:lt){
lines(frecu,espec[,i],type='l',col=arco[i])
}
source('C:/Users/EQUIPO 1/Desktop/julio/DATOS/JGMN6SUE/buscanod_delta01.R')
source('C:/Users/EQUIPO 1/Desktop/julio/DATOS/JGMN6SUE/buscanod_delta01.R')
dev.off()
dev.off()
dev.off()
dev.off()
sujeto = 1
source('C:/Users/EQUIPO 1/Desktop/julio/DATOS/JGMN6SUE/buscanod_delta01.R')
for(sujeto in 2:12){
source('C:/Users/EQUIPO 1/Desktop/julio/DATOS/JGMN6SUE/buscanod_delta01.R')
}
R = rnorm(512*30)
s = cos(seq(0,30,by=1/512))
s = cos(seq(0,30,by=1/512))[2:length(S)]
s = cos(seq(0,30,by=1/512))[2:length(s)]
s = seq(0,30,by=1/512))[2:length(s)]
t = seq(0,30,by=1/512)[2:length(s)]
plot(t,r+s)
plot(t,R+s)
t = seq(0,30,by=1/512)[1:length(R)]
plot(t,R+s)
plot(t,R+s,type='l')
s = cos(0.5*seq(0,30,by=1/512))[2:length(S)]
s = cos(0.5*seq(0,30,by=1/512))[2:length(s)]
s = cos(0.5*seq(0,30,by=1/512))[1:length(R)]
plot(t,R+s,type='l')
plot(t,R*0.5+s,type='l')
y = R*o.5+s
y = R*0.5+s
a = specgram(y)
plot(a)
a = Mod(fft(y))
plot(a,type='l')
plot(a[1:(length(a)/2)],type='l')
plot(t,y,type='l')
plot(a[1:(length(a)/2)],type='l')
y.t = ts(y,frequency = 512,start=c(0,0))
y.s = stl(y.t,s.window = 'periodic')
y.r = y.s$time.series[,'remainder']
plot(t,y.t,type='l')
plot(t,y.r,type='l')
a.r = Mod(fft(y.r))
plot(a.r[1:(length(a.r)/2)],type='l')
diffuso = seq(0.5,3.5)
for(i in 1:length(diffuso)){
senal = senal + cos(diffuso[i]*t)
}
senal = t*0
for(i in 1:length(diffuso)){
senal = senal + cos(diffuso[i]*t)
}
plot(t,senal+R,xlab='tiempo (s)',ylab='amplitud',main='Señal con ruido')
plot(t,senal+R,xlab='tiempo (s)',ylab='amplitud',main='Señal con ruido',type='l')
y = y+R
esp = Mod(fft(senal))
plot(esp[1:(length(esp)/2)])
plot(esp[1:(length(esp)/2)],type='l')
esp = specgram(senal)$S
plot(esp,type='l')
plot(Mod(esp),type='l')
esp = Mod(specgram(senal)$S)[,1]
plot(esp,type='l')
plot(esp,type='l',xlab='frecuencia (Hz)',ylab='amplitud',main='Periodograma de la señal con ruido')
senal.t = ts(senal,frequency = 512)
senal.s = stl(senal.t,s.window = 'periodic')
plot(senal.s)
senal.r = senal.s$time.series[,'remainder']
plot(t,senal.t,xlab='tiempo (s)',ylab='amplitud',main='Señal filtrada')
plot(t,senal.t,xlab='tiempo (s)',ylab='amplitud',main='Señal filtrada',type='l')
esp.r = Mod(specgram(senal.r)$S)[,1]
plot(esp.r,type='l',xlab='frecuencia (Hz)',ylab='amplitud',main='Periodograma de la señal con ruido')
plot(esp.r,type='l',xlab='frecuencia (Hz)',ylab='amplitud',main='Periodograma de la señal filtrada')
plot(esp,type='l',xlab='frecuencia (Hz)',ylab='amplitud',main='Periodograma de la señal con ruido')
plot(senal)
senal = senal +R
esp = specgram(senal)$S
esp = Mod(specgram(senal)$S)[,1]
plot(esp,type='l',xlab='frecuencia (Hz)',ylab='amplitud',main='Periodograma de la señal con ruido')
senal.t = ts(senal,frequency = 512)
senal.s = stl(senal.t,s.window = 'periodic')
plot(senal.s)
senal.r = senal.s$time.series[,'remainder']
plot(t,senal.r,xlab='tiempo (s)',ylab='amplitud',type='l')
plot(t,senal.r,xlab='tiempo (s)',ylab='amplitud',type='l',main='Señal filtrada')
esp.r = Mod(specgram(senal.r)$S)[,1]
plot(esp.r,type='l',xlab='frecuencia (Hz)',ylab='amplitud',main='Periodograma de la señal filtrada')
plot(esp,type='l',xlab='frecuencia (Hz)',ylab='amplitud',main='Periodograma de la señal con ruido')
ej1 = senal - senal.s$time.series[,'seasonal']
ej.p = Mod(specgram(ej1))
typeof(ej1)
ej.p = Mod(specgram(ej1))
ej.p = Mod(specgram(ej1)$S)
plot(ej.p[,1])
plot(ej.p[,1],type='l')
plot(ej.p[,1],type='l',xlab='tiempo (s)',ylab='amplitud',main='senal sin periodicidad, periodograma')
ej2 = senal - senal.s$time.series[,'trend']
ej2.p = Mod(specgram(ej2)$S)
plot(ej2.p[,1],type='l',xlab='tiempo (s)',ylab='amplitud',main='senal sin tendencia, periodograma')
plot(ej1)
plot(ej2)
ej3 = senal + t
plot(t,ej3,xlab='tiempo (s)',ylab='mV?',main='Señal con tendenci y ruido')
plot(t,ej3,xlab='tiempo (s)',ylab='mV?',main='Señal con tendenci y ruido',type='l')
sp3 = Mod(specgram(ej3)$S)
plot(sp3,xlab='frecuencia (Hz)',ylab='amplitud',main='periodograma de señal con ruido y tendencia')
plot(sp3[,1],xlab='frecuencia (Hz)',ylab='amplitud',main='periodograma de señal con ruido y tendencia')
plot(sp3[,1],xlab='frecuencia (Hz)',ylab='amplitud',main='periodograma de señal con ruido y tendencia',type='l')
ej3.t = ts(ej3,frequency = 512)
ej3.s = stl(ej3.t,s.window = 'periodic')
plot(ej3.s)
ej3.r = ej3.s$time.series[,'remainder']
plot(t,ej3.r,xlab='tiempo (s)',ylab='mV?',type='l',main='periodograma de señal con tendencia, pero filtrada')
plot(t,ej3.r,xlab='tiempo (s)',ylab='mV?',type='l',main='señal con tendencia, pero filtrada')
sp3.r = Mod(specgram(ej3.r)$S)
sp3.r = Mod(specgram(ej3.r)$S)
plot(sp3.r[,1],xlab='frecuencia (Hz)',ylab='amplitud',main='periodograma de señal con ruido y tendencia, filtrada',type='l')