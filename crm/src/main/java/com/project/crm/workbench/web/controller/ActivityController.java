package com.project.crm.workbench.web.controller;

import com.project.crm.settings.domain.User;
import com.project.crm.settings.service.UserService;
import com.project.crm.settings.service.impl.UserServiceImpl;
import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.PrintJson;
import com.project.crm.utils.ServiceFactory;
import com.project.crm.utils.UUIDUtil;
import com.project.crm.vo.PagenationVO;
import com.project.crm.workbench.domain.Activity;
import com.project.crm.workbench.domain.ActivityRemark;
import com.project.crm.workbench.service.ActivityService;
import com.project.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ClassName: ActivityController
 * Package: com.project.crm.workbench.web.controller
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/22 12:33
 * @Version 1.0
 */
public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入市场活动控制器");
        String path = request.getServletPath();
        System.out.println(path);
        if ("/workbench/activity/getUserList.do".equals(path)) {
           getUserList(request,response);
            //xxx(request.response);
        } else if ("/workbench/activity/save.do".equals(path)) {
            save(request,response);
        }else if ("/workbench/activity/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/activity/delete.do".equals(path)){
            delete(request,response);
        }else if ("/workbench/activity/getUserListAndActivity.do".equals(path)){
            getUserListAndActivity(request,response);
        }else if ("/workbench/activity/update.do".equals(path)){
            update(request,response);
        }else if ("/workbench/activity/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/activity/getRemarkListByActivityId.do".equals(path)){
            getRemarkListByActivityId(request,response);
        }else if ("/workbench/activity/deleteRemarkById.do".equals(path)){
            deleteRemarkById(request,response);
        }else if ("/workbench/activity/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/activity/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入备注更新控制器");
        String id = request.getParameter("id"); //需要更新的备注的id
        String noteContent = request.getParameter("noteContent"); //需要更新的备注的内容
        String editTime = DateTimeUtil.getSysTime();
        String editBy =((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
        ActivityRemark activityRemark  = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditTime(editTime);
        activityRemark.setEditBy(editBy);
        activityRemark.setEditFlag(editFlag);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean isUpdateRemark = activityService.updateRemark(activityRemark);
        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("success",isUpdateRemark);
        map.put("activity",activityRemark);
        PrintJson.printJsonObj(response,map);

    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String activityId = request.getParameter("activityId");
        System.out.println(activityId);
        String noteContent = request.getParameter("noteContent");
        System.out.println("这是新创建的备注————————————————————————————————————————————————————————————————————————————————————————————" + noteContent);
        String id = UUIDUtil.getUUID();
        //创建时间  是当前的系统时间
        String createTime = DateTimeUtil.getSysTime();
        //创建人 当前登录的用户
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        String  editFlage = "0" ;

        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setActivityId(activityId);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setCreateBy(createBy);
        activityRemark.setCreateTime(createTime);
        activityRemark.setEditFlag(editFlage);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = activityService.saveRemark(activityRemark);

        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("activityRemark",activityRemark);
        PrintJson.printJsonObj(response,map);

    }

    private void deleteRemarkById(HttpServletRequest request, HttpServletResponse response) {
        String deleteId = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean isDelete = activityService.deleteRemarkById(deleteId);
        PrintJson.printJsonFlag(response,isDelete);
    }

    private void getRemarkListByActivityId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入市场活动ID取得备注信息列表");
        String activityId = request.getParameter("activityId");

        ActivityService activityService  = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

       List<ActivityRemark> activityRemarkList =  activityService.getRemarkListByActivityId(activityId);
       PrintJson.printJsonObj(response,activityRemarkList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到详细信息页的操作");
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
         Activity activity = activityService.detal(id);
         request.setAttribute("activity",activity);
         //转发的路径是内部路径，前面不需要项目名，
        //只有转发才能从reques域中取值  重定向不行
         request.getRequestDispatcher("/workbench/activity/detail.jsp") .forward(request,response);


    }

    private void update(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行市场活动的更新操作");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");

        //修改时间  是当前的系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人 当前登录的用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

//        String editTime = request.getParameter("editTime");
//        String editBy = request.getParameter("editBy");

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        //用servlet 只能使用这种方法来接受参数和设置参数
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);

        boolean isSaveFlag = activityService.update(activity);
        PrintJson.printJsonFlag(response,isSaveFlag);





    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询用户信息列表和根据市场活动id查询单条记录");
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        /*
            总结：以后业务层调用service的方法，返回值是什么，你应该思考前端需要什么？
            就从业务层返回什么

           前端需要什么？
            一个市场活动列表，一个拥有者列表
            Ulist               a
            该情况复用率低，直接使用map
         */
        Map<String,Object> map = activityService.getUserListAndActivity(id);
        PrintJson.printJsonObj(response,map);



    }

    private void edit(HttpServletRequest request, HttpServletResponse response) {
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("------------------------------------进入删除市场活动控制器-------------------------------------------");

//        String deleteIds = request.getParameter("deleteId"); //根据 键值对的方式获取值？？
        String[] receiptDeleteIds = request.getParameterValues("deleteId");
        String deleteId = receiptDeleteIds[0];
        String[] deleteIds = deleteId.split("&");
        for (int i = 0; i < deleteIds.length; i++) {

            System.out.println(deleteIds[i]);

        }
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean isDeleteFlag = activityService.delete(deleteIds );

        PrintJson.printJsonFlag(response,isDeleteFlag);
//        List list = deleteIds.split();

    }


    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入市场活动的查询操作 (结合条件查询和分页查询)");

        String name  = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        //略过的记录数
        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.parseInt(pageNoStr);
        //每页的记录数
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.parseInt(pageSizeStr);
        //计算出略过的记录数  pageSize = 5 为例 :
        int skipCount = (pageNo -1 ) * pageSize;

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        /*
                前端需要什么？
                    市场活动的信息列表
                     查询的总条数
                 业务层拿到以上的信息后，如何做返回？？？
                将来分页查询，每个模块都有，所以使用一个通用vo，操作比较方便

                 复用率高 用 VO
                 复用率低  用 map
                 分页操作，复用率相当高：VO

         */
      PagenationVO<Activity> pagenationVO =  activityService.pageList(map);
      PrintJson.printJsonObj(response,pagenationVO);


    }

    private void save(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行市场活动的添加操作");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");



        //创建时间  是当前的系统时间
        String createTime = DateTimeUtil.getSysTime();
        //创建人 当前登录的用户
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

//        String editTime = request.getParameter("editTime");
//        String editBy = request.getParameter("editBy");

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        //用servlet 只能使用这种方法来接受参数和设置参数
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);

         boolean isSaveFlag = activityService.save(activity);
         PrintJson.printJsonFlag(response,isSaveFlag);




    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得用户信息列表");
        /*  与用户相关的操作，为什么是市场活动来处理？ 因为请求是从市场活动页面发出来的，不论是什么操作
               理应由市场活动controller来完成
             但是业务是与用户相关的操作，没有用到市场活动相关的数据表、业务层
        */
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }
}
