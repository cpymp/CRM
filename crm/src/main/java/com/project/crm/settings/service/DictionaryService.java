package com.project.crm.settings.service;

import com.project.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * ClassName: DctionaryService
 * Package: com.project.crm.settings.service
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/26 23:45
 * @Version 1.0
 */
public interface DictionaryService {
    Map<String, List<DicValue>> getAll();

}
