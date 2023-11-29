package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    List<CustomerRemark> getRemarkListByCustomerId(String customerId);

    int saveCustomerRemark(CustomerRemark customerRemark);

    int updateRemark(CustomerRemark customerRemark);

    int deleteRemarkById(String id);
}
