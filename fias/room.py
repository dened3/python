#!/usr/bin/python3
'''
  0 - roomid    : '27820501-5978-494e-929d-3df0f572f522'
  1 - roomguid  : '27820501-5978-494e-929d-3df0f572f522'
  2 - houseguid : '1664a030-1b73-4e38-ac17-ed4a32a009e1'
  3 - regioncode: '54'
  4 - flatnumber: '2                                                 '
  5 - flattype  : 2
  6 - roomnumber: '                                                  '
  7 - roomtype  : '0 '
  8 - cadnum    : '                                                                                                    '
  9 - roomcadnum: '                                                                                                    '
 10 - postalcode: '630532'
 11 - updatedate: datetime.date(2017, 1, 10)
 12 - previd    : '                                    '
 13 - nextid    : '                                    '
 14 - operstatus: 10
 15 - startdate : datetime.date(2017, 1, 10)
 16 - enddate   : datetime.date(2079, 6, 6)
 17 - livestatus: 1
 18 - normdoc   : 'fd02c5ad-ff73-4d95-afbf-2cad716b33eb'
'''

import dbf
import datetime
import os

def import_room(table, file_name, remove_tsv_file=1, import_tsv_file=1):

    cnt = 0
    total = 0
    line = ''
    for record in table:
        #print(record)
        #break;

        total += 1

        if datetime.date.today() < record.enddate:
            roomid = record.roomid.strip()
            if not roomid:
                roomid = '00000000-0000-0000-0000-000000000000'
            roomguid = record.roomguid.strip()
            if not roomguid:
                roomguid = '00000000-0000-0000-0000-000000000000'
            houseguid = record.houseguid.strip()
            if not houseguid:
                houseguid = '00000000-0000-0000-0000-000000000000'
            regioncode = record.regioncode.strip()
            flatnumber = record.flatnumber.strip()
            flattype = str(record.flattype)
            roomnumber = record.roomnumber.strip()
            roomtype = record.roomtype.strip()
            cadnum = record.cadnum.strip()
            roomcadnum = record.roomcadnum.strip()
            postalcode = record.postalcode.strip()
            updatedate = str(record.updatedate)
            previd = record.previd.strip()
            if not previd:
                previd = '00000000-0000-0000-0000-000000000000'
            nextid = record.nextid.strip()
            if not nextid:
                nextid = '00000000-0000-0000-0000-000000000000'
            operstatus = str(record.operstatus)
            startdate = str(record.startdate)
            enddate = str(record.enddate)
            livestatus = str(record.livestatus)
            normdoc = record.normdoc.strip()
            if not normdoc:
                normdoc = '00000000-0000-0000-0000-000000000000'

            # line += houseguid + '\t' + flatnumber + '\n'

            line += roomid + '\t' + roomguid + '\t' + houseguid + '\t' + regioncode + '\t' + \
                    flatnumber + '\t' + flattype + '\t' + roomnumber + '\t' + roomtype + '\t' + \
                    cadnum + '\t' + roomcadnum + '\t' + postalcode + '\t' + updatedate + '\t' + \
                    previd + '\t' + nextid + '\t' + operstatus + '\t' + startdate + '\t' + \
                    enddate + '\t' + livestatus + '\t' + normdoc + '\t' + flatnumber.upper() + "\n"

            cnt += 1

    log = open(file_name, 'w+')
    log.write(line)
    log.close()

    # Импорт в clickhouse
    if import_tsv_file == 1:
        cmd = 'cat ' + file_name + ' | clickhouse-client --database=fias --query="INSERT INTO room FORMAT TSV"';
        os.system(cmd)

    # Удаляем TSV файл
    if remove_tsv_file == 1 and import_tsv_file == 1:
        cmd_del = 'rm ' + file_name;
        os.system(cmd_del)

    print(str(datetime.datetime.now()) + ': ' + str(cnt) + '(' + str(total) + ') ' + file_name)


if __name__ == '__main__':

    print(str(datetime.datetime.now()) + ': старт')

    for x in range(54, 55):
        file_name = 'ROOM' + str(x).rjust(2, '0')

        try:
            table = dbf.Table('fias_dbf/' + file_name + '.DBF')
            table.open()
        except:
            continue

        import_room(table, 'fias_csv/' + file_name + '.tsv', 0, 1)
        #break

    print(str(datetime.datetime.now()) + ': финиш')
