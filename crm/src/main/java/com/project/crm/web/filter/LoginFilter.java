package com.project.crm.web.filter;

import com.project.crm.settings.domain.User;
import com.sun.deploy.net.HttpRequest;
import com.sun.deploy.net.HttpResponse;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Path;

/**
 * ClassName: LoginFilter
 * Package: com.project.crm.web.filter
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/22 10:45
 * @Version 1.0
 */
public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        /*
        需要转发或重定向，但是这两个方法貌似只有更加具体的子类HttpServletRequest和HttpServletRequest才有，所以需要把父类ServletRequest 和ServletResponse
        强转为为子类的类型，调用重定向相关的方法
        */

        HttpServletRequest request = (HttpServletRequest) req; //父类转子类，需要强转
        HttpServletResponse response = (HttpServletResponse) resp; //父类转子类，需要强转


        String path= request.getServletPath();
        //不应该拦截的资源，
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){
            chain.doFilter(req,resp);

            //其他资源
        }else {
        //从request中获取session对象，
        HttpSession session = request.getSession();
        //从session域中获取user对象
        User user = (User) session.getAttribute("user");
        //登录过后，session域中就有一个user对象
        if (user != null){
            //放行
            chain.doFilter(req,resp);
        }else {

            /*
                关于转发和重定向：
                    重定向的路径怎么写？
                        实际开发项目中，无论是前端还是后端，应该一律使用绝对路径

                        转发：使用的是一种绝对路径的方式，这种绝对路径前面不加 "/项目名",这种路径也称为内部路径
                        /login.jsp
                        重定向:使用的是传统绝对路径的写法，前面必须以"/项目名"开头，后面跟具体的资源路径
                        /Project_Crm/login.jsp

                    为什么使用重定向而不使用转发？
                        >转发之后，浏览器地址栏的路径还是老路径，而不是跳转后的路径
                         应该在用户跳转到登录页后，将地址栏的路径自动跳转到跳转后的路径
                sendRedirect重定向
                             原理：服务器把路径给浏览器，浏览器拿到路径后自动再发送请求给后端
                             */

            //${pageContext.request.contextPath} 获得一个 /项目名
//            response.sendRedirect("/Project_Crm/login.jsp"); //将路径写死
            response.sendRedirect(request.getContextPath()+"/login.jsp"); //动态获取项目名

        }

        }


    }

}
