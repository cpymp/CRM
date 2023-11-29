package com.project.crm.workbench.service.impl;

import com.project.crm.settings.dao.UserDao;
import com.project.crm.settings.domain.User;
import com.project.crm.utils.SqlSessionUtil;
import com.project.crm.vo.PagenationVO;
import com.project.crm.workbench.dao.ActivityDao;
import com.project.crm.workbench.dao.ActivityRemarkDao;
import com.project.crm.workbench.domain.Activity;
import com.project.crm.workbench.domain.ActivityRemark;
import com.project.crm.workbench.service.ActivityService;
import org.apache.ibatis.session.SqlSessionFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ClassName: ActivityServiceImpl
 * Package: com.project.crm.workbench.service.impl
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/22 12:30
 * @Version 1.0
 */
public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);

    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public List<ActivityRemark> getRemarkListByActivityId(String activityId) {
        List<ActivityRemark> activityRemarkList = activityRemarkDao.getRemarkListByActivityId(activityId);
        return activityRemarkList;
    }

    @Override
    public boolean update(Activity activity) {

        boolean isUpdateFlag = true;
        //受到影响的条数
        int updateCount = activityDao.update(activity);
        //比较标准的方式是抛出自定义异常，但是比较麻烦，还是
        if (updateCount != 1){
            isUpdateFlag = false;
        }
        return isUpdateFlag;

    }

    @Override
    public Activity detal(String id) {

        Activity activity = activityDao.detail(id);

        return activity;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
        //取 ulist
        List<User> userList = userDao.getUserList();

        //取  a
        Activity activity = activityDao.getById(id);

        //将 ulist 和 a打包到 map中
        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("userList",userList);
        map.put("a",activity);
        //返回map
        return map;
    }

    @Override
    public boolean edit(String editId) {
        return false;
    }

    @Override
    public boolean deleteRemarkById(String deleteId) {
        boolean isDelete = false;
        int isDeleteCount =  activityRemarkDao.deleteById(deleteId);
        if (isDeleteCount > 0){
            isDelete = true;
        }
        return isDelete;
    }

    @Override
    public boolean saveRemark(ActivityRemark activityRemark) {
        boolean isSaveFlag = false;
         int isSaveCount = activityRemarkDao.saveRemark(activityRemark);
         if (isSaveCount > 0){
             isSaveFlag = true;
         }
        return isSaveFlag;
    }

    @Override
    public boolean updateRemark(ActivityRemark activityRemark) {

        boolean isUpdateRemark = false;

       int updateCount =  activityRemarkDao.updateRemark(activityRemark);

       if (updateCount > 0){
           isUpdateRemark = true;
       }

        return isUpdateRemark;
    }

    @Override
    public boolean delete(String[] deleteId) {
        boolean isDeleteFlag = true;
        /*
        因为市场活动表还关联了一张备注表,所以在删除市场活动表时还需要查询备注表并加以删除！

        由此开始引入ActivityRemarkSqlSession
         */

        //查询出需要删除的备注的数量 注：任何添加、删除、修改的活动如果成功会有一条受到影响的条数
        int remarkRequestDeleteCount = activityRemarkDao.getCountByDeleteId(deleteId);
        //删除备注，返回受到影响的记录条数 既：实际删除的数量
        int remarkActualDeleteCount = activityRemarkDao.deleteByDeleteId(deleteId);
        //删除市场活动表
        if (remarkRequestDeleteCount != remarkActualDeleteCount){
            return false;
        }

        int  activityDeleteCount  = activityDao.delete(deleteId);
        //受影响的条数应该和传入的数组的长度比较，如果长度一样则删除成功，不一样则删除失败

        if (activityDeleteCount != deleteId.length){
            return false;
        }
        return isDeleteFlag;
    }

    @Override
    public boolean save(Activity activity) {

        boolean isSaveFlag = true;
        //受到影响的条数
        int saveCount = activityDao.save(activity);
        //比较标准的方式是抛出自定义异常，但是比较麻烦，还是
        if (saveCount != 1){
            isSaveFlag = false;
        }
        return isSaveFlag;
    }

    @Override
    public PagenationVO<Activity> pageList(Map<String, Object> map) {
        //取得记录总条数 total
        int total = activityDao.getTotalByCondition(map);
        //取得dataList  活动信息列表
        List<Activity> list = activityDao.getActivityByCondition(map);
        //将以上两样封装到VO对象中
        PagenationVO<Activity> pagenationVO  = new PagenationVO<Activity>();
        pagenationVO.setTotal(total);
        pagenationVO.setDataList(list);
        //返回VO对象
        return pagenationVO;
    }
}
