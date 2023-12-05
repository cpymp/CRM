<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
		$("#saveButton").click(function (){
			$.ajax({
				url: "workbench/contacts/save.do",
				data: {
					"owner" : $.trim($("#create-owner").val()),
					"source" : $.trim($("#create-source").val()),
					"customerName" : $.trim($("#create-customerName").val()),
					"fullname" : $.trim($("#create-fullname").val()),
					"appellation" : $.trim($("#create-appellation").val()),
					"email" : $.trim($("#create-email").val()),
					"mphone" : $.trim($("#create-mphone").val()),
					"job" : $.trim($("#create-job").val()),
					"birth" : $.trim($("#create-birth").val()),
					"description" : $.trim($("#create-description").val()),
					"contactSummary" : $.trim($("#create-contactSummary1").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime1").val()),
					"address" : $.trim($("#create-address1").val()),
				},
				dataType: "json",
				type: "post",
				success: function (data) {

			if (data.success){
				pageList(1,15);
			}
				}
			})

		})
		$("#createButton").click(function (){
			$.ajax({
				url: "workbench/contacts/getUserList.do",
				data: {},
				dataType: "json",
				type: "get",
				success: function (data) {
				var html = "";
				$.each(data,function (i,n){
					html += "<option value='"+n.id+"'>"+n.name+"</option>"
				})
				$("#create-owner").html(html);
				var id = "${sessionScope.user.id}"
				$("#create-owner").val(id);

				$("#createContactsModal").modal("show");
				}
			})

		})
	$("#serchButton").click(function (){
		pageList($("#activityPage").bs_pagination('getOption','currentPage'),
				$("#activityPage").bs_pagination('getOption','rowsPerPage'));
	})
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		pageList(1,10);


		$("#editButton").click(function (){
			var editOrdinarySelect = $("input[name=listSelect]:checked");
			var editId = editOrdinarySelect.val();
			if(editOrdinarySelect.length == 0 ){
				alert("请选择需要修改的客户记录！")
				return false;
			}else if (editOrdinarySelect.length > 1){
				alert("同时只能修改1条记录！")
				return  false;
			}
			$.ajax({
				url:"workbench/contacts/getUserListAndContactsInfo.do",
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

						$("#edit-owner").html(html);
						$("#edit-owner").val(data.contactsInfo.owner);

						// $("#edit-customerOwner").val(data.customerInfo.owner);
						// $("#edit-customerName").val(data.customerInfo.name);
						// $("#edit-website").val(data.customerInfo.website);
						// $("#edit-phone").val(data.customerInfo.phone);
						// $("#edit-description").val(data.customerInfo.description);
						// $("#edit-contactSummary").val(data.customerInfo.contactSummary);
						// $("#edit-nextContactTime").val(data.customerInfo.nextContactTime);
						// $("#edit-address").val(data.customerInfo.address);
						// $("#editCustomerModal").modal("show");
						$("#edit-source").val(data.contactsInfo.source);
						$("#edit-name").val(data.contactsInfo.fullname);
						$("#edit-appellation").val(data.contactsInfo.appellation);
						$("#edit-job").val(data.contactsInfo.job);
						$("#edit-mphone").val(data.contactsInfo.mphone);
						$("#edit-email").val(data.contactsInfo.email);
						$("#edit-birth").val(data.contactsInfo.birth);
						$("#edit-customerName").val(data.contactsInfo.customerId);
						$("#edit-description").val(data.contactsInfo.description);
						$("#edit-contactSummary").val(data.contactsInfo.contactSummary);
						$("#edit-nextContactTime").val(data.contactsInfo.nextContactTime);
						$("#edit-address").val(data.contactsInfo.address);

						$("#editContactsModal").modal("show");

					}

				}

			})

		})

		$("#editSaveButton").click(function (){

			var editOrdinarySelect = $("input[name=listSelect]:checked");
			var editId = editOrdinarySelect.val();
			//将输入框中的内容提交给后台进行更新

			$.ajax({

				url:"workbench/contacts/update.do",
				dataType:"json",
				type:"get",

				data:{
			"id":editId,
			"source":$.trim($("#edit-source").val()),
			"name":$.trim($("#edit-name").val()),
			"appellation":$.trim($("#edit-appellation").val()),
			"job":$.trim($("#edit-job").val()),
			"mphone":$.trim($("#edit-mphone").val()),
			"email":$.trim($("#edit-email").val()),
			"birth":$.trim($("#edit-birth").val()),
			"customerName":$.trim($("#edit-customerName").val()),
			"description":$.trim($("#edit-description").val()),
			"contactSummary":$.trim($("#edit-contactSummary").val()),
			"nextContactTime":$.trim($("#edit-nextContactTime").val()),
			"address":$.trim($("#edit-address").val()),
					"owner":$.trim($("#edit-owner").val())
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

		$("#deleteButton").click(function (){

			//获取要删除的id
			var editSelect = $("input[name=listSelect]:checked");
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
				url:"workbench/contacts/delete.do",
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
			url:"workbench/contacts/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#serch-name").val()),
				"owner":$.trim($("#serch-owner").val()),
				"customerName":$.trim($("#serch-customerName").val()),
				"clueSource":$.trim($("#serch-clueSource").val()),
				"birth":$.trim($("#serch-birth").val())
			},
			type:"get",
			dataType:"json",
			success:function (data){
				/*
					data :
							[{联系人1},{联系人2,}...]
							["total":100/200/10/20]
					拼接在一起
							["total":100,"contactsList":[{客户活动1},{客户活动2}]]
				 */

				var html = "";
				$.each(data.contactsList,function(i,n){
				html += '<tr>;'
				html += '<td><input type="checkbox" name="listSelect" value="'+n.id+'"/></td>;'
				html += '<td><a style="text-decoration: none; cursor: pointer;" >'+n.fullname+'</a></td>;'
				html += '<td>'+n.customerId+'</td>;'
				html += '<td>'+n.owner+'</td>;'
				html += '<td>'+n.source+'</td>;'
				html += '<td>'+n.birth+'</td>;'
				html += '</tr>;'
				})
				$("#contactsListBody").html(html);


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
	}  //查询联系人， 有多个入口


</script>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>

								</select>
							</div>
							<label for="create-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${applicationScope.source}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
<%--								  <option>广告</option>--%>
<%--								  <option>推销电话</option>--%>
<%--								  <option>员工介绍</option>--%>
<%--								  <option>外部介绍</option>--%>
<%--								  <option>在线商场</option>--%>
<%--								  <option>合作伙伴</option>--%>
<%--								  <option>公开媒介</option>--%>
<%--								  <option>销售邮件</option>--%>
<%--								  <option>合作伙伴研讨会</option>--%>
<%--								  <option>内部研讨会</option>--%>
<%--								  <option>交易会</option>--%>
<%--								  <option>web下载</option>--%>
<%--								  <option>web调研</option>--%>
<%--								  <option>聊天</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<c:forEach items="${applicationScope.appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>

								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime1">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveButton" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
<%--								  <option selected>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${applicationScope.source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-name" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" value="李四">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<c:forEach items="${applicationScope.appellation}" var="a">
										<option value="${a.value}">${a.text}</option>

									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="哈哈啊">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button"  id="editSaveButton" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="serch-owner" >
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="serch-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="serch-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="serch-clueSource">
						  <option></option>
<%--						  <option>广告</option>--%>
<%--						  <option>推销电话</option>--%>
<%--						  <option>员工介绍</option>--%>
<%--						  <option>外部介绍</option>--%>
<%--						  <option>在线商场</option>--%>
<%--						  <option>合作伙伴</option>--%>
<%--						  <option>公开媒介</option>--%>
<%--						  <option>销售邮件</option>--%>
<%--						  <option>合作伙伴研讨会</option>--%>
<%--						  <option>内部研讨会</option>--%>
<%--						  <option>交易会</option>--%>
<%--						  <option>web下载</option>--%>
<%--						  <option>web调研</option>--%>
<%--						  <option>聊天</option>--%>
						  <c:forEach items="${applicationScope.source}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input class="form-control" type="date" id="serch-birth" >
				    </div>
				  </div>
				  
				  <button type="button" id="serchButton" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createButton"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default"  id="editButton"  ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteButton"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactsListBody">
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/contacts/detail.jsp';">李四</a></td>
							<td>哈哈啊</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/contacts/detail.jsp';">李四</a></td>
                            <td>哈哈啊</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>2000-10-10</td>
                        </tr>
					</tbody>
				</table>
			</div>
<%--
			<div style="height: 50px; position: relative;top: 10px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>
			--%>
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>

			</div>
		</div>
		
	</div>
</body>
</html>