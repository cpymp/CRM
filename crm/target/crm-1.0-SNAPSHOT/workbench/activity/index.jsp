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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<%--	这是日历控件核心   		 一定是先加载   jquery(主体)  才有 js 插件(扩展包)

--%>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>


<script type="text/javascript">

	$(function(){
		
		//为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addButton").click(function (){
			//bootstrap时间控件
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			/*
			操作模态窗口的方式:
				>找到需要操作的模态窗口的jquery对象，调用modal方法，为该方法传递参数，  show ：打开模态 hide：隐藏

			 */
			// alert("123"); 相当于打开模态窗口之前，进入服务器取出数据
			//走后台，为了取用户信息列表，为下拉列表框捕值
			$.ajax({
				url:"workbench/activity/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data){
					/*
						List<User> userList
						以json的形式打到前端
						data :[{用户1},{用户2},{用户3}]
					 */
					var exhobit = "<option></option>";
					$.each(data,function (i,n){
						exhobit += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-owner").html(exhobit);

					//将当前登录的用户的id设置为下拉框的默认选项
					var id = "${sessionScope.user.id}";
					$("#create-owner").val(id);
					//展现模态窗口
					$("#createActivityModal").modal("show");

				}
			})
		})

		//为保存按钮添加绑定时间，执行添加操作
		$("#saveButton").click(function (){
			$.ajax({
				url:"workbench/activity/save.do",
				data:{
					// id  不用传，生成UUID即可
					"owner":$.trim($("#create-owner").val()),
					"name":$.trim($("#create-name").val()),
					"startDate":$.trim($("#create-startDate").val()),
					"endDate":$.trim($("#create-endDate").val()),
					"cost":$.trim($("#create-cost").val()),
					"description":$.trim($("#create-description").val()),
					// createTime  后台处理
					// createBy  后台处理
					// editTime 修改的操作
					// editBy	修改的操作
				},
				type:"post",
				dataType:"json",
				success : function (data){
					/*
					data
						{"success":true/false}
					 */

					if (data.success){
					//添加成功后


					// 应该刷新列表页

					/*
						$("#activityAddForm").submit() 方法能提交表单

						通过id 拿到了form表单的jquery对象
						可以通过submit来提交表单
						但是该对象没有提供方法来重置表单。

						虽然该对象没有提供reset方法，但是原生的js提供了reset方法
						只需要将jquery对象转换为原生的dom对象

						jquery对象转换为dom对象，
							jquery对象[下标]  去得dom对象    从0开始数

						dom对象转换为jquery对象
						 $ {dom}
					 */
					//每次打开创建活动的模态窗口是将以前的记录清空
					// $("#activityAddForm")[0].reset();


					//关闭添加操作的模态窗口
						$("#createActivityModal").modal("hide");
					}else {
						alert("添加失败");
					}




				},error:function (){

				}
			})

		})
	//页面加载后触发一个方法 --->默认展开列表的第一页，每页展现两条记录
	pageList(1,5);  //①
	//为serchButton绑定单机事件，触发pageList方法
	$("#serchButton").click(function (){


		//查询前，将查询条件框中的数据保存到隐藏域中
		$("#hidden-name").val($.trim($("#serch-name").val()));
		$("#hidden-owner").val($.trim($("#serch-owner").val()));
		$("#hidden-startDate").val($.trim($("#serch-startDate").val()));
		$("#hidden-endDate").val($.trim($("#serch-endDate").val()));


		pageList(1 ,5); //点击查询触发的pageList ③
	})


	   //为选择框绑定事件,触发全选或全反选操作
		$("#selectAll").click(function (){

			$("input[name=ordinary-select]").prop("checked",this.checked);

		})


		//动态生成的元素，不能以普通绑定时间的形式进行操作
		/*
			动态生成的元素，需要以on方法的形式来触发时间
			$(需要绑定的元素).on(绑定事件的方式，需要绑定的元素的jquery对象，回调函数)
			需要有效的外层元素，动态生成的元素是无效的，需要往外层扩充
		 */
		$("#activityBody").on("click",$("input[name=ordinary-select]"),function (){
			$("#selectAll").prop("checked",$("input[name=ordinary-select]").length==$("input[name=ordinary-select]:checked").length);
		})

	});
	/*  pageList方法  ：自动发出一个ajax请求到后台，从后台取得最新的市场的活动信息列表数据
	    通过响应回来的数据，局部刷新市场活动信息列表
	    在哪些情况下，需要调用pageList方法？
	    ①点击市场活动选项的超链接       ②创建、删除、修改后，需要刷新市场活动列表
	    ③点击“查询”按钮的时候 		    ④点击 分页组件按钮的时候
	    以上为pageList方法指定了6个入口，在以上6个操作执行完毕后，必须调用pageList方法，刷新列表
	*/
	/*
		对于所有的关系型数据库，做前端的分页相关的操作的基础组件
		就是pageNo 和pageSize  ,不可或缺的，在前端主要操作这两个组件

	 */
	//pageNo 和pageSize是得发送到后台的条件
	function pageList(pageNo,pageSize){
		//查询前，将隐藏域中的条件取出重新赋值给查询条件
		$("#serch-name").val($.trim($("#hidden-name").val()));
		$("#serch-owner").val($.trim($("#hidden-owner").val()));
		$("#serch-startDate").val($.trim($("#hidden-startDate").val()));
		$("#serch-endDate").val($.trim($("#hidden-endDate").val()));



		$.ajax({
			url:"workbench/activity/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#serch-name").val()),
				"owner":$.trim($("#serch-owner").val()),
				"startDate":$.trim($("#serch-startDate").val()),
				"endDate":$.trim($("#serch-endDate").val())
			},
			dataType:"json",
			type:"get",
			success : function (data){
				/*
					data
						需要的
							[{市场活动列表},{市场活动列表}，{市场活动列表}，{市场活动列表}]
					分页插件 需要的： 查询出来的总记录数  total {"total":100}
					拼一个：  {"total":100,"dataList":[{市场活动列表},{市场活动列表}，{市场活动列表}，{市场活动列表}]}
					77 12min
				 */

				var html = "";
				$.each(data.dataList,function (i,n){


					   html += '<tr class="active">;'
					html += '<td><input type="checkbox" name="ordinary-select" value="'+n.id+'" /></td>;'  //复选框 需要一个值
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.jsp\';">'+n.name+'</a></td>;'
					html += '<td>'+n.owner+'</td>;'      //该表中的owner　存的是用户表的主键　，是外键管理　ＵＵＩｄ  ，所以在后台需要此owner 查询出关联的用户
					html += '<td>'+n.startDate+'</td>;'
					html += '<td>'+n.endDate+'</td>;'
					   html += '</tr>;'

				})

				$("#activityBody").html(html);

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
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form  id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">

                                <input type="text" class="form-control" id="create-name">

                            </div>
						</div>
						
						<div class="form-group">

							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>

							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>

							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>

							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">

                                <input type="text" class="form-control" id="create-cost">

                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">

								<textarea class="form-control" rows="3" id="create-description"></textarea>

							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveButton">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表123123</h3>
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
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="serch-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="serch-endDate">
				    </div>
				  </div>
				<%--	若button 的类型是submit，则是传统请求发送到后台，会全局刷新页面，而非ajax --%>
				  <button type="button" id="serchButton" class="btn btn-default">查询按钮</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">

					<%--
							data=toggle = "modal":
								表示触发该按钮，将要打开一个模态窗口
							data-target="#createActivityModal":
								表示要打开哪个模态窗口，通过#id的形式找到该窗口

						现在是通过属性和属性值的方式写在了button元素中，用来打开模态窗口
						但是有一个问题：没有办法对按钮的功能进行扩充，因为写死了
									扩充：比如在打开模态窗口前，弹出一个aler("123").
						所以：对于触发模态窗口的操作，一定不要写死在元素当中
							 应当自己写js代码操控？？？？
 						data-toggle="modal" data-target="#createActivityModal
 						data-toggle="modal" data-target="#editActivityModal"
							--%>
				  <button type="button" class="btn btn-primary" id="addButton"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editButton" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
<%--					需要动态拼接trpd 例如动态拼接option，然后通过id找到此处，-%>
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>

				<%--	bootstrap 提供的分页组件		--%>
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>

			</div>
			
		</div>
		
	</div>
</body>
</html>