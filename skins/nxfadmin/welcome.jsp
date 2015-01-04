<%@include file="include/lib.jsp"%>
<%
// Create data access object.
UserTestDao dao = new UserTestDao();
String user = dao.find_user(request.getRemoteAddr());

// Get welcome-page.
BlockPageDao bp_dao = new BlockPageDao();
BlockPageData data = bp_dao.select_one_local();
String welcome_page = data.welcome_page;

// Replace template params.
welcome_page = welcome_page.replaceAll("#\\{user\\}", user);

out.print(welcome_page);
%>