-- users에서 country별 회원 수 구하기 쿼리
SELECT country, COUNT(DISTINCT id) as uniqueUserCnt
	FROM users
	GROUP BY country;
-- -----> 뒤에 나오는 컬럼명을 기준으로 그룹화해서
-- country를 표시하고, COUNT() 적용한 컬럼도 표시해서 조해해줘.

SELECT  * FROM users;

-- users에서 country가 Korea인 회원 중에서 마케팅 수신에 동의한 회원 수를 구해 출력할 것
-- 표시 컬럼 uniqueUserCnt 두 컬럼으로 구성되어 있다. (Group By - x)
SELECT COUNT(DISTINCT id) as uniqueUserCnt 
	FROM users
	WHERE country = "Korea" AND is_marketing_agree = 1;

-- users에서 country별로 마케팅 수신 동의한 회원 수와 동의하지 않은 회원 수를 구해 출력
-- 표시 컬럼 country, uniqueUserCnt (Group By - o)
SELECT country, is_marketing_agree,COUNT(DISTINCT id) as uniqueUserCnt
	FROM users
	GROUP BY country, is_marketing_agree
	ORDER BY country, uniqueUserCnt DESC;
-- 국가별로는 오름차순(default라서 미표기), uniqueUserCnt를 기준으로는 내림차순
-- select절 - from 테이블명 - group by절 - order by절 : 순서

GROUP BY에 두 개 이상의 기준 컬럼을 추가하면 데이터가 여러 그룹으로 나뉨.
아르헨티나를 기준으로 했을 때 마케팅 수신 동의 여부가 0인 회원 수와 마케팅 수신 여부가 1인
회원수르 기준으로 나뉘어져 있음을 알 수 있음.

예를 들어서 위의 쿼리문의 경우, country를 기준으로 먼저 그룹화가 이루어지고,
그 후에 is_marketing_agree를 기준으로 그룹화됐다.

그래서 GROUP BY에 여러 기준을 설정하면, 컬럼 순서에 따라 결과가 달라짐.
따라서 '중요한 기준을 앞에 배치'해서 시각화와 그룹화에 대한 우선순위를 결정할 필요 있음.

-- GROUP BY 정리
-- 1) 주어진 컬럼을 기준으로 데이터를 그룹화하여 '집게함수'와 함께 사용
-- 2) GROUP BY 뒤에는 그룹화할 컬럼명을 입력. 그룹화한 컬럼에 집계 함수 적용하
	--	그룹별 계산을 수행
-- 3) 형식 : GROUP BY 컬럼명1, 컬럼명2, ...
-- 4) GROUP BY에서 두 개 이상의 기준 컬럼을 조건으로 추가하여 여러 그룹으로
--	  분할 가능한데, 컬럼 순서에 따라 결과에 영향을 미치므로 우선순위를 생각할 필요 있음

-- users에서 국가(country) 내 도시(city)별 회원수를 구하여 출력.
-- 단, 국가명을 알파벳 순서대로 정렬, 같은 국가 내에서는 회원 수 기준으로 내림차순 정렬.
-- 표시 컬럼 country, city, uniqueUserCnt(where절 - x)
SELECT country, city, COUNT(DISTINCT id) as uniqueUsesrCNt
	FROM users
	GROUP BY country, city 
	ORDER BY country, city DESC;

-- SUBSTR(컬럼명, 시작값, 글자개수)
-- users에서 월별(e.g. 2013-10) 가입 회원 수를 출력할 것
-- 가입일시 컬럼 활용하고, 최신순으로 정렬할 것.
SELECT SUBSTR(created_at, 1, 7) AS month, COUNT(DISTINCT id) AS uniqueUserCnt
	FROM users
	GROUP BY SUBSTR(created_at, 1, 7)
	ORDER BY month DESC;

-- 1. orderdetails에서 order_id 별 주문 수량 quantity의 총합을 출력할 것.
--	  주문 수량의 총합이 내림차순으로 정렬되도록 할 것
SELECT order_id, SUM(quantity) 
	FROM orderdetails
	GROUP BY order_id 
	ORDER BY SUM(quantity) DESC; 

-- 2. orders에서 staff_id 별, user_id 별로 주문 건수(COUNT(*))를 출력할 것.
--    단, staff_id 기준 오름차순하고 주문 건수 별 기준 내림차순
SELECT staff_id, user_id, COUNT(*) 
	FROM orders
	GROUP BY staff_id, user_id 
	ORDER BY staff_id, COUNT(*) DESC; 

-- 3. orders에서 월별로 주문한 회원 수 출력할 것(order_date 컬럼 이용, 최신순으로 정렬)
SELECT SUBSTR(order_date, 1, 7), COUNT(DISTINCT user_id) 
	FROM orders
	GROUP BY SUBSTR(order_date, 1, 7)
	ORDER BY SUBSTR(order_date, 1, 7) DESC;

-- HAVING
-- GROUP BY를 이용해서 데이터를 그룹화하고, 해당 그룹별로 집계 연산을 수행하여,
-- 국가 별 회원 수를 도출해낼 수 있었다. (COUNT())
-- 예를 들어서, 회원 수가 n명 이상인 국가의 회원 수만 보는 등의 조건을 걸러면 어떻게 해야 할까?

-- WHERE절을 이용하는 방법이 있긴 하지만 추가적인 개념에 대해서 학습할 예정이다.
-- 언제나 WHERE을 쓰는 것이 용이하지 않다는 점부터 짚고 넘어가서 HAVING 학습할 예정

-- users에서 country가 Korea, USA, France인 회원 숫자를 도출할 것.
SELECT country, COUNT(DISTINCT id) 
	FROM users
	WHERE country IN ("Korea","USA","France")
	GROUP BY country;

WHERE을 통해서 원하는 국가만 먼저 필터링하고, GROUP BY를 했다.
여기서 필터링 조건은 country 컬럼의 데이터 값에 해당한다.

만약 회원 수가 8명 이상인 국가의 회원 수만 필터링하려면 어떻게 해야 할까?

-- SELECT country, COUNT(DISTINCT id) 
-- 	FROM users
-- 	WHERE COUNT(DISTINCT id) >= 8;
-- 오류 나느 사례

-- users에서 회원 수가 8명 이상인 country 별 회원 수 출력(회원 수 기준 내림 차순)
-- SELECT country, COUNT(DISTINCT id)
-- 	FROM users
-- 	GROUP BY country 
-- 	HAVING COUNT(DISTINCT id) >= 8
-- 	ORDER BY COUNT(DISTINCT id) DESC;

SELECT country, COUNT(DISTINCT id)
	FROM users
	GROUP BY country 
	HAVING COUNT(DISTINCT id) >= 8
	ORDER BY 2 DESC;		-- 두번째 컬럼을 DESC순으로 정리

1. where에서 필터링을 시도할 때 오류가 발생하는 이유
   where은 group by보다 먼저 실행되기 때무에 그룹화를 진행하기 전에 행을 필터링 함.
   하지만 집계 함수로 계산된 값의 경우에는 그룹화 이후에 이루어지기 때문에
   순서상으로 group by보다 뒤에 있어야 해서 where 절 도입이 불가능 함.
   
2. 즉 group by 를 사용한 집계 값을 필터링할 때는 -> HAVING을 사용.

-- orders에서 담당 직원 별 주문 건수와 주문 회원 수를 계산하고, 주문 건수가 10건 이상이면서
-- 주문 회원 수가 40명 이하인 데이터만 출력(단, 주문 건수 기준으로 내림차순 정렬할 것.)
-- staff_id, users_id, id 컬럼 이용)
SELECT staff_id, COUNT(DISTINCT id), COUNT(DISTINCT user_id) 
	FROM orders
	GROUP BY staff_id
	HAVING COUNT(DISTINCT id) >= 10 AND COUNT(DISTINCT user_id) <= 40
	ORDER BY COUNT(DISTINCT id) DESC;

-- HAVING 정리
-- 순서상 GROUP BY 뒤쪽에 위치하며, GROUP BY와 집계함수로 그룹별로 집계한 값을
-- 필털이할 때 사용

-- WHERE과 동일하게 필터링 기능을 수행하지만, 적용 영역의 차이 때뭉에 주의할 필요 있음.
-- WHERE은 'FROM에서 불러온 데이터'를 직접 필터링하는 반면에,
-- HAVING은 'GROUP BY가 실행된 이후의 집계 함수 값'을 필터링함.
-- 따라서 HAVING은 GROUP BY가 SELECT문 내에 없다면 사용할 수 없다.

-- SELECT문의 실행 순서
-- SELECT 컬럼명		- 5
-- FROM 테이블명		- 1
-- WHERE 조건1		- 2
-- GROUP BY 컬럼명	- 3
-- HAVING 조건2		- 4
-- ORDER BY 컬럼		- 6
-- 
-- 1. 컴퓨터는 가장 먼저 FROM 을 읽어 데이터가 저장된 위치에 접근하고, 테이블의 존재 유무를 따져
--    테이블을 확인하는 작업을 실행하고,
-- 2. WHERE을 실행하여 가져올 데이터의 범위 확인.
-- 3. 데이터베이스에서 가져올 범위가 결정된 데이터에 한하여 집계 연산을 적용할 수 있게
--    그룹으로 데이터를 나눈다.
-- 4. HAVING은 바로 그 다음 실행되면서 이미 GROUP BY를 통해 집계 연산 적용이 가능한 상태이기
--    때문에 4의 단계에서 집계 연산을 수행함.
-- 5. 이후 SELECT를 통해 특정 컬럼, 혹은 집계 함수 적용 컬럼을 조회하여 값을 보여주는데,
-- 6. ORDER BY을 통해 특정 컬럼 및 연산 결과를 통한 오름차순 및 내림차순으로 나열함.

-- 연습 문제
-- 1. orders에서 회원별 주문 건수 추출하라(단, 주문 건수가 7건 이상인 회원의 정보만 추출,
--    주문 건수 기준으로 내림차순 정렬, user_id와 주문 아이디(id)컬럼 활용할 것)
SELECT user_id, COUNT(DISTINCT id) 
	FROM orders
	GROUP BY user_id 
	HAVING COUNT(DISTINCT id) >= 7
	ORDER BY COUNT(DISTINCT id) DESC;
	
-- 2. users에서 country 별 city 수와 국가별 회원(id) 수를 추출.
--    단, 도시 수가 5개 이상이고 회원 수가 3명 이상인 정보만 추출하고,
--    도시 수, 회원 수 기준으로 모두 내림차순할 것
SELECT country, COUNT(DISTINCT city), COUNT(DISTINCT id)
	FROM users
	GROUP BY country 
	HAVING COUNT(DISTINCT city) >= 5 AND COUNT(DISTINCT id) >=3
	ORDER BY COUNT(DISTINCT city) DESC, COUNT(DISTINCT id) DESC;
	
-- 3. users에서 USA, Brazil, Korea, Argentina, Mexico에서 거주 중인 회원 수를 
--    국가별로 추출(단, 회원 수가 5명 이상인 국가만 추출하고, 회원 수 기준으로 내림차순)
--    (힌트 : WHERE도 있고 HAVING도 있다.)
SELECT country, COUNT(DISTINCT id)
	FROM users
	WHERE country IN ("USA", "Brazil", "Korea", "Argentina", "Mexico")
	GROUP BY country
	HAVING COUNT(DISTINCT id) >= 5
	ORDER BY COUNT(DISTINCT id) DESC;

-- SQL 실무 상황에서의 GROUP BY & HAVING
-- 1. 2025-01에 음식 분류별(한식, 중식, 분식, ...) 주문 건수 집계
-- SELECT 음식분류, COUNT(DISTINCT 주문아이디) AS 주문건수
-- 	FROM 주문정보
-- 	WHERE 주문시간(월) = "2025-01"
-- 	GROUP BY 음식분류
-- 	ORDER BY 주문건수 DESC 
-- 	;
