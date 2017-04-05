create or replace procedure p_item_damage_register
/****************************************************************/
--Desc:
--Call to register a damaged item

--Log:
--Added by Wang Qingxiang @2015-11-06

--Proc
--1. Deny when p_item_code is null or empty string;
--2. Deny when p_warehouse_code is null or empty string;
--3. Deny when p_quantity is not positive;
--4. Deny when p_check_admin does not exist in ADM_INFO;
--5. Deny when p_item_code does not have a valid record in ITEM_ITEMS;
--6. Deny when p_warehouse_code does not have a valid record in WH_INFO;
--7. Deny when p_item_code does not exist in p_warehouse_code;
--8. Deny when quantity of p_item_code in p_warehouse_code is less than input quantity;
--9. insert a record into ITEM_DAMAGE;
--10. update quantity in ITEM_QUANTITY;
--11. Rollback when exception occurs.
/****************************************************************/
(
--input params
  p_item_code         in string,    --item to be register
  p_warehouse_code    in string,    --warehouse where the item is registered
  p_quantity          in number,    --damage quantity of the item
  p_check_admin       in number,    --registration operator
  p_remark            in string,    --remark
--output params
  c_errorcode         out number,   --error code
  c_errormesg         out string,   --error message
  c_id_no             out string    --item check code
) is

  v_count number := 0;
  v_quantity number := 0;

begin

  --initializing data
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count := 0;
  v_quantity := 0;
  
  --step 1: p_item_code is null or empty string
  if ((p_item_code is null) or length(p_item_code) <= 0) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_item_damage_1;
    return;
  end if;
  
  --step 2: p_warehouse_code is null or empty string
  if ((p_warehouse_code is null) or length(p_warehouse_code) <= 0) then
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_item_damage_2;
    return;
  end if;
  
  --step 3: p_quantity is not positive
  if (p_quantity <= 0) then
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_item_damage_3;
    return;
  end if;
  
  --step 4: p_check_admin does not exist in ADM_INFO
  if not f_check_admin(p_check_admin) then
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_item_damage_4;
    return;
  end if;
  
  --step 5: p_item_code does not have a valid record in ITEM_ITEMS
  v_count := 0;
  select count(item_code)
    into v_count
    from ITEM_ITEMS
   where item_code = p_item_code
     and status = 1;
  
  if v_count = 0 then
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_item_damage_5;
    return;
  end if;
  
  --step 6: p_warehouse_code does not have a valid record in WH_INFO
  v_count := 0;
  select count(warehouse_code)
    into v_count
    from WH_INFO
   where warehouse_code = p_warehouse_code
     and (status = 1 or status = 3);
  
  if v_count = 0 then
    c_errorcode := 6;
    c_errormesg := error_msg.err_p_item_damage_6;
    return;
  end if;
  
  --step 7: p_item_code does not exist in p_warehouse_code
  v_count := 0;
  select count(item_code)
    into v_count
    from ITEM_QUANTITY
   where item_code = p_item_code
     and warehouse_code = p_warehouse_code;
  
  if v_count = 0 then
    c_errorcode := 7;
    c_errormesg := error_msg.err_p_item_damage_7;
    return;
  end if;
  
  --step 8: quantity of p_item_code in p_warehouse_code is less than input quantity
  v_quantity := 0;
  select quantity
    into v_quantity
    from ITEM_QUANTITY
   where item_code = p_item_code
     and warehouse_code = p_warehouse_code;
  
  if v_quantity < p_quantity then
    c_errorcode := 8;
    c_errormesg := error_msg.err_p_item_damage_8;
    return;
  end if;
  
  --step 9: insert a record into ITEM_DAMAGE
  c_id_no := f_get_item_id_no_seq();
  
  insert into ITEM_DAMAGE
    (ID_NO,
     DAMAGE_DATE,
     ITEM_CODE,
     QUANTITY,
     CHECK_ADMIN,
     REMARK,
     WAREHOUSE_CODE)
  values
    (c_id_no,
     sysdate,
     p_item_code,
     p_quantity,
     p_check_admin,
     p_remark,
     p_warehouse_code);
  
  --step 10: update quantity in ITEM_QUANTITY
  update ITEM_QUANTITY
     set quantity = quantity - p_quantity
   where item_code = p_item_code
     and warehouse_code = p_warehouse_code;
  
  commit;

exception
  when others then
    rollback;
    c_errorcode := 100;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

end p_item_damage_register;