<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- uri 指定自定义标签库存放位置 prefix 指定标签库的前缀
	1）Core标签库是一个核心标签库，主要提供实现Web应用中通用操作的标签。例如，用于输出变量内容的<c:out>标签、用于条件判断的<c:if>标签等。
	--%>
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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		pageList(1,5);

		//获取后台用户列表信息
		$("#createBtn").click(function (){
			$.ajax({
				url:"workbench/clue/getUList.do",
				dataType:"json",
				type:"get",
				data:{},
				success:function (data){
					/*
                            data:		[{1}{2}{3}]
                     */
					var html = "<option></option>";

					$.each(data,function(i,n){

						html += "<option value='"+n.id+"'>"+n.name+"</option>";

					})
					//将用户信息列表添加到模态窗口
					$("#create-owner").html(html);
					var id = "${sessionScope.user.id}";
					// 设置默认拥有者选项为当前登录用户
					$("#create-owner").val(id);

					$("#createClueModal").modal("show");
					//设置

				}


			}) //createBtn 方法结束



			//打开模态窗口
		})
		//为保存按钮绑定单机事件
		$("#saveButton").click(function (){

				$.ajax({
					url:"workbench/clue/save.do",
					dataType:"json",
					type:"get",
					data:{
						"fullname":$.trim($("#create-fullname").val()),
						"appellation":$.trim($("#create-appellation").val()),
						"owner":$.trim($("#create-owner").val()),
						"company":$.trim($("#create-company").val()),
						"job":$.trim($("#create-job").val()),
						"email":$.trim($("#create-email").val()),
						"phone":$.trim($("#create-phone").val()),
						"website":$.trim($("#create-website").val()),
						"mphone":$.trim($("#create-mphone").val()),
						"state":$.trim($("#create-state").val()),
						"source":$.trim($("#create-source").val()),
						"description":$.trim($("#create-description").val()),
						"contactSummary":$.trim($("#create-contactSummary").val()),
						"nextContactTime":$.trim($("#create-nextContactTime").val()),
						"address":$.trim($("#create-address").val())
					},
					success:function (data){

						if (data.success){

							//创建成功后，调用pageList
							pageList(1,5);

						}else {
							alert("创建失败");
						}


					}


				})

		})
		//为查询按钮绑定事件
		$("#serchButton").click(function (){

			$("#serch-hiddenFullname").val($.trim($("#serch-fullname").val()));
			$("#serch-hiddenOwner").val($.trim($("#serch-owner").val()));
			$("#serch-hiddenCompany").val($.trim($("#serch-company").val()));
			$("#serch-hiddenPhone").val($.trim($("#serch-phone").val()));
			$("#serch-hiddenMphone").val($.trim($("#serch-mphone").val()));
			$("#serch-hiddenSource").val($.trim($("#serch-source").val()));
			$("#serch-hiddenClueState").val($.trim($("#serch-State").val()));
			pageList(1,5);
		})
		//为选择按钮绑定事件
		$("#selectAll").click(function (){

			 $("input[name=ordinary-select]").prop("checked",this.checked);
		})
		//为修改按钮绑定事件
		$("#editButton").click(function (){
			var selectNum = $("input[name=ordinary-select]:checked");
			alert(selectNum.length);
			var id = selectNum.val();
			$("#editId").html(id);
			if (selectNum.length > 1 || selectNum.length ==0){
				alert("只能同时修改1条线索！");
				return false;
			}

			$.ajax({
				url:"workbench/clue/getUserListAndClue.do",
				dataType:"json",
				type:"get",
				data:{
						"id":id
				},
				success:function (data){
					/*
							data:
									["userList":[{1}{2}{3}],"clue",{},"success":true]
					 */
					if (data.success){
						var u = "<option></option>";

						$.each(data.userList,function (i,n){

							u += "<option value='"+n.id+"'>"+n.name+"</option>"

						})
						$("#edit-owner").html(u);

								 $("#edit-fullname").val(data.clue.fullname);
								 $("#edit-appellation").val(data.clue.appellation);
								 $("#edit-company").val(data.clue.company);
								 $("#edit-job").val(data.clue.job);
								 $("#edit-email").val(data.clue.email);
								 $("#edit-phone").val(data.clue.phone);
								 $("#edit-website").val(data.clue.website);
								 $("#edit-mphone").val(data.clue.mphone);
								 $("#edit-state").val(data.clue.state);
								 $("#edit-source").val(data.clue.source);
								 $("#edit-description").val(data.clue.description);
								 $("#edit-contactSummary").val(data.clue.contactSummary);
								 $("#edit-nextContactTime").val(data.clue.nextContactTime);
								 $("#edit-address").val(data.clue.address);
								 $("#edit-owner").val(data.clue.owner);
								$("#editClueModal").modal("show");

								// $.trim($("#edit-owner").val(data.clue));
					}
				}

			})
		})
		//为保存按钮绑定事件
		$("#updateButton").click(function (){
			var updateId = ($("#editId").html());

			$.ajax({
				url:"workbench/clue/update.do",
				dataType:"json",
				type:"get",
				data:{
						"id":updateId,
					"fullname":$("#edit-fullname").val(),
					"appellation":$("#edit-appellation").val(),
					"company":$("#edit-company").val(),
					"job":$("#edit-job").val(),
					"email":$("#edit-email").val(),
					"phone":$("#edit-phone").val(),
					"website":$("#edit-website").val(),
					"mphone":$("#edit-mphone").val(),
					"state":$("#edit-state").val(),
					"source":$("#edit-source").val(),
					"description":$("#edit-description").val(),
					"contactSummary":$("#edit-contactSummary").val(),
					"nextContactTime":$("#edit-nextContactTime").val(),
					"address":$("#edit-address").val(),
					"owner":$("#edit-owner").val()
				},
				success:function (data){
					/*
							data:
									["success":true]
					 */

					if(data.success){

						pageList(1,5);
					}else {
						alert("添加失败");
					}

				}

			})
		})
		//为删除按钮绑定事件
		$("#deleteButton").click(function (){

			// var deleteId = $("#editId").html();
			 var deleteID = "";
			 var deleteSelect = $("input[name=ordinary-select]:checked");

			 if (deleteSelect.length == 0){

				 alert("请选择需要删除的线索！")
				 return false;
			 }else {
				 if (confirm("确认删除选中的线索吗？")){
					 for (var i = 0 ; i < deleteSelect.length;i++){

						 deleteID += $(deleteSelect[i]).val();

						 if (i != deleteSelect.length -1){
							 deleteID += "&";
						 }
					 }

					 $.ajax({
						 url:"workbench/clue/delete.do",
						 dataType:"json",
						 sync:true,
						 data:{
							 	"id":deleteID
						 },
						 type:"get",
						 success:function (data){
							 if (data.success){
								 alert("删除成功.");
								 pageList(1,5);
							 }else {
								 alert("删除失败");
							 }
						 }
					 })
				 } else {
					 return  false;
				 }
			 }

		})

	});

	function pageList(pageNum,pageSize){

		$("#serch-fullname").val($.trim($("#serch-hiddenFullname").val()));
		$("#serch-owner").val($.trim($("#serch-hiddenOwner").val()));
		$("#serch-company").val($.trim($("#serch-hiddenCompany").val()));
		$("#serch-phone").val($.trim($("#serch-hiddenPhone").val()));
		$("#serch-mphone").val($.trim($("#serch-hiddenMphone").val()));
		$("#serch-source").val($.trim($("#serch-hiddenSource").val()));
		$("#serch-State").val($.trim($("#serch-hiddenClueState").val()));

		//获取需要查询的数据，提交给后台查询。
		// alert("123");
		$.ajax({
			url:"workbench/clue/pageList.do",
			dataType:"json",
			data:{
				//需要提交的数据
				"pageNum" : pageNum,
				"pageSize" : pageSize,
				"fullname":$.trim($("#serch-fullname").val()),
				"owner":$.trim($("#serch-owner").val()),
				"company":$.trim($("#serch-company").val()),
				"phone":$.trim($("#serch-phone").val()),
				"mphone":$.trim($("#serch-mphone").val()),
				"source":$.trim($("#serch-source").val()),
				"clueState":$.trim($("#serch-State").val()),
			},
			type:"get",
			success:function (data){

				if (data.success){

					//查找成功后，根据返回的clueList 遍历并拼接出展示内容
					/*
							data:
								["success",true, "clueList":[{1}{2}{3}]]
					 */
					var clues = "";
					$.each(data.clueList,function (i,n){
						clues += '<tr class="active">';
						clues += '<td><input type="checkbox" value="'+n.id+'"  name="ordinary-select" /></td>';
						clues += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+n.id+'\';">'+n.fullname+'</a></td>';
						clues += '<td>'+n.company+'</td>';
						clues += '<td>'+n.phone+'</td>';
						clues += '<td>'+n.mphone+'</td>';
						clues += '<td>'+n.source+'</td>';
						clues += '<td>'+n.owner+'</td>';
						clues += '<td>'+n.state+'</td>';
						clues += '</tr>';
					})
					$("#clueTBody").html(clues);
					var totalPages = data.total % pageSize == 0? data.total / pageSize:parseInt(data.total/pageSize)+1;

					$("#activityPage").bs_pagination({
						currentPage: pageNum, // 页码
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

				}else {

					alert("查询失败");

				}

			}
		})


	}

</script>
</head>
<body>

	<input type="hidden" id="serch-hiddenFullname">
	<input type="hidden" id="serch-hiddenOwner">
	<input type="hidden" id="serch-hiddenCompany">
	<input type="hidden" id="serch-hiddenPhone">
	<input type="hidden" id="serch-hiddenMphone">
	<input type="hidden" id="serch-hiddenSource">
	<input type="hidden" id="serch-hiddenClueState">

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								   <c:forEach items="${applicationScope.appellation}" var="a">
									   <option value="${a.value}">${a.text}</option>
								   </c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
									<c:forEach items="${applicationScope.clueState}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${applicationScope.source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
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
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="saveButton">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<input type="hidden" id="editId">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company"  >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job"  >
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" >
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
									<c:forEach items="${applicationScope.clueState}" var="y">
										<option value="${y.value}">${y.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
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
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
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
									<input type="text" class="form-control time" id="edit-nextContactTime" >
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal"  id="updateButton">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="serch-fullname" >
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="serch-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="serch-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="serch-source">
					  	  <option></option>
					  	 <c:forEach items="${applicationScope.source}" var="s">
							 <option value="${s.value}">${s.text}</option>
						 </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="serch-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="serch-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="serch-State">
					  	<option></option> <!-- ClueState  -->
					  	<c:forEach items="${applicationScope.clueState}" var="s">
							<option value="${s.value}">${s.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="serchButton">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary"   id="createBtn" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editButton"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteButton"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueTBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>--%>
<%--                            <td>动力节点</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>12345678901</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>已联系</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>

			</div>

			<div style="height: 50px; position: relative;top: 60px;">
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

		</div>
		
	</div>
</body>
</html>