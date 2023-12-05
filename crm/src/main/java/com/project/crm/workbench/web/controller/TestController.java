package com.project.crm.workbench.web.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * ClassName: TestController
 * Package: com.project.crm.workbench.web.controller
 * Description:
 *
 * @Author cpymp
 * @Create 2023/12/1 15:25
 * @Version 1.0
 */
@WebServlet(name = "ClueServlet" ,urlPatterns = "/clueServlet")
public class TestController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入doPost");
        String tp = request.getParameter("tp");
        System.out.println(tp);
        if ("transfrom".equals(tp)){
            convert(request,response);
        }

    }

    private void convert(HttpServletRequest request, HttpServletResponse response) {

        String clueId = request.getParameter("clueId");
        String activityId = request.getParameter("activityId");
        String isTrans = request.getParameter("isTrans");
        String name = request.getParameter("name");
        String money = request.getParameter("money");
        String expectedDate = request.getParameter("expectedDate");
        String stage = request.getParameter("stage");


        System.out.println(clueId);
        System.out.println(activityId);
        System.out.println(isTrans);
        System.out.println(name);
        System.out.println(money);
        System.out.println(expectedDate);
        System.out.println(stage);




    }

}
