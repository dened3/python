create table addrob(
  actstatus  Int8           comment '0 - Статус последней исторической записи в жизненном цикле адресного объекта: 0 – Не последняя, 1 - Последняя',  -- : 1
  aoguid     UUID           comment '1 - Глобальный уникальный идентификатор адресного объекта', -- : '1ac46b49-3209-4814-b7bf-a509ea1aecd9'
  aoid       UUID           comment '2 - Уникальный идентификатор записи. Ключевое поле.',   -- : '1a8430ad-dcc9-43d9-81ea-948b90a25d8b'
  aolevel    Int8           comment '3 - Уровень адресного объекта',   -- : 1
  areacode   FixedString(3) comment '4 - Код района', -- : '000'
  autocode   FixedString(1) comment '5 - Код автономии', -- : '0'
  centstatus Int8           comment '6 - Статус центра', -- : 0
  citycode   FixedString(3) comment '7 - Код города', -- : '000'
  code       String         comment '8 - Код адресного элемента одной строкой с признаком актуальности из классификационного кода', -- : '5400000000000'
  currstatus Int8           comment '9 - Статус актуальности КЛАДР 4 (последние две цифры в коде)',   -- : 0
  enddate    Date           comment '10 - Окончание действия записи',  -- : datetime.date(2079, 6, 6)
  formalname String         comment '11 - Формализованное наименование',   -- : 'Новосибирская'
  ifnsfl     FixedString(4) comment '12 - Код ИФНС ФЛ', -- : '5400'
  ifnsul     FixedString(4) comment '13 - Код ИФНС ЮЛ', -- : '5400'
  nextid     UUID           comment '14 - Идентификатор записи  связывания с последующей исторической записью',  -- : '                                    '
  offname    String         comment '15 - Официальное наименование',  -- : 'Новосибирская'
  okato      String         comment '16 - ОКАТО',  -- : '50000000000'
  oktmo      String         comment '17 - ОКТМО',  -- : '           '
  operstatus Int8           comment '18 - Статус действия над записью – причина появления записи (см. OperationStatuses )',  -- : 1
  parentguid UUID           comment '19 - Идентификатор родительского объекта',    -- : '                                    '
  placecode  FixedString(3) comment '20 - Код населенного пункта', -- : '000'
  plaincode  String         comment '21 - Код адресного элемента одной строкой без признака актуальности (последних двух цифр)',  -- : '54000000000'
  postalcode String         comment '22 - Почтовый индекс',  -- : '      '
  previd     UUID           comment '23 - Идентификатор записи связывания с предыдушей исторической записью',   -- : '                                    '
  regioncode FixedString(2) comment '24 - Код региона', -- : '54'
  shortname  String         comment '25 - Краткое наименование типа объекта',  -- : 'обл       '
  startdate  Date           comment '26 - Начало действия записи',   -- : datetime.date(1900, 1, 1)
  streetcode FixedString(4) comment '27 - Код улицы', -- : '0000'
  terrifnsfl String         comment '28 - Код территориального участка ИФНС ФЛ',   -- : '    '
  terrifnsul String         comment '29 - Код территориального участка ИФНС ЮЛ',   -- : '    '
  updatedate Date           comment '30 - Дата  внесения (обновления) записи',     -- : datetime.date(2015, 9, 15)
  ctarcode   FixedString(3) comment '31 - Код внутригородского района', -- : '000'
  extrcode   FixedString(4) comment '32 - Код дополнительного адресообразующего элемента', -- : '0000'
  sextcode   FixedString(3) comment '33 - Код подчиненного дополнительного адресообразующего элемента', -- : '000'
  livestatus Int8           comment '34 - Статус актуальности адресного объекта ФИАС на текущую дату: 0 – Не актуальный, 1 - Актуальный', -- : 1
  normdoc    UUID           comment '35 - Внешний ключ на нормативный документ',   -- : '                                    '
  plancode   FixedString(4) comment '36 - Код элемента планировочной структуры', -- : '0000'
  cadnum     String         comment '37 - Кадастровый номер',   -- : '                         '
  divtype    Int8           comment '38 - Тип деления: 0 – не определено, 1 – муниципальное, 2 – административное',  -- : 0
  name String               comment 'Наименование UPPER'   -- : 'НОВОСИБИРСКАЯ'
) ENGINE = MergeTree() order by (aoguid);

create table house(
  aoguid     UUID           comment '0 - Guid записи родительского объекта (улицы, города, населенного пункта и т.п.)', -- : 'b12be701-c8a2-4493-8469-046721dd7aa9'
  buildnum   String         comment '1 - Номер корпуса',   -- : '          '
  enddate    Date           comment '2 - Окончание действия записи',  -- : datetime.date(2079, 6, 6)
  eststatus  Int8           comment '3 - Признак владения',  -- : 3
  houseguid  UUID           comment '4 - Глобальный уникальный идентификатор дома',  -- : '22bcb5be-abba-4529-8c36-4970b8e39428'
  houseid    UUID           comment '5 - Уникальный идентификатор записи дома',  -- : 'dc87e43c-c3f3-4c8b-889a-0000a5470fb7'
  housenum   String         comment '6 - Номер дома',  -- : '42                  '
  statstatus Int8           comment '7 - Состояние дома',  -- : 0
  ifnsfl     FixedString(4) comment '8 - Код ИФНС ФЛ',  -- : '0105'
  ifnsul     FixedString(4) comment '9 - Код ИФНС ЮЛ',  -- : '0105'
  okato      String         comment '10 - ОКАТО',  -- : '79222000017'
  oktmo      String         comment '11 - ОКTMO',  -- : '79622457101'
  postalcode String         comment '12 - Почтовый индекс',  -- : '385751'
  startdate  Date           comment '13 - Начало действия записи',  -- : datetime.date(2017, 3, 23)
  strucnum   String         comment '14 - Номер строения',  -- : '          '
  strstatus  Int8           comment '15 - Признак строения',  -- : 0
  terrifnsfl String         comment '16 - Код территориального участка ИФНС ФЛ',  -- : '0104'
  terrifnsul String         comment '17 - Код территориального участка ИФНС ЮЛ',  -- : '0104'
  updatedate Date           comment '18 - Дата время внесения (обновления) записи',  -- : datetime.date(2017, 4, 4)
  normdoc    UUID           comment '19 - Внешний ключ на нормативный документ',  -- : 'd73fe747-cd9d-4800-8fd3-46a39841b503'
  counter    Int8           comment '20 - Счетчик записей зданий, сооружений для формирования классификационного кода',  -- : 26
  cadnum     String         comment '21 - Кадастровый номер',  -- : '                                                               '
  divtype    Int8           comment '22 - Тип деления: 0 – не определено, 1 – муниципальное, 2 – административное',  -- : 0
  house      String         comment 'Номер дома UPPER'  -- : '42                  '
) ENGINE = MergeTree() order by (houseguid);

create table room(
  roomid     UUID           comment '0 - Уникальный идентификатор записи помещения', -- : '27820501-5978-494e-929d-3df0f572f522'
  roomguid   UUID           comment '1 - Глобальный уникальный идентификатор помещения', -- : '27820501-5978-494e-929d-3df0f572f522'
  houseguid  UUID           comment '2 - Глобальный уникальный идентификатор родительского объекта (дома)', -- : '1664a030-1b73-4e38-ac17-ed4a32a009e1'
  regioncode FixedString(2) comment '3 - Код региона', -- : '54'
  flatnumber String         comment '4 - Номер квартиры, офиса и прочего',  -- : '2                                                 '
  flattype   Int8           comment '5 - Тип квартиры',  -- : 2
  roomnumber String         comment '6 - Номер комнаты или помещения',  -- : '                                                  '
  roomtype   String         comment '7 - Тип комнаты',  -- : '0 '
  cadnum     String         comment '8 - Кадастровый номер',  -- : '                                                                                                    '
  roomcadnum String         comment '9 - ???',  -- : '                                                                                                    '
  postalcode String         comment '10 - Почтовый индекс',  -- : '630532'
  updatedate Date           comment '11 - Дата время внесения (обновления) записи',  -- : datetime.date(2017, 1, 10)
  previd     UUID           comment '12 - Идентификатор записи связывания с предыдущей исторической записью',   -- : '                                    '
  nextid     UUID           comment '13 - Идентификатор записи  связывания с последующей исторической записью',  -- : '                                    '
  operstatus Int8           comment '14 - Статус действия над записью – причина появления записи (см. OperationStatuses )',  -- : 10
  startdate  Date           comment '15 - Начало действия записи',   -- : datetime.date(1900, 1, 1)
  enddate    Date           comment '16 - Окончание действия записи',  -- : datetime.date(2079, 6, 6)
  livestatus Int8           comment '17 - Статус актуальности адресного объекта ФИАС на текущую дату: 0 – Не актуальный, 1 - Актуальный', -- : 1
  normdoc    UUID           comment '18 - Внешний ключ на нормативный документ',
  flat       String         comment 'Номер квартиры UPPER'
) ENGINE = MergeTree() order by (roomguid);
