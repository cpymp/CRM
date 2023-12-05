package com.project.crm.workbench.service.impl;

import com.project.crm.settings.dao.UserDao;
import com.project.crm.settings.domain.User;
import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.ServiceFactory;
import com.project.crm.utils.SqlSessionUtil;
import com.project.crm.utils.UUIDUtil;
import com.project.crm.workbench.dao.*;
import com.project.crm.workbench.domain.*;
import com.project.crm.workbench.service.ClueService;
import com.project.crm.workbench.service.CustomerService;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ClassName: ClueServiceImpl
 * Package: com.project.crm.workbench.service.impl
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/26 22:49
 * @Version 1.0
 */
public class ClueServiceImpl implements ClueService {
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    //线索相关表
    ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    ClueActivityRelationDao carDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    //客户相关表
    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    //联系人相关表
    ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    ContactsRemarkDao contactsRemarkDao =  SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    //交易相关表
    TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    @Override
    public boolean save(Clue clue) {
        boolean isSave = false;
        int isSaveCount = clueDao.save(clue);
        if (isSaveCount > 0){
            isSave = true;
            System.out.println("添加成功");
        }
        return isSave;
    }

    @Override
    public boolean unBound(String carId) {
        boolean isUnBound = false;
        int isUnBoundCount = clueDao.unBound(carId);
        if (isUnBoundCount > 0){
            isUnBound = true;
        }

        return isUnBound;
    }

    @Override
    public boolean convert(String clueId, String createBy, Tran tran) {
        boolean isConvertFlag = true;
        String createTime = DateTimeUtil.getSysTime();

        //根据clueId，查询clue对象(根据Id查单条)
        Clue clue = clueDao.getClueById(clueId);

        //通过线索信息，提取客户信息
        String company = clue.getCompany();
        Customer customer = customerDao.getCustomerByName(company);

        //如果customer为空，则新建一个客户对象并保存相应信息   否则直接服用旧数据即可
        if (customer ==  null) {
            customer = new Customer();
            //id
            customer.setId(UUIDUtil.getUUID());
            customer.setAddress(clue.getAddress());
            customer.setName(company);
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);
            customer.setOwner(clue.getOwner());
            customer.setWebsite(clue.getWebsite());
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            //添加客户
            int isSaveCount = customerDao.save(customer);
            if (isSaveCount != 1) {
                isConvertFlag = false;
            }
        }
            //通过线索信息提取联系人对象
            Contacts contacts = new Contacts();
            contacts.setId(UUIDUtil.getUUID());
            contacts.setFullname(clue.getFullname());
            contacts.setOwner(clue.getOwner());
            contacts.setSource(clue.getSource());
            contacts.setCustomerId(customer.getId());
            contacts.setAppellation(clue.getAppellation());
            contacts.setEmail(clue.getEmail());
            contacts.setMphone(clue.getMphone());
            contacts.setJob(clue.getJob());
//            contacts.setBirth();
            contacts.setCreateBy(createBy);
            contacts.setCreateTime(createTime);
            contacts.setDescription(clue.getDescription());
            contacts.setContactSummary(clue.getContactSummary());
            contacts.setNextContactTime(clue.getNextContactTime());
            contacts.setAddress(clue.getAddress());

        //添加联系人
            int isSavecontactsCount = contactsDao.save(contacts);
            if (isSavecontactsCount != 1){
                isConvertFlag = false;
            }


           List<ClueRemark> clueRemarkList = clueRemarkDao.getRemarkByClueId(clueId);
            for (ClueRemark clueRemark: clueRemarkList){
                //取出每一条线索备注
                String noteContent = clueRemark.getNoteContent();

                //创建客户备注对象，添加客户备注
                CustomerRemark customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtil.getUUID());
                customerRemark.setCustomerId(customer.getId());
                customerRemark.setCreateBy(createBy);
                customerRemark.setNoteContent(noteContent);
                customerRemark.setCreateTime(createTime);
                customerRemark.setEditFlag("0");
                int isSaveCustomerRemark = customerRemarkDao.save(customerRemark);
                if (isSaveCustomerRemark != 1){
                    return false;
                }

                //创建联系人备注对象，添加联系人
                ContactsRemark contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtil.getUUID());
                contactsRemark.setContactsId(contacts.getId());
                contactsRemark.setCreateBy(createBy);
                contactsRemark.setNoteContent(noteContent);
                contactsRemark.setCreateTime(createTime);
                contactsRemark.setEditFlag("0");
                int isSaveContactsRemark = contactsRemarkDao.save(contactsRemark);
                if (isSaveContactsRemark != 1){
                    return false;
                }
            }


            //获取clue和activity的关系
            List<ClueActivityRelation> clueActivityRelationList = carDao.getclueActivityRelationListByClueId(clueId);
            for (ClueActivityRelation clueActivityRelation: clueActivityRelationList){
                ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtil.getUUID());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                int count = contactsActivityRelationDao.save(contactsActivityRelation);
                if (count != 1){
                    isConvertFlag = false;
                }



            }



            if (tran != null){
                //创建交易  tran 已经封装了重要的基本信息
                tran.setSource(clue.getSource());
                tran.setNextContactTime(clue.getNextContactTime());
                tran.setCustomerId(clue.getId());
                tran.setOwner(clue.getOwner());
                tran.setContactsId(contacts.getId());
                tran.setDescription(clue.getDescription());
                tran.setContactSummary(clue.getContactSummary());
                int isSaveTranCount = tranDao.save(tran);
                if (isSaveTranCount != 1){
                    isConvertFlag = false;
                }

            //只有创建交易了才创建交易历史
                TranHistory tranHistory = new TranHistory();
                tranHistory.setId(UUIDUtil.getUUID());
                tranHistory.setCreateBy(createBy);
                tranHistory.setCreateTime(createTime);
                tranHistory.setTranId(tran.getId());
                tranHistory.setMoney(tran.getMoney());
                tranHistory.setStage(tran.getStage());
                tranHistory.setExpectedDate(tran.getExpectedDate());

                int isSaveTranHistoryCount = tranHistoryDao.save(tranHistory);
                if ( isSaveTranHistoryCount != 1){
                    isConvertFlag = false;
                }

            }

            //删除线索备注
        for (ClueRemark clueRemark: clueRemarkList){

            String id = clueRemark.getClueId();
            int isDeleteClueRcount =  clueRemarkDao.deleteById(id);
            if (isDeleteClueRcount != 1){
                isConvertFlag = false;
            }


        }

            //删除市场活动和线索的关系
        for (ClueActivityRelation clueActivityRelation: clueActivityRelationList){
            String id = clueActivityRelation.getId();

            int isDeleteCARCount =  carDao.delete(id);
            if (isDeleteCARCount != 1){
                isConvertFlag = false;
            }


        }

            //删除 线索
        int isDeleteClueCount = clueDao.deleteById(clueId);
            if (isDeleteClueCount != 1){
                isConvertFlag = false;
            }
            return isConvertFlag;
    }

    @Override
    public boolean bound(Map<String, Object> map) {
        boolean isBound = false;
        String[] aIds = ((String[])map.get("activityIds"));
        int boundCount = 0;
        for (int i = 0; i< aIds.length;i++){
            System.out.println(aIds[i]);
            System.out.println(aIds[i]);
            System.out.println(aIds[i]);
            System.out.println(aIds[i]);
            System.out.println(aIds[i]);
            Map<String,Object>  map1  = new HashMap<String,Object>();
            map1.put("id",UUIDUtil.getUUID());
            map1.put("clueId",map.get("clueId"));
            map1.put("activityId",aIds[i]);
            carDao.bound(map1);
            boundCount ++;
        }
        if (boundCount == aIds.length ){
            isBound = true;
        }
        return isBound;
    }

    @Override
    public Clue getClueById(String id) {

        Clue clue = clueDao.getClueByIdForDetail(id);

        return clue;



    }

    @Override
    public boolean delete(String[] deleteIds) {
        boolean isDelete = false;
        int count = clueDao.delete(deleteIds);
        if (count == deleteIds.length){
            System.out.println("删除成功！！");
            isDelete = true;
        }
        return isDelete;
    }

    @Override
    public boolean update(Clue clue) {
        boolean isUpdate = false;
        int count = clueDao.update(clue);
        if (count > 0){
            isUpdate = true;
        }
        return isUpdate;
    }

    @Override
    public  Map<String ,Object> getUserListAndClue(String id) {
        Clue clue = clueDao.getClueById(id);
        List<User> userList = userDao.getUserList();
        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("clue",clue);
        map.put("userList",userList);
        return map;
    }

    @Override
    public Map<String, Object> pageList(Map<String, Object> map) {



        int total = clueDao.getTotalByCondition(map);
        List<Clue> list = clueDao.getClueByCOndition(map);

       Map<String,Object> rMap =  new HashMap<String,Object>();
        rMap.put("total",total);
        rMap.put("clueList",list);

        return rMap;
    }
}
