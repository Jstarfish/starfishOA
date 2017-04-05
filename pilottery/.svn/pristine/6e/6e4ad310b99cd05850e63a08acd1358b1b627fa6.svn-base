package com.huacai.assist.main;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.huacai.assist.common.App;
import com.huacai.assist.main.YYcAdapter.YYcData;
import com.huacai.pistore.R;

interface OnSetItemListener {
	public void onSetItem(View v, YYcData tvs, String[] data);
}

public class YYcAdapter extends BaseAdapter {
	ArrayList<String[]> data = new ArrayList<String[]>();
	private OnSetItemListener setItemListener = null;
	private String[] fieldTypes = null;
	private String[] fieldNames = null;
	private int nResId;
	private Context context;
	public static class YYcData {
		TextView texts[] = null;
		ImageView arrow = null;
		public YYcData(View v, int[] fields, String[] types, String[] data) {
			texts = new TextView[fields.length];
			arrow = (ImageView) v.findViewById(R.id.right_arrow);
			for( int i = 0 ;i < fields.length ;i ++ ){
				if (texts[i] == null && i < fields.length) {
					texts[i] = (TextView) v.findViewById(fields[i]);
				}
			}
			setData(v, types, data);
		}
		public void setData(View v,String[] types, String[] data) {
			for( int i = 0 ;i < types.length ;i ++ ){
				if (types[i].length() > 5 && types[i].charAt(1) == '|') {
					// types[j] = "n|1,ff808080,a,ffff0000,...";
					String[] colors = types[i].substring(2).split(",");
					String colorInfo = data[i];
					String strColor =  null;
					for (int n=0; n<=colors.length/2;n+=2) {
						if (colorInfo.equals(colors[n])) {
							strColor = colors[n+1];
							break;
						}
					}
					if (strColor == null) {
						strColor = colors[colors.length-1];
					}
					int n = types[i].charAt(0)-'0';
					int color = Integer.parseInt(strColor, 16);
					color |= 0xff000000;
					texts[n].setTextColor(color);
				} else if (texts.length > i) {
					if (texts[i] != null) {
						texts[i].setText(data[i]);
					}
				}
			}
		}
	}
	public void setOnSetItemListener(OnSetItemListener listener) {
		setItemListener = listener;
	}
	public YYcAdapter(Context ctx, int resId, ArrayList<String[]> list) {
		context = ctx;
		nResId = resId;
		data = list;
	}
	public void setJsonData(JSONArray ja) {
		String[] names = fieldNames;
		String[] types = fieldTypes;
		data.clear();
		try {
			if (ja != null) {
				int nameCount = names.length;
				int count = ja.length();
				for (int i=0; i<count; i++) {
					JSONObject item = ja.getJSONObject(i);
					String[] fields = new String[nameCount];
					for (int j=0; j<nameCount; j++) {
						if (types[j].equals("longR")) {
							fields[j] = App.getPriceFormated(item.getLong(names[j]))+App.getResString(R.string.com_unit);
						} else if (types[j].equals("long")) {
							fields[j] = App.getPriceFormated(item.getLong(names[j]));
						} else if (types[j].equals("time")) {
							fields[j] = item.getString(names[j]);
							if (fields[j].length() == 19) {
								fields[j] = fields[j].substring(5, 16);
							}
						} else {
							fields[j] = item.getString(names[j]);
						}
					}
					data.add(fields);
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		notifyDataSetChanged();
	}
	// YYcAdapter(this, R.layout.some_item, jo, resultList, new String[]{"time","site","user","amount","tagNo"}, new String[]{"time","","","long",""});
	public YYcAdapter(Context ctx, int resId, JSONObject jo, 
			String field, String[] names, String[] types) {
		context = ctx;
		nResId = resId;
		fieldNames = names;
		fieldTypes = types;
		try {
			JSONArray ja = jo.getJSONArray(field);
			if (ja != null) {
				int nameCount = names.length;
				int count = ja.length();
				for (int i=0; i<count; i++) {
					JSONObject item = ja.getJSONObject(i);
					String[] fields = new String[nameCount];
					for (int j=0; j<nameCount; j++) {
						if (types[j].equals("longR")) {
							fields[j] = App.getPriceFormated(item.getLong(names[j]))+App.getResString(R.string.com_unit);
						} else if (types[j].equals("long")) {
							fields[j] = App.getPriceFormated(item.getLong(names[j]));
						} else if (types[j].equals("time")) {
							fields[j] = item.getString(names[j]);
							if (fields[j].length() == 19) {
								fields[j] = fields[j].substring(5, 16);
							}
						} else {
							fields[j] = item.getString(names[j]);
						}
					}
					data.add(fields);
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
	}
	
	@Override
	public int getCount() {
		return data.size();
	}

	@Override
	public Object getItem(int n) {
		return n;
	}

	@Override
	public long getItemId(int n) {
		return n;
	}

	@Override
	public View getView(int n, View v, ViewGroup vg) {
		if(v==null){//如果缓存中没有条目实例
			v=  LayoutInflater.from(context).inflate(nResId, null);;//convertView赋值
			v.setTag(new YYcData(v, 
					new int[]{R.id.tv1,R.id.tv2,R.id.tv3,R.id.tv4},
					fieldTypes,
					data.get(n)));
		} else {
			((YYcData)v.getTag()).setData(v, fieldTypes, data.get(n));
		}
		if (setItemListener != null) {
			setItemListener.onSetItem(v, (YYcData) v.getTag(), data.get(n));
		}
		return v;
	}
	
}
