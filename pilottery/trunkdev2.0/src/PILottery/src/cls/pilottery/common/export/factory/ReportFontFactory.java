package cls.pilottery.common.export.factory;

import java.awt.Color;
import java.io.IOException;

import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.pdf.BaseFont;

public class ReportFontFactory {
	public enum Font_Type{
		TITLE,HEADER,CONTENT;
    }
	private ReportFontFactory(){}
	/**
	 * Function 创建PDF报表字体
	 * CreateTime 2014年7月22日
	 * @author yyh
	 * @param fontType 字体类型(enum)
	 * @return Font 字体
	 * @throws DocumentException
	 * @throws IOException
	 */
	public  static Font getFontChinese(Font_Type fontType) throws DocumentException, IOException{
		BaseFont bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
		com.lowagie.text.Font fontChinese=null;
		switch (fontType){
		   case TITLE:
			   fontChinese= new com.lowagie.text.Font(bfChinese,12, com.lowagie.text.Font.BOLD);
			   break;
		   case HEADER:
			   fontChinese = new com.lowagie.text.Font(bfChinese,8, com.lowagie.text.Font.BOLD);
			   break;
		   case CONTENT:
			   fontChinese = new com.lowagie.text.Font(bfChinese,8, com.lowagie.text.Font.NORMAL);
			   break;
		   default:	  
			   fontChinese = new com.lowagie.text.Font(bfChinese,7, com.lowagie.text.Font.NORMAL);
		       break;
		}
        return fontChinese;
	}
	public  static Font getFontEnglish(Font_Type fontType) throws DocumentException, IOException{
		Font fontChinese = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new Color(0, 0, 0));
        return fontChinese;
	}

}
