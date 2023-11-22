package com.project.crm.settings.web.controller;

import com.project.crm.settings.domain.User;
import com.project.crm.settings.service.UserService;
import com.project.crm.settings.service.impl.UserServiceImpl;
import com.project.crm.utils.MD5Util;
import com.project.crm.utils.PrintJson;
import com.project.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * ClassName: UserContorller
 * Package: com.project.crm.settings.web.controller
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/20 23:11
 * @Version 1.0
 */


public class UserContorller extends HttpServlet {


    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入用户控制器");
        String path =request.getServletPath();
//        System.out.println(path);  /settings/user/login.do 成功获取

        request.getRemoteAddr();//获取请求的ip地址
        if ("/settings/user/login.do".equals(path)) {
            login(request,response);
            //xxx(request.response);
        } else if ("/settings/user/xxx.do".equals(path)) {

        }

    }

    private void login(HttpServletRequest request, HttpServletResponse response) {

        response.setContentType("text/html;charset=UTF-8");
        System.out.println("进入验证登录asdfasdfsad234234234");
        String loginAccount = request.getParameter("loginAccount");
        String loginPassword = request.getParameter("loginPassword");
        System.out.println("账号：-------------"+loginAccount);
        System.out.println("密码：-------------"+loginPassword);

        //处理消息前将密码从明文转换为md5形式，再与数据库做对比
        loginPassword = MD5Util.getMD5(loginPassword);

        System.out.println(loginPassword+"----------------------------------------------------");
        //获取请求的IP地址
        String loginIp = request.getRemoteAddr();

        //普通实现类，不走事务
//        UserService userService = new UserServiceImpl();

        //为了方便开发扩充，统一使用代理类的开发
        // 传张三，取李四？？？  既 代理类形态

        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        System.out.println("进入预想步骤——————————————————————————————————————1");
        try {
            //登录成功还好，返回一个domain对象，如果登录失败，则会捕捉一个异常
            System.out.println("进入预想步骤——————————————————————————————————————2");

            User user = userService.login(loginAccount,loginPassword,loginIp);
            System.out.println("进入预想步骤——————————————————————————————————————3");

            //将返回的实体类对象保存在Session域中 ,此语句，如果登录失败，则直接跳转到catch
            //不存在此处时user对象还是空值。
            HttpSession session = request.getSession();
            session.setAttribute("user",user);
               // 登录成功，应该给前端传一个ajax需要的两个数据， {"success":true};
//                    String success = " {\"success\":true}"; //idea 自动拼接
//                    response.getWriter().print(success);

            //拼接字符串操作过于复杂，所以使用工具包下的PrintJson  也就是jackson

             PrintJson.printJsonFlag(response, true);
            System.out.println("成功成功成功成功成功成功成功成功成功成功成功成功成功成功");

        }catch (Exception e){
            /*
            执行到此，说明验证失败，抛出了一个异常
            需要给ajax传两个数据，{"success":false,"errorMessage": 错误消息}
            错误消息从异常消息中取
             */
            System.out.println("进入catch处理异常-------------------");
            String errorMessage = e.getMessage();

            /*
            如果为前端 响应{"success":false,"errorMessage": 错误消息}？ map键值对即可
            {"success":false,"errorMessage": 错误消息}
            提供多项信息，可以将信息打包为map，再将map解析即可
            除此之外，可以使用VO对象，此对象专门为前端展现值。
                                        > private boolean success;
                                        > private String errorMessage;
            展现的信息以后还会使用，则创建一个VO类
                展现的信息以后不会使用，则创建一个map即可
             */
            Map<String,Object> errMap = new HashMap<String, Object>();
            errMap.put("success",false);
            errMap.put("errorMessage",errorMessage);
            PrintJson.printJsonObj(response,errMap);

        }
    }


}
