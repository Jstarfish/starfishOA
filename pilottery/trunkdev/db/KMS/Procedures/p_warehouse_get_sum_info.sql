CREATE OR REPLACE PROCEDURE p_warehouse_get_sum_info
/****************************************************************/
  -----���ò��ó������ݽṹ������Ʊ����������Ϣ-----------
  --add by dzg: 2015-9-26
  /*************************************************************/
(
 --------------����----------------
 p_good_info IN type_lottery_info, -- ���Ĳ�Ʊ����
 
 ---------���ڲ���---------
 c_total_pack   OUT NUMBER, --�ܰ���
 c_total_ticket OUT NUMBER, --��Ʊ��
 c_total_amount OUT NUMBER  --�ܽ��
 
 ) IS

  v_tn_per_trunk      NUMBER := 0; --ÿ��Ʊ��
  v_tn_per_box        NUMBER := 0; --ÿ��Ʊ��
  v_tn_per_package    NUMBER := 0; --ÿ��Ʊ��
  v_amount_per_ticket NUMBER := 0; --��Ʊ���

BEGIN

  /*----------- ����У��   -----------------*/
  IF (p_good_info IS NULL) THEN
    c_total_ticket := 0;
    c_total_amount := 0;
    c_total_pack   := 0;
    RETURN;
  END IF;

  select d.packs_every_trunk * d.tickets_every_pack,
         (d.packs_every_trunk / d.boxes_every_trunk) * d.tickets_every_pack,
         d.tickets_every_pack,
         p.ticket_amount  
    into v_tn_per_trunk,
         v_tn_per_box,
         v_tn_per_package,
         v_amount_per_ticket 
    FROM game_batch_import_detail d
    left join game_plans p
      ON d.plan_code = p.plan_code
   WHERE d.plan_code = p_good_info.plan_code
     And d.batch_no = p_good_info.batch_no;

  CASE p_good_info.valid_number
    WHEN 1 THEN
      c_total_ticket := v_tn_per_trunk;
      c_total_amount := v_tn_per_trunk * v_amount_per_ticket;
      c_total_pack   := v_tn_per_trunk/v_tn_per_package;
    WHEN 2 THEN
      c_total_ticket := v_tn_per_box;
      c_total_amount := v_tn_per_box * v_amount_per_ticket;
      c_total_pack   := v_tn_per_box/v_tn_per_package;
    WHEN 3 THEN
      c_total_ticket := v_tn_per_package;
      c_total_amount := v_tn_per_package * v_amount_per_ticket;
      c_total_pack   := 1;
    ELSE
      c_total_ticket := 0;
      c_total_amount := 0;
      c_total_pack   := 0;
  END CASE;
  
  EXCEPTION WHEN OTHERS THEN 
    c_total_ticket := 0;
    c_total_amount := 0;
    c_total_pack   := 0;

END;
