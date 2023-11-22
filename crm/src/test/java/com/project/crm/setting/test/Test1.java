package com.project.crm.setting.test;

import com.project.crm.settings.domain.User;
import com.project.crm.settings.service.UserService;
import com.project.crm.settings.service.impl.UserServiceImpl;
import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.MD5Util;
import com.project.crm.utils.ServiceFactory;
import com.project.crm.utils.SqlSessionUtil;
import org.apache.ibatis.session.SqlSession;
import org.apache.taglibs.standard.tag.common.core.OutSupport;
import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

/**
 * ClassName: Test1
 * Package: com.project.crm.setting.test
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/20 23:39
 * @Version 1.0
 */
public class Test1 {
    public static void main(String[] args) {

        //验证失效时间

        String expireTime = "2023-11-23 10:10:10";

        //当前系统时间
//        Date date = new Date();
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//        String format = sdf.format(date);
//        System.out.println(format);
        String currentTime = DateTimeUtil.getSysTime();
        //通过字符串比较时间
        int result = expireTime.compareTo(currentTime);
        //result 只存在 大于0 或小于0
        System.out.println(result);

    }

    /*
    判断锁定状态
     */
    @Test
    public void test1(){
        String lockState = "0";
        //如果字符串判断  一定把字符串放在变量前面
        if("0".equals(lockState)){
            System.out.println("账号已锁定");
        }
    }

    /*
    验证ip地址
     */
    @Test
    public void test2(){
    String ip = "192.168.1.1";
    String allowIps = "192.168.1.1,192.168.1.2";
    if (allowIps.contains(ip)){
        System.out.println("有效的ip地址，允许访问");
    }else {
        System.out.println("ip受限，不许访问。");
    }
    }


    //md5 密码
    @Test
    public void test3(){
    String pwd = "cpymp971512235";
        String myPwd = MD5Util.getMD5(pwd);
        System.out.println(myPwd);
    }

    @Test
    public void test4(){

        UserService ss = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> list = ss.getAll();
        Iterator<User> iterator = list.iterator();
        while (iterator.hasNext()){
            System.out.println(iterator.next());
        }


    }

    @Test
    public void test5(){


            String s = "123";
            int i = Integer.parseInt(s);
            System.out.println(i);
        System.out.println(++i);

    }
}
