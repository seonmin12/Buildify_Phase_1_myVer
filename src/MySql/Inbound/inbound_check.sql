use wmsdb;

##
DROP PROCEDURE IF EXISTS DB_INBOUND_allcheck_read;
delimiter &&
create procedure DB_INBOUND_allcheck_read()
begin
select * from inbound where Inbound_status = 0;
end &&
delimiter ;


## 관리자 입고요청 전체승인
DROP PROCEDURE IF EXISTS DB_inbound_check_client_read;
delimiter &&
CREATE PROCEDURE DB_inbound_check_client_read()
BEGIN
    -- 기존에 존재하는 상품이라면 수량만 업데이트
UPDATE inventory v
    JOIN inbound i
ON i.prod_id = v.prod_id
    AND i.client_id = v.client_id

    SET v.quantity = v.quantity + i.quantity
WHERE i.inbound_status = 0;

-- 존재하지 않는 상품이라면 새로 추가
INSERT INTO inventory (prod_id, client_id, quantity, ware_id, last_inbound_day)
SELECT i.prod_id, i.client_id, i.quantity, 'ware1', now()
FROM inbound i
WHERE i.inbound_status = 0
  AND NOT EXISTS (
    SELECT 1 FROM inventory v
    WHERE v.prod_id = i.prod_id
      AND v.client_id = i.client_id

);
-- 입고 상태 변경
UPDATE inbound
SET inbound_status = 1, ware_id = 'ware1'
WHERE inbound_status = 0;
END &&
DELIMITER ;


##
DROP PROCEDURE IF EXISTS db_inbound_check_client_read;
delimiter &&
create procedure db_inbound_check_client_read(in a varchar(255))
begin
select * from inbound where client_id = a and Inbound_status = 0;
end &&
delimiter ;


## 관리자 입고요청 업체별 승인
DROP PROCEDURE IF EXISTS db_inbound_check_client_update;
    DELIMITER &&
CREATE PROCEDURE db_inbound_check_client_update(IN client_id_param VARCHAR(255))
BEGIN
    -- 1️⃣ `inventory` 테이블에 있는 경우 → `quantity` 업데이트
UPDATE inventory v
    JOIN inbound i
ON i.prod_id = v.prod_id
    AND i.client_id = v.client_id

    SET v.quantity = v.quantity + i.quantity
WHERE i.inbound_status = 0 AND i.client_id = client_id_param;

-- 2️⃣ `inventory` 테이블에 없는 경우 → 새로운 데이터 INSERT
INSERT INTO inventory (prod_id, client_id, quantity, ware_id, last_inbound_day)
SELECT i.prod_id, i.client_id, i.quantity, 'ware1', now()
FROM inbound i
WHERE i.inbound_status = 0
  AND i.client_id = client_id_param
  AND NOT EXISTS (
    SELECT 1 FROM inventory v
    WHERE v.prod_id = i.prod_id
      AND v.client_id = i.client_id
);
-- 3️⃣ `inbound` 상태 업데이트 (승인 완료: `0` → `1`)
UPDATE inbound
SET Inbound_status = 1, ware_id = 'ware1'
WHERE Inbound_status = 0
  AND client_id = client_id_param;
END &&
DELIMITER ;


##
DROP PROCEDURE IF EXISTS db_inbound_allcheck_return;
delimiter &&
create procedure db_inbound_allcheck_return()
begin
update inbound set Inbound_status = 2 where Inbound_status = 0;
end &&
delimiter ;

##
DROP PROCEDURE IF EXISTS db_inbound_check_client_return;
delimiter &&
create procedure db_inbound_check_client_return(in a varchar(255))
begin
    update inbound set Inbound_status = 2 where client_id = a and Inbound_status = 0;
end &&
delimiter ;


## 관리자 입고요청 개별승인
drop procedure if exists db_inbound_check_inbound_number_update;
DELIMITER &&
CREATE PROCEDURE db_inbound_check_inbound_number_update(IN inbound_num_param VARCHAR(255))
BEGIN
    -- 기존에 inventory 테이블에 존재하는지 확인
    -- 기존 데이터가 존재하면 수량만 추가
UPDATE inventory v
    JOIN inbound i ON i.prod_id = v.prod_id
    AND i.client_id = v.client_id

    SET v.quantity = v.quantity + i.quantity
WHERE i.inbound_id = inbound_num_param
  AND i.inbound_status = 0;

-- 존재하지 않으면 새로 삽입
INSERT INTO inventory (prod_id, client_id, quantity, ware_id, last_inbound_day)
SELECT prod_id, client_id, quantity, 'ware1', now()
FROM inbound i
WHERE inbound_id = inbound_num_param
  AND inbound_status = 0
  and not exists(
    select 1 from inventory v
    where v.prod_id = i.prod_id
      and v.client_id = i.client_id
);
-- inbound_status를 1로 변경 (처리 완료)
UPDATE inbound
SET inbound_status = 1, ware_id = 'ware1'
WHERE inbound_id = inbound_num_param
  AND inbound_status = 0;
END &&
DELIMITER ;


##
DROP PROCEDURE IF EXISTS db_inbound_check_inbound_number_return;
delimiter &&
create procedure db_inbound_check_inbound_number_return(in a varchar(30))
begin
    update inbound set Inbound_status = 2 where inbound_id = a and Inbound_status = 0;
end ;
delimiter ;


##
DROP PROCEDURE IF EXISTS db_inbound_userSearch;
delimiter &&
create procedure db_inbound_userSearch(in a varchar(255))
begin
    select * from inbound where client_id = a order by Inbound_status;
end &&
delimiter ;