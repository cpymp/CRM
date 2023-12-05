package com.project.crm.workbench.web.controller;

import com.project.crm.settings.dao.UserDao;
import com.project.crm.settings.domain.User;
import com.project.crm.settings.service.UserService;
import com.project.crm.settings.service.impl.UserServiceImpl;
import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.PrintJson;
import com.project.crm.utils.ServiceFactory;
import com.project.crm.utils.UUIDUtil;
import com.project.crm.workbench.dao.ClueActivityRelationDao;
import com.project.crm.workbench.domain.Activity;
import com.project.crm.workbench.domain.Clue;
import com.project.crm.workbench.domain.ClueActivityRelation;
import com.project.crm.workbench.domain.Tran;
import com.project.crm.workbench.service.ActivityService;
import com.project.crm.workbench.service.ClueService;
import com.project.crm.workbench.service.CustomerService;
import com.project.crm.workbench.service.impl.ActivityServiceImpl;
import com.project.crm.workbench.service.impl.ClueServiceImpl;
import com.project.crm.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * ClassName: ClueController
 * Package: com.project.crm.workbench.web.controller
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/26 22:49
 * @Version 1.0
 */
//@WebServlet (name = "ClueServlet" ,urlPatterns = "/clueServlet")
public class ClueController extends HttpServlet {
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        System.out.println("进入doPost");
//        String tp = request.getParameter("tp");
//        System.out.println(tp);
//        if ("transfrom".equals(tp)){
//            convert(request,response);
//        }
//
//    }
//
//    private void convert(HttpServletRequest request, HttpServletResponse response) {
//
//        String clueId = request.getParameter("clueId");
//        String activityId = request.getParameter("activityId");
//        String isTrans = request.getParameter("isTrans");
//        String name = request.getParameter("name");
//        String money = request.getParameter("money");
//        String expectedDate = request.getParameter("expectedDate");
//        String stage = request.getParameter("stage");
//
//
//        System.out.println(clueId);
//        System.out.println(activityId);
//        System.out.println(isTrans);
//        System.out.println(name);
//        System.out.println(money);
//        System.out.println(expectedDate);
//        System.out.println(stage);
//
//
//
//
//    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入线索控制器");
        String path = request.getServletPath();
        System.out.println(path);
        if ("/workbench/clue/getUList.do".equals(path)) {
            getUserList(request,response);
            //xxx(request.response);
        } else if ("/workbench/clue/save.do".equals(path)) {
            save(request,response);
        } else if ("/workbench/clue/pageList.do".equals(path)) {
            pageList(request,response);
        } else if ("/workbench/clue/getUserListAndClue.do".equals(path)) {
            getUserListAndClue(request,response);
        } else if ("/workbench/clue/update.do".equals(path)) {
            update(request,response);
        }else if ("/workbench/clue/delete.do".equals(path)) {
            delete(request,response);
        }else if ("/workbench/clue/detail.do".equals(path)) {
            detail(request,response);
        }else if ("/workbench/clue/getActivityByClueId.do".equals(path)) {
            getActivityByClueId(request,response);
        }else if ("/workbench/clue/deleteActivityByCARId.do".equals(path)) {
            deleteActivityByCARId(request,response);
        }else if ("/workbench/clue/getActivityByNameAndNotBount.do".equals(path)) {
           getActivityByNameAndNotBount(request,response);
        }else if ("/workbench/clue/bound.do".equals(path)) {
            bound(request,response);
        }else if ("/workbench/clue/xxx.do".equals(path)) {
//            xxx(request,response);
        }else if ("/workbench/clue/getActivityByName.do".equals(path)) {
            getActivityByName(request,response);
        }else if ("/workbench/clue/convert.do".equals(path)) {
            convert(request,response);
        }

    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException,ServletException {
            //判断是否需要创建交易
            String isTrans = request.getParameter("isTrans");

            //传递到业务层的值
            String clueId = request.getParameter("clueId");
            Tran t = null;
            String createBy = ((User)request.getSession().getAttribute("user")).getName();

        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());


        if ("t".equals(isTrans)){
            System.out.println("确认创建交易");
            t =new Tran();

            String activityId = request.getParameter("activityId");
            String name = request.getParameter("name");
            String money = request.getParameter("money");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String uuid = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();
            t.setId(uuid);
            t.setMoney(money);
            t.setName(name);
            t.setExpectedDate(expectedDate);
            t.setStage(stage);
            t.setCreateTime(createTime);
            t.setCreateBy(createBy);
            t.setActivityId(activityId);
        }else {
//            String clueId = request.getParameter("clueId");
            System.out.println("确认不创建交易");
        }

        boolean isFlag = clueService.convert(clueId,createBy,t);
        if (isFlag){
            response.sendRedirect(request.getContextPath() + "/workbench/clue/index.jsp");
        }

    }

    private void getActivityByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入市场活动列表查询控制器，根据名称模糊查");
        String activityName = request.getParameter("activityName");
        System.out.println(activityName);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> list = activityService.getActivityByName(activityName);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",true);
        map.put("activityList",list);
        PrintJson.printJsonObj(response,map);
    }

    private void bound(HttpServletRequest request, HttpServletResponse response) {

        String activityIds = request.getParameter("activityIds");
        String[] activityIdsList = activityIds.split("&");
        String clueId = request.getParameter("clueId");

        Map<String ,Object > map = new HashMap<String, Object>();
        map.put("activityIds",activityIdsList);
        map.put("clueId",clueId);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean isBount = clueService.bound(map);
        PrintJson.printJsonFlag(response,isBount);


    }

    private void getActivityByNameAndNotBount(HttpServletRequest request, HttpServletResponse response) {

        String clueId = request.getParameter("clueId");
        String activityName = request.getParameter("activityName");

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        Map<String ,String > map = new HashMap<String, String>();
        map.put("clueId",clueId);
        map.put("activityName",activityName);
        List<Activity> list = activityService.getActivityByNameAndNotBount(map);
        PrintJson.printJsonObj(response,list);


    }

    private void deleteActivityByCARId(HttpServletRequest request, HttpServletResponse response) {

        String carId = request.getParameter("carId");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean isUnBound =  clueService.unBound(carId);
        PrintJson.printJsonFlag(response,isUnBound);


    }

    private void getActivityByClueId(HttpServletRequest request, HttpServletResponse response) {

        String clueId = request.getParameter("clueId");

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        List<Activity> list = activityService.getActivityByClueId(clueId);

        PrintJson.printJsonObj(response,list);


    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入详细信息控制器");
        String id = request.getParameter("id");
        System.out.println(id);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = clueService.getClueById(id);
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);

    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        String deleteId = request.getParameter("id");

        String[] deleteIds = deleteId.split("&");

        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());

        boolean isDelete = clueService.delete(deleteIds);
        PrintJson.printJsonFlag(response,isDelete);


    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        clue.setEditTime(editTime);
        clue.setEditBy(editBy);

        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean isUpdate = clueService.update(clue);
        PrintJson.printJsonFlag(response,isUpdate);
    }

    private void getUserListAndClue(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Map<String ,Object> map =  clueService.getUserListAndClue(id);

        map.put("success",true);


        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入线索查询控制器");
        String pageNumStr  = request.getParameter("pageNum");
        String pageSizeStr  = request.getParameter("pageSize");
        String fullname  = request.getParameter("fullname");
        String owner  = request.getParameter("owner");
        String company  = request.getParameter("company");
        String phone  = request.getParameter("phone");
        String mphone  = request.getParameter("mphone");
        String source  = request.getParameter("source");
        String clueState  = request.getParameter("clueState");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Map<String ,Object> map = new HashMap<String, Object>();
        int pageNum = Integer.parseInt(pageNumStr);
        int pageSize = Integer.parseInt(pageSizeStr);
        int skipPage = (pageNum -1 ) * pageSize;
        String skipPageStr = String.valueOf(skipPage);

        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("source",source);
        map.put("clueState",clueState);
        map.put("skipPage",skipPage);
        map.put("pageNum",pageNumStr);
        map.put("pageSize",pageSize);

        Map<String,Object> rMap = clueService.pageList(map);
        rMap.put("success",true);
        PrintJson.printJsonObj(response,rMap);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加线索控制器");
        String  fullname  = request.getParameter("fullname");
        String  appellation  = request.getParameter("appellation");
        String  owner  = request.getParameter("owner");
        String  company  = request.getParameter("company");
        String  job  = request.getParameter("job");
        String  email  = request.getParameter("email");
        String  phone  = request.getParameter("phone");
        String  website  = request.getParameter("website");
        String  mphone  = request.getParameter("mphone");
        String  state  = request.getParameter("state");
        String  source  = request.getParameter("source");
        String  description  = request.getParameter("description");
        String  contactSummary  = request.getParameter("contactSummary");
        String  nextContactTime  = request.getParameter("nextContactTime");
        String  address  = request.getParameter("address");
        String  createBy = ((User)request.getSession().getAttribute("user")).getName();
        String  createTime = DateTimeUtil.getSysTime();
        String  id = UUIDUtil.getUUID();

        Clue clue = new Clue();
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        clue.setId(id);

        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());

        boolean isSave = clueService.save(clue);

        PrintJson.printJsonFlag(response,isSave);



    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入获取用户列表控制器");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> userList = userService.getUserList();

        PrintJson.printJsonObj(response,userList);


    }


}
