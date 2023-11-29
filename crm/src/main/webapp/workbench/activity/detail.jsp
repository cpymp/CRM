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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});


        $("#saveButton").click(function (){
            var  isEmpty = $("#remark").val();
            if (isEmpty.length == 0){
                alert("备注不能为空！！！");
                return false;
            }
            // //点击保存后
            //
            // // alert("123");

            $.ajax({
                url:"workbench/activity/saveRemark.do",
                data:{
                    "activityId":"${activity.id}",
                    "noteContent":$.trim($("#remark").val())
                },
                type:"post",
                dataType:"json",
                success:function (data){

                    $("#remark").val("");

                    /*
                            data
                                   {"success":true,"activityRemark":{备注}}

                     */
                    var html  = "";
                    //添加成功后，在每一个后面追加一个div
                    html += '<div  id="'+data.activityRemark.id+'" class="remarkDiv" style="height: 60px;">';
                    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5 id="e'+data.activityRemark.id+'">'+data.activityRemark.noteContent+'</h5>';
                    //																		双引号内 EL直接调用即可								  创建时间、修改时间   | 创建人、修改人 使用三元运算符
                    html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+data.activityRemark.createTime+' 由'+data.activityRemark.createBy+'</small>';
                    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                    html += '<a   onclick="editRemark(\''+data.activityRemark.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size : 20px; color: #FF0000;"></span></a>';
                    html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    //javascript:void(0):将超链接禁用，只能以触发事件的形式来操作
                    //在遍历（动态）出来的元素中，永远都是直接触发事件，而且必须套在字符串之间   onclick="deleteRemark()"
                    //但是直接触发方法需要将 被删除记录的id一起传进去，也需要拼接字符  难点！！！
                    html += '<a  onclick="deleteRemark(\''+data.activityRemark.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove-sign" style="font-size: 20px; color: #FF0000;"></span></a>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';

                    $("#remarkDiv").before(html);

                }
            })

        }) // 保存按钮方法结束


        //为更新按钮绑定事件  -- 绑定事件必须写在 function里面
        $("#updateRemarkButton").click(function (){

                var id = $("#remarkId").val();
                var noteContent = $("#noteContent").val();

                if (noteContent.length == 0){
                    alert("备注不能为空！！")
                    return false;
                }
            $.ajax({
                url:"workbench/activity/updateRemark.do",
                data:{
                    "id":id,
                    "noteContent":noteContent
                },
                type:"get",
                dataType:"json",
                success:function (data){

                    /*
                                data:
                                    {"success":true/false},{"activityRemark":{备注}}

                     */

                    if (data.success){

                        //后台更新成功之后，需要把div中的内容也更新，包括文本内容，编辑时间，编辑人
                        $("#e"+id).html(data.activity.noteContent);
                        $("#s"+id).html(data.activity.editTime+"由"+data.activity.editBy);
                        $("#editRemarkModal").modal("hide");

                    }else {

                        alert("更新失败");
                    }



                }




            })


        })






	});


	//页面加载完毕后，刷新该条活动的备注列表
    showRemarkList();
	// $(function(){
    //
	//
    //
	// });

	function showRemarkList(){
		$.ajax({
			url:"workbench/activity/getRemarkListByActivityId.do",
			data:{
				//因为页面加载时已经将Activity对象放进了request域中 ， 所以直接使用EL表达式即可Expression Language
				//但是，因为是在javaScript中，el表达式需要使用“” 双引号括起来
				"activityId":"${activity.id}"
			},
			type:"get", //取值
			dataType:"json",

			success:function (data){
				/*
						data
							[{备注1},{备注2}]
							下列each中的每一个 n 都是每一个市场活动的对象 {备注1}
							noteContent
				 */
				var html = "";
				$.each(data,function (i,n){
					<!-- 备注1   因为里面有大量的双引号，所以用单引号来拼接-->
                    //删除一条备注后，根据id来删除指定的div实现局部刷新
					html += '<div  id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
					html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
					//																		双引号内 EL直接调用即可								  创建时间、修改时间   | 创建人、修改人 使用三元运算符
					html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a  onclick="editRemark(\''+n.id+'\')" class="myHref" href="javascript:void(0);" ><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    //javascript:void(0):将超链接禁用，只能以触发时间的形式来操作
                    //在遍历（动态）出来的元素中，永远都是直接触发事件，而且必须套在字符串之间   onclick="deleteRemark()"
                    //但是直接触发方法需要将 被删除记录的id一起传进去，也需要拼接字符  难点！！！
					html += '<a  onclick="deleteRemark(\''+n.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove-sign" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';

				})
				// $("#activityRemarkBody").html(html);
				$("#remarkDiv").before(html);

                $("#remarkBody").on("mouseover",".remarkDiv",function(){
                    $(this).children("div").children("div").show();
                });
                $("#remarkBody").on("mouseout",".remarkDiv",function(){
                    $(this).children("div").children("div").hide();
                })


            },error:function (data){

			}

		}); //ajax方法结束

	}

    function deleteRemark(id){
        $.ajax({
            url:"workbench/activity/deleteRemarkById.do",
            data:{"id":id},
            type: "get",
            dataType:"json" ,
            success:function (data){

                /*
                        ["success":false/true]
                 */
                if (data.success){
                    //showRemarkList()这种方法不行，越删越"多"！
                    // showRemarkList();
                    $("#" +id).remove();
                }else {
                    alert("删除失败");
                }
            },error:function (data){
                alert("未知错误")
            }
        }) //删除ajax方法结
    }

    function editRemark(id){
        //将模态窗口中隐藏域中的id赋值，
        $("#remarkId").val(id);
        //根据id获取文本域的内容 既找到指定的的备注信息的h5标签
        var noteContent = $("#e"+id).html();
        var test = $("#remarkId").val();


        $("#noteContent").val(noteContent);
        // alert(test);
        $("#editRemarkModal").modal("show");



    }
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkButton">更新</button>
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
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
<%--					市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等--%>
	${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div  id="remarkBody" style="position: relative; top: 30px; left: 40px;">

		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
		<div id="activityRemarkBody"></div>
		<!-- 备注2 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveButton">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>