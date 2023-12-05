<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<%@page pageEncoding="UTF-8"%>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

</head>
<body>
<script>
	$(function(){
	$("#serchButton").click(function (){
		pageList(1,5);
	})
	$("#createButton").click(function (){

	$("#createUserModal").modal("show");

	})

		$("#saveButton").click(function (){
			var loginPwd = $.trim($("#create-loginPwd").val());
			var confirmPwd = $.trim($("#create-confirmPwd").val());
			var dept = $.trim($("#create-dept").val());
			var loginActNo = $.trim($("#create-loginActNo").val());

			// if (dept == '' ||loginActNo == '' || confirmPwd == '' || loginPwd == '' ){
			// 	alert("请填入必填信息然后再保存！");
			// 	return false;
			// }
			// if (loginPwd != confirmPwd){
			// 	alert("密码不一样,请重新输入");
			// 	return false;
			// }
			$.ajax({
				url:"settings/qx/user/isRepeat.do",
				type:"post",
				data:{
					"loginActNo":$.trim($("#create-loginActNo").val())

				},
				dataType:"json",
				success:function (data){

					if (data.success){
						$.ajax({
							url:"settings/qx/user/save.do",
							type:"post",
							data:{
								"loginActNo":$.trim($("#create-loginActNo").val()),
								"username":$.trim($("#create-username").val()),
								"email":$.trim($("#create-email").val()),
								"expireTime":$.trim($("#create-expireTime").val()),
								"loginPwd":$.trim($("#create-loginPwd").val()),
								"confirmPwd":$.trim($("#create-confirmPwd").val()),
								"lockStatus":$.trim($("#create-lockStatus").val()),
								"dept":$.trim($("#create-dept").val()),
								"allowIps":$.trim($("#create-allowIps").val())

							},
							dataType:"json",
							success:function (data){

								if (data.success){

									pageList(1,5);
									$("#createUserModal").modal("hide");
								}
							}
						})


					}else {
						alert("登录账户已存在，请重新输入!");
						$("#createUserModal").modal("show");
					}

				}
			})





		})
		pageList(1,5);
	$("#deleteButton").click(function (){

		var $xz = $("input[name=xz]:checked");
		// alert($xz.length);
		var deleteIds = "";
		if ($xz.length == 0 ){
			alert("请选择需要删除的用户");
			return false;
		}
		for(var i = 0; i < $xz.length;i++){
			deleteIds += $($xz[i]).val();

			if (i != $xz.length -1){
				deleteIds += "&";
			}
		}
		alert(deleteIds);
		$.ajax({
			url: "settings/qx/user/deleteUser.do",
			data: {
				"deleteIds":deleteIds
			},
			dataType: "json",
			type: "get",
			success: function (data) {

			if (data.success){
				pageList(1,5);
			}
			}
		})


	})
	})
function  pageList(pageNo,pageSize){

	$.ajax({
		url: "settings/qx/user/pageList.do",
		data: {
			"pageNo":pageNo,
			"pageSize":pageSize,
			"userName":$.trim($("#serch-userName").val()),
			"lockState":$.trim($("#serch-lockState").val()),
			"expireStartTime":$.trim($("#serch-expireStartTime").val()),
			"expireEndTime":$.trim($("#serch-expireEndTime").val())
		},
		dataType: "json",
		type: "post",
		success: function (data) {

			var html = "";
			$.each(data.userList,function (i,n){

					html +='<tr class="active">;'
					html +='<td><input type="checkbox" name="xz" value="'+n.id+'" " /></td>;'
					html +='<td>'+(i+1)+'</td>;'
					html +='<td><a  href="detail.html">'+n.loginAct+'</a></td>;'
					html +='<td>'+n.name+'</td>;'

					html +='<td> '+n.email+'</td>;'
					html +='<td>'+n.expireTime+'</td>;'
					html +='<td>'+n.allowIps+'</td>;'
					html +='<td>'+n.lockState+'</td>;'
					html +='<td>admin</td>;'
					html +='<td>'+n.createTime+'</td>;'

					html +='</tr>;'



			})
			$("#userInfoBody").html(html);
			var totalPages = data.total % pageSize == 0 ?  data.total / pageSize : parseInt(data.total/pageSize)+1;
			$("#activityPage").bs_pagination({
				currentPage: pageNo, // 页码
				rowsPerPage: pageSize, // 每页显示的记录条数
				maxRowsPerPage: 20, // 每页最多显示的记录条数
				totalPages: totalPages, // 总页数
				totalRows: data.total, // 总记录条数

				visiblePageLinks: 3, // 显示几个卡片

				showGoToPage: true,
				showRowsPerPage: true,
				showRowsInfo: true,
				showRowsDefaultInfo: true,

				onChangePage : function(event, data){
					pageList(data.currentPage , data.rowsPerPage);
				}
			});

		}
	})


}

</script>

	<!-- 创建用户的模态窗口 -->
	<div class="modal fade" id="createUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">新增用户</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-loginActNo" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-loginActNo">
							</div>
							<label for="create-username" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-username">
							</div>
						</div>
						<div class="form-group">
							<label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-loginPwd">
							</div>
							<label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-confirmPwd">
							</div>
						</div>
						<div class="form-group">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control time" id="create-expireTime">
							</div>
						</div>
						<div class="form-group">
							<label for="create-lockStatus" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-lockStatus">
								  <option></option>
								  <option>启用</option>
								  <option>锁定</option>
								</select>
							</div>
							<label for="create-org" class="col-sm-2 control-label">部门<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="create-dept">
                                    <option></option>
                                    <option>市场部</option>
                                    <option>策划部</option>
                                </select>
                            </div>
						</div>
						<div class="form-group">
							<label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-allowIps" style="width: 280%" placeholder="多个用逗号隔开">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary"  id="saveButton" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户列表</h3>
			</div>
		</div>
	</div>
	
	<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">用户姓名</div>
		      <input class="form-control" type="text" id="serch-userName">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
<%--		  <div class="form-group">--%>
<%--		    <div class="input-group">--%>
<%--		      <div class="input-group-addon">部门名称</div>--%>
<%--		      <input class="form-control" type="text">--%>
<%--		    </div>--%>
<%--		  </div>--%>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">锁定状态</div>
			  <select class="form-control" id="serch-lockState">
			  	  <option></option>
			      <option>锁定</option>
				  <option>启用</option>
			  </select>
		    </div>
		  </div>
		  <br><br>
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">失效时间</div>
			  <input class="form-control" type="text" id="serch-expireStartTime" />
		    </div>
		  </div>
		  
		  ~
		  
		  <div class="form-group">
		    <div class="input-group">
			  <input class="form-control" type="text" id="serch-expireEndTime" />
		    </div>
		  </div>
		  
		  <button type="button" class="btn btn-default" id="serchButton">查询</button>
		  
		</form>
	</div>
	
	
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary"   id="createButton"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-danger" id="deleteButton"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
		
	</div>
	
	<div style="position: relative; left: 30px; top: 40px; width: 110%">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" /></td>
					<td>序号</td>
					<td>登录帐号</td>
					<td>用户姓名</td>

					<td>邮箱</td>
					<td>失效时间</td>
					<td>允许访问IP</td>
					<td>锁定状态</td>
					<td>创建者</td>
					<td>创建时间</td>

				</tr>
			</thead>
			<tbody id="userInfoBody">
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td><a  href="detail.html">zhangsan</a></td>
					<td>张三</td>

					<td>zhangsan@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td>启用</td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td><a  href="detail.html">lisi</a></td>
					<td>李四</td>

					<td>lisi@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td>锁定</td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div style="height: 50px; position: relative;top: 30px; left: 30px;">
<%--		<div>--%>
<%--			<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
<%--		</div>--%>
<%--		<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--			<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--			<div class="btn-group">--%>
<%--				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--					10--%>
<%--					<span class="caret"></span>--%>
<%--				</button>--%>
<%--				<ul class="dropdown-menu" role="menu">--%>
<%--					<li><a href="#">20</a></li>--%>
<%--					<li><a href="#">30</a></li>--%>
<%--				</ul>--%>
<%--			</div>--%>
<%--			<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--		</div>--%>
<%--		<div style="position: relative;top: -88px; left: 285px;">--%>
<%--			<nav>--%>
<%--				<ul class="pagination">--%>
<%--					<li class="disabled"><a href="#">首页</a></li>--%>
<%--					<li class="disabled"><a href="#">上一页</a></li>--%>
<%--					<li class="active"><a href="#">1</a></li>--%>
<%--					<li><a href="#">2</a></li>--%>
<%--					<li><a href="#">3</a></li>--%>
<%--					<li><a href="#">4</a></li>--%>
<%--					<li><a href="#">5</a></li>--%>
<%--					<li><a href="#">下一页</a></li>--%>
<%--					<li class="disabled"><a href="#">末页</a></li>--%>
<%--				</ul>--%>
<%--			</nav>--%>
<%--		</div>--%>

	</div>
<div style="height: 50px; position: relative;top: 30px;">
	<div id="activityPage"></div>

</div>
			
</body>
</html>