package com.project.crm.settings.service.impl;

import com.project.crm.settings.dao.DicTypeDao;
import com.project.crm.settings.dao.DicValueDao;
import com.project.crm.settings.domain.DicType;
import com.project.crm.settings.domain.DicValue;
import com.project.crm.settings.service.DictionaryService;
import com.project.crm.settings.service.DictionaryService;
import com.project.crm.utils.SqlSessionUtil;

import java.util.Dictionary;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ClassName: DictionaryServiceImpl
 * Package: com.project.crm.settings.service.impl
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/26 23:45
 * @Version 1.0
 */
public class DictionaryServiceImpl implements DictionaryService {

        DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
        DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);



        @Override
        public Map<String, List<DicValue>> getAll() {
                Map<String,List<DicValue>> valueMap = new HashMap<String, List<DicValue>>();
                //将字典类型列表取出
                List<DicType> dicTypeList = dicTypeDao.getTypeList();
                //根据字典类型，取值各个类型的值
                for (DicType dicType : dicTypeList){
                        //
                        String code = dicType.getCode();
                        //根据每个字典类型取得字典列表

                        List<DicValue> dicValueList = dicValueDao.getListByCode(code);

                        valueMap.put(code,dicValueList);

                }
                return valueMap;
        }
}
