package com.project.crm.workbench.web.controller;

import com.project.crm.settings.dao.UserDao;
import com.project.crm.settings.domain.User;
import com.project.crm.settings.service.UserService;
import com.project.crm.settings.service.impl.UserServiceImpl;
import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.PrintJson;
import com.project.crm.utils.ServiceFactory;
import com.project.crm.utils.UUIDUtil;
import com.project.crm.workbench.domain.Clue;
import com.project.crm.workbench.service.ClueService;
import com.project.crm.workbench.service.CustomerService;
import com.project.crm.workbench.service.impl.ClueServiceImpl;
import com.project.crm.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
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
public class ClueController extends HttpServlet {
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
        }else if ("/workbench/clue/xxx.do".equals(path)) {
//            xxx(request,response);
        }

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
