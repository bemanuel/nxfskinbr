<%@include file="include/lib.jsp"%>
<%
// Create data access object.
BlockDao dao = new BlockDao(request);

// See if it's a request for a remote user policy.
String token = param_str("token");
boolean decode_flag = param_bool("decode_flag");
if(!is_empty(token)){
	out.print(dao.get_remote_user_policy(token, decode_flag));
	return;
}

// You can't access this page using localhost.
if(dao.is_invalid_request()){
	return;
}

// hack to add path for skins directory
//String fp = request.getServletPath();
//int sep = fp.lastIndexOf("/");
//out.println("Path : " + fp.substring(0, sep));

if(dao.is_logout_domain()){
    response.sendRedirect("http://" + dao.get_logout_domain() + "/login.jsp?action_flag=logout");
	//response.sendRedirect("http://" + dao.get_logout_domain() + fp.substring(0, sep) + "/login.jsp?action_flag=logout");
	return;
}

if(dao.is_login_required()){
    response.sendRedirect("http://" + dao.get_login_domain() + "/login.jsp");
	//response.sendRedirect("http://" + dao.get_login_domain() + fp.substring(0, sep) + "/login.jsp");
	return;
}

// Now we set reason and etc..
dao.set_reason();

// Deal with ad-remove.
// We can find out this one after we get the reason above.
if(dao.is_blank_block()){
	out.print("");
	return;
}

String domain = dao.get_domain();
String reason = dao.get_reason();
String user = dao.get_user();
String group = dao.get_group();
String policy = dao.get_policy();
String category = dao.get_category();

// Get block-page.
BlockPageDao bp_dao = new BlockPageDao();
BlockPageData data = bp_dao.select_one_local();
String block_page = data.block_page;

// Replace template params.
block_page = block_page.replaceAll("#\\{domain\\}", domain);
block_page = block_page.replaceAll("#\\{reason\\}", reason);
block_page = block_page.replaceAll("#\\{user\\}", user);
block_page = block_page.replaceAll("#\\{group\\}", group);
block_page = block_page.replaceAll("#\\{policy\\}", policy);
block_page = block_page.replaceAll("#\\{category\\}", category);

out.print(block_page);
%>
