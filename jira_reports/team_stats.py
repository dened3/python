#!/usr/bin/python3
import sys
import cx_Oracle
import json
import excel
import os
from datetime import timedelta, date

connectJira = 'jira_user/qwe123@jira'
file_name = 'Статистика.xlsx'

cols = excel.cols

def fill_sheet(ws, team, days):
	# Фильтруем пользователей
	user_list = {}
	user_list_str = ''
	for u in data:
		if data[u]['team'] == team:
			user_list.update ({u : data[u]})
			user_list_str = user_list_str + "'" + str(u) + "',"

	user_list_str = user_list_str[:-1]

	rownum = 1
	#print(user_list_str)

	# Ширина столбцов
	ws.column_dimensions['A'].width = 14 # Задача
	ws.column_dimensions['B'].width = 80 # Описание
	ws.column_dimensions['C'].width = 11 # За период
	ws.column_dimensions['D'].width = 11 # Всего
	ws.column_dimensions['E'].width = 11 # Оценка

	# Заголовок
	excel.SetCell(ws['A' + str(rownum)], 'Команда', 'border bold')
	excel.SetCell(ws['B' + str(rownum)], team.upper(), 'border')
	rownum += 1
	excel.SetCell(ws['A' + str(rownum)], 'Участники', 'border bold top')
	for i in user_list:
		#print(user_list[i]['name'] + ' ' + user_list[i]['surname'])
		excel.SetCell(ws['B' + str(rownum)], user_list[i]['name'] + ' ' + user_list[i]['surname'], 'border')
		rownum += 1

	ws.merge_cells('A2:A' + str(rownum-1))

	#start = date_1 + datetime.timedelta(days=10)
	cnt = int(days)
	excel.SetCell(ws['A' + str(rownum)], 'Период', 'border bold')
	excel.SetCell(ws['B' + str(rownum)], 'С ' + (date.today() - timedelta(days=cnt)).strftime('%d/%m/%Y') + ' по ' + (date.today() - timedelta(days=1)).strftime('%d/%m/%Y'), 'border')
	rownum += 1
	#print('С ' + (date.today() - timedelta(days=cnt)).strftime('%d/%m/%Y') + ' по ' + (date.today() - timedelta(days=1)).strftime('%d/%m/%Y'))

	rownum += 1

	# Заполняем шапку
	excel.SetCell(ws['A' + str(rownum)], 'Задача', 'border center bold')
	excel.SetCell(ws['B' + str(rownum)], 'Описание', 'border center bold')
	excel.SetCell(ws['C' + str(rownum)], 'За период', 'border center bold')
	excel.SetCell(ws['D' + str(rownum)], 'Всего', 'border center bold')
	excel.SetCell(ws['E' + str(rownum)], 'Оценка', 'border center bold')

	# фиксируем области
	#ws.freeze_panes = 'D2'

	conJira = cx_Oracle.connect(connectJira)
	cur = conJira.cursor()

	sql = """select p.pkey || '-' || i.issuenum jiranum,
       i.summary,
       sum(w.timeworked / 60 / 60) period_worked,
       (
         select sum(z.worked) worked
             from (
            select round(sum(l.timeworked)/60/60) worked
            from jira.worklog l
           where l.issueid = i.id
            union all
            select round(sum( l.timeworked / 60 / 60 )) worked
              from jira.issuelink sl,
                 jira.worklog   l
             where sl.source = i.id
               and sl.linktype = 10020
               and l.issueid = sl.destination
         ) z
         ) total_worked,
         round(i.timeoriginalestimate/60/60) cost
  from jira.worklog   w,
       jira.jiraissue i,
       jira.project   p
 where w.author in (""" + user_list_str + """)
   and w.created > sysdate - """ + days + """
   and i.id = w.issueid
   and p.id = i.project
 group by i.summary,
          i.issuenum,
          p.pkey,
          i.id,
          i.timeoriginalestimate
 order by 3 desc"""

	cur.execute(sql)
	#rownum = 1
	while True:
		rownum += 1
		row = cur.fetchone()
		if row is None:
			break

		#print(row[0])
		excel.SetCell(ws['A' + str(rownum)], row[0], "border")
		excel.SetCell(ws['B' + str(rownum)], row[1], "border wrap")
		excel.SetCell(ws['C' + str(rownum)], row[2], "border")
		excel.SetCell(ws['D' + str(rownum)], row[3], "border")
		excel.SetCell(ws['E' + str(rownum)], row[4], "border")

	#
	sql = """with period as
(
 select trunc(sysdate) - rownum dat
   from dual
connect by level < """ + days + """
)
select to_char(t.dat, 'dd/mm/yyyy') dat,
       trim(to_char(t.dat, 'Day', 'nls_date_language = RUSSIAN')) wday,
       p.pkey || '-' || i.issuenum jiranum,
       i.summary,
       sum(w.timeworked / 60 / 60) period_worked
  from period t,
       jira.worklog   w,
       jira.jiraissue i,
       jira.project   p
 where w.author(+) in (""" + user_list_str + """)
   and w.created(+) between t.dat and t.dat + 86399/86400
   and i.id(+) = w.issueid
   and p.id(+) = i.project
 group by i.summary,
          i.issuenum,
          p.pkey,
          t.dat
 order by t.dat, 5 desc"""

	cur.close()


def task_period(ws, team, days):

	conJira = cx_Oracle.connect(connectJira)
	cur = conJira.cursor()
	sql = """with period as
(
 select trunc(sysdate) - rownum dat
   from dual
connect by level < """ + days + """
)
select to_char(t.dat, 'dd/mm/yyyy') dat,
       trim(to_char(t.dat, 'Day', 'nls_date_language = RUSSIAN')) wday,
       p.pkey || '-' || i.issuenum jiranum,
       i.summary,
       sum(w.timeworked / 60 / 60) period_worked
  from period t,
       jira.worklog   w,
       jira.jiraissue i,
       jira.project   p
 where w.author(+) in (""" + user_list_str + """)
   and w.created(+) between t.dat and t.dat + 86399/86400
   and i.id(+) = w.issueid
   and p.id(+) = i.project
 group by i.summary,
          i.issuenum,
          p.pkey,
          t.dat
 order by t.dat, 5 desc"""

	cur.close()


if __name__ == "__main__":


	# Загружаем всех пользователей
	f = open('users.json')
	data = json.loads(f.read())


	# Первый агрумент команда(team)
	while 1 == 1:
		try:
			team = sys.argv[2]
		except Exception as e:
			team = input('Team[all]: ')
			if team == "":
				team = 'all'
		if team not in ('java', 'sql', 'srv', 'net', 'web', 'all'):
			print('Допустимые значения: [all, java, sql, srv, net, web]. Попробуйте еще раз')
		else:
			break

	# кол-во дней
	while 1 == 1:
		try:
			days = sys.argv[3]
		except Exception as e:
			days = input('Days ago[60]: ')
			if days == "":
				days = '60'
		try:
			int(days)
			if int(days) <= 100:
				break
		except ValueError:
			print('Должно быть целое число <= 100. Попробуйте еще раз')


	#exit(0)

	# загружаем выходные дни
	holy = open('holy.list')
	hd = {}
	for line in holy.readlines():
		hd[line[:-1]] = 1
	try:
		os.remove(file_name)
	except Exception as e:
		z = 1
	#
	if team == 'all':
		for tm in ('java', 'sql', 'srv', 'net', 'web'):
			#print(tm)
			wb, ws = excel.getWorkSheet(file_name, 'Total')
			fill_sheet(ws, tm, days)
			wb.save(file_name)
	elif team in ('java', 'sql', 'srv', 'net', 'web'):
		wb, ws = excel.getWorkSheet(file_name, team)
		fill_sheet(ws, team, days)
		#
		wb, ws_t = excel.getWorkSheet(file_name, team)
		task_period(ws_t, team, days)
		wb.save(file_name)
	else:
		print('Указана несуществующая команда ' + team)
		print('Допустимые значения: [all, java, sql, srv, net, web] ')
	# Сохраняем файл
	#wb.save(file_name)
