<%@include file="include/lib.jsp"%>
<%
//-----------------------------------------------
// Create data access object.
UserLoginDao dao = new UserLoginDao(request);

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("logout")){
	dao.logout();
}
if(action_flag.equals("login")){
	if(dao.login(param_str("uname"), param_str("passwd"))){
		response.sendRedirect("welcome.jsp");
		return;
	}
	else{
	    out.println("<h1 align=\"center\" style=\"color:red\">LOGIN ERROR!</h1>");
		err_list.add("Login error!");
	}
}

// Get login-page.
BlockPageDao bp_dao = new BlockPageDao();
BlockPageData data = bp_dao.select_one_local();
out.print(data.login_page);

%>