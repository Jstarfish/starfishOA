/********************************************************************************/
  ------------------- 根据区域编码生成站点编码-----------------------------
  ----add by dzg: 2015-9-12
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_agency_code_by_area
(
       p_area_code IN STRING --区域编码      
) 
RETURN STRING IS
/*-----------    变量定义     -----------------*/
  v_ret_code STRING(8) :=''; -- 返回值
  v_temp     number := 0; -- 临时变量
  
BEGIN
  
    select mod(nvl(max(inf_agencys.agency_code), 0),10000)
              into v_temp
              from inf_agencys
              where inf_agencys.area_code =p_area_code;
              
    v_temp := v_temp + 1;
    v_ret_code := rtrim(ltrim(p_area_code)) || lpad(v_temp,4,'0');
    return v_ret_code;
    
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-100, 'code overflow!');
              

END;
