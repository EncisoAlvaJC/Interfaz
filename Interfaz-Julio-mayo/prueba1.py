#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 16 11:23:19 2018

@author: eroland
"""
from rpy2.robjects.packages import STAP
import pandas as pd
import numpy as np

with open('D:/DIART/Estancia/JULIO/Interfaz/colorcitos_usable02.R', 'r') as f:
    string = f.read()

colorcitos = STAP(string, "colorcitos")
                
sujeto=1
frecuenciasss=(512)
nombres = (['GURM251148SUE'])
etiqueta = (['GUR'])
directorio =(['GURM_revisado'])
res = 'D:/DIART/Estancia/JULIO/datos/Imagenes/'

a = colorcitos.colorcitos(sujeto, frecuenciasss, nombres, etiqueta, directorio, res)
aa = np.asmatrix(a)
df=pd.DataFrame(aa)
df.to_csv('aa.csv', header=False, index =False)
#a = np.asmatrix(a)