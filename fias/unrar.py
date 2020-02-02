#!/usr/bin/python3
import os
import patoolib

rar_file = 'fias_dbf.rar'
dbf_folder = 'fias_dbf/'

if __name__ == '__main__':

    patoolib.extract_archive(rar_file, outdir=dbf_folder)
    #cmd = 'unrar e ' + rar_file + ' ' + dbf_folder + '/'
    #os.system(cmd)
