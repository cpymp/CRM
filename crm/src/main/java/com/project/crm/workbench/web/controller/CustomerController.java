package com.project.crm.workbench.web.controller;

import com.project.crm.settings.domain.User;
import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.PrintJson;
import com.project.crm.utils.ServiceFactory;
import com.project.crm.utils.UUIDUtil;
import com.project.crm.vo.CustomerVO;
import com.project.crm.workbench.dao.CustomerRemarkDao;
import com.project.crm.workbench.domain.ActivityRemark;
import com.project.crm.workbench.domain.Customer;
import com.project.crm.workbench.domain.CustomerRemark;
import com.project.crm.workbench.service.ActivityService;
import com.project.crm.workbench.service.CustomerService;
import com.project.crm.workbench.service.impl.ActivityServiceImpl;
import com.project.crm.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * ClassName: CustomerController
 * Package: com.project.crm.workbench.web.controller
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/27 15:00
 * @Version 1.0
 */
public class CustomerController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入客户控制器");
        String path = request.getServletPath();

        if ("/workbench/customer/pageList.do".equals(path)) {

            pageList(request,response);

        } else if ("/workbench/customer/getUserList.do".equals(path)) {
            getUserList(request,response);

        }else if ("/workbench/customer/save.do".equals(path)) {
            save(request,response);

        }else if ("/workbench/customer/getUserListAndCutomerInfo.do".equals(path)) {

            getUserListAndCutomerInfo(request,response);
        }else if ("/workbench/customer/update.do".equals(path)) {

            update(request,response);

        }else if ("/workbench/customer/delete.do".equals(path)) {

            delete(request,response);

        }else if ("/workbench/customer/detail.do".equals(path)) {
//            xxx(request,response);
            detail(request,response);
        }else if ("/workbench/customer/getRemarkListByCustomerId.do".equals(path)) {
            getRemarkListByCustomerId(request,response);
        }else if ("/workbench/customer/saveRemark.do".equals(path)) {
            saveRemark(request,response);
        }else if ("/workbench/customer/updateRemark.do".equals(path)) {
            updateRemark(request,response);
        }else if ("/workbench/customer/deleteRemarkById.do".equals(path)) {
            deleteRemarkById(request,response);
        }

    }

    private void deleteRemarkById(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean isDelete = customerService.deleteRemarkById(id);
        PrintJson.printJsonFlag(response,isDelete);

    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入备注更新控制器");
        String id = request.getParameter("id"); //需要更新的备注的id
        String noteContent = request.getParameter("noteContent"); //需要更新的备注的内容
        String editTime = DateTimeUtil.getSysTime();
        String editBy =((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        CustomerRemark customerRemark  = new CustomerRemark();
        customerRemark.setId(id);
        customerRemark.setNoteContent(noteContent);
        customerRemark.setEditTime(editTime);
        customerRemark.setEditBy(editBy);
        customerRemark.setEditFlag(editFlag);
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean isUpdateRemark = customerService.updateRemark(customerRemark);
        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("success",isUpdateRemark);
        map.put("customer",customerRemark);
        PrintJson.printJsonObj(response,map);


    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {

        String noteContent = request.getParameter("remark");
        String customerId = request.getParameter("customerId");
        System.out.println("----------------------------------------------");
        System.out.println("----------------------------------------------");
        System.out.println("----------------------------------------------");
        System.out.println("----------------------------------------------");
        System.out.println("----------------------------------------------");
        System.out.println("----------------------------------------------");
        System.out.println(customerId);
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String id = UUIDUtil.getUUID();
        String editFlag = "0";

        CustomerRemark customerRemark = new CustomerRemark();
        customerRemark.setCustomerId(customerId);
        customerRemark.setId(id);
        customerRemark.setCreateBy(createBy);
        customerRemark.setCreateTime(createTime);
        customerRemark.setEditFlag(editFlag);
        customerRemark.setNoteContent(noteContent);

        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        int isSaveCount = customerService.saveCustomerRemark(customerRemark);
        if (isSaveCount > 0){

        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("success",true);
        map.put("remark",customerRemark);
        PrintJson.printJsonObj(response,map);

        }

    }

    private void getRemarkListByCustomerId(HttpServletRequest request, HttpServletResponse response) {
        String customerId = request.getParameter("customerId");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        List<CustomerRemark> list = customerService.getRemarkListByCustomerId(customerId);

        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("success",true);
        map.put("remarkList",list);
        PrintJson.printJsonObj(response,map);


    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String id = request.getParameter("id");
        CustomerService  customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        Customer customer = customerService.getCustomerById(id);
        request.setAttribute("customer",customer);

        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);


    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入客户删除控制器！！");
        System.out.println("进入客户删除控制器！！");
        System.out.println("进入客户删除控制器！！");
        System.out.println("进入客户删除控制器！！");
        System.out.println("进入客户删除控制器！！");
        String deleteIds = request.getParameter("deleteIds");

        List<String> deleteList = Arrays.asList(deleteIds.split("&"));

        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean isDelete = customerService.delete(deleteList);
        PrintJson.printJsonFlag(response,isDelete);


    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入更新客户控制器");
        System.out.println("进入更新客户控制器");
        System.out.println("进入更新客户控制器");
        System.out.println("进入更新客户控制器");
        System.out.println("进入更新客户控制器");
        String    id = request.getParameter("id");
        String    customerOwner  = request.getParameter("customerOwner");
        String    customerName  = request.getParameter("customerName");
        String    website  = request.getParameter("website");
        String    phone  = request.getParameter("phone");
        String    description  = request.getParameter("description");
        String    contactSummary  = request.getParameter("contactSummary");
        String    nextContactTime  = request.getParameter("nextContactTime");
        String    address  = request.getParameter("address");
        String    editTime = DateTimeUtil.getSysTime();
        String    editBy = ((User)request.getSession().getAttribute("user")).getName();

        Customer customer = new Customer();
        customer.setId(id);
        customer.setOwner(customerOwner);
        customer.setName(customerName);
        customer.setWebsite(website);
        customer.setPhone(phone);
        customer.setDescription(description);
        customer.setContactSummary(contactSummary);
        customer.setNextContactTime(nextContactTime);
        customer.setAddress(address);
        customer.setEditTime(editTime);
        customer.setEditBy(editBy);

        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        boolean isUpdate = customerService.update(customer);
        PrintJson.printJsonFlag(response,isUpdate);



    }


    private void getUserListAndCutomerInfo(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Map<String ,Object> map =  customerService.getUserListAndCutomerInfo(id);
        map.put("success",true);
        PrintJson.printJsonObj(response,map);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
         String id = UUIDUtil.getUUID(); //UUid 工具生成
         String owner = request.getParameter("owner");
         String name = request.getParameter("name");
         String website = request.getParameter("website");
         String phone = request.getParameter("phone");
         String createBy = ((User)request.getSession().getAttribute("user")).getName();
         String createTime = DateTimeUtil.getSysTime();
//         String editBy = request.getParameter("");
//         String editTime = request.getParameter("");
         String contactSummary = request.getParameter("contactSummary");
         String nextContactTime = request.getParameter("nextContactTime");
         String description = request.getParameter("description");
         String address = request.getParameter("address");

         Customer customer = new Customer();
         customer.setId(id);
         customer.setOwner(owner);
         customer.setWebsite(website);
         customer.setName(name);
         customer.setPhone(phone);
         customer.setCreateTime(createTime);
         customer.setCreateBy(createBy);
         customer.setContactSummary(contactSummary);
         customer.setNextContactTime(nextContactTime);
         customer.setDescription(description);
         customer.setAddress(address);

        System.out.println("---------------------------------------------------------------------------------------------------------------");

        System.out.println(customer);

        System.out.println("---------------------------------------------------------------------------------------------------------------");

        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean isSave = customerService.save(customer);
        PrintJson.printJsonFlag(response,isSave);


    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入查询所有者控制器");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<User> list =  customerService.getUserList();
        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("success",true);
        map.put("uList",list);
        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入查询客户控制器");
        String pageNoStr = request.getParameter("pageNo");
        System.out.println(pageNoStr);
        String pageSizeStr = request.getParameter("pageSize");
        System.out.println(pageSizeStr);

        String name = request.getParameter("name");
        System.out.println(name);

        String phone = request.getParameter("phone");
        System.out.println(phone);

        String website = request.getParameter("website");
        System.out.println(website);

        String owner = request.getParameter("owner");
        System.out.println(owner);

        //略过的记录数
        int pageNo = Integer.parseInt(pageNoStr);

        //每页的记录数
        int pageSize = Integer.parseInt(pageSizeStr);

        int skipCount = (pageNo -1) * pageSize;
        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("name",name);
        map.put("phone",phone);
        map.put("website",website);
        map.put("owner",owner);
        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        CustomerVO<Customer> customerVO = customerService.pageList(map);

        PrintJson.printJsonObj(response,customerVO);



        //        Customer customer = new Customer();
    //        customer.setName(name);
    //        customer.setPhone(phone);
    //        customer.setWebsite(website);
    //        customer.setOwner(owner);


    }
}
