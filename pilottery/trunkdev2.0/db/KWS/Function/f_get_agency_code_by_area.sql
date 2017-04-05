/********************************************************************************/
  ------------------- 根据区域编码生成站点编码-----------------------------
  ---- add by dzg: 2015-9-12
  ---- modify by Chen Zhen @2016-06-28  修改生成规则。找到0-9999中，未被使用的编号，返回
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_agency_code_by_area
(
  p_area_code IN STRING --区域编码
)
RETURN STRING IS
/*-----------    变量定义     -----------------*/

  v_temp     varchar2(8); -- 临时变量

BEGIN

  select min(agency_code)
    into v_temp
    from (select p_area_code || lpad(rownum, 4, '0') agency_code
            from dual
          connect by rownum < 10000
          minus
          select agency_code
            from inf_agencys
           where inf_agencys.area_code = p_area_code);

  return v_temp;

  EXCEPTION
    WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-100, 'code overflow!');

END;
