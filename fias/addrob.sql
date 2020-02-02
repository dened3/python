create table addrob(
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
) ENGINE = MergeTree() order by (aoguid);

select a1.offname, a2.offname, a3.offname, a4.offname, a5.offname, a6.offname
  from addrobj a1
  join addrobj a2 on a1.parentguid = a2.aoguid
  join addrobj a3 on a2.parentguid = a3.aoguid
  join addrobj a4 on a3.parentguid = a4.aoguid
  join addrobj a5 on a4.parentguid = a5.aoguid
  join addrobj a6 on a5.parentguid = a6.aoguid
 where a1.aolevel = 65
 limit 100

create table fias ENGINE = MergeTree() order by (aoguid) as
select a1.aoguid aoguid, a1.regioncode regioncode,
       a1.offname offname, a2.offname offname2, a3.offname offname3, a4.offname offname4, a5.offname offname5, a6.offname offname6,
       a1.shortname shortname, a2.shortname shortname2, a3.shortname shortname3, a4.shortname shortname4, a5.shortname shortname5, a6.shortname shortname6,
       a1.aolevel aolevel, a2.aolevel aolevel2, a3.aolevel aolevel3, a4.aolevel aolevel4, a5.aolevel aolevel5, a6.aolevel aolevel6
  from addrobj a1
  left join addrobj a2 on a1.parentguid = a2.aoguid
  left join addrobj a3 on a2.parentguid = a3.aoguid
  left join addrobj a4 on a3.parentguid = a4.aoguid
  left join addrobj a5 on a4.parentguid = a5.aoguid
  left join addrobj a6 on a5.parentguid = a6.aoguid;

select a.offname, a.shortname,
       a.offname2, a.shortname2,
       a.offname3, a.shortname3,
       a.offname4, a.shortname4
  from fias a
 where a.offname like 'РОССИЙ%'
   and (a.offname like 'НОВОСИБ%'
     or a.offname2 like 'НОВОСИБ%'
     or a.offname3 like 'НОВОСИБ%'
     or a.offname4 like 'НОВОСИБ%'
     or a.offname5 like 'НОВОСИБ%'
     or a.offname6 like 'НОВОСИБ%')
 order by a.aolevel2, a.aolevel3

 select name,
        toString(aoguid) aoguid,
        val
   from (
 select a.shortname || ' ' || a.offname || '(' || a.shortname2 || ' ' || a.offname2 || ', ' || a.shortname3 || ' ' || a.offname3 || ')' name,
        a.aoguid,
        a.offname || ' ' || a.offname2 || ' ' || a.offname3 val
   from fias a
  where (a.offname like '%НОВОСИБ%'
      or a.offname2 like '%НОВОСИБ%'
      or a.offname3 like '%НОВОСИБ%'
      or a.offname4 like '%НОВОСИБ%'
      or a.offname5 like '%НОВОСИБ%'
      or a.offname6 like '%НОВОСИБ%')
    and (a.offname like '%МУСЫ%'
      or a.offname2 like '%МУСЫ%'
      or a.offname3 like '%МУСЫ%'
      or a.offname4 like '%МУСЫ%'
      or a.offname5 like '%МУСЫ%'
      or a.offname6 like '%МУСЫ%')
    and (a.offname like '%ДЖАЛИЛ%'
      or a.offname2 like '%ДЖАЛИЛ%'
      or a.offname3 like '%ДЖАЛИЛ%'
      or a.offname4 like '%ДЖАЛИЛ%'
      or a.offname5 like '%ДЖАЛИЛ%'
      or a.offname6 like '%ДЖАЛИЛ%')
  order by multiIf(a.regioncode = '54', 0, 1), a.aolevel2, a.aolevel3
) limit 30

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
) ENGINE = MergeTree() order by (aoguid);

create table fiash ENGINE = MergeTree() order by (aoguid) as
select f.aoguid aoguid, f.regioncode regioncode,
       f.offname offname, f.offname2 offname2, f.offname3 offname3, f.offname4 offname4, f.offname5 offname5, f.offname6 offname6,
       f.shortname shortname, f.shortname2 shortname2, f.shortname3 shortname3, f.shortname4 shortname4, f.shortname5 shortname5, f.shortname6 shortname6,
       f.aolevel aolevel, f.aolevel2 aolevel2, f.aolevel3 aolevel3, f.aolevel4 aolevel4, f.aolevel5 aolevel5, f.aolevel6 aolevel6,
       h.houseguid houseguid, h.housenum housenum, h.buildnum buildnum, h.strucnum strucnum, h.postalcode postalcode
  from house h
  join fias f on f.aoguid = h.aoguid;
  limit 100


  select a.aoguid,
         a.offname, a.shortname,
         a.offname2, a.shortname2,
         a.offname3, a.shortname3,
         a.offname4, a.shortname4,
         a.housenum
    from fiash a
   where (a.offname like '%НОВОСИБ%'
       or a.offname2 like '%НОВОСИБ%'
       or a.offname3 like '%НОВОСИБ%'
       or a.offname4 like '%НОВОСИБ%'
       or a.offname5 like '%НОВОСИБ%'
       or a.offname6 like '%НОВОСИБ%')
     and (a.offname like 'РОССИЙС%'
       or a.offname2 like 'РОССИЙС%'
       or a.offname3 like 'РОССИЙС%'
       or a.offname4 like 'РОССИЙС%'
       or a.offname5 like 'РОССИЙС%'
       or a.offname6 like 'РОССИЙС%')
   order by multiIf(a.regioncode = '54', 0, 1), a.aolevel2, a.aolevel3, a.housenum
   union all
   select a.aoguid,
          a.offname, a.shortname,
          a.offname2, a.shortname2,
          a.offname3, a.shortname3,
          a.offname4, a.shortname4,
          a.housenum
     from fiash a
    where (a.offname like '%НОВОСИБ%'
        or a.offname2 like '%НОВОСИБ%'
        or a.offname3 like '%НОВОСИБ%'
        or a.offname4 like '%НОВОСИБ%'
        or a.offname5 like '%НОВОСИБ%'
        or a.offname6 like '%НОВОСИБ%')
      and (a.offname like '%РОССИЙС%'
        or a.offname2 like '%РОССИЙС%'
        or a.offname3 like '%РОССИЙС%'
        or a.offname4 like '%РОССИЙС%'
        or a.offname5 like '%РОССИЙС%'
        or a.offname6 like '%РОССИЙС%')
    order by multiIf(a.regioncode = '54', 0, 1), a.aolevel2, a.aolevel3, a.housenum

    select a.aoguid,
           a.offname, a.shortname,
           a.offname2, a.shortname2,
           a.offname3, a.shortname3,
           a.offname4, a.shortname4
      from fias a
     where (a.offname like 'НОВОСИБ%'
         or a.offname2 like 'НОВОСИБ%'
         or a.offname3 like 'НОВОСИБ%'
         or a.offname4 like 'НОВОСИБ%'
         or a.offname5 like 'НОВОСИБ%'
         or a.offname6 like 'НОВОСИБ%')
       and (a.offname like '%ДЖАЛИЛ%'
         or a.offname2 like '%ДЖАЛИЛ%'
         or a.offname3 like '%ДЖАЛИЛ%'
         or a.offname4 like '%ДЖАЛИЛ%'
         or a.offname5 like '%ДЖАЛИЛ%'
         or a.offname6 like '%ДЖАЛИЛ%')


  select a.aoguid,
         a.offname, a.shortname,
         a.offname2, a.shortname2,
         a.offname3, a.shortname3,
         a.offname4, a.shortname4,
         a.housenum
    from fiash a
   where (a.offname like '%НОВОСИБ%'
       or a.offname2 like '%НОВОСИБ%'
       or a.offname3 like '%НОВОСИБ%'
       or a.offname4 like '%НОВОСИБ%'
       or a.offname5 like '%НОВОСИБ%'
       or a.offname6 like '%НОВОСИБ%')
     and (a.offname like '%МУСЫ%'
       or a.offname2 like '%МУСЫ%'
       or a.offname3 like '%МУСЫ%'
       or a.offname4 like '%МУСЫ%'
       or a.offname5 like '%МУСЫ%'
       or a.offname6 like '%МУСЫ%')
     and (a.offname like '%ДЖАЛИЛ%'
       or a.offname2 like '%ДЖАЛИЛ%'
       or a.offname3 like '%ДЖАЛИЛ%'
       or a.offname4 like '%ДЖАЛИЛ%'
       or a.offname5 like '%ДЖАЛИЛ%'
       or a.offname6 like '%ДЖАЛИЛ%')
   order by multiIf(a.regioncode = '54', 0, 1), a.aolevel2, a.aolevel3, a.housenum


select h.housenum, f.offname, f.offname2
  from house h join fias f on f.aoguid = h.aoguid
 where h.aoguid in ('2fcb96d8-0bd6-4fb3-9b3e-e57a82cd8e8b', 'f2bf0a03-36db-4993-967c-3259dde651d1', '8b837975-2435-4756-acc4-1458adbcc25b')
   and h.housenum like '%1%' limit 20
