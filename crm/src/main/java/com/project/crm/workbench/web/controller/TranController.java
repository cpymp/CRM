package com.project.crm.workbench.web.controller;

import com.project.crm.settings.domain.User;
import com.project.crm.settings.service.UserService;
import com.project.crm.settings.service.impl.UserServiceImpl;
import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.PrintJson;
import com.project.crm.utils.ServiceFactory;
import com.project.crm.utils.UUIDUtil;
import com.project.crm.workbench.domain.Activity;
import com.project.crm.workbench.domain.Contacts;
import com.project.crm.workbench.domain.Tran;
import com.project.crm.workbench.domain.TranHistory;
import com.project.crm.workbench.service.ActivityService;
import com.project.crm.workbench.service.ContactsService;
import com.project.crm.workbench.service.CustomerService;
import com.project.crm.workbench.service.TranService;
import com.project.crm.workbench.service.impl.ActivityServiceImpl;
import com.project.crm.workbench.service.impl.ContactsServiceImpl;
import com.project.crm.workbench.service.impl.CustomerServiceImpl;
import com.project.crm.workbench.service.impl.TranServiceImpl;

import javax.naming.Name;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * ClassName: TranController
 * Package: com.project.crm.workbench.web.controller
 * Description:
 *
 * @Author cpymp
 * @Create 2023/12/1 23:56
 * @Version 1.0
 */
public class TranController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入客户控制器");
        String path = request.getServletPath();

        if ("/workbench/transaction/add.do".equals(path)) {

            add(request,response);
//            xxx(request,response);

        } else if ("/workbench/transaction/showActivityList.do".equals(path)) {
            showActivityList(request,response);

        } else if ("/workbench/transaction/serchActivityList.do".equals(path)) {
            showActivityList(request,response);

        }else if ("/workbench/transaction/getCustomerName.do".equals(path)) {
            getCustomerName(request,response);

        }else if ("/workbench/transaction/getContactsName.do".equals(path)) {
            getContactsName(request,response);

        }else if ("/workbench/transaction/save.do".equals(path)) {
            save(request,response);

        }else if ("/workbench/transaction/pageList.do".equals(path)) {
            pageList(request,response);

        }else if ("/workbench/transaction/detail.do".equals(path)) {
            detail(request,response);

        }else if ("/workbench/transaction/getTranHistoryList.do".equals(path)) {
            getTranHistoryList(request,response);

        }else if ("/workbench/transaction/showActivityList.do".equals(path)) {
//            xxx(request,response);

        }else if ("/workbench/transaction/edit.do".equals(path)) {
            edit(request,response);

        }
        else if ("/workbench/transaction/getUserList.do".equals(path)) {
            getUserList(request,response);

        }else if ("/workbench/transaction/getTran.do".equals(path)) {
            getTran(request,response);

        }else if ("/workbench/transaction/delete.do".equals(path)) {
            delete(request,response);

        }else if ("/workbench/transaction/changeStage.do".equals(path)) {
            changeStage(request,response);

        }else if ("/workbench/transaction/getCharts.do".equals(path)) {
            getCharts(request,response);

        }
    }

    private void getCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得交易阶段数量统计图表的数据");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Map<String,Object> map = tranService.getChars();
        /*
            业务层返回total 和 dataList 打包返回
         */
        PrintJson.printJsonObj(response,map);
    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行改变阶段方法");
        String id = request.getParameter("id");
        String stage = request.getParameter("stage");
        String money = request.getParameter("money");
        String expectedDate = request.getParameter("expectedDate");
        String editBy = ((User) (request.getSession().getAttribute("user"))).getName();
        String editTime = DateTimeUtil.getSysTime();
        Tran tran = new Tran();
        tran.setId(id);
        tran.setStage(stage);
        tran.setMoney(money);
        tran.setExpectedDate(expectedDate);
        tran.setEditTime(editTime);
        tran.setEditBy(editBy);
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean isFlage = tranService.changeStage(tran);
        Map<String ,Object> map = new HashMap<String, Object>();
        Map<String,String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");
        tran.setPossibility(pMap.get(stage));
        map.put("success",isFlage);
        map.put("tran",tran);

        PrintJson.printJsonObj(response,map);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入删除控制器");
        String deleteIds = request.getParameter("deleteIds");
        String[] deleteArr = deleteIds.split("&");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean isDelete = tranService.deleteById(deleteArr);
        PrintJson.printJsonObj(response,isDelete);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }

    private void getTran(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran = tranService.getTranById(id);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request,response);
        PrintJson.printJsonFlag(response,true);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入修改控制器！");
        String nextContactTime = request.getParameter("nextContactTime");
        String contactSummary = request.getParameter("contactSummary");
        String description = request.getParameter("describe");
        String contactsName = request.getParameter("contactsName");
        String activitySrc = request.getParameter("activitySrc");
        String Source = request.getParameter("clueSource");
        String transactionType = request.getParameter("transactionType");
        String transactionStage = request.getParameter("transactionStage");
        String accountName = request.getParameter("accountName");
        String expectedClosingDate = request.getParameter("expectedClosingDate");
        String transactionName = request.getParameter("transactionName");
        String amountOfMoney = request.getParameter("amountOfMoney");
        String transactionOwner = request.getParameter("transactionOwner");
        String id = request.getParameter("id");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        System.out.println(editBy);
        Tran tran = new Tran();
        tran.setId(id);
        tran.setNextContactTime(nextContactTime);
        tran.setContactSummary(contactSummary);
        tran.setDescription(description);
        tran.setContactsId(contactsName); //待处理
        tran.setActivityId(activitySrc);
        tran.setSource(Source);
        tran.setType(transactionType);
        tran.setStage(transactionStage);
        tran.setCustomerId(accountName); // 待处理
        tran.setExpectedDate(expectedClosingDate);
        tran.setName(transactionName);
        tran.setMoney(amountOfMoney);
        tran.setOwner(transactionOwner);
        System.out.println(transactionOwner);
        tran.setEditBy(editBy);
        tran.setEditTime(editTime);
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        System.out.println(tran);
        boolean isUpdate = tranService.update(tran);
        PrintJson.printJsonFlag(response,isUpdate);



    }

    private void getTranHistoryList(HttpServletRequest request, HttpServletResponse response) {
        String tranId = request.getParameter("tranId");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> list = tranService.getTranHistoryByTranId(tranId);

        Iterator<TranHistory> iterator = list.iterator();
        Map<String,String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");
        while (iterator.hasNext()){
            TranHistory history = iterator.next();
            String stage = history.getStage();
            String possibility = pMap.get(stage);
            history.setPossibility(possibility);
        }

        PrintJson.printJsonObj(response,list);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran = tranService.getTranById(id);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入查询交易列表控制器");

                  String pageNostr = request.getParameter("pageNo");
                  String pageSizestr = request.getParameter("pageSize");
                  String customerName = request.getParameter("customerName");
                  String stage = request.getParameter("stage");
                  String contactsName = request.getParameter("contactsName");
                  String source = request.getParameter("source");
                  String type = request.getParameter("type");
                  String name = request.getParameter("name");
                  String owner = request.getParameter("owner");

                int pageNo = Integer.parseInt(pageNostr);
                int pageSize = Integer.parseInt(pageSizestr);
                int skipNum = (pageNo -1)*pageSize;
                Map<String,Object> map = new HashMap<String, Object>();
                map.put("customerName",customerName);
                map.put("stage",stage);
                map.put("contactsName",contactsName);
                map.put("source",source);
                map.put("type",type);
                map.put("name",name);
                map.put("owner",owner);
                map.put("skipNum",skipNum);
                map.put("pageSize",pageSize);

        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Map<String,Object> rMap  = tranService.pageList(map);
        PrintJson.printJsonObj(response,rMap);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("进入保存交易方法");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();

        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName"); //没有客户ID，只有客户名称
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

//        System.out.println(activityId);
//        System.out.println(contactsId);

        Tran tran = new Tran();
//        tran.setCustomerName(customerName);
        tran.setId(id);
        tran.setCreateBy(createBy);
        tran.setCreateTime(createTime);
        tran.setOwner(owner);
       tran.setMoney(money);
       tran.setName(name);
       tran.setExpectedDate(expectedDate);
       tran.setStage(stage);
       tran.setType(type);
       tran.setSource(source);
       tran.setActivityId(activityId);
       tran.setContactsId(contactsId);
       tran.setDescription(description);
       tran.setContactSummary(contactSummary);
       tran.setNextContactTime(nextContactTime);

        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean isSave = tranService.save(tran,customerName);
        if (isSave){
            //如果添加交易成功，就跳转到首页
            //request域存值，必须使用转发  且转发过后地址栏是维持在 .do的操作，只后的每一次刷新，都会在后台继续走请求。
//            request.getRequestDispatcher("/workbench/transaction/index.jsp").forward(request,response);
            //request 重定向，回到列表页

            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }


    }

    private void getContactsName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取联系人信息控制器");
        String name = request.getParameter("name");
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> list = contactsService.getContactsByFullName(name);
        PrintJson.printJsonObj(response,list);

    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入查询客户姓名控制器");
        String name = request.getParameter("name");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<String> customerNameList = customerService.getCustomerName(name);
        PrintJson.printJsonObj(response,customerNameList);





    }


    private void showActivityList(HttpServletRequest request, HttpServletResponse response) {

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

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到跳转至添加交易页面控制器");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        request.setAttribute("userList",userList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);

    }
}
