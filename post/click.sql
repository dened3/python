create table post_pays(
  uno       UInt64,
  summ      String,
  comm_summ String,
  fio		String,
  adr		String,
  accpu		String,
  created   DateTime,
  entried   DateTime,
  srvid     UInt64,
  orgid     UInt64,
  pspid     UInt64
) ENGINE = MergeTree() order by (uno);

create table post_pays(uno UInt64, summ String, comm_summ String, fio String, adr String, accpu String, created DateTime, entried DateTime, srvid UInt64, orgid UInt64, pspid UInt64) ENGINE = MergeTree() order by (uno);

cat res_11.txt | clickhouse-client --database=kp --query="INSERT INTO post_pays FORMAT CSV";
cat res_12.csv | clickhouse-client --database=kp --query="INSERT INTO post_pays FORMAT CSV";

cat res_12.csv | clickhouse-client --database=kp --format_csv_delimiter=";" --query="INSERT INTO post_pays FORMAT CSV";

clickhouse-client --database=kp --query="select * from post_pays limit 10 FORMAT CSV" > test.csv

clickhouse-client --database=kp --query="select fio, adr, count() from post_pays group by fio, adr having count() > 20 FORMAT CSV" > stat.csv

select p.fio, p.adr, p.accpu, ops.name, count() from post_pays p left join orgs ops on ops.id = p.pspid group by p.fio, p.adr, p.accpu, ops.name having count() > 20

select p.fio, p.adr, p.accpu, count() from post_pays p group by p.fio, p.adr, p.accpu having count() > 20

select p.fio, p.adr, count() from post_pays p group by p.fio, p.adr having count() > 20

select cnt, count() from (select p.adr, count() cnt from post_pays p group by p.adr) group by cnt

select cnt, count() from (select p.accpu, count() cnt from post_pays p group by p.accpu) group by cnt

select p.accpu, count() cnt from post_pays p group by p.accpu having count() = 1 limit 10

select p.accpu, p.adr, toString(s.srvnum) || '-' || s.name, count() cnt from post_pays p left join services s on s.id = p.srvid group by p.accpu, p.adr, s.srvnum, s.name having count() > 100 limit 100

select * from post_pays p where p.adr = '���������,������,9,38'

select * from post_pays p where p.adr like '%9,38%'

create table orgs(
  id         UInt64,
  parent     Nullable(UInt64),
  agent_type Nullable(UInt16),
  inn		 String,
  kpp		 String,
  name		 String,
  is_lock	 Nullable(UInt8),
  level_org  Nullable(UInt8)
) ENGINE = MergeTree() order by (id);

create table services(
  id		UInt64,
  type		String,
  srvnum	UInt64,
  name		String,
  short		String,
  owner		Nullable(UInt64),
  is_lock	Nullable(UInt8)
) ENGINE = MergeTree() order by (id);
