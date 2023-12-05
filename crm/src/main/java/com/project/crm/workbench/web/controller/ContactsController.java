package com.project.crm.workbench.web.controller;

import com.project.crm.settings.domain.User;
import com.project.crm.settings.service.UserService;
import com.project.crm.settings.service.impl.UserServiceImpl;
import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.PrintJson;
import com.project.crm.utils.ServiceFactory;
import com.project.crm.utils.UUIDUtil;
import com.project.crm.workbench.domain.Contacts;
import com.project.crm.workbench.service.ContactsService;
import com.project.crm.workbench.service.CustomerService;
import com.project.crm.workbench.service.impl.ContactsServiceImpl;
import com.project.crm.workbench.service.impl.CustomerServiceImpl;

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
 * ClassName: ContactsController
 * Package: com.project.crm.workbench.web.controller
 * Description:
 *
 * @Author cpymp
 * @Create 2023/12/4 19:09
 * @Version 1.0
 */
public class ContactsController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入客户控制器");
        String path = request.getServletPath();

        if ("/workbench/contacts/pageList.do".equals(path)) {

            pageList(request,response);

        } else if ("/workbench/contacts/getUserListAndContactsInfo.do".equals(path)) {
            getUserListAndContactsInfo(request,response);

        } else if ("/workbench/contacts/getUserList.do".equals(path)) {
            getUserList(request,response);
        }else if ("/workbench/contacts/save.do".equals(path)) {
            save(request,response);
        }else if ("/workbench/contacts/update.do".equals(path)) {
            update(request,response);
        }else if ("/workbench/contacts/delete.do".equals(path)) {
            delete(request,response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入客户删除控制器！！");
        System.out.println("进入客户删除控制器！！");
        System.out.println("进入客户删除控制器！！");
        System.out.println("进入客户删除控制器！！");
        System.out.println("进入客户删除控制器！！");
        String deleteIds = request.getParameter("deleteIds");

        List<String> deleteList = Arrays.asList(deleteIds.split("&"));

        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean isDelete = contactsService.delete(deleteList);
        PrintJson.printJsonFlag(response,isDelete);


    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("更新联系人信息");
        String source = request.getParameter("source");
        String name = request.getParameter("name");
        String appellation = request.getParameter("appellation");
        String job = request.getParameter("job");
        String mphone = request.getParameter("mphone");
        String email = request.getParameter("email");
        String birth = request.getParameter("birth");
        String customerName = request.getParameter("customerName");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTIme = DateTimeUtil.getSysTime();
        Contacts con  = new Contacts();
        con.setSource(source);
        con.setOwner(request.getParameter("owner"));
        con.setFullname(name);
        con.setAppellation(appellation);
        con.setJob(job);
        con.setMphone(mphone);
        con.setEmail(email);
        con.setBirth(birth);
        con.setCustomerId(customerName);
        con.setDescription(description);
        con.setContactSummary(contactSummary);
        con.setNextContactTime(nextContactTime);
        con.setAddress(address);
        con.setEditBy(editBy);
        con.setEditTime(editTIme);
        con.setId(request.getParameter("id"));
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean isUpdate = contactsService.update(con);
        PrintJson.printJsonFlag(response,isUpdate);



    }

    private void getUserListAndContactsInfo(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("获取用户列表和联系人信息");
        String id = request.getParameter("id");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        Contacts contacts = contactsService.getContactById(id);
        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("userList",userList);
        map.put("contactsInfo",contacts);
        map.put("success",true);
        PrintJson.printJsonObj(response,map);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入保存联系人控制器");
        String owner = request.getParameter("owner");
        String source = request.getParameter("source");
        String customerName = request.getParameter("customerName");
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String email = request.getParameter("email");
        String mphone = request.getParameter("mphone");
        String job = request.getParameter("job");
        String birth = request.getParameter("birth");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String id = UUIDUtil.getUUID();
        Contacts contacts = new Contacts();
        contacts.setOwner(owner);
        contacts.setSource(source);
        contacts.setCustomerId(customerName); //待处理
        contacts.setFullname(fullname);
        contacts.setAppellation(appellation);
        contacts.setEmail(email);
        contacts.setMphone(mphone);
        contacts.setJob(job);
        contacts.setBirth(birth);
        contacts.setDescription(description);
        contacts.setContactSummary(contactSummary);
        contacts.setNextContactTime(nextContactTime);
        contacts.setAddress(address);
        contacts.setCreateTime(createTime);
        contacts.setCreateBy(createBy);
        contacts.setId(id);
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean isSave = contactsService.save(contacts);
        PrintJson.printJsonFlag(response,isSave);


    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取用户列表控制器");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入查询客户控制器");
        String pageNo = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String customerName = request.getParameter("customerName");
        String clueSource = request.getParameter("clueSource");
        String birth = request.getParameter("birth");

        int pageNum = Integer.parseInt(pageNo);
        int pageSize = Integer.parseInt(pageSizeStr);

        int skipNum = (pageNum - 1) * pageSize;
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        Map<String ,Object>  map = new HashMap<String ,Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("customerName",customerName);
        map.put("clueSource",clueSource);
        map.put("birth",birth);
        map.put("skipNum",skipNum);
        map.put("pageSize",pageSize);
        Map<String,Object> rMap = contactsService.pageList(map);
        PrintJson.printJsonObj(response,rMap);



    }
}
