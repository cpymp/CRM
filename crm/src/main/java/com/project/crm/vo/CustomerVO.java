package com.project.crm.vo;

import java.util.List;

/**
 * ClassName: CustomerVo
 * Package: com.project.crm.vo
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/27 15:46
 * @Version 1.0
 */
public class CustomerVO<T> {
    private int total;
    private List<T> dataList;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
