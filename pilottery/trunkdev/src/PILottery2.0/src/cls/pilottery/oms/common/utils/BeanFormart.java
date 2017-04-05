package cls.pilottery.oms.common.utils;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import cls.pilottery.oms.lottery.model.Betinfo;

public class BeanFormart {
	public static Betinfo transBean(String[] attr) {
		Betinfo reObject=new Betinfo();
		Map<String, Object>map=new HashMap<String, Object>();
		Field fields[] = reObject.getClass().getDeclaredFields();
		String[] name = new String[fields.length];
		try {
			Field.setAccessible(fields, true);
			for (int i = 0,j=0; i < name.length && j<attr.length; i++,j++) {
				name[i] = fields[i].getName();
				System.out.println(name[i] + "-> ");
				// value[i] = fields[i].get(a);
				map.put(name[i], attr[j]);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			reObject=map2Bean(reObject,map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       return reObject;
	}
    @SuppressWarnings("unchecked")
	private static <T> T map2Bean(T t,Map map) throws Exception{  
        Class clazz = t.getClass();  
        //实例化类  
        T entity = (T)clazz.newInstance();  
        Set<String> keys = map.keySet();  
        //变量map 赋值  
        for(String key:keys){  
            String fieldName = key;  
            //判断是sql 还是hql返回的结果  
            if(key.equals(key.toUpperCase())){  
                //获取所有域变量  
                Field[] fields = clazz.getDeclaredFields();  
                for(Field field: fields){  
                    if(field.getName().toUpperCase().equals(key)) fieldName=field.getName();  
                    break;  
                }  
            }  
            //设置赋值  
            try {  
                //参数的类型  clazz.getField(fieldName)  
                Class<?> paramClass = clazz.getDeclaredField(fieldName).getType();  
                //拼装set方法名称  
                String methodName = "set"+fieldName.substring(0,1).toUpperCase()+fieldName.substring(1);  
                //根据名称获取方法  
                Method method = clazz.getMethod(methodName, paramClass);  
                //调用invoke执行赋值  
                method.invoke(entity, map.get(key));  
            } catch (Exception e) {  
                //NoSuchMethod  
            }  
        }  
          
        return entity;  
    }  
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String str="ZX-DT*DS -(1+2+3+4+5+6:7)-1-0";
//		String buf="SSQ | 21030814007 | 8 | 24000 | FLAG | ZX-DS -(1+2+3+4+5+6:7)-1-0 / ZX-DS -(1+2+3+4+5+6:7)-1-0 / ZX-DS -(1+2+3+4+5+6:7)-1-0";
//		String arr[]=buf.split("[|]");
		String att[]=str.split("-");
		Betinfo info=new Betinfo();
		info=transBean(att);
		System.out.println(info.getBet());
	}

}
