package cls.pilottery.oms.monitor.util;

//import java.io.File;
import java.io.File;
import java.io.StringReader;
import java.lang.reflect.Array;
import java.lang.reflect.Field;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class XmlUtil {
    
    public static void main(String[] args) {

        try {

            String xml="<xml>" +
                    "<item_code>11</item_code>" +
                    "<item_name>22</item_name>" +
                    "<sub>" +
                        "<sub_code>111</sub_code>" +
                        "<sub_name>111</sub_name>" +
                    "</sub>" +
                    "<subs>" +
                        "<sub>" +
                            "<sub_code>1111</sub_code>" +
                            "<sub_name>1111</sub_name>" +
                        "</sub>" +
                        "<sub>" +
                            "<sub_code>2222</sub_code>" +
                            "<sub_name>2222</sub_name>" +
                        "</sub>" +
                    "</subs>" +
                    "<levels>" +
                        "<level>level1</level>" +
                        "<level>level2</level>" +
                        "<level>level3</level>" +
                    "</levels>" +
                    "</xml>";
            
            //XmlUtil util = new XmlUtil(); 
            
            
            XmlInfo obj = new XmlInfo();

            obj = readXml(xml,obj);
            
            System.out.println(obj.subs[1].sub_code);
       
        }catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } 
    }

    public static <T> T readXml(T t,String xmlSrc) {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = factory.newDocumentBuilder();
            Document doc = db.parse(new File(xmlSrc));
            Element elmtInfo = doc.getDocumentElement();
            NodeList nodeList = elmtInfo.getChildNodes();

            fillObjectByXml(t,nodeList);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return t;
  }


    public static <T> T readXml(String xml,T t) {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = factory.newDocumentBuilder();
            Document doc = db.parse(new InputSource(new StringReader(xml)));
            //Document doc = db.parse(new File("d://a.xml"));
            Element elmtInfo = doc.getDocumentElement();
            NodeList nodeList = elmtInfo.getChildNodes();

            fillObjectByXml(t,nodeList);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return t;
  }

    /**
     * 该方法暂时只支持对String,Object,Array(数组类型)的属性赋值
     * @param t 要对其赋值的对象t
     * @param nodeList 要赋值对象对应的节点
     * @return t 已赋值的对象t
     */
    private static <T> void fillObjectByXml(T t, NodeList nodeList) {
        try {
            for(int i = 0; i < nodeList.getLength(); i++) {
                Node node = nodeList.item(i);

                for (Field field : t.getClass().getDeclaredFields()) {
                    if (node.getNodeName().equals(field.getName())) {
    
                        field.setAccessible(true);
    
                        if (field.getType() == String.class) {
                            field.set(t, node.getTextContent());
    
                        } else if (field.getType().isArray()) {
                            Object objs = Array.newInstance(field.getType().getComponentType(), node.getChildNodes().getLength());

                            for (int j = 0; j < node.getChildNodes().getLength(); j++) {
                                Node subNode = node.getChildNodes().item(j);

                                if(field.getType().getComponentType() == String.class) {
                                     Array.set(objs, j, subNode.getTextContent());
                                } else {
                                    Object obj = field.getType().getComponentType().newInstance();
                                    fillObjectByXml(obj, subNode.getChildNodes());
                                    Array.set(objs, j, obj);
                                }
                            }
                            field.set(t, objs);
                        } else {
                            Object obj = field.getType().newInstance();

                            fillObjectByXml(obj, node.getChildNodes());
         
                            field.set(t, obj);
                        }
                    }
                }
            }
        } catch (Exception e) {

            // e.printStackTrace();
            System.out.println(e.getMessage());
            System.out.println("类型不匹配！");
        }

    }

    

}





class XmlInfo {

    String item_code;
    String item_name;
    Sub sub;
    Sub[] subs;
    String[] levels;
}

class Sub {
    String sub_code;
    String sub_name;
    
}
