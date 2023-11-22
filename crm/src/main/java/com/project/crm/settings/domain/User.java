package com.project.crm.settings.domain;

/**
 * ClassName: User
 * Package: com.project.crm.settings.domain
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/20 22:58
 * @Version 1.0
 */
public class User  {

    /*

            关于字符串中表现的时间和日期
            常用的有两种方式
            日期：年月日
                    yyyy--MM-dd 10位字符串

            日期 + 时间：年月日时分秒  19位字符串
                    yyyy-MM-dd HH:mm:s
     */

    private String id ;// 编号 主键
    private String loginAct;// 登录账号
    private String name;// 用户的真实姓名
    private String loginPwd;// 登录密码
    private String email;// 邮箱
    private String expireTime;// 失效时间                 日期 + 时间：年月日时分秒  19位字符串

    private String lockState;//  锁定状态    0表示锁定   1 表示启用
    private String deptno;// 部门编号
    private String allowIps;//允许访问的IP地址
    private String createTime;//记录的创建时间
    private String createBy;//记录的创建人
    private String editTime;//修改时间  日期 + 时间：年月日时分秒  19位字符串
    private String editBy;//修改人


    /*
        关于登录
               >验证账号和密码
                   User user =  select * from tbl_user where loginAct  = ? and  loginPwd = ?;

                   if(user ==null){
                   账号密码错误
                   }
                   if(user != null){
                    继续验证其他信息

                    user.getExpireTime();  验证失效时间   例如：临时用户  有效时间 一周
                    user.getLockState();   验证锁定状态   0 锁定   1 启用
                    user.getAllLowIps();   验证浏览器的ip地址是否有效


                   }



                    除此之外 还需要验证 是否失效
                    除此之外 还需要验证 ip地址是否允许访问



     */

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginAct() {
        return loginAct;
    }

    public void setLoginAct(String loginAct) {
        this.loginAct = loginAct;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(String expireTime) {
        this.expireTime = expireTime;
    }

    public String getLockState() {
        return lockState;
    }

    public void setLockState(String lockState) {
        this.lockState = lockState;
    }

    public String getDeptno() {
        return deptno;
    }

    public void setDeptno(String deptno) {
        this.deptno = deptno;
    }

    public String getAllowIps() {
        return allowIps;
    }

    public void setAllowIps(String allowIps) {
        this.allowIps = allowIps;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", loginAct='" + loginAct + '\'' +
                ", name='" + name + '\'' +
                ", loginPwd='" + loginPwd + '\'' +
                ", email='" + email + '\'' +
                ", expireTime='" + expireTime + '\'' +
                ", lockState='" + lockState + '\'' +
                ", deptno='" + deptno + '\'' +
                ", allowIps='" + allowIps + '\'' +
                ", createTime='" + createTime + '\'' +
                ", createBy='" + createBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", editBy='" + editBy + '\'' +
                '}';
    }
}
