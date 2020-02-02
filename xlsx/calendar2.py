#!/usr/bin/python3
import json
import os
from datetime import datetime
import pandas as pd

class cld:
    def __init__(self, start_date, end_date):
        self.dbeg = start_date
        self.dend = end_date
        f = open('calendar.json')
        self.hd = json.loads(f.read())

    def get_wtime(self, date):
        try:
            res = self.hd[date.strftime("%d/%m/%Y")]['hours']
        except Exception as KeyError:
            #if date.strftime("%a") in ('Sat', 'Sun'):
            if date.strftime("%w") in ('0', '6'):
                res = 0
            else:
                res = 8
        return res

if __name__ == "__main__":

    dt = datetime.now()

    while 1 == 1:
        try:
            data = sys.argv[2]
        except Exception as e:
            data = input('Дата в формате dd/mm/yyyy [' + dt.strftime("%d/%m/%Y") + ']:')
            if data == "":
                data = dt.strftime("%d/%m/%Y")
        try:
            dt = datetime.strptime(data, '%d/%m/%Y')
            break
        except Exception as ValueError:
            pass

    prd = cld(dt, datetime.strptime('18/01/2020', '%d/%m/%Y'))

    #ch = prd.get_wtime(datetime.strptime('11/01/2020', '%d/%m/%Y'))
    ch = prd.get_wtime(dt)
    print(ch)

    daterange = pd.date_range(prd.dbeg, prd.dend)

    print(daterange)
