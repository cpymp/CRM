package com.project.crm.workbench.service.impl;

import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.SqlSessionUtil;
import com.project.crm.utils.UUIDUtil;
import com.project.crm.workbench.dao.ContactsDao;
import com.project.crm.workbench.dao.CustomerDao;
import com.project.crm.workbench.domain.Contacts;
import com.project.crm.workbench.domain.Customer;
import com.project.crm.workbench.service.ContactsService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * ClassName: ContactsServiceImpl
 * Package: com.project.crm.workbench.service.impl
 * Description:
 *
 * @Author cpymp
 * @Create 2023/12/2 13:56
 * @Version 1.0
 */
public class ContactsServiceImpl implements ContactsService {
    @Override
    public boolean delete(List<String> deleteList) {

        boolean isDelete = false;
        int isDeleteCount = contactsDao.delete(deleteList);
        if (isDeleteCount == deleteList.size()){

            isDelete = true;

        }
        return isDelete;
    }

    @Override
    public boolean update(Contacts con) {
        boolean isUpdate = true;
        String customerName = con.getCustomerId();
        Customer customer = customerDao.getCustomerByName(customerName);
        if (customer == null){
            //不存在客户，则创建一个客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(con.getOwner());
            customer.setName(customerName);
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(con.getCreateBy());
            customer.setContactSummary(con.getContactSummary());
            customer.setNextContactTime(con.getNextContactTime());
            customer.setDescription(con.getDescription());
            customer.setAddress(con.getAddress());
            int count = customerDao.save(customer);
            if (count != 1){
                isUpdate = false;
            }
        }
        con.setCustomerId(customer.getId());

        int csCount = contactsDao.update(con);//创建联系人之前先将对应的客户创建好
        if (csCount != 1){
            isUpdate = false;
        }
        return isUpdate;
    }

    ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public List<Contacts> getContactsByFullName(String name) {
        List<Contacts> list = contactsDao.getContactsByFullName(name);

        return list;
    }

    @Override
    public Contacts getContactById(String id) {
        Contacts contacts =  contactsDao.getContactById(id);
        return contacts;
    }

    @Override
    public boolean save(Contacts contacts) {
        boolean isSave = true;
        String customerName = contacts.getCustomerId();
        Customer customer = customerDao.getCustomerByName(customerName);
        if (customer == null){
            //不存在客户，则创建一个客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(contacts.getOwner());
            customer.setName(customerName);
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(contacts.getCreateBy());
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setDescription(contacts.getDescription());
            customer.setAddress(contacts.getAddress());
            int count = customerDao.save(customer);
            if (count != 1){
                isSave = false;
            }
        }
            contacts.setCustomerId(customer.getId());

        int csCount = contactsDao.save(contacts);//创建联系人之前先将对应的客户创建好
        if (csCount != 1){
            isSave = false;
        }
        return isSave;
    }

    @Override
    public Map<String, Object> pageList(Map<String, Object> map) {
        Map<String, Object> rMap = new HashMap<String, Object>();
        List<Contacts> list = contactsDao.getContactsByCondition(map);
        int total = contactsDao.getTotalByCondition(map);
        rMap.put("total",total);
        rMap.put("contactsList",list);
        return rMap ;
    }
}
