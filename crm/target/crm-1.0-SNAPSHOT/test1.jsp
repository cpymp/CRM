<%--
  Created by IntelliJ IDEA.
  User: 666
  Date: 2023/11/21
  Time: 10:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%><base href="<%=basePath%>">

<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>

</head>
<body>
<script>

    owner
    source
    customerName
    fullname
    appellation
    email
    mphone
    job
    birth
    description
    contactSummary1
    nextContactTime1
    address


    edit-source
    edit-name
    edit-appellation
    edit-job
    edit-mphone
    edit-email
    edit-birth
    edit-customerName
    edit-description
    edit-contactSummary
    edit-nextContactTime
    edit-address

    <c:forEach items="${applicationScope.stage}" var="s">
    <option value="${s.value}">${s.text}</option>

    </c:forEach>

<c:forEach items="${applicationScope.source}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>

<c:forEach items="${applicationScope.transactionType}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </c:forEach>
<c:forEach items="${applicationScope.appellation}" var="a">
										<option value="${a.value}">${a.text}</option>







									</c:forEach>
    $.ajax({
        url: " ",
        data: {},
        dataType: "json",
        type: "get",
        success: function (data) {


        }
    })


    $(".time").datetimepicker({
        minView: "month",
        language:  'zh-CN',
        format: 'yyyy-mm-dd',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
    });


</script>










</body>
</html>
