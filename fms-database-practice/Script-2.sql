select * from fms.chick_info;

select chick_no, breeds from fms.chick_info;

select chick_no as cn, breeds as "품종"
from fms.chick_info;

select count(*) from fms.chick_info;

select chick_no, hatchday, egg_weight
from fms.chick_info
order by egg_weight desc, hatchday
limit 7 offset 2;

select distinct(egg_weight) from fms.chick_info;

select chick_no from fms.chick_info
where egg_weight >= 70;

-- 68 초과이거나 63 미만이거나
select chick_no, egg_weight
from fms.chick_info
where egg_weight > 68 or egg_weight < 63;

-- hatchday가 1-1과 1-2인 종란만 필터링
select count(*) from fms.chick_info
where hatchday between '2023-01-01' and '2023-01-02';

-- 품종이 C로 시작하는 병아리들만 필터링
select count(*) from fms.chick_info
where breeds like 'C%';

-- 품종이 C1, D1에 속하는 병아리만 필터링
select chick_no, breeds 
from fms.chick_info
where breeds in ('C1', 'D1');

select * from fms.env_cond
where humid is null;

-- null과 ''은 다름
select * from fms.health_cond
where note != '';

update fms.health_cond
set note = null
where trim(note) = '';

select * from fms.health_cond
where note is not null;

-- chick_no로부터 출신농장, 출생연도, 성별 추출
-- 5개만 출력
select chick_no,
       left(chick_no, 1) as "출신농장",
	   '20'||substring(chick_no, 2, 2) as "출생년도",
	   substring(chick_no, 4, 1) as "성별",
	   right(chick_no, 4) as "일련번호"
from fms.chick_info
limit 5;

-- 출신농장, 성별, 품종을 합치기 fgb
select farm || gender || breeds as fgb
from fms.chick_info;

-- 성별 M을 'Male'로 변환해서 출력
select replace(replace(gender, 'M', 'Male'), 'F', 'Female') "성별"
from fms.chick_info;

select sum(egg_weight), avg(egg_weight), min(egg_weight), max(egg_weight)
from fms.chick_info;

select breeds, avg(egg_weight) from fms.chick_info
group by breeds;

-- prod_result 테이블에서 생산일자별 생닭 중량의 평균 출력
select prod_date, avg(raw_weight)
from fms.prod_result
group by prod_date
order by prod_date;

-- ship_result에서 고객사별로 출하된 마리수
select customer, count(chick_no)
from fms.ship_result
group by customer
having count(chick_no) >= 10;

-- 특정 날짜 이후의 데이터만 출력하고자 한다면
-- arrival_date가 2023-02-05 이후인 데이터에 대해서만
select customer, count(chick_no)
from fms.ship_result
where arrival_date >= '2023-02-05'
group by customer
having count(chick_no) >= 8;

select now();
select current_date;
select current_timestamp;
select current_timestamp::Date;

-- '2025-04-08'
select to_char(timestamp '2025-04-08', 'YYYY');

select to_char(hatchday, 'YYYY')
from fms.chick_info;

select * from fms.env_cond;
where humid is null;

select farm, date, humid,  coalesce(humid, 60)
from fms.env_cond
where date between '2023-01-23' and '2023-01-27'
and farm = 'A';

select farm, date, humid,  nullif(humid, 60)
from fms.env_cond
where date between '2023-01-23' and '2023-01-27'
and farm = 'A';

select chick_no, egg_weight,
case 
	when egg_weight >= 69 then '대란'
	when egg_weight >= 65 then '중란'
	else '소란'
end "등급",
case
	when gender = 'F' then 'Female'
	when gender = 'M' then 'Male'
end "성별"
from fms.chick_info;

-- fms.chick_info 테이블에서 종란 무게가 가장 높은 상위 5개의 데이터를 조회
select * from fms.chick_info
order by egg_weight desc
limit 5;

-- health_cond 기록 중 몸무게가 800g 초과이고 체온이 41도 미만인 병아리를 조회
select * from fms.health_cond
where weight > 800 and body_temp < 41;

-- fms.chick_info 테이블에서 부화일자별로 육계의 수를 조회하되, 10마리 이상인 경우만 조회
select hatchday, count(*)
from fms.chick_info
group by hatchday
having count(*) >= 10;

-- env_cond 농장별 조도(lux)가 10 이상 측정된 일자 수
select farm, count(*)
from fms.env_cond
where lux >= 10
group by farm;

SELECT farm, COUNT(DISTINCT date) AS high_lux_days
FROM fms.env_cond
WHERE lux >= 10
GROUP BY farm;

-- fms.health_cond 테이블에서 노트가 없는 경우 '없음'으로 표시하여 조회
SELECT chick_no, 
       COALESCE(note, '없음') AS note_text
FROM fms.health_cond;

-- chick_info 테이블에서 평균 종란 무게보다 높은 육계를 조회
-- 1단계: 평균종란무게 구하기
-- 2단계: 평균보다 큰 병아리 조회
select avg(egg_weight) from fms.chick_info;

select * from fms.chick_info
where egg_weight >= 66.75;

-- 생산 합격 여부(pass_fail)를 기준으로 상태 분류
select chick_no, prod_date,
case pass_fail
	when 'P' then '합격'
	when 'F' then '불합격'
	else '미확인'
end "result_status"
from fms.prod_result;

-- ship_result 테이블을 사용항여 고객사별 출하 주문 건수를 3단계 계층으로 분류하는 쿼리를 작성
-- 12건 이상: 'A등급'
-- 9~11건: 'B등급'
-- 9건 미만: 'C등급'
select customer, count(*),
case 
	when count(*) >= 12 then 'A등급'
	when count(*) >= 9 then 'B등급'
	else 'C등급'
end "grade"
from fms.ship_result
group by customer;

select p.chick_no, p.raw_weight, p.pass_fail, s.order_no, s.customer
from fms.prod_result p, fms.ship_result s
where p.chick_no = s.chick_no;

select p.chick_no, p.raw_weight, p.pass_fail, s.order_no, s.customer
from fms.prod_result p
right join fms.ship_result s
on p.chick_no = s.chick_no;

select chick_no, gender, hatchday
from fms.chick_info
union
select 'C2500012', 'F', '2025-10-16';

select * from fms.chick_info
where egg_weight > (select avg(egg_weight) from fms.chick_info);

select
	a.chick_no, a.breeds, b.code_desc "breeds_nm"
from	
	fms.chick_info a,
	fms.master_code b
where
	a.breeds = b.code
	and b.column_nm = 'breeds';

-- 명시적 조인
select
	a.chick_no, a.breeds, b.code_desc "breeds_nm"
from fms.chick_info a,
join fms.master_code b
on a.breeds = b.code
where b.column_nm = 'breeds';

-- 스칼라 서브쿼리
select a.chick_no, a.breeds,
(
	select code_desc
	from fms.master_code b
	where column_nm = 'breeds'
	and b.code = a.breeds
)
from fms.chick_info a;

-- 인라인 뷰
select a.chick_no, a.breeds, b.code_desc
from fms.chick_info a,
(
	select code, code_desc
	from fms.master_code b
	where column_nm = 'breeds'
) b
where a.breeds = b.code;

create or replace view fms.breeds_prod
(
prod_date, breed_nm, total_sum
)
as select
a.prod_date,
(
	select m.code_desc as breed_nm
	from fms.master_code m
	where m.column_nm = 'breeds'
	and m.code = b.breeds
),
sum(a.raw_weight) as total_sum
from
fms.prod_result a,
fms.chick_info b
where
a.chick_no = b.chick_no
and a.pass_fail = 'P'
group by a.prod_date, b.breeds;

select * from fms.breeds_prod;

-- prod_result, chick_info 생산 결과와 병아리 정보 조인하여 성별별 평균 중량 구하기
select a.gender, avg(b.raw_weight) as "avg_weight"
from fms.chick_info a
join fms.prod_result b
on a.chick_no = b.chick_no
group by a.gender;

-- 건강 상태에서 설사(diarrhea_yn='Y')가 있었던 병아리 리스트
select distinct a.chick_no, b.farm, a.check_date
from fms.health_cond a
join fms.chick_info b
on a.chick_no = b.chick_no
where a.diarrhea_yn = 'Y'
order by a.check_date desc;

-- [UNION] A농장의 수컷과 B농장의 암컷 데이터 통합 조회
select * from fms.chick_info
where gender = 'M' and farm = 'A'
union
select * from fms.chick_info
where gender = 'F' and farm = 'B';

-- [복합조인] chick_info, prod_result, ship_result를 조인해 부산으로 출하된 생닭 정보 조회
select c.* from fms.chick_info a
inner join fms.prod_result b
on a.chick_no = b.chick_no
inner join fms.ship_result c
on a.chick_no = c.chick_no
where c.destination = '부산' and b.pass_fail = 'P';

-- [뷰 생성] 품종별 주간 생산량 집계 뷰 생성, fms.breeds_stats
create or replace view fms.breeds_stats
(
breeds, total, avg_weight
)
as select
a.breeds,
count(b.*) as total,
avg(b.raw_weight) as avg_weight
from fms.chick_info a
join fms.prod_result b
on a.chick_no = b.chick_no
group by a.breeds;

select * from fms.breeds_stats;
