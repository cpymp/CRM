package com.project.crm.workbench.service.impl;

import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.ServiceFactory;
import com.project.crm.utils.SqlSessionUtil;
import com.project.crm.utils.UUIDUtil;
import com.project.crm.workbench.dao.ContactsDao;
import com.project.crm.workbench.dao.CustomerDao;
import com.project.crm.workbench.dao.TranDao;
import com.project.crm.workbench.dao.TranHistoryDao;
import com.project.crm.workbench.domain.Customer;
import com.project.crm.workbench.domain.Tran;
import com.project.crm.workbench.domain.TranHistory;
import com.project.crm.workbench.service.ContactsService;
import com.project.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * ClassName: TranServiceImpl
 * Package: com.project.crm.workbench.service.impl
 * Description:
 *
 * @Author cpymp
 * @Create 2023/12/1 23:55
 * @Version 1.0
 */
public class TranServiceImpl implements TranService {

    TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    @Override
    public List<TranHistory> getTranHistoryByTranId(String tranId) {

        List<TranHistory> list = tranHistoryDao.getHistoryByTranId(tranId);
        Iterator<TranHistory> iterator = list.iterator();
        while (iterator.hasNext()){
            TranHistory next = iterator.next();

        }

        return list;
    }

    @Override
    public boolean update(Tran tran) {
       boolean isUpdate = false;
       //   根据contacts和customer 查询 返回id
        String contactsId = tran.getContactsId();
        String rContactsId = contactsDao.getIdByName(contactsId);
        String customerId = tran.getCustomerId();
        String rCustomerId = customerDao.getIdByName(customerId);
        tran.setContactsId(rContactsId);
        tran.setCustomerId(rCustomerId);
        int count = tranDao.update(tran);
        if (count > 0){
            isUpdate = true;
        }
        //更新交易后，创建交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setCreateBy(tran.getEditBy());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setTranId(tran.getId());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setExpectedDate(tran.getExpectedDate());

        int isSaveTranHistoryCount = tranHistoryDao.save(tranHistory);
        if (isSaveTranHistoryCount == 1){
            isUpdate = true;
        }



        return isUpdate;
    }

    @Override
    public boolean deleteById(String[] deleteArr) {
        boolean isDelete = false;
        //删除交易前，删除对应的交易历史
        int hCount =  tranHistoryDao.deleteByTranId(deleteArr);
        if (hCount == deleteArr.length){
            isDelete=true;
        }
        int count = tranDao.delete(deleteArr);
        if (count == deleteArr.length){
            isDelete=true;
        }





        return false;
    }

    @Override
    public Tran getTranById(String id) {
        Tran tran = tranDao.getTranById(id);
        return tran;
    }

    @Override
    public Map<String, Object> getChars() {
        Map<String, Object> map = new HashMap<String, Object>();
        //取得 total
        int total = tranDao.getTotal();
        //取得dataList
        List<Map<String,Object>> dataList = tranDao.getDataList();
        //将结果打包到map
        map.put("total",total);
        map.put("dataList",dataList);

        //返回map
        return map;
    }

    @Override
    public boolean changeStage(Tran tran) {
        boolean isChange = true;
        int count = tranDao.changeStage(tran);
        if (count != 1) {
            isChange = false;
        }
        //生成交易历史
        TranHistory tranHistory = new TranHistory();
        String id = UUIDUtil.getUUID();
        tranHistory.setId(id);
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setTranId(tran.getId());
        tranHistory.setStage(tran.getStage());
        tranHistory.setCreateBy(tran.getEditBy() );
        int isSHCount =  tranHistoryDao.save(tranHistory);
        if (isSHCount != 1){
             isChange = false;
        }
        return isChange;
    }

    @Override
    public Map<String,Object> pageList(Map<String, Object> map) {
        Map<String,Object> rMap = new HashMap<String, Object>();
        List<Tran> list =  tranDao.pageList(map);
        int total = tranDao.getTotalByCondition(map);
        rMap.put("transList",list);
        rMap.put("total",total);

        return rMap;
    }

    @Override
    public boolean save(Tran tran, String customerName) {
        boolean isSave = true;
        /*
                交易的添加业务
                    在做添加之前，参数t里面少了一项信息，既 ：ｃｕｓｔｏｍｅｒＩｄ
                    >判断customerName 根据名字在客户表精确查询
                    >如果有客户，则取出客户的id，封装到tran对象中
                    >如果没有客户，则新建一个客户信息，然后将新建的id取出，封装到tran对象中

         */
        Customer customer = customerDao.getCustomerByName(customerName);
        if (customer == null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(tran.getCreateTime());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setOwner(tran.getOwner());
            customer.setName(customerName);
            int isSaveCustomerCount = customerDao.save(customer);
            if (isSaveCustomerCount != 1){
                isSave =false;
            }
        }

        //通过对于客户的处理，无论是以前有的，或者是新增的，客户信息已有,将客户ID封装到tran对象中
        tran.setCustomerId(customer.getId());
        //添加交易
        int isSaveTranCount = tranDao.save(tran);
        if (isSaveTranCount != 1){
            isSave =false;
        }
        //添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setStage(tran.getStage());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(tran.getCreateTime());
        int isSaveTranHistoryCount =tranHistoryDao.save(tranHistory);
        if (isSaveTranHistoryCount != 1){
            isSave =false;
        }

        return isSave;
    }



}
