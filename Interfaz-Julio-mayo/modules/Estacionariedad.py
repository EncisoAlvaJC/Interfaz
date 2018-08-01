# -*- coding: utf-8 -*-
"""
Created on Wed Feb 28 05:31:04 2018

@author: Clandestina
"""

import pyqtgraph as pg
from PyQt5.QtWidgets import (QVBoxLayout, QHBoxLayout, QPushButton, QFileDialog, QMessageBox,QTableWidget,QTableWidgetItem, QWidget, QSplitter, QFormLayout, QComboBox)#, QTabWidget, QVBoxLayout, QWidget)
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QPainterPath
import os
from rpy2.robjects.packages import STAP
import rpy2.robjects as robjects
import numpy as np


class Estacionariedad(QVBoxLayout):
    
    def __init__(self):      
        super().__init__()
        self.initUI()
    
#%%
    def showDialog(self):
        
        if((self.data_dir!='')&(self.result_dir!='')):
            grupo_de=[]
            frecuenciasss=[]
            tam = self.table.rowCount()
            self.sizeEpo = self.sizes[self.cmbEpoch.currentIndex()]
            for i in range(tam):
                grupo_de.append(int(self.table.item(i,3).text()))
                frecuenciasss.append(int(self.table.item(i,4).text()))
            grupo_de = 1#robjects.IntVector(grupo_de)
            frecuenciasss = robjects.IntVector(frecuenciasss)
            #print(self.data_dir)
            print(os.getcwd() + '/')
            #print(self.result_dir)
            #print(self.nom_dir)
            #print(self.nom_arch)
            #print(self.nom_facil)
            #print(grupo_de, frecuenciasss)
            #print(self.sizeEpo)
            with open('estacionariedad.R', 'r') as f:
                string = f.read()
            estacionariedad = STAP(string, "estacionariedad")
            estacionariedad.estacionariedad(self.data_dir, os.getcwd() + '/', self.result_dir, self.nom_dir, self.nom_arch, self.nom_facil, grupo_de, frecuenciasss, self.sizeEpo)
        else:
            QMessageBox.critical(None, "Alerta","Debes seleccionar un directorio de datos y otro para salvar resultados ", QMessageBox.Ok)
            
#%%
    def openFiles(self, bot):
        if (bot == 1):
            self.data_dir = QFileDialog.getExistingDirectory(None, 'Open Directory', '/home') 
            self.data_dir = self.data_dir + '/'
            self.nom_dir = os.listdir(self.data_dir)
            for i in self.nom_dir:
                elemento = os.listdir(self.data_dir+"/"+i)[0]
                elemento = str.split(elemento,'_')[0]
                self.nom_arch.append(elemento)
                self.nom_facil.append(elemento[0:3])
        elif (bot == 2):
            self.result_dir = QFileDialog.getExistingDirectory(None, 'Open Directory', '/home') 
            self.result_dir = self.result_dir + '/'
            print(self.result_dir)

#%%
    def llenarTabla(self):
        filas=len(self.nom_facil)
        self.table.setRowCount(filas)
        self.table.setColumnCount(5)
        for i in range(filas):
            self.table.setItem(i,0,QTableWidgetItem(self.nom_dir[i]))
            self.table.setItem(i,1,QTableWidgetItem(self.nom_arch[i]))
            self.table.setItem(i,2,QTableWidgetItem(self.nom_facil[i]))
            self.table.setItem(i,3,QTableWidgetItem(""))
            self.table.setItem(i,4,QTableWidgetItem(""))
    
#%%
    def recuperaSujeto(self):
        self.sizeEpo = self.sizes[self.cmbEpoch.currentIndex()]
        print("En ress")
        rowTable = self.table.currentRow()
        print("1")
        sujeto=rowTable+1
        frecuenciasss=(512)#self.table.itemAt(rowTable,4).text()
        nombres = [self.table.item(rowTable,1).text()]#(['GURM251148SUE'])
        etiqueta = [self.table.item(rowTable,2).text()]# (['GUR'])
        directorio = self.nom_dir#self.data_dir+self.nom_dir
        res = self.result_dir
        with open(self.actual_dir+'\colorcitos_usable02.R', 'r') as f: string = f.read()
        colorcitos = STAP(string, "colorcitos")
        
#        print('Sujeto: ', sujeto)
#        print(frecuenciasss)
#        print(nombres)
#        print(etiqueta)
#        print(directorio[sujeto-1])
#        print(res)
#        print(self.sizeEpo)
        imagen = colorcitos.colorcitos(1, frecuenciasss, nombres, etiqueta, list(directorio[sujeto-1]), res, self.sizeEpo)
        imagen = np.asmatrix(imagen)
        imagen=np.asarray(imagen)
        cont=0
        tamX = imagen.shape[1]
        self.p1.setXRange(-0.5, tamX+0.5)
        
        ejeX =[]
        for i in  range(int(self.sizeEpo)):
            ejeX.append(i*self.sizeEpo)
        
        for i in range(21,-1,-1):
            x=np.where(imagen[i,:]>0)
            ta=len(x[0])
            x=x[0]
            self.spis[cont].setData(x, cont + 0.5 + np.zeros((ta,)))
            cont=cont+1
        self.lblTit.setText("<span style='font-size: 12pt; color : black'> <b>Sujeto: %s</b></span>"%  self.table.item(rowTable,1).text())

#        xdict = dict(enumerate(ejeX))
#        stringaxis = pg.AxisItem(orientation='bottom')
#        stringaxis.setTicks([xdict.items()])
#        
#        self.glw.addItem(axisItems={'bottom': stringaxis}, row=1, col=1)
        
        self.p1.plot()

#%%           
    def initUI(self):
        pg.setConfigOption('background', 'w')
        self.actual_dir=os.getcwd()
        self.lblTit = pg.LabelItem(justify='right')
        
#        self.lblTit.setText("Hola")
        #Variables
        self.data_dir=''
        self.result_dir=''
        self.nom_dir = []
        self.nom_arch=[]
        self.nom_facil = []
        self.sizes = np.asarray([120, 60, 30, 15, 7.5, 3.75, 1.875, 0.9375])

        buttons = QHBoxLayout()
        datos = QVBoxLayout()
        contain=QSplitter(Qt.Horizontal)
        ima = QVBoxLayout()
        
        self.glw = pg.GraphicsLayoutWidget(border=(100,100,100))
        self.glw.useOpenGL(True)
        self.glw.addItem(self.lblTit, col=1, colspan=4)
        self.glw.nextRow()
        self.glw.addLabel('Canales', angle=-90, rowspan=3)
        
        
        
        vtick = QPainterPath()
        vtick.moveTo(0, -0.5)
        vtick.lineTo(0,0.5)
        vtick.addRect(0,0.5,1,1)

        s1 = pg.ScatterPlotItem(pxMode=False)
        s1.setSymbol(vtick)
        s1.setSize(1)

        s2 = pg.ScatterPlotItem(pxMode=False)
        s2.setSymbol(vtick)
        s2.setSize(1)
        
        s3 = pg.ScatterPlotItem(pxMode=False)
        s3.setSymbol(vtick)
        s3.setSize(1)
#        s3.setPen=(QColor(*np.random.randint(0, 255 + 1, 3).tolist()))
        
        s4 = pg.ScatterPlotItem(pxMode=False)
        s4.setSymbol(vtick)
        s4.setSize(1)
        
        s5 = pg.ScatterPlotItem(pxMode=False)
        s5.setSymbol(vtick)
        s5.setSize(1)
        
        s6 = pg.ScatterPlotItem(pxMode=False)
        s6.setSymbol(vtick)
        s6.setSize(1)
        
        s7 = pg.ScatterPlotItem(pxMode=False)
        s7.setSymbol(vtick)
        s7.setSize(1)
        
        s8 = pg.ScatterPlotItem(pxMode=False)
        s8.setSymbol(vtick)
        s8.setSize(1)
        
        s9 = pg.ScatterPlotItem(pxMode=False)
        s9.setSymbol(vtick)
        s9.setSize(1)
        
        s10 = pg.ScatterPlotItem(pxMode=False)
        s10.setSymbol(vtick)
        s10.setSize(1)
        
        s11 = pg.ScatterPlotItem(pxMode=False)
        s11.setSymbol(vtick)
        s11.setSize(1)
        
        s12 = pg.ScatterPlotItem(pxMode=False)
        s12.setSymbol(vtick)
        s12.setSize(1)
        
        s13 = pg.ScatterPlotItem(pxMode=False)
        s13.setSymbol(vtick)
        s13.setSize(1)
        
        s14 = pg.ScatterPlotItem(pxMode=False)
        s14.setSymbol(vtick)
        s14.setSize(1)
        
        s15 = pg.ScatterPlotItem(pxMode=False)
        s15.setSymbol(vtick)
        s15.setSize(1)
        
        s16 = pg.ScatterPlotItem(pxMode=False)
        s16.setSymbol(vtick)
        s16.setSize(1)
        
        s17 = pg.ScatterPlotItem(pxMode=False)
        s17.setSymbol(vtick)
        s17.setSize(1)
        
        s18 = pg.ScatterPlotItem(pxMode=False)
        s18.setSymbol(vtick)
        s18.setSize(1)
        
        s19 = pg.ScatterPlotItem(pxMode=False)
        s19.setSymbol(vtick)
        s19.setSize(1)
        
        s20 = pg.ScatterPlotItem(pxMode=False)
        s20.setSymbol(vtick)
        s20.setSize(1)
        
        s21 = pg.ScatterPlotItem(pxMode=False)
        s21.setSymbol(vtick)
        s21.setSize(1)
        
        s22 = pg.ScatterPlotItem(pxMode=False)
        s22.setSymbol(vtick)
        s22.setSize(1)
        
        y =['0', 'EMG', 'ROG',  'LOG',  'T6',  'T5',  'T4',  'T3',  'PZ',  'P4', 'P3',  'O2', 'O1', 'FZ', 'FP2', 'FP1', 'F8', 'F7', 'F4', 'F3', 'CZ', 'C4', 'C3']
        ydict = dict(enumerate(y))
        stringaxis = pg.AxisItem(orientation='left')
        stringaxis.setTicks([ydict.items()])
        
        
        self.p1 = self.glw.addPlot(axisItems={'left': stringaxis}, row=1, col=1)
        
#        self.p2 = self.glw.addPlot(col=0)
        
#        self.p1.setYRange(-0.5, 26.5, padding=0)
        self.p1.setLimits(yMin=-0.5)
        self.p1.setLimits(yMax=26.5)
        
        
        
        self.p1.addItem(s1)
        self.p1.addItem(s2)
        self.p1.addItem(s3)
        self.p1.addItem(s4)
        self.p1.addItem(s5)
        self.p1.addItem(s6)
        self.p1.addItem(s7)
        self.p1.addItem(s8)
        self.p1.addItem(s9)
        self.p1.addItem(s10)
        self.p1.addItem(s11)
        self.p1.addItem(s12)
        self.p1.addItem(s13)
        self.p1.addItem(s14)
        self.p1.addItem(s15)
        self.p1.addItem(s16)
        self.p1.addItem(s17)
        self.p1.addItem(s18)
        self.p1.addItem(s19)
        self.p1.addItem(s20)
        self.p1.addItem(s21)
        self.p1.addItem(s22)
        
        self.spis = [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22]
        
        self.lytEpoch = QFormLayout()
        self.cmbEpoch = QComboBox()
        self.cmbEpoch.addItem("120")
        self.cmbEpoch.addItem("60")
        self.cmbEpoch.addItem("30")
        self.cmbEpoch.addItem("15")
        self.cmbEpoch.addItem("7.5")
        self.cmbEpoch.addItem("3.75")
        self.cmbEpoch.addItem("1.875")
        self.cmbEpoch.addItem("0.9375")
        
        self.lytEpoch.addRow("Epoch size: ", self.cmbEpoch)

        btn_data_dir = QPushButton('Load Files')        
        btn_data_dir.clicked.connect(lambda: self.openFiles(1))
        
        btn_result_dir = QPushButton('Save Results')
        btn_result_dir.clicked.connect(lambda: self.openFiles(2))
        
        btn_do = QPushButton('Do')
        btn_do.clicked.connect(self.llenarTabla)
        
        self.table = QTableWidget()
        
        btn_make = QPushButton('Processing')
        btn_make.clicked.connect(self.showDialog)
        
        btn_showSujeto = QPushButton('Sujeto')
        btn_showSujeto.clicked.connect(self.recuperaSujeto)
        
        datos.addLayout(self.lytEpoch)
        buttons.addWidget(btn_data_dir)
        buttons.addWidget(btn_result_dir)
        buttons.addWidget(btn_do)
        datos.addLayout(buttons)
        datos.addWidget(self.table)
        datos.addWidget(btn_make)
        datos.addWidget(btn_showSujeto)
        ima.addWidget(self.glw)

        bot = QWidget()
        bot.setLayout(datos)
        gra = QWidget()
        gra.setLayout(ima)
        
        
        contain.addWidget(bot)
        contain.addWidget(gra)
        self.addWidget(contain)