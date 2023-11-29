<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		//为创建按钮绑定事件 拿到所有者
		$("#create-customer").click(function (){
			// alert("123");

			//过后台，拿到所有者
			$.ajax({
				url:"workbench/customer/getUserList.do",
				type:"get",
				data:{},
				dataType:"json" ,
				success:function (data){
					/*
							data:
								["success":true,"userList":[{ulist1},{ulist2}]]
					 */

					if (data.success){

						var html = "<option></option>";
						$.each(data.uList,function (i,n){

							html +="<option value='"+n.id+"'>"+n.name+"</option>";
						})
						$("#create-customerOwner").html(html); //将后台返回的数据填入下拉框

						var currentOwner = "${sessionScope.user.id}";
						$("#create-customerOwner").val(currentOwner);
						$("#createCustomerModal").modal("show");
					}
				}


			})




		})
		//创建按钮方法结束
		//------------------------------------------------------//------------------------------------------------------
		//为保存按钮绑定事件
		$("#create-save").click(function (){
			// alert("123");
			//走后台，提交框框内的数据
			$.ajax({
				url:"workbench/customer/save.do",
				dataType:"json",
				type:"post",
				data:{
					"owner":$.trim($("#create-customerOwner").val()),
					"name":$.trim($("#create-customerName").val()),
					"website":$.trim($("#create-website").val()),
					"phone":$.trim($("#create-phone").val()),
					<%--"createBy":"${sessionScope.user.name}",--%> //创建人和创建时间后台获取
					<%--"createTime":$.trim($("#create-").val()),--%>
					// "editBy":$.trim($("#create-").val()),
					// "editTime":$.trim($("#create-").val()),
					"contactSummary":$.trim($("#create-contactSummary").val()),
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"description":$.trim($("#create-description").val()),
					"address":$.trim($("#create-address1").val())
				},
				success:function (data){

					/*
							data 需要什么？？
							["success":true]
					 */
					if (data.success){
						//添加成功后刷新客户列表
						pageList(1,
								5);
					}
				}

			})

		})
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		//为查询按钮绑定事件
		$("#serchButton").click(function (){

			pageList($("#activityPage").bs_pagination('getOption','currentPage'),
					$("#activityPage").bs_pagination('getOption','rowsPerPage'));

		})
		pageList(1, 5);


		$("#edit-customer").click(function (){

			var editOrdinarySelect = $("input[name=ordinary-select]:checked");
			var editId = editOrdinarySelect.val();
			if(editOrdinarySelect.length == 0 ){
				alert("请选择需要修改的客户记录！")
				return false;
			}else if (editOrdinarySelect.length > 1){
				alert("同时只能修改1条记录！")
				return  false;
			}

			$.ajax({
				url:"workbench/customer/getUserListAndCutomerInfo.do",
				data:{
					"id":editId
				},
				type:"get",
				dataType:"json",
				success:function (data){

					/*
							data:
								["UserList":[{张三},{张三2}，{张三3}]，“customerInfo”:{客户信息}]
					 */

					if (data.success){

						var html = "<option></option>";
						$.each(data.userList,function (i,n){

							html += "<option value='"+n.id+"'>"+n.name+"</option>";

						})
						alert(html);
						$("#edit-customerOwner").html(html);
						$("#edit-customerOwner").val(data.customerInfo.owner);
						$("#edit-customerName").val(data.customerInfo.name);
						$("#edit-website").val(data.customerInfo.website);
						$("#edit-phone").val(data.customerInfo.phone);
						$("#edit-description").val(data.customerInfo.description);
						$("#edit-contactSummary").val(data.customerInfo.contactSummary);
						$("#edit-nextContactTime").val(data.customerInfo.nextContactTime);
						$("#edit-address").val(data.customerInfo.address);
						$("#editCustomerModal").modal("show");
					}

				}

			})

		})

		$("#selectAll").click(function (){

			$("input[name=ordinary-select]").prop("checked",this.checked);

		})

		$("#edit-saveButton").click(function (){

			var editOrdinarySelect = $("input[name=ordinary-select]:checked");
			var editId = editOrdinarySelect.val();

			//将输入框中的内容提交给后台进行更新
				$.ajax({

					url:"workbench/customer/update.do",
					dataType:"json",
					type:"get",
					data:{
						"id":editId,
						"customerOwner":$("#edit-customerOwner").val(),
						"customerName":$("#edit-customerName").val(),
						"website":$("#edit-website").val(),
						"phone":$("#edit-phone").val(),
						"description":$("#edit-description").val(),
						"contactSummary":$("#edit-contactSummary").val(),
						"nextContactTime":$("#edit-nextContactTime").val(),
						"address":$("#edit-address").val()
					},
					success:function (data){

						/*
							data:
									["success":true]

						 */

						if (data.success){

							pageList($("#activityPage").bs_pagination('getOption','currentPage'),
									$("#activityPage").bs_pagination('getOption','rowsPerPage'));
						}
					}

				})

		})


		$("#edit-deleteButton").click(function (){

			//获取要删除的id
			var editSelect = $("input[name=ordinary-select]:checked");
			var editSelectNum = editSelect.length;
			if (editSelectNum == 0){
				alert("请选择需要删除的记录！");
				return false;
			}else {
				if (confirm("确定删除选中的客户记录吗？")){
				var deleteIds = "";

				for ( var i = 0 ; i < editSelectNum ;i++) {
					deleteIds += $(editSelect[i]).val();

					if (i != editSelectNum - 1) {
						deleteIds += "&";
					}
					}
				}
			}

			$.ajax({
				url:"workbench/customer/delete.do",
				data:{
					"deleteIds":deleteIds
				},
				dataType:"json",
				type:"get",
				success:function (data){

					if (data.success){
						alert("删除成功。")
						pageList($("#activityPage").bs_pagination('getOption','currentPage'),
								$("#activityPage").bs_pagination('getOption','rowsPerPage'));

					}

				}


			})


		})
	});


	function pageList(pageNo,pageSize){

		$.ajax({
			url:"workbench/customer/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#serch-name").val()),
				"phone":$.trim($("#serch-companyPhone").val()),
				"website":$.trim($("#serch-companyWebsite").val()),
				"owner":$.trim($("#serch-owner").val())
			},
			type:"get",
			dataType:"json",
			success:function (data){
				/*
					data :
							[{客户列表},{客户列表2,}...]
							["total":100/200/10/20]
					拼接在一起
							["total":100,"dataList":[{客户活动1},{客户活动2}]]
				 */

				var html = "";
				$.each(data.dataList,function(i,n){
						html += '<tr class="active">;'
						html += '<td><input  name="ordinary-select" type="checkbox" value="'+n.id+'"/></td>;'
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id='+n.id+'\';">'+n.name+'</a></td>;'
						html += '<td>'+n.owner+'</td>;'
						html += '<td>'+n.phone+'</td>;'
						html += '<td>'+n.website+'</td>;'
						html += '</tr>;'
				})
				$("#customerBody").html(html);


				var totalPages = data.total % pageSize == 0 ? data.total / pageSize: parseInt(data.total/pageSize)+1;


				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 10, // 每页最多显示的记录条数
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
	}  //查询客户， 有多个入口
	
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal" >关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="create-save">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName"  >
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="edit-saveButton">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="serch-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="serch-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="serch-companyPhone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="serch-companyWebsite">
				    </div>
				  </div>
				  
				  <button type="button" id="serchButton" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal" id="create-customer"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editCustomerModal" id="edit-customer"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="edit-deleteButton"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/customer/detail.jsp';">测试功能</a></td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>http://www.bjpowernode.com</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/customer/detail.jsp';">测试功能</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>http://www.bjpowernode.com</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>

			</div>
		</div>
	</div>
</body>
</html>