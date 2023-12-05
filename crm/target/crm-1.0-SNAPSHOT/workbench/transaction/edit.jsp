<%@ page import="java.util.Set" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
	Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
	Set<String> set =  pMap.keySet();
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
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>


</head>
<body>
<script>
	var  json = {
		<%
            for (String key:set){
                String value = pMap.get(key);

        %>
		"<%=key%>" :<%=value%>,
		<%
        }
        %>
	};
	$(function (){


		getUserList();



		$("#saveButton").click(function (){

			 alert($("#edit-contactsName").val());
			$.ajax({
				url:"workbench/transaction/edit.do",
				data:{
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"contactSummary":$.trim($("#create-contactSummary").val()),
					"describe":$.trim($("#create-describe").val()),
					"contactsName":$.trim($("#edit-contactsName").val()),
					"activitySrc":$.trim($("#activityId").val()),
					"clueSource":$.trim($("#edit-clueSource").val()),
					"transactionType":$.trim($("#edit-transactionType").val()),
					"transactionStage":$.trim($("#edit-transactionStage").val()),
					"accountName":$.trim($("#edit-accountName").val()),
					"expectedClosingDate":$.trim($("#edit-expectedClosingDate").val()),
					"transactionName":$.trim($("#edit-transactionName").val()),
					"amountOfMoney":$.trim($("#edit-amountOfMoney").val()),
					"transactionOwner":$.trim($("#edit-transactionOwner").val()),
					"id":"${requestScope.tran.id}"


				},
				dataType:"json",
				type:"post",
				success:function (data){

					if (data.success){

						pageList(1,5);


					}



				}




			})



		})
		$("#edit-transactionStage").click(function (){
			var stage = $("#edit-transactionStage").val();

			var possibility = json[stage];

			//为可能性的文本框赋值
			$("#edit-possibility").val(possibility);

		})
		$("#submitActivityButton").click(function (){
			var $dx = $("input[name=activityCId]:checked");
			var id = $dx.val();
			$("#activityId").val($dx.val());
			var activityName = $("#"+id).html();
			$("#edit-activitySrc").val(activityName);

		})

		$("#aname").keydown(function (event){
			if (event.keyCode==13){

				$.ajax({
					url: "workbench/transaction/serchActivityList.do",
					data: {
						"activityName":$.trim($("#aname").val())
					},
					dataType: "json",
					type: "get",
					success: function (data) {

						if (data.success){

							var html = "";

							$.each(data.activityList,function (i,n){

								html += '<tr>;'
								html += '<td><input type="radio" name="activityCId" value="'+n.id+'"/></td>;'
								html += '<td id="'+n.id+'">'+n.name+'</td>;'
								html += '<td>'+n.startDate+'</td>;'
								html += '<td>'+n.endDate+'</td>;'
								html += '<td>'+n.owner+'</td>;'
								html += '</tr>;'
							})
							$("#activityBody").html(html);

						}
					}
				})

				return false;
			}

		})

		$("#serch-contactsNameModal").keydown(function (event){

			if (event.keyCode == 13){
				var contactsName = $("#serch-contactsNameModal").val();
				// alert(contactsName);

				$.ajax({
					url: "workbench/transaction/getContactsName.do",
					data: {
						"name":contactsName
					},
					dataType: "json",
					type: "post",
					success: function (data) {

						/*
                        {"contactsList":{1},{2},{3}}

                         */
						var html ="";
						$.each(data,function (i,n){

							html += '<tr>;'
							html += '<td><input type="radio" name="contactsSelect" value="'+n.id+'"/></td>;'
							html += '<td id="'+n.id+'">'+n.fullname+'</td>;'
							html += '<td>'+n.email+'</td>;'
							html += '<td>'+n.mphone+'</td>;'
							html += '</tr>;'
						})
						$("#serch-contactsNameBody").html(html);


					}
				})

				return false;
			}


		}) //搜索方法结束

		$("#submitContactsButton").click(function (){
			var $dx = $("input[name=contactsSelect]:checked");
			var id = $dx.val();
			$("#contactsId").val($dx.val());
			var contactsName = $("#"+id).html();
			$("#edit-contactsName").val(contactsName);
		})


	})
	$(".time").datetimepicker({
		minView: "month",
		language:  'zh-CN',
		format: 'yyyy-mm-dd',
		autoclose: true,
		todayBtn: true,
		pickerPosition: "bottom-left"
	});

	function  getUserList(){

		$.ajax({
			url: "workbench/transaction/getUserList.do",
			data: {},
			dataType: "json",
			type: "get",
			success: function (data) {

				var  html = "<option></option>";
				$.each(data,function (i,n){
					html += "<option value='"+n.id+"'>"+n.name+"</option>";
				})
				$("#edit-transactionOwner").html(html);
				var id ="${sessionScope.user.id}";

				$("#edit-transactionOwner").val(id);

			}
		})



	}
</script>
	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control"  id="aname" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityBody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="submitActivityButton">提交</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control"  id="serch-contactsNameModal"  style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">

						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="serch-contactsNameBody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>李四</td>--%>
<%--								<td>lisi@bjpowernode.com</td>--%>
<%--								<td>12345678901</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>李四</td>--%>
<%--								<td>lisi@bjpowernode.com</td>--%>
<%--								<td>12345678901</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="submitContactsButton">提交</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="saveButton" class="btn btn-primary">更新</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionOwner">
<%--				  <option selected>zhangsan</option>--%>
<%--				  <option>lisi</option>--%>
<%--				  <option>wangwu</option>--%>
				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-amountOfMoney" value="${tran.money}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-transactionName" value="${tran.name}">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label time">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="date" class="form-control" id="edit-expectedClosingDate" value="${tran.expectedDate}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-accountName" value="${tran.customerId}" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-transactionStage" >
			  	<option>${tran.stage}</option>
				  <c:forEach items="${applicationScope.stage}" var="stage">
					  <option value="${stage.value}">${stage.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionType">
				  <option>${tran.type}</option>
					<c:forEach items="${applicationScope.transactionType}" var="type">
						<option value="${type.value}">${type.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility"  >
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-clueSource">
				  <option>${tran.source}</option>
				  <c:forEach items="${applicationScope.source}" var="source">
					  <option value="${source.value}">${source.text}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="edit-activitySrc" class="col-sm-2 control-label" id="serchActivitySrouce">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-activitySrc" value="${tran.activityId}">
				<input type="hidden" id="activityId" name="activityId">

			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-contactsName" value="${tran.contactsId}">
				<input type="hidden" id="contactsId" name="contactsId">

			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe">${tran.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary">${tran.contactSummary}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="date" class="form-control time" id="create-nextContactTime" value="${tran.nextContactTime}">
			</div>
		</div>
		
	</form>
</body>
</html>