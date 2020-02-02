select f2.shortname || ' ' || f2.offname p3,
       f1.shortname || ' ' || f1.offname p4,
       trigramDistance(f1.offname, 'РАСИЙСКАЯ')
  from addr f1 join addr f2 on f1.parentid = f2.id
 where trigramDistance(f1.offname, 'РАСИЙСКАЯ') between 0 and 0.5

select f1.shortname || ' ' || f1.offname p4,
       trigramDistance(f1.offname, 'РАСИЙСКАЯ')
  from addr f1
 where trigramDistance(f1.offname, 'РАСИЙСКАЯ') between 0 and 0.5

 select f1.shortname || ' ' || f1.offname p4,
        ngramDistance(f1.offname, 'РАСИЙСКАЯ')
   from fias.fias f1
  where ngramDistance(f1.offname, 'РАСИЙСКАЯ') between 0 and 0.3

  select ngramDistance('НОВОСИБИРСК', 'НАВАСИБИРСК')

  select ngramDistance(a.offname, 'НАВАСИБИРСК'), a.offname
  from fias.fias a where ngramDistance(a.offname, 'НАВАСИБИРСК') between 0 and 0.3

select name, toString(aoguid) aoguid, val from (
  select '(' || a.shortname2 || ' ' || a.offname2 || ', ' || a.shortname3 || ' ' || a.offname3 || ') ' || a.shortname || ' ' ||
  a.offname name, a.aoguid, a.offname3 || ' ' || a.offname2 || ' ' || a.offname val
  from fias.fias a where ( ngramDistance(a.offname, 'НАВАСИБИРСК') between 0 and 0.3
   or a.offname2 like '%НАВАСИБИРСК%' or a.offname3 like '%НАВАСИБИРСК%'
   or a.offname4 like '%НАВАСИБИРСК%' or a.offname5 like '%НАВАСИБИРСК%' or a.offname6 like '%НАВАСИБИРСК%'
  ) order by multiIf(a.regioncode = '54', 0, 1), a.aolevel2, a.aolevel3 ) limit 10

create table addrob_1(
  id         Int32          comment 'ID записи',
  parentid   Int32          comment 'ID родительской записи',
  actstatus  Int8           comment 'Статус последней исторической записи в жизненном цикле адресного объекта: 0 – Не последняя, 1 - Последняя',  -- : 1
  aoguid     UUID           comment 'Глобальный уникальный идентификатор адресного объекта', -- : '1ac46b49-3209-4814-b7bf-a509ea1aecd9'
  aoid       UUID           comment 'Уникальный идентификатор записи. Ключевое поле.',   -- : '1a8430ad-dcc9-43d9-81ea-948b90a25d8b'
  aolevel    Int8           comment 'Уровень адресного объекта',   -- : 1
  areacode   FixedString(3) comment 'Код района', -- : '000'
  autocode   FixedString(1) comment 'Код автономии', -- : '0'
  centstatus Int8           comment 'Статус центра', -- : 0
  citycode   FixedString(3) comment 'Код города', -- : '000'
  code       String         comment 'Код адресного элемента одной строкой с признаком актуальности из классификационного кода', -- : '5400000000000'
  currstatus Int8           comment 'Статус актуальности КЛАДР 4 (последние две цифры в коде)',   -- : 0
  enddate    Date           comment 'Окончание действия записи',  -- : datetime.date(2079, 6, 6)
  formalname String         comment 'Формализованное наименование',   -- : 'Новосибирская'
  ifnsfl     FixedString(4) comment 'Код ИФНС ФЛ', -- : '5400'
  ifnsul     FixedString(4) comment 'Код ИФНС ЮЛ', -- : '5400'
  nextid     UUID           comment 'Идентификатор записи  связывания с последующей исторической записью',  -- : '                                    '
  offname    String         comment 'Официальное наименование',  -- : 'Новосибирская'
  okato      String         comment 'ОКАТО',  -- : '50000000000'
  oktmo      String         comment 'ОКТМО',  -- : '           '
  operstatus Int8           comment 'Статус действия над записью – причина появления записи (см. OperationStatuses )',  -- : 1
  parentguid UUID           comment 'Идентификатор родительского объекта',    -- : '                                    '
  placecode  FixedString(3) comment 'Код населенного пункта', -- : '000'
  plaincode  String         comment 'Код адресного элемента одной строкой без признака актуальности (последних двух цифр)',  -- : '54000000000'
  postalcode String         comment 'Почтовый индекс',  -- : '      '
  previd     UUID           comment 'Идентификатор записи связывания с предыдушей исторической записью',   -- : '                                    '
  regioncode FixedString(2) comment 'Код региона', -- : '54'
  shortname  String         comment 'Краткое наименование типа объекта',  -- : 'обл       '
  startdate  Date           comment 'Начало действия записи',   -- : datetime.date(1900, 1, 1)
  streetcode FixedString(4) comment 'Код улицы', -- : '0000'
  terrifnsfl String         comment 'Код территориального участка ИФНС ФЛ',   -- : '    '
  terrifnsul String         comment 'Код территориального участка ИФНС ЮЛ',   -- : '    '
  updatedate Date           comment 'Дата  внесения (обновления) записи',     -- : datetime.date(2015, 9, 15)
  ctarcode   FixedString(3) comment 'Код внутригородского района', -- : '000'
  extrcode   FixedString(4) comment 'Код дополнительного адресообразующего элемента', -- : '0000'
  sextcode   FixedString(3) comment 'Код подчиненного дополнительного адресообразующего элемента', -- : '000'
  livestatus Int8           comment 'Статус актуальности адресного объекта ФИАС на текущую дату: 0 – Не актуальный, 1 - Актуальный', -- : 1
  normdoc    UUID           comment 'Внешний ключ на нормативный документ',   -- : '                                    '
  plancode   FixedString(4) comment 'Код элемента планировочной структуры', -- : '0000'
  cadnum     String         comment 'Кадастровый номер',   -- : '                         '
  divtype    Int8           comment 'Тип деления: 0 – не определено, 1 – муниципальное, 2 – административное',  -- : 0
  INDEX ind_guid (aoguid) type set(0) GRANULARITY 4
) ENGINE = MergeTree() order by (id);

create table addrob(
  id         Int32          comment 'ID записи',
  parentid   Int32          comment 'ID родительской записи',
  actstatus  Int8           comment 'Статус последней исторической записи в жизненном цикле адресного объекта: 0 – Не последняя, 1 - Последняя',  -- : 1
  aoguid     UUID           comment 'Глобальный уникальный идентификатор адресного объекта', -- : '1ac46b49-3209-4814-b7bf-a509ea1aecd9'
  aoid       UUID           comment 'Уникальный идентификатор записи. Ключевое поле.',   -- : '1a8430ad-dcc9-43d9-81ea-948b90a25d8b'
  aolevel    Int8           comment 'Уровень адресного объекта',   -- : 1
  areacode   FixedString(3) comment 'Код района', -- : '000'
  autocode   FixedString(1) comment 'Код автономии', -- : '0'
  centstatus Int8           comment 'Статус центра', -- : 0
  citycode   FixedString(3) comment 'Код города', -- : '000'
  code       String         comment 'Код адресного элемента одной строкой с признаком актуальности из классификационного кода', -- : '5400000000000'
  currstatus Int8           comment 'Статус актуальности КЛАДР 4 (последние две цифры в коде)',   -- : 0
  enddate    Date           comment 'Окончание действия записи',  -- : datetime.date(2079, 6, 6)
  formalname String         comment 'Формализованное наименование',   -- : 'Новосибирская'
  ifnsfl     FixedString(4) comment 'Код ИФНС ФЛ', -- : '5400'
  ifnsul     FixedString(4) comment 'Код ИФНС ЮЛ', -- : '5400'
  nextid     UUID           comment 'Идентификатор записи  связывания с последующей исторической записью',  -- : '                                    '
  offname    String         comment 'Официальное наименование',  -- : 'Новосибирская'
  okato      String         comment 'ОКАТО',  -- : '50000000000'
  oktmo      String         comment 'ОКТМО',  -- : '           '
  operstatus Int8           comment 'Статус действия над записью – причина появления записи (см. OperationStatuses )',  -- : 1
  parentguid UUID           comment 'Идентификатор родительского объекта',    -- : '                                    '
  placecode  FixedString(3) comment 'Код населенного пункта', -- : '000'
  plaincode  String         comment 'Код адресного элемента одной строкой без признака актуальности (последних двух цифр)',  -- : '54000000000'
  postalcode String         comment 'Почтовый индекс',  -- : '      '
  previd     UUID           comment 'Идентификатор записи связывания с предыдушей исторической записью',   -- : '                                    '
  regioncode FixedString(2) comment 'Код региона', -- : '54'
  shortname  String         comment 'Краткое наименование типа объекта',  -- : 'обл       '
  startdate  Date           comment 'Начало действия записи',   -- : datetime.date(1900, 1, 1)
  streetcode FixedString(4) comment 'Код улицы', -- : '0000'
  terrifnsfl String         comment 'Код территориального участка ИФНС ФЛ',   -- : '    '
  terrifnsul String         comment 'Код территориального участка ИФНС ЮЛ',   -- : '    '
  updatedate Date           comment 'Дата  внесения (обновления) записи',     -- : datetime.date(2015, 9, 15)
  ctarcode   FixedString(3) comment 'Код внутригородского района', -- : '000'
  extrcode   FixedString(4) comment 'Код дополнительного адресообразующего элемента', -- : '0000'
  sextcode   FixedString(3) comment 'Код подчиненного дополнительного адресообразующего элемента', -- : '000'
  livestatus Int8           comment 'Статус актуальности адресного объекта ФИАС на текущую дату: 0 – Не актуальный, 1 - Актуальный', -- : 1
  normdoc    UUID           comment 'Внешний ключ на нормативный документ',   -- : '                                    '
  plancode   FixedString(4) comment 'Код элемента планировочной структуры', -- : '0000'
  cadnum     String         comment 'Кадастровый номер',   -- : '                         '
  divtype    Int8           comment 'Тип деления: 0 – не определено, 1 – муниципальное, 2 – административное'  -- : 0
) ENGINE = MergeTree() order by (id);

select a.id, a.parentid, a.offname, (select id from addrob b where b.aoguid = a.parentguid) parid from addrob a limit 50

create table addr ENGINE = MergeTree() order by (id) as
select a.id, b.id parentid, a.actstatus, a.aoguid,a.aoid,a.aolevel,a.areacode,
a.autocode,a.centstatus,a.citycode,a.code,a.currstatus,a.enddate,a.formalname,a.ifnsfl,a.ifnsul,a.nextid,a.offname,a.okato,a.oktmo,
a.operstatus,a.parentguid,a.placecode,a.plaincode,a.postalcode,a.previd,a.regioncode,a.shortname,
a.startdate,a.streetcode,a.terrifnsfl,a.terrifnsul,a.updatedate,a.ctarcode,a.extrcode,a.sextcode,
a.livestatus,a.normdoc,a.plancode,a.cadnum,a.divtype
  from addrob a
  left join addrob b on b.aoguid = a.parentguid;

select a.id, a.parentid, a.offname, a.parentguid from addrob a limit 50;

select f4.shortname || ' ' || f4.offname p1,
       f3.shortname || ' ' || f3.offname p2,
       f2.shortname || ' ' || f2.offname p3,
       f1.shortname || ' ' || f1.offname p4,
       f1.aoguid
  from addr f1
       left join addr f2 on f1.parentid = f2.id
       left join addr f3 on f2.parentid = f3.id
       left join addr f4 on f3.parentid = f4.id
 where f1.offname like 'РОССИЙСК%'
   and (f2.offname like 'НОВОСИБ%'
     or f3.offname like 'НОВОСИБ%'
     or f4.offname like 'НОВОСИБ%'
       )
  order by multiIf(f2.offname like 'НОВОСИБ%',1, f3.offname like 'НОВОСИБ%', 2, f4.offname like 'НОВОСИБ%', 3, 4)

create table addr_ind ENGINE = MergeTree() order by (id) as select id, parentid, offname, shortname, aolevel from addr;

  select f4.shortname || ' ' || f4.offname p1,
         f3.shortname || ' ' || f3.offname p2,
         f2.shortname || ' ' || f2.offname p3,
         f1.shortname || ' ' || f1.offname p4,
         f1.id
    from addr_ind f1
         left join addr_ind f2 on f1.parentid = f2.id
         left join addr_ind f3 on f2.parentid = f3.id
         left join addr_ind f4 on f3.parentid = f4.id
   where f1.offname like 'РОССИЙСК%'
     and (f2.offname like 'НОВОСИБ%'
       or f3.offname like 'НОВОСИБ%'
       or f4.offname like 'НОВОСИБ%'
         )
    order by multiIf(f2.offname like 'НОВОСИБ%',1, f3.offname like 'НОВОСИБ%', 2, f4.offname like 'НОВОСИБ%', 3, 4)

    select f4.shortname || ' ' || f4.offname p1,
           f3.shortname || ' ' || f3.offname p2,
           f2.shortname || ' ' || f2.offname p3,
           f1.shortname || ' ' || f1.offname p4,
           f1.id
      from addr_ind f1
           left join addr_ind f2 on f1.parentid = f2.id
           left join addr_ind f3 on f2.parentid = f3.id
           left join addr_ind f4 on f3.parentid = f4.id
     where f1.offname like 'РАСИЙСК%'
      order by multiIf(f2.offname like 'НОВОСИБ%',1, f3.offname like 'НОВОСИБ%', 2, f4.offname like 'НОВОСИБ%', 3, 4),f2.aolevel, f3.aolevel

      select f4.shortname || ' ' || f4.offname p1,
             f3.shortname || ' ' || f3.offname p2,
             f2.shortname || ' ' || f2.offname p3,
             f1.shortname || ' ' || f1.offname p4,
             f1.id
        from addr_ind f1
             left join addr_ind f2 on f1.parentid = f2.id
             left join addr_ind f3 on f2.parentid = f3.id
             left join addr_ind f4 on f3.parentid = f4.id
       where trigramDistance(f1.offname, 'РАСИЙСКАЯ') between 0 and 0.5
        order by multiIf(f2.offname like 'НОВОСИБ%',1, f3.offname like 'НОВОСИБ%', 2, f4.offname like 'НОВОСИБ%', 3, 4),f2.aolevel, f3.aolevel

        select f4.shortname || ' ' || f4.offname p1,
               f3.shortname || ' ' || f3.offname p2,
               f2.shortname || ' ' || f2.offname p3,
               f1.shortname || ' ' || f1.offname p4,
               f1.id
          from addrob f1 left join addrob f2 on f1.parentid = f2.id
               left join addrob f3 on f2.parentid = f3.id
               left join addrob f4 on f3.parentid = f4.id
         where trigramDistance(f1.offname, 'РАСИЙСКАЯ') between 0 and 0.5
          order by multiIf(f2.offname like 'НОВОСИБ%',1, f3.offname like 'НОВОСИБ%', 2, f4.offname like 'НОВОСИБ%', 3, 4),f2.aolevel, f3.aolevel

          select f1.shortname || ' ' || f1.offname p4,
                 f1.id
            from addrob f1
           where trigramDistance(f1.offname, 'РАСИЙСКАЯ') between 0 and 0.5

           select f1.shortname || ' ' || f1.offname p4,
                  f1.id
             from addrob f1
            where f1.offname like 'РОССИЙ%'

 select f2.shortname || ' ' || f2.offname p3,
        f1.shortname || ' ' || f1.offname p4,
        f1.id
   from addr f1 join addr f2 on f1.parentid = f2.id
  where trigramDistance(f1.offname, 'РАСИЙСКАЯ') between 0 and 0.5

  select f3.shortname || ' ' || f3.offname p2,
         f2.shortname || ' ' || f2.offname p3,
         f1.shortname || ' ' || f1.offname p4,
         f1.id
    from addrob f1 left join addrob f2 on f1.parentid = f2.id
         left join addrob f3 on f2.parentid = f3.id
   where trigramDistance(f1.offname, 'РАСИЙСКАЯ') between 0 and 0.5

create table addr(
  id         Int32          comment 'ID записи',
  parentid   Int32          comment 'ID родительской записи',
  actstatus  Int8           comment 'Статус последней исторической записи в жизненном цикле адресного объекта: 0 – Не последняя, 1 - Последняя',  -- : 1
  aoguid     UUID           comment 'Глобальный уникальный идентификатор адресного объекта', -- : '1ac46b49-3209-4814-b7bf-a509ea1aecd9'
  aoid       UUID           comment 'Уникальный идентификатор записи. Ключевое поле.',   -- : '1a8430ad-dcc9-43d9-81ea-948b90a25d8b'
  aolevel    Int8           comment 'Уровень адресного объекта',   -- : 1
  areacode   FixedString(3) comment 'Код района', -- : '000'
  autocode   FixedString(1) comment 'Код автономии', -- : '0'
  centstatus Int8           comment 'Статус центра', -- : 0
  citycode   FixedString(3) comment 'Код города', -- : '000'
  code       String         comment 'Код адресного элемента одной строкой с признаком актуальности из классификационного кода', -- : '5400000000000'
  currstatus Int8           comment 'Статус актуальности КЛАДР 4 (последние две цифры в коде)',   -- : 0
  enddate    Date           comment 'Окончание действия записи',  -- : datetime.date(2079, 6, 6)
  formalname String         comment 'Формализованное наименование',   -- : 'Новосибирская'
  ifnsfl     FixedString(4) comment 'Код ИФНС ФЛ', -- : '5400'
  ifnsul     FixedString(4) comment 'Код ИФНС ЮЛ', -- : '5400'
  nextid     UUID           comment 'Идентификатор записи  связывания с последующей исторической записью',  -- : '                                    '
  offname    String         comment 'Официальное наименование',  -- : 'Новосибирская'
  okato      String         comment 'ОКАТО',  -- : '50000000000'
  oktmo      String         comment 'ОКТМО',  -- : '           '
  operstatus Int8           comment 'Статус действия над записью – причина появления записи (см. OperationStatuses )',  -- : 1
  parentguid UUID           comment 'Идентификатор родительского объекта',    -- : '                                    '
  placecode  FixedString(3) comment 'Код населенного пункта', -- : '000'
  plaincode  String         comment 'Код адресного элемента одной строкой без признака актуальности (последних двух цифр)',  -- : '54000000000'
  postalcode String         comment 'Почтовый индекс',  -- : '      '
  previd     UUID           comment 'Идентификатор записи связывания с предыдушей исторической записью',   -- : '                                    '
  regioncode FixedString(2) comment 'Код региона', -- : '54'
  shortname  String         comment 'Краткое наименование типа объекта',  -- : 'обл       '
  startdate  Date           comment 'Начало действия записи',   -- : datetime.date(1900, 1, 1)
  streetcode FixedString(4) comment 'Код улицы', -- : '0000'
  terrifnsfl String         comment 'Код территориального участка ИФНС ФЛ',   -- : '    '
  terrifnsul String         comment 'Код территориального участка ИФНС ЮЛ',   -- : '    '
  updatedate Date           comment 'Дата  внесения (обновления) записи',     -- : datetime.date(2015, 9, 15)
  ctarcode   FixedString(3) comment 'Код внутригородского района', -- : '000'
  extrcode   FixedString(4) comment 'Код дополнительного адресообразующего элемента', -- : '0000'
  sextcode   FixedString(3) comment 'Код подчиненного дополнительного адресообразующего элемента', -- : '000'
  livestatus Int8           comment 'Статус актуальности адресного объекта ФИАС на текущую дату: 0 – Не актуальный, 1 - Актуальный', -- : 1
  normdoc    UUID           comment 'Внешний ключ на нормативный документ',   -- : '                                    '
  plancode   FixedString(4) comment 'Код элемента планировочной структуры', -- : '0000'
  cadnum     String         comment 'Кадастровый номер',   -- : '                         '
  divtype    Int8           comment 'Тип деления: 0 – не определено, 1 – муниципальное, 2 – административное'  -- : 0
) ENGINE = MergeTree() order by (id);

create table house(
  aoguid     UUID           comment 'Guid записи родительского объекта (улицы, города, населенного пункта и т.п.)', -- : 'b12be701-c8a2-4493-8469-046721dd7aa9'
  buildnum   String         comment 'Номер корпуса',   -- : '          '
  enddate    Date           comment 'Окончание действия записи',  -- : datetime.date(2079, 6, 6)
  eststatus  Int8           comment 'Признак владения',  -- : 3
  houseguid  UUID           comment 'Глобальный уникальный идентификатор дома',  -- : '22bcb5be-abba-4529-8c36-4970b8e39428'
  houseid    UUID           comment 'Уникальный идентификатор записи дома',  -- : 'dc87e43c-c3f3-4c8b-889a-0000a5470fb7'
  housenum   String         comment 'Номер дома',  -- : '42                  '
  statstatus Int8           comment 'Состояние дома',  -- : 0
  ifnsfl     FixedString(4) comment 'Код ИФНС ФЛ',  -- : '0105'
  ifnsul     FixedString(4) comment 'Код ИФНС ЮЛ',  -- : '0105'
  okato      String         comment 'ОКАТО',  -- : '79222000017'
  oktmo      String         comment 'ОКTMO',  -- : '79622457101'
  postalcode String         comment 'Почтовый индекс',  -- : '385751'
  startdate  Date           comment 'Начало действия записи',  -- : datetime.date(2017, 3, 23)
  strucnum   String         comment 'Номер строения',  -- : '          '
  strstatus  Int8           comment 'Признак строения',  -- : 0
  terrifnsfl String         comment 'Код территориального участка ИФНС ФЛ',  -- : '0104'
  terrifnsul String         comment 'Код территориального участка ИФНС ЮЛ',  -- : '0104'
  updatedate Date           comment 'Дата время внесения (обновления) записи',  -- : datetime.date(2017, 4, 4)
  normdoc    UUID           comment 'Внешний ключ на нормативный документ',  -- : 'd73fe747-cd9d-4800-8fd3-46a39841b503'
  counter    Int8           comment 'Счетчик записей зданий, сооружений для формирования классификационного кода',  -- : 26
  cadnum     String         comment 'Кадастровый номер',  -- : '                                                               '
  divtype    Int8           comment 'Тип деления: 0 – не определено, 1 – муниципальное, 2 – административное'  -- : 0
) ENGINE = MergeTree() order by (aoguid, housenum);

select f2.name, f.name from fias f left join fias f2 on f.parguid = f2.guid where f.name like 'Севастополь'
select f2.offname, f.offname from addrobj f left join addrobj f2 on f.parentguid = f2.aoguid where f.offname like 'СЕВАСТОПОЛЬ'
select f.parentguid, f.offname from addrobj f where f.offname like 'СЕВАСТОПОЛЬ'

ALTER TABLE addrobj DELETE where 1=1
ALTER TABLE addrob DELETE where 1=1
ALTER TABLE house DELETE where 1=1

create table addrobj_tmp ENGINE = MergeTree() order by (offname) as select * from addrobj limit 1000000;

create table addrobj_ind ENGINE = MergeTree() order by (offname, aoguid) as select offname, parentguid, aoguid from addrobj;
create table addrobj_ind ENGINE = MergeTree() order by (aoguid) as select aoguid, parentguid, offname, shortname from addrobj;

  select f4.shortname || ' ' || f4.offname p1,
         f3.shortname || ' ' || f3.offname p2,
         f2.shortname || ' ' || f2.offname p3,
         f1.shortname || ' ' || f1.offname p4,
         f1.aoguid
    from addrobj_ind f1
         left join addrobj_ind f2 on f1.parentguid = f2.aoguid
         left join addrobj_ind f3 on f2.parentguid = f3.aoguid
         left join addrobj_ind f4 on f3.parentguid = f4.aoguid
   where f1.offname like 'РОССИЙСК%'
     and (f2.offname like 'НОВОСИБ%'
       or f3.offname like 'НОВОСИБ%'
       or f4.offname like 'НОВОСИБ%'
         )
    order by multiIf(f2.offname like 'НОВОСИБ%',1, f3.offname like 'НОВОСИБ%', 2, f4.offname like 'НОВОСИБ%', 3, 4)

    --multiIf(f.shortname='б-р',7, f.shortname='г', 1, f.shortname='с', 2, f.shortname='пгт', 2, 3)

   select f4.offname p1,
          f3.offname p2,
          f2.offname p3,
          f1.offname p4,
          f1.aoguid
     from addrobj f1
          left join addrobj f2 on f1.parentguid = f2.aoguid
          left join addrobj f3 on f2.parentguid = f3.aoguid
          left join addrobj f4 on f3.parentguid = f4.aoguid
    where f1.offname like '%Российская%'

select f2.name, f.name from fias f left join fias f2 on f.parguid = f2.guid where f2.name like '%Новосибирск%' and f.name like 'Российскоя'

cat fias_houses_csv/HOUSE03.csv | clickhouse-client --database=kp --query="INSERT INTO house FORMAT CSV";

select f2.name, f.name, fs.housenum, fs.parguid
  from fias f left join fias f2 on f.parguid = f2.guid join fias_houses fs on fs.parguid = f.guid
 where f2.name like '%Новосибирск%' and f.name like 'Российская' and fs.housenum = '21'

 select f2.name, f.name, f.guid
   from fias f left join fias f2 on f.parguid = f2.guid
  where f2.name like '%Новосибирск%' and f.name like 'Российская'

  select fp.name, f2.name, f.name, f.guid, f2.guid
    from fias f left join fias f2 on f.parguid = f2.guid
         left join fias fp on f2.parguid = fp.guid
   where f2.name like '%Чистополье%' and f.name like '%Центральная%'

select f4.shortname || ' ' || f4.offname p1,
       f3.shortname || ' ' || f3.offname p2,
       f2.shortname || ' ' || f2.offname p3,
       f1.shortname || ' ' || f1.offname p4,
       f1.aoguid
  from fias_addrobj f1
       left join fias_addrobj f2 on f1.parentguid = f2.aoguid
       left join fias_addrobj f3 on f2.parentguid = f3.aoguid
       left join fias_addrobj f4 on f3.parentguid = f4.aoguid
 where f1.offname like '%Российская%'

 select f.short || ' ' || f.offname || '(' || f1.shortname || ' ' || f1.offname || ')' from fias.addrobj f left join fias f1 on f.parentguid = f1.aoguid where f.offname like '" . $search . "%25' order by f.offname limit 20

 select f.shortname || ' ' || f.offname || '(' || f1.shortname || ' ' || f1.offname || ', ' || ')'
   from fias.addrobj f
        left join fias.addrobj f1 on f.parentguid = f1.aoguid
        --left join fias.addrobj f2 on f1.parentguid = f2.aoguid
  where f.offname like 'НОВОСИБИРС%' order by f.offname limit 20

 select f.shortname || ' ' || f.offname || '(' || f1.shortname || ' ' || f1.offname || ')'
   from fias.addrobj f left join fias.addrobj f1 on f.parentguid = f1.aoguid
                       left join fias.addrobj fs on fs.parentguid = f.aoguid
  where f.offname like '" . $search . "%25'
    and fs.offname like '" . $street . "%25'
  order by f.offname limit 20

  select f.shortname || ' ' || f.offname || '(' || f1.shortname || ' ' || f1.offname || ') - ' || fs.offname
    from fias.addrobj f left join fias.addrobj f1 on f.parentguid = f1.aoguid
                        left join fias.addrobj fs on fs.parentguid = f.aoguid
   where f.offname = 'НОВОСИБИРСК'
     and fs.offname like 'РОССИЙСКА%'
   order by f.offname limit 20

   select f.shortname || ' ' || f.offname || '(' || f1.shortname || ' ' || f1.offname || ') - ' || fs.offname
     from fias.addrobj f join fias.addrobj f1 on f.parentguid = f1.aoguid
                         join fias.addrobj fs on fs.parentguid = f.aoguid
    where f.offname = 'НОВОСИБИРСК'
      and fs.offname like 'РОССИЙСКА%'
    order by f.offname limit 20

   select f.shortname || ' ' || f.offname || '(' || f1.shortname || ' ' || f1.offname || ')'
     from fias.addrobj f left join fias.addrobj f1 on f.parentguid = f1.aoguid
                         left join fias.addrobj f2 on f1.parentguid = f2.aoguid
    where f.offname like '" . $street . "%25'
      and (f1.offname like '" . $city . "%25' or f2.offname like '" . $city . "%25')
    order by f.offname limit 20

    select f.shortname || ' ' || f.offname || '(' || f1.shortname || ' ' || f1.offname || ')'
      from fias.addrobj f left join fias.addrobj f1 on f.parentguid = f1.aoguid
                          left join fias.addrobj f2 on f1.parentguid = f2.aoguid
     where f.offname like 'РОССИЙСКА%'
       and (f1.offname like 'НОВОСИБИР%' or f2.offname like 'НОВОСИБИР%')
     order by f.offname limit 20

select * from house fs
where fs.aoguid = 'fe5f97a4-cd4b-405e-b19b-c254b2110e22'

select trigramDistance(f.name, 'Чистаполье') as res
  from fias f
 where f.name like '%Чистополье%'

 select trigramDistance(f.name, 'Навасибирск') as res, f.name
   from fias f
  where trigramDistance(f.name, 'Навасибирск') < 0.38

 select position(f.name, 'олье')
   from fias f
  where f.name like '%Чистополье%'

  select trigramDistance(f.name, 'Навасибирск') as res, f.name
    from fias f
   where trigramDistance(f.name, 'Навасибирск') < 0.38

   select trigramDistance(f.name, 'Новасибирск') as res, f.name
     from fias f
    where f.name = 'Новосибирск'

select * from (select round(trigramDistance(f.name, 'Навасибирск')*1000) as res, f.name,f.short    from fias f   where trigramDistance(f.name, 'Навасибирск') between 0 and 0.55 order by f.short, res) limit 10


select * from (
select 0 as res, f.name, f.short
  from fias f
 where f.name like '%Новосибирск%'
  order by multiIf(f.short='б-р',7, f.short='г', 1, f.short='с', 2, f.short='пгт', 2, 3), res
union all
select round(trigramDistance(f.name, 'Навасибирск')*1000) as res, f.name,f.short
  from fias f   where trigramDistance(f.name, 'Навасибирск') between 0 and 0.5
  order by multiIf(f.short='б-р',7, f.short='г', 0, f.short='с', 2, f.short='пгт', 2, 3), res
) limit 10

  select f.name
    from fias f
   where f.name like '%Чистополье%'
