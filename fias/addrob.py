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

def import_file(table, file_name, remove_tsv_file=1, import_tsv_file=1):

    cnt = 0
    total = 0
    line = ""

    for record in table:
        #print(record)
        #break
        total += 1

        if record.livestatus == 1:
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
            formalname = record.formalname.strip()
            ifnsfl    = record.ifnsfl.strip()
            ifnsul    = record.ifnsul.strip()
            nextid    = record.nextid.strip()
            if not nextid:
                nextid = '00000000-0000-0000-0000-000000000000'
            offname   = record.offname.strip()
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

            line += actstatus + "\t" + aoguid + "\t" + aoid + "\t" + aolevel + "\t" + areacode + "\t" + autocode + "\t" + \
                    centstatus + "\t" + citycode + "\t" + code + "\t" + currstatus + "\t" + enddate + "\t" + formalname + "\t" + \
                    ifnsfl + "\t" + ifnsul + "\t" + nextid + "\t" + offname + "\t" + okato + "\t" + oktmo + "\t" + operstatus + "\t" + parentguid + "\t" + placecode + "\t" + \
                    plaincode + "\t" + postalcode + "\t" + previd + "\t" + regioncode + "\t" + shortname + "\t" + startdate + "\t" + \
                    streetcode + "\t" + terrifnsfl + "\t" + terrifnsul + "\t" + updatedate + "\t" + ctarcode + "\t" + extrcode + "\t" + \
                    sextcode + "\t" + livestatus + "\t" + normdoc + "\t" + plancode + "\t" + cadnum + "\t" + divtype + \
                    "\t" + offname.upper() + "\n"
            cnt += 1
            #break

    log = open(file_name, 'w+')
    log.write(line)
    log.close()

    # Импорт в clickhouse
    if import_tsv_file == 1:
        cmd = 'cat ' + file_name + ' | clickhouse-client --database=fias --query="INSERT INTO addrob FORMAT TSV"';
        os.system(cmd)

    # Удаляем TSV файл
    if remove_tsv_file == 1 and import_tsv_file == 1:
        cmd_del = 'rm ' + file_name;
        os.system(cmd_del)

    print(str(datetime.datetime.now()) + ": " + str(cnt) + "(" + str(total) + ") " + file_name)

if __name__ == "__main__":

    print(str(datetime.datetime.now()) + ': старт')

    for x in range(1, 100):
        file_name = "ADDROB" + str(x).rjust(2, '0')

        try:
            table = dbf.Table("fias_dbf/" + file_name + ".DBF")
            table.open()
        except:
            continue

        import_file(table, "fias_csv/" + file_name + '.tsv')
        #break
    print(str(datetime.datetime.now()) + ': финиш')
