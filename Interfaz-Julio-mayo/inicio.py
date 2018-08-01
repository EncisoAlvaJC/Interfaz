# -*- coding: utf-8 -*-
"""
Created on Wed Feb 28 05:18:33 2018

@author: Clandestina
"""

import sys
from PyQt5.QtWidgets import QMainWindow, QApplication
from modules.vistaPrincipal import vistaPrincipal

class inicio(QMainWindow):
 
    def __init__(self):
        super().__init__()
        self.setWindowTitle('Análisis de Sueño')
        self.table_widget = vistaPrincipal(self)
        self.setCentralWidget(self.table_widget)
        self.showMaximized()
        self.show()
        
        
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = inicio()
    sys.exit(app.exec_())
    