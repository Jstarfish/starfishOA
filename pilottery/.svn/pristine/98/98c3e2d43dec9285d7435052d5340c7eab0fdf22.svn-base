create or replace procedure p_wh_ticket_damage
/****************************************************************/
   ------------------- 票损毁状态更新 -------------------
   ---- add by dzg: 2015/10/29
   ---- 本存储过程不提交，只在最后提交
   ---- modify by dzg :2015/10/31 修改箱子更新bug
   ---- modify by dzg :2015/11/13 更新档损毁子级别，把父级别完整状态拆包
   /*************************************************************/
(
   --------------输入----------------
   p_admin_id        in number,        --操作人员
   p_plan_code       in String,        --方案编号
   p_batch_no        in String,        --批次号
   p_valid_number    in number,        --型号
   p_trunk_no        in String,        --箱号
   p_box_no          in String,        --盒号
   p_package_no      in String         --本号

 ) is


begin
   -- 按照类型，处理正负号
   case
      when p_valid_number in (evalid_number.trunk) then
        
         --更新箱子状态
         update wh_ticket_trunk
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
          
         --盒
         update wh_ticket_box
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
            
            
         --本
         update wh_ticket_package
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
         

      when p_valid_number in (evalid_number.box) then
         
         --更新箱子不完整
         update wh_ticket_trunk
            set is_full      = eboolean.noordisabled,
                change_admin = p_admin_id,
                change_date  = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
         --盒
         update wh_ticket_box
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and box_no = p_box_no;
            
         --本  
         update wh_ticket_package
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and box_no = p_box_no;
         

      when p_valid_number in (evalid_number.pack) then
        
        
         --更新箱子不完整
         update wh_ticket_trunk
            set is_full      = eboolean.noordisabled,
                change_admin = p_admin_id,
                change_date  = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
            
         --更新盒子不完整
         update wh_ticket_box
            set is_full      = eboolean.noordisabled,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and box_no = p_box_no;
        
         --本  
         update wh_ticket_package
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and package_no = p_package_no;         

   end case; 

end;
