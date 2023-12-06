<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
	<script type="text/javascript" src="jquery/Bootstrap-3-Typeahead-master/bootstrap3-typeahead.min.js"></script>


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
	//Object object   最后的逗号，会被自动屏蔽
	// alert(json);
		$(function (){
			//为阶段的下拉框，绑定选中下拉框的事件，工具选中你的阶段填写可能性
			$("#create-transactionStage").click(function (){

				//取得选中的阶段
				var stage = $("#create-transactionStage").val();
				/*
					目标：填写可能性

					阶段有了stage
					阶段和可能性之间的对应关系pMap,但是pMap是java中的map对象，在JavaScript中用不了
					》将pMap装换为js中的键值对关系 --json

				以上已经将json处理完毕
				 */
				/*
					以json.key的形式，不能取得value，因为stage 是一个可变的变量
					动态的key，则不能以传统的json.key的方式取值，
					使用的取值方式，为 json[key] 类似数组
				 */
				var possibility = json[stage];
				// alert(possibility);
				//为可能性的文本框赋值
				$("#create-possibility").val(possibility);
			})
			//自动补全
			$("#create-accountName").typeahead({
				source: function (query, process) {
					$.post(
							"workbench/transaction/getCustomerName.do",
							{ "name" : query },
							function (data) {
								//alert(data);
								process(data);
							},
							"json"
					);
				},
				delay: 1500
			});

			//日历控件
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			$(".time2").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});


			$("#openActivityModal").click(function (){

				activityList();


			})

			$("#submitActivityButton").click(function (){
				var $dx = $("input[name=activityCId]:checked");
				var id = $dx.val();
				$("#activityId").val($dx.val());
				var activityName = $("#"+id).html();
				$("#create-activitySrc").val(activityName);

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
				$("#create-contactsName").val(contactsName);
			})

			$("#saveButton").click(function (){

				 $("#tranForm").submit();
			})
		})


		function activityList(){
			var serContext = $.trim($("#create-activitySrc").val());

			$.ajax({
				url: "workbench/transaction/showActivityList.do",
				data: {
					"activityName":serContext
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

		}
	</script>
</head>
<body>

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
						    <input type="text" class="form-control" style="width: 300px;"  id="aname" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button"  onclick="window.location.href='workbench/activity/detail.jsp';"    >取消</button>
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
						    <input type="text" class="form-control"  id="serch-contactsNameModal" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
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
							<tr>
							<td><input type="radio" name="activity"/></td>
							<td>李四</td>
							<td>lisi@bjpowernode.com</td>
							<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
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
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveButton">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form"  id="tranForm" action="workbench/transaction/save.do" method="post" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" name="owner">
				   <c:forEach items="${requestScope.userList}" var="u">
					   <option value="${u.id}" ${sessionScope.user.id eq u.id ? "selected":""}>${u.name}</option>
					<%--  EL表达式中也能使用三目运算符  --%>
				   </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-expectedClosingDate" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建" name="customerName">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage" name="stage">
			  	<option></option>
				  <c:forEach items="${applicationScope.stage}" var="s">
					<option value="${s.value}">${s.text}</option>

				  </c:forEach>
<%--			  	<option>资质审查</option>--%>
<%--			  	<option>需求分析</option>--%>
<%--			  	<option>价值建议</option>--%>
<%--			  	<option>确定决策者</option>--%>
<%--			  	<option>提案/报价</option>--%>
<%--			  	<option>谈判/复审</option>--%>
<%--			  	<option>成交</option>--%>
<%--			  	<option>丢失的线索</option>--%>
<%--			  	<option>因竞争丢失关闭</option>--%>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType" name="type">
				  <option></option>
					<c:forEach items="${applicationScope.transactionType}" var="t">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource" name="source">
				  <option></option>
					<c:forEach items="${applicationScope.source}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
<%--				  <option>广告</option>--%>
<%--				  <option>推销电话</option>--%>
<%--				  <option>员工介绍</option>--%>
<%--				  <option>外部介绍</option>--%>
<%--				  <option>在线商场</option>--%>
<%--				  <option>合作伙伴</option>--%>
<%--				  <option>公开媒介</option>--%>
<%--				  <option>销售邮件</option>--%>
<%--				  <option>合作伙伴研讨会</option>--%>
<%--				  <option>内部研讨会</option>--%>
<%--				  <option>交易会</option>--%>
<%--				  <option>web下载</option>--%>
<%--				  <option>web调研</option>--%>
<%--				  <option>聊天</option>--%>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity" id="openActivityModal"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activitySrc"   >
				<input type="hidden" id="activityId" name="activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" >
				<input type="hidden" id="contactsId" name="contactsId">

			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>