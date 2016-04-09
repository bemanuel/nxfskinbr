<%@include file="include/lib.jsp"%>
<%
// See if it's from Chrome agent.
String domain = param_str("domain");
if(is_empty(domain)){
	out.print("");
	return;
}

// Create data access object.
BlockDao dao = new BlockDao(request);

// Now we set reason and etc..
dao.set_reason(domain);

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
