<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
		$("#editButton").click(function (){

			var $xz = $("input[name=select-tran]:checked");
	 		if ($xz.length >1 || $xz.length == 0 ){
				 alert("只能且必须勾选1条记录进行修改！");
				 return false;
			}
			var id = $xz.val();

			 window.location.href='workbench/transaction/getTran.do?id='+id+'';
			// $.ajax({
			// 	url: "workbench/transaction/getTranId.do",
			// 	data: {"id":id},
			// 	dataType: "json",
			// 	type: "get",
			// 	success: function (data) {
			// 	if (data.success){
			//
			// 	}
			//
			//
			// 	}
			// })




		})
	    $("#serchButton").click(function (){

			pageList(1,20);//pageList 的六个入口之一  删除成功后  ④

		})
		$("#deleteButton").click(function (){

			var deleteNum = $("input[name=select-tran]:checked");
			var name ="${sessionScope.user.name}";
			if (deleteNum.length == 0){
				alert("请选择需要删除的交易");
				return false;
			}else if (name != 'admin'){
				alert("非管理员不能删除！");
				return false;
			}
			var deleteIds = "";
			for (var i = 0 ; i <　deleteNum.length;i++){
				deleteIds += $(deleteNum[i]).val();
				 if(i != deleteNum.length -1){
					 deleteIds += "&";
				 }
			}

		 if (confirm("确认删除交易记录？")){
			 	if (confirm("确认删除交易记录？")){

					$.ajax({
						url: "workbench/transaction/delete.do",
						data: {
							"deleteIds":deleteIds
						},
						dataType: "json",
						type: "get",
						success: function (data) {


							pageList(1,20);

						}
					})


				}
		 }




		})

		pageList(1,20);//pageList 的六个入口之一  删除成功后  ④

	});

	function pageList(pageNo,pageSize){

		$.ajax({
			url: "workbench/transaction/pageList.do",
			data: {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"customerName":$.trim($("#customerName").val()),
				"stage":$.trim($("#stage").val()),
				"contactsName":$.trim($("#contactsName").val()),
				"source":$.trim($("#source").val()),
				"type":$.trim($("#type").val()),
				"name":$.trim($("#name").val()),
				"owner":$.trim($("#owner").val())
			},
			dataType: "json",
			type: "post",
			success: function (data) {
				var html = "";

			$.each(data.transList,function (i,n){

				html += '<tr>;'
				html += '<td><input type="checkbox" name="select-tran" value="'+n.id+'" /></td>;'
				html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+n.id+'\';">'+n.customerId+'-'+n.name+'</a></td>;'
				html += '<td>'+n.customerId+'</td>;'
				html += '<td>'+n.stage+'</td>;'
				html += '<td>'+n.type+'</td>;'
				html += '<td>'+n.owner+'</td>;'
				html += '<td>'+n.activityId+'</td>;'
				html += '<td>'+n.contactsId+'</td>;'
				html += '</tr>;'

			})
				$("#transBody").html(html);


				// var totalPages = data.total % pageSize == 0 ?  data.total / pageSize : parseInt(data.total/pageSize)+1;
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
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
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
				      <input class="form-control" type="text" id="owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="stage">
					  	<option></option>
<%--					  	<option>资质审查</option>--%>
<%--					  	<option>需求分析</option>--%>
<%--					  	<option>价值建议</option>--%>
<%--					  	<option>确定决策者</option>--%>
<%--					  	<option>提案/报价</option>--%>
<%--					  	<option>谈判/复审</option>--%>
<%--					  	<option>成交</option>--%>
<%--					  	<option>丢失的线索</option>--%>
<%--					  	<option>因竞争丢失关闭</option>--%>
						  <c:forEach items="${applicationScope.stage}" var="s">
							  <option value="${s.value}">${s.text}</option>

						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="type">
					  	<option></option>
<%--					  	<option>已有业务</option>--%>
<%--					  	<option>新业务</option>--%>
						  <c:forEach items="${applicationScope.transactionType}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="source">
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
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="contactsName">
				    </div>
				  </div>
				  
				  <button type="button" id="serchButton" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">|
					<input type="hidden" id="editId" name="editId" >
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editButton" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteButton"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transBody">
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">哈哈啊-交易01</a></td>
							<td>哈哈啊</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">哈哈啊-交易01</a></td>
                            <td>哈哈啊</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>
					</tbody>
				</table>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>

			</div>
			
		</div>
		
	</div>
</body>
</html>