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
	<script>
		$(function (){

			if (window.top!=window){
				window.top.location=window.location;
			}
			//页面加载完毕后，将文本框中的内容清空
			$("#loginAccount").val("");
			//页面加载完毕后，自动获取用户名焦点
			$("#submittButton").focus();
			//66666
			$("#submittButton").click(function (){
				// alert("执行验证登录操作;")  //封装成方法
				login();
			})
			//为当前页面窗口绑定敲键盘的事件
			$(window).keydown(function (event){
				//event 可以取得敲下的键盘的字符
				//jsp原生的
				//alert(event.keyCode); 回车取得的码值是13
				//如果取得的码值是13，就执行登录操作
				if (event.keyCode == 13){
					// alert("执行验证登录操作;")//封装成方法
					login();
				}
			})
		})

		//为了避免涉及其他的元素或变量而造成未知的异常，即将普通的自定义方法写在$(function(){})外面
		function login(){
			//首先验证账号密码不为空
			var loginAccount = $.trim($("#loginAccount").val());
			var loginPassword = $.trim($("#loginPassword").val());
			//if没走，代表账号密码都填写了
			if (loginAccount=="" || loginPassword==""){
				$("#errorMsg").html("账号密码不能为空！");
				//如果账号密码为空，则强制终止该方法
				return false;
			}
			$.ajax({
				url:"settings/user/login.do",
				data:{
					//往后端传账号密码
					"loginAccount":loginAccount,
					"loginPassword":loginPassword
					//结尾没有分号
				},
				async:true,
				dataType:"json", //从后台接受的参数的类型  text  json
				type:"post",  //发送的请求的方式
				success:function (data){  //data为接受的数据
					if (data.success){
						window.location.href = "workbench/index.jsp";
					}else {
						$("#errorMsg").html(data.errorMessage);
					}
				},
				error:function (data){
					alert("error!")
				}
			})
		}


	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
<!--		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;&nbsp;</span></div>-->
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAccount">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPassword">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

<%--							//错误消息
--%>
							<span id="errorMsg" style="color: red"></span>
						
					</div>
					<button type="button"  id="submittButton" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>

					<%--		在form表单中，button即使不写submit，类型也默认为submis！！！
								若不想提交表单，则使用button覆盖submit即可

								自行决定触发哪种行为。
								--%>

				</div>
			</form>
		</div>
	</div>
</body>
</html>