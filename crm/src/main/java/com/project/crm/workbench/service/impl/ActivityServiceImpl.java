package com.project.crm.workbench.service.impl;

import com.project.crm.utils.SqlSessionUtil;
import com.project.crm.vo.PagenationVO;
import com.project.crm.workbench.dao.ActivityDao;
import com.project.crm.workbench.dao.ActivityRemarkDao;
import com.project.crm.workbench.domain.Activity;
import com.project.crm.workbench.service.ActivityService;
import org.apache.ibatis.session.SqlSessionFactory;

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
