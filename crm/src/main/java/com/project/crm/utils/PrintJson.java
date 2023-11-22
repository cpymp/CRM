package com.project.crm.utils;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class PrintJson {
	
	//将boolean值解析为json串
	public static void printJsonFlag(HttpServletResponse response,boolean flag){
		//如果只需要向前端传一个标记为，例如：添加、修改、删除等操作，只需要true和false 则调用此方法即可
		Map<String,Boolean> map = new HashMap<String,Boolean>();
		//将形参中的flag 变成map 键值对的关系
		map.put("success",flag);
		
		ObjectMapper om = new ObjectMapper();
		try {
			//{"success":true}  既解析为json串的形式
			String json = om.writeValueAsString(map);
			System.out.println(json+"-------------------------这是json登陆成功的字符串格式");
			response.getWriter().print(json);
		} catch (JsonGenerationException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		

		
	}
	
	//将对象解析为json串
	public static void printJsonObj(HttpServletResponse response,Object obj){
		
		/*
		 * 将对象解析为json串的形式
		 * Person p
		 * 	id name age
		 * {"id":"?","name":"?","age":?}
		 *
		 * 将LIst解析为json串的形式
		 * List<Person> pList
		 * [{"id":"?","name":"?","age":?},{"id":"?","name":"?","age":?},{"id":"?","name":"?","age":?}...]
		 *
		 * 将map解析为json串的形式
		 * Map
		 * 	key value
		 * {key:value}
		 * 
		 * 
		 */
		
		ObjectMapper om = new ObjectMapper();
		try {
			String json = om.writeValueAsString(obj);
			System.out.println("json"+json +"-------------------------------------- 这是登录失败的字符串格式");
			response.getWriter().print(json);
		} catch (JsonGenerationException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		
	}
	
}























