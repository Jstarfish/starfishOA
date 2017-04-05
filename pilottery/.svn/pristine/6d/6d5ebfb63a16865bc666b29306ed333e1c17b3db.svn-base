create or replace procedure p_item_delete
/****************************************************************/
--Desc:
--Call to delete an item

--Log:
--Added by Wang Qingxiang @2015-10-13

--Proc:
--1. Deny when p_item_code is null or empty string;
--2. Deny when p_item_code's item does not exist in ITEM_ITEMS;
--3. Deny when p_item_code's item exists in ITEM_QUANTITY;
--4. Delete p_item_code from ITEM_QUANTITY if it has '0' quantity in the table;
--5. Change p_item_code's status to 2 (deleted);
--6. Rollback when exception occurs.
/****************************************************************/
(
--input params
  p_item_code in string,    --item code to be deleted

--output params
  c_errorcode out number,   --error code
  c_errormesg out string    --error message
) is

  v_count_temp number := 0; --temp variable

begin

  --initializing data
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  --step 1: p_item_code is null or empty string
  if ((p_item_code is null) or length(p_item_code) <= 0) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_item_delete_1;
    return;
  end if;

  --step 2: p_item_code's item does not exist in ITEM_ITEMS
  v_count_temp := 0;
  select count(item_code)
    into v_count_temp
    from ITEM_ITEMS
   where item_code = p_item_code;

  if v_count_temp = 0 then
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_item_delete_2;
    return;
  end if;

  --step 3: p_item_code's item exists in ITEM_QUANTITY
  v_count_temp := 0;
  select count(1)
    into v_count_temp
    from dual
   where
    exists(
      select 1
        from ITEM_QUANTITY
       where item_code = p_item_code
         and QUANTITY > 0
    );

  if v_count_temp > 0 then
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_item_delete_3;
    return;
  end if;
  
  --step 4: Delete p_item_code from ITEM_QUANTITY if it has '0' quantity in the table
  delete from item_quantity
  where item_code = p_item_code
    and quantity = 0;

  --step 5: Change p_item_code's status to 2 (deleted)
  update ITEM_ITEMS
     set status = 2
   where item_code = p_item_code;

  commit;

exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

end p_item_delete;
