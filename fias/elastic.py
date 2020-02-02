#!/usr/bin/python3

#  0 - actstatus : 1
#  1 - aoguid    : '1ac46b49-3209-4814-b7bf-a509ea1aecd9'
#  2 - aoid      : '1a8430ad-dcc9-43d9-81ea-948b90a25d8b'
#  3 - aolevel   : 1
#  4 - areacode  : '000'
#  5 - autocode  : '0'
#  6 - centstatus: 0
#  7 - citycode  : '000'
#  8 - code      : '5400000000000    '
#  9 - currstatus: 0
# 10 - enddate   : datetime.date(2079, 6, 6)
# 11 - formalname: 'Новосибирская                                                                                                           '
# 12 - ifnsfl    : '5400'
# 13 - ifnsul    : '5400'
# 14 - nextid    : '                                    '
# 15 - offname   : 'Новосибирская                                                                                                           '
# 16 - okato     : '50000000000'
# 17 - oktmo     : '           '
# 18 - operstatus: 1
# 19 - parentguid: '                                    '
# 20 - placecode : '000'
# 21 - plaincode : '54000000000    '
# 22 - postalcode: '      '
# 23 - previd    : '                                    '
# 24 - regioncode: '54'
# 25 - shortname : 'обл       '
# 26 - startdate : datetime.date(1900, 1, 1)
# 27 - streetcode: '0000'
# 28 - terrifnsfl: '    '
# 29 - terrifnsul: '    '
# 30 - updatedate: datetime.date(2015, 9, 15)
# 31 - ctarcode  : '000'
# 32 - extrcode  : '0000'
# 33 - sextcode  : '000'
# 34 - livestatus: 1
# 35 - normdoc   : '                                    '
# 36 - plancode  : '0000'
# 37 - cadnum    : '                                                                                                    '
# 38 - divtype   : 0

import dbf
import datetime
import os
import requests
import json

uri_create = 'http://localhost:9200/fias/addrob/'
uri_search = 'http://localhost:9200/fias/addrob/_search'
#ES_URL = 'http://localhost:9200'

# Создать индекс
def create_doc(uri, doc_data={}):
    query = json.dumps(doc_data)
    #print(query)
    response = requests.post(uri, data=query)

    json_response = response.json()
    #print(json_response)

# Поиск
def search(uri, term):
    query = json.dumps({
        "query": { "match_all": {} },
        "size": 1000
    })
    response = requests.get(uri, data=query)
    results = json.loads(response.text)
    #print(results)
    return results

def format_results(results):
    data = [doc for doc in results['hits']['hits']]
    for doc in data:
        #print("%s) %s" % (doc['_id'], doc['_source']['name']))
        print("%s" % (doc['_source']['name']))

if __name__ == '__main__':
    # Запись в лог о начале работы
    print(str(datetime.datetime.now()) + '\n')
    # Цикл по файлам
    for x in range(99, 100):
        # Формируем имя файла
        file_name = "ADDROB" + str(x).rjust(2, '0')
        # Пытаемся открыть dbf файл
        try:
            table = dbf.Table("fias_dbf/" + file_name + ".DBF")
            table.open()
        except:
            continue

        cnt = 0
        total = 0
        line = ""

        for record in table:
            #print(record)
            #break

            # Увеличиваем общее кол-во записей(во всех файлах)
            total += 1

            if datetime.date.today() < record.enddate:
                actstatus  = str(record.actstatus)
                aoguid     = record.aoguid.strip()
                aoid       = record.aoid.strip()
                aolevel    = str(record.aolevel)
                areacode   = record.areacode.strip()
                autocode   = record.autocode.strip()
                centstatus = str(record.centstatus)
                citycode   = record.citycode.strip()
                code       = record.code.strip()
                currstatus = str(record.currstatus)
                enddate    = str(record.enddate)
                formalname = record.formalname.strip().replace(',', '.').replace('"', '')
                ifnsfl    = record.ifnsfl.strip()
                ifnsul    = record.ifnsul.strip()
                nextid    = record.nextid.strip()
                if not nextid:
                    nextid = '00000000-0000-0000-0000-000000000000'
                offname   = record.offname.strip().replace(',', '.').replace('"', '').upper()
                okato      = record.okato.strip()
                oktmo      = record.oktmo.strip()
                operstatus = str(record.operstatus)
                parentguid = record.parentguid.strip()
                if not parentguid:
                    parentguid = '00000000-0000-0000-0000-000000000000'
                placecode  = record.placecode.strip()
                plaincode  = record.plaincode.strip()
                postalcode = record.postalcode.strip()
                previd     = record.previd.strip()
                if not previd:
                    previd = '00000000-0000-0000-0000-000000000000'
                regioncode = record.regioncode.strip()
                shortname  = record.shortname.strip()
                startdate  = str(record.startdate)
                streetcode = record.streetcode.strip()
                terrifnsfl = record.terrifnsfl.strip()
                terrifnsul = record.terrifnsul.strip()
                updatedate = str(record.updatedate)
                ctarcode   = record.ctarcode.strip()
                extrcode   = record.extrcode.strip()
                sextcode   = record.sextcode.strip()
                livestatus = str(record.livestatus)
                normdoc    = record.normdoc.strip()
                if not normdoc:
                    normdoc = '00000000-0000-0000-0000-000000000000'
                plancode   = record.plancode.strip()
                cadnum     = record.cadnum.strip()
                divtype    = str(record.divtype)

                # Увеличиваем кол-во записей в текущем файле
                cnt += 1

                #print(formalname)
                # помещаем в elastic
                create_doc(uri_create, {"name": formalname, "aoguid": aoguid, "parentguid": parentguid})


        # Запись в лог
        print('\n' + str(datetime.datetime.now()) + ": " + str(cnt) + "(" + str(total) + ") " + file_name)

    results = search(uri_search, "Байконур")
    format_results(results)

'''
curl -XPUT "localhost:9200/fias/?pretty" -d'
{
  "name": "Байконур",
  "aoguid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
  "parentguid": "00000000-0000-0000-0000-000000000000"
}'
curl -XPUT "localhost:9200/fias/?pretty" -d'
{
  "name": "Байконур2",
  "aoguid": "63ed1a35-4be6-4564-a1ec-0c51f7383314",
  "parentguid": "00000000-0000-0000-0000-000000000000"
}'

# Удалить все индексы
curl -X DELETE 'http://localhost:9200/_all'
'''
