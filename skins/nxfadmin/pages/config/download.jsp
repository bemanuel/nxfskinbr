<%@page import="java.io.*,nxd.dao.*"%><%
String filename = request.getParameter("filename");

if(filename == null){
	out.println("Invalid filename!");
}
else{
	response.setContentType("application/octet-stream");
	response.setHeader("content-disposition","attachment; filename=\"" + filename + "\"");

	OutputStream outx = response.getOutputStream();
	FileInputStream fis = new FileInputStream(GlobalDao.get_www_tmp_path() + "/" + filename);
	int i = 0;
	while((i = fis.read()) != -1){
		outx.write(i);
	} 
	fis.close();
}
%>