package com.project.crm.workbench.service.impl;

import com.project.crm.utils.SqlSessionUtil;
import com.project.crm.workbench.dao.ClueDao;
import com.project.crm.workbench.domain.Clue;
import com.project.crm.workbench.service.ClueService;
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
    ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);

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
    public Map<String, Object> pageList(Map<String, Object> map) {



        int total = clueDao.getTotalByCondition(map);
        List<Clue> list = clueDao.getClueByCOndition(map);

       Map<String,Object> rMap =  new HashMap<String,Object>;
        rMap.put("total",total);
        rMap.put("clueList",list);

        return rMap;
    }
}
