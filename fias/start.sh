#!/bin/bash

now=$(date +"%d-%m-%Y_%H-%M-%S")
file="logs/$now.log"

time ./addrob.py >> $file
