#!/usr/bin/python3

#  0 - aoguid    : 'b12be701-c8a2-4493-8469-046721dd7aa9'
#  1 - buildnum  : '          '
#  2 - enddate   : datetime.date(2079, 6, 6)
#  3 - eststatus : 3
#  4 - houseguid : '22bcb5be-abba-4529-8c36-4970b8e39428'
#  5 - houseid   : 'dc87e43c-c3f3-4c8b-889a-0000a5470fb7'
#  6 - housenum  : '42                  '
#  7 - statstatus: 0
#  8 - ifnsfl    : '0105'
#  9 - ifnsul    : '0105'
# 10 - okato     : '79222000017'
# 11 - oktmo     : '79622457101'
# 12 - postalcode: '385751'
# 13 - startdate : datetime.date(2017, 3, 23)
# 14 - strucnum  : '          '
# 15 - strstatus : 0
# 16 - terrifnsfl: '0104'
# 17 - terrifnsul: '0104'
# 18 - updatedate: datetime.date(2017, 4, 4)
# 19 - normdoc   : 'd73fe747-cd9d-4800-8fd3-46a39841b503'
# 20 - counter   : 26
# 21 - cadnum    : '                                                                                                    '
# 22 - divtype   : 0

import dbf
import datetime
import os

def import_file(table, file_name, remove_tsv_file=1, import_tsv_file=1):

    cnt = 0
    total = 0
    line = ""
    for record in table:
        '''
        if cnt == 55222:
            print(record)
            break;
        '''

        total += 1

        if datetime.date.today() < record.enddate:
            aoguid     = record.aoguid.strip()
            if not aoguid:
                aoguid = '00000000-0000-0000-0000-000000000000'
            buildnum   = record.buildnum.strip()
            enddate    = str(record.enddate)
            eststatus  = str(record.eststatus)
            houseguid  = record.houseguid.strip()
            if not houseguid:
                houseguid = '00000000-0000-0000-0000-000000000000'
            houseid    = record.houseid.strip()
            if not houseid:
                houseid = '00000000-0000-0000-0000-000000000000'
            housenum   = record.housenum.strip().upper()
            statstatus = str(record.statstatus)
            ifnsfl     = record.ifnsfl.strip()
            ifnsul     = record.ifnsul.strip()
            okato      = record.okato.strip()
            oktmo      = record.oktmo.strip()
            postalcode = record.postalcode.strip()
            startdate  = str(record.startdate)
            strucnum   = record.strucnum.strip()
            strstatus  = str(record.strstatus)
            terrifnsfl = record.terrifnsfl.strip()
            terrifnsul = record.terrifnsul.strip()
            updatedate = str(record.updatedate)
            normdoc    = record.normdoc.strip()
            if not normdoc:
                normdoc = '00000000-0000-0000-0000-000000000000'
            counter    = str(record.counter)
            cadnum     = record.cadnum.strip().replace('\t', '\\t').replace('\\', '\\\\')
            divtype    = str(record.divtype)

            line += aoguid + "\t" + buildnum + "\t" + enddate + "\t" + eststatus + "\t" + \
                    houseguid + "\t" + houseid + "\t" + housenum + "\t" + statstatus + "\t" + \
                    ifnsfl + "\t" + ifnsul + "\t" + okato + "\t" + oktmo + "\t" + \
                    postalcode + "\t" + startdate + "\t" + strucnum + "\t" + strstatus + "\t" + \
                    terrifnsfl + "\t" + terrifnsul + "\t" + updatedate + "\t" + normdoc + "\t" + \
                    counter + "\t" + cadnum + "\t" + divtype + "\t" + housenum.upper() + "\n"
            '''
            if houseguid == 'b866f854-3447-4ed3-8138-09e655357e40':
                print(record)
                break;
            '''
            cnt += 1

    log = open(file_name, 'w+')
    log.write(line)
    log.close()

    # Импорт в clickhouse
    if import_tsv_file == 1:
        cmd = 'cat ' + file_name + ' | clickhouse-client --database=fias --query="INSERT INTO house FORMAT TSV"';
        os.system(cmd)

    # Удаляем TSV файл
    if remove_tsv_file == 1 and import_tsv_file == 1:
        cmd_del = 'rm ' + file_name;
        os.system(cmd_del)

    print(str(datetime.datetime.now()) + ": " + str(cnt) + "(" + str(total) + ") " + file_name)

if __name__ == "__main__":

    print(str(datetime.datetime.now()) + ': старт')

    for x in range(1, 100):
        file_name = "HOUSE" + str(x).rjust(2, '0')

        try:
            table = dbf.Table("fias_dbf/" + file_name + ".DBF")
            table.open()
        except:
            continue

        import_file(table, "fias_csv/" + file_name + '.tsv', 0, 1)
        #break

    print(str(datetime.datetime.now()) + ': финиш')
