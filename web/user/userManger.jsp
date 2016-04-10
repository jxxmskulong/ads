<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<script src="js/jquery/jquery-1.11.1.min.js"></script>
<link href="${pageContext.request.contextPath }/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath }/css/bootstrap-datetimepicker.min.css"
	rel="stylesheet">
<link href="<%=path%>/common/css/global.css" rel="stylesheet" />
<link href="<%=path%>/common/css/public.css" rel="stylesheet" />
<script src="js/bootstrap/bootstrap.min.js"></script>
<script
	src="<%=basePath%>js/bootstrap/bootstrap-paginator.min.js"></script>
<script src="<%=basePath%>js/bootstrap/b3paginator.js"></script>
<style type="text/css">
   .errorInfo{color:red;display:none;}
</style>
<script type="text/javascript">
        var path='<%=basePath%>';
    $(document).ready(function(){
	   loadPage(1);
    });

	function loadPage(page) {
		var data = getParam(page);
		var url = path+"user/getUserList.do";
		$("#content").load(url,data,function(data){
		    initB3paginator();
		});
		
	}
	
	function getParam(currentPage){
	    var curp = 1;
	    var pageSize=2;
	    var userName = $("#name").val();
		var userType = $("#userType").val();
		if(userType==null||userType==""){
		userType =1;
		}
		if($("#pageSize").val()){
		    pageSize = $("#pageSize").val();
		}
		var totPage = $("#totPage").val();
		if(currentPage!=null&&currentPage!=''){
		   curp = currentPage;
		}else if($("#curPage").val()){
		   curp = $("#curPage").val();
		}
		var data = {
		   name:userName,
		   userType:userType,
		   currentPage:curp,
		   pageSize:pageSize,
		   totPage:totPage
		};
		return data;
	}
	//初始化分页
function initB3paginator(){
	var data = getParam();
	//基本分页
	b3Paginator('pagination', 10, data['currentPage'], data['pageSize'], data['totPage'], 
		function(event, originalEvent, type, page){
        	var goPage = 1;
        	if(type == "first") goPage = 1;
        	else if(type == "prev") goPage = parseInt(data['currentPage']) - 1;
        	else if(type == "next") goPage = parseInt(data['currentPage']) + 1;
        	else if(type == "last") goPage = data['totPage'];
        	else if(type == "page") goPage = page;
        	//页面跳转方法自行定义
        	loadPage(goPage);
    	}, function (type, page, current) {
        	return null;
    });
	$(".page-list").b3paginatorext({
    	onPageSizeChange:function(){loadPrList(1);},
    	pagesizeinput:"#pageSize",
    	pagesize:data['pageSize'],
    	totcount:data['totPage']
		});
}

function loadUserAddPage(){
   var url = path+"user/loadUserAdd.do";
   $("#well").load(url);
}



function checkUserNameExist(){
    var userName = $("#username").val();
     var url = path+"user/checkUserNameExsit.do";
    var data={userName:userName}
    var flag = true;
    $.ajax({
       type: 'POST',
       async:false,
       url:url,
       data:data,
       success:function(res){
       if(res=='0'){
          $("#usernameInfo").show();
          flag = false;
       }else{
          $("#usernameInfo").hide();
       }
       }
   });
   return flag;
}

function submitUserAdd(){
    var name= $("#name").val();
    if(name==null||name==""){
       $("#nameInfo").show();
       return;
    }else{
       $("#nameInfo").hide();
    }
    var userType=$("#userType").val();
    if(userType==null||userType==""){
       $("#typeInfo").show();
       return;
    }else{
       $("#typeInfo").hide();
    }
    var userName = $("#username").val();
    if(userName==null||userName==""){
       $("#usernameInfo").show();
       return;
    }else{
      $("#usernameInfo").hide();
    }
    var password = $("#password").val();
    if(password==null||password==""){
       $("#passwordInfo").show();
       return;
    }else{
      $("#passwordInfo").hide();
    }
    if(!checkUserNameExist()){
       return;
    }
    
    $("#userAddForm").submit();
}

function showUser(id){
   var url = path+"user/showUser.do";
    $("#well").load(url,{id:id});
}

function reback(){
   $("#loadManger").click();
}

</script>
</head>

<body class="index">
	<div class="container admin-container">
		<!-- 顶部内容 -->
		<header class="navbar navbar-inverse navbar-fixed-top docs-nav"
				role="banner">
			<jsp:include page="/common/include/header_mge.jsp">
				<jsp:param name="target" value="user" />
			</jsp:include>
		</header>

		<!-- 左侧菜单 -->
		<jsp:include page="/user/common_nav.jsp">
			<jsp:param name="target" value="user" />
		</jsp:include>

			<!-- 右侧内容 -->
			<div id="well" class="col-md-10">
				<div  class="well">
					<div class="form-inline well well-sm">
						<div class="form-group">
							<input id="name" type="text" class="form-control"
								placeholder="请输入姓名">
						</div>
						<div class="form-group">
							<select class="form-control" id="userType">
								<option value="">人员类型</option>
								<option value="1">管理员</option>
								<option value="2">销售人员</option>
							</select>
						</div>
						<span class="btn btn-primary" onclick="loadPage(1)">查询</span> 
						<span class="btn btn-primary" onclick="loadUserAddPage()">添加</span>
					</div>
				</div>
				<div id="content"></div>
			</div>
		</div>
	</div>
</body>
</html>
