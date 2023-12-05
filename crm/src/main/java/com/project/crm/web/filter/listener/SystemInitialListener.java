package com.project.crm.web.filter.listener;

import com.project.crm.settings.domain.DicValue;
import com.project.crm.settings.service.DictionaryService;
import com.project.crm.settings.service.impl.DictionaryServiceImpl;
import com.project.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * ClassName: SystemInitialListener
 * Package: com.project.crm.web.filter.listener
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/28 20:10
 * @Version 1.0
 */
public class SystemInitialListener implements ServletContextListener {

    // 和过滤器不一样， 实现 ServletContextListener接口

    //使用两个方法

    /*
        该方法是用来监听上下文域对象的方法，当服务器启动时，上下文对象域创建
        对象完成后，马上执行该方法 ，意味着服务器启动时，可以在此方法在中从数据库
        获取数据库字典，保存Application中

        event: 该参数能够取得监听的对象
                监听的是什么对象，就能通过该参数取得什么对象
                例如：现在监听的是上下文对象 既ServletContextListener
                       request域对象 ： HttpRequestListener
                       Session域对象： HttpSessionListener

     */
    @Override
    public void contextInitialized(ServletContextEvent event) {
//        System.out.println("上下文域对象创建了！！");
        System.out.println("服务器处理数据字典缓存开始");
        //获取对象
        ServletContext application = event.getServletContext();


        //获取数据字典并赋值            application.setAttribute(key,value);
        /*
               因为使用的是数据字典中的值
               所欲需要分类的取出并保存


 SELECT * FROM tbl_dic_value WHERE  typeCode = 'appellation'; 称呼

 SELECT * FROM tbl_dic_value WHERE  typeCode = 'clueState'; 线索状态

 SELECT * FROM tbl_dic_value WHERE  typeCode = 'returnPriority'; 回访优先级

 SELECT * FROM tbl_dic_value WHERE  typeCode = 'returnState'; 回访状态

 SELECT * FROM tbl_dic_value WHERE  typeCode = 'source'; 来源

 SELECT * FROM tbl_dic_value WHERE  typeCode = 'stage'; 交易的阶段

 SELECT * FROM tbl_dic_value WHERE  typeCode = 'transactionType'; 交易类型

    每一次查询应该返回一个 divList

        注：web三大组件： 过滤器、控制器、 监听器
        三大组件都是顶层内容，都可以调业务层干活

        7个list 可以打包为一个Map
        业务层：
            map.put("appellation",dviList)
            map.put("clueStateList",dviList2)
            map.put("StageList",dviList3)
            map.put("...",)
            map.put("...",)
            map.put("...",)
            map.put("...",)
         */
        //需要业务层返回什么？
       DictionaryService dictionaryService = (DictionaryService) ServiceFactory.getService(new DictionaryServiceImpl());

       Map<String, List<DicValue>> map = dictionaryService.getAll();
       //将map解析为上下文域对象中保存的域键值对
       Set<String>  set = map.keySet();
       //获取map中的key，然后通过key值将上下文域的内容保存到application中
       for (String key:set){
        application.setAttribute(key,map.get(key));
       }
        System.out.println("服务器处理数据字典缓存结束");

        /*
            处理完数据字典后，处理stageTopossivility.properties文件
            步骤：
                》解析该文件，将该属性文件中的键值对关系处理成java中的键值对关系，既map
                Map<String,String>  key:阶段      value:可能性  > possbilityMap
                                    key:stage      value:possibility

                Map<String,String> possbilityMap = new HashMap<String,String>
                possibilityMap.put("01资质省察",10);
                possibilityMap.put("02需求分析",25);
                possibilityMap.put("07",100);

                》将possbilityMap保存到上下文域对象中
                application.setAttribute("pMap",possbilityMap);

         */
                ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
                //枚举-- 不胜枚举 -- 数量少的，可以一一列举出来的 。
                //使用范围：对象、值已经创建好了，不允许创建其他的，例如，月份(12个值)、星期(7个值)、交通灯(红黄绿灯3个值)
                //iterator 是所有的遍历工具中，速度最快的。

                Enumeration<String> keys = rb.getKeys();
                Map<String,String> possbilityMap = new HashMap<String,String>();

                  while (keys.hasMoreElements()){
                    //阶段
                    String key = keys.nextElement();
                    //可能性
                    String value = rb.getString(key);

                      possbilityMap.put(key,value);
                }
            application.setAttribute("pMap",possbilityMap);
    }
}
