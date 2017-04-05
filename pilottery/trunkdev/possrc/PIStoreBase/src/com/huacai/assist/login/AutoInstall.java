package com.huacai.assist.login;

import java.io.File;

import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.Settings;
import android.util.Log;

public class AutoInstall {

	public static void setUnkonwSource(Context context, boolean open) {
		ContentValues values = new ContentValues();
		if (open) {
			values.put("value", 1);
		} else {
			values.put("value", 0);
		}
		Cursor cursor = null;
        try{
            int value = 0;
            cursor = context.getContentResolver().query(Settings.Secure.CONTENT_URI, new String[] { "value",},
                 "name=?", new String[] {Settings.Secure.INSTALL_NON_MARKET_APPS}, null);
            if(cursor != null && cursor.moveToNext()){
                value = cursor.getInt(cursor.getColumnIndex("value"));
            }
            if(cursor != null){
            		cursor.close();
            		cursor = null;
            }
            int i = context.getContentResolver().update(Settings.Secure.CONTENT_URI, values,"name=?", 
                    new String[] {Settings.Secure.INSTALL_NON_MARKET_APPS} );
            if(i > 0){
                Log.e("yyc", "INSTALL_NON_MARKET_APPS success");
            }else{
                Log.e("yyc", "INSTALL_NON_MARKET_APPS fail");
            }
        }catch (Exception e) {
            e.printStackTrace();
        }finally{
            if(cursor != null){
            		cursor.close();
            		cursor = null;
            }
        }
	}
	/**
	 * 安装
	 * 
	 * @param context
	 *            接收外部传进来的context
	 */
	public static void install(Context context, String url) {
//		setUnkonwSource(context, true);
		// 核心是下面几句代码
		Intent intent = new Intent(Intent.ACTION_VIEW);
		intent.setDataAndType(Uri.fromFile(new File(url)),
				"application/vnd.android.package-archive");
		context.startActivity(intent);
//		setUnkonwSource(context, false);
	}
}