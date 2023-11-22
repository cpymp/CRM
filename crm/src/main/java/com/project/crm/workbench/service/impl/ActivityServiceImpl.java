package com.project.crm.workbench.service.impl;

import com.project.crm.utils.SqlSessionUtil;
import com.project.crm.vo.PagenationVO;
import com.project.crm.workbench.dao.ActivityDao;
import com.project.crm.workbench.domain.Activity;
import com.project.crm.workbench.service.ActivityService;

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
