<%@page trimDirectiveWhitespaces="true"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="nxd.lib.wLib"%>
<%@page import="nxd.lib.NxParam"%>
<%@page import="nxd.dao.*"%>
<%@page import="nxd.data.*"%>
<%!
//-----------------------------------------------
PageContext pc = null;
HttpServletRequest request = null;
HttpServletResponse response = null;
JspWriter out = null;

NxParam param = null;
PermissionData permission = null;
AdminLoginDao admin_login_dao = null;
LicenseDao license_dao = null;

List<String> err_list = null;
List<String> succ_list = null;
boolean demo_flag = false;

//-----------------------------------------------
void init_lib(PageContext pc){
	this.pc = pc;
	request = (HttpServletRequest)pc.getRequest();
	response = (HttpServletResponse)pc.getResponse();
	out = pc.getOut();

	param = new NxParam(request);
	permission = new PermissionData();
	admin_login_dao = new AdminLoginDao(request);
        license_dao= new LicenseDao(err_list);

	demo_flag = GlobalDao.get_demo_flag();
	err_list = new ArrayList<String>();
	succ_list = new ArrayList<String>();
}

//-----------------------------------------------
String param_str(String key){
	return param.get_str(key);
}

//-----------------------------------------------
String param_str(String key, String def_val){
	return param.get_str(key, def_val);
}

//-----------------------------------------------
int param_int(String key){
	return param.get_int(key);
}

//-----------------------------------------------
int param_int(String key, int default_value){
	return param.get_int(key, default_value);
}

//-----------------------------------------------
long param_long(String key){
	return param.get_long(key);
}

//-----------------------------------------------
boolean param_bool(String key){
	return param.get_bool(key);
}

//-----------------------------------------------
String[] param_arr(String key){
	try {
		return request.getParameterValues(key);
	} catch (Exception e) {
	}
	return null;
}

//-----------------------------------------------
String request_str(String key){
	String val = request.getParameter(key);
	return val == null ? "" : val;
}

//-----------------------------------------------
void printf(String fmt, Object... args){
	try{
		out.print(String.format(fmt, args));
	}
	catch(Exception e){}
}

//-----------------------------------------------
//@SuppressWarnings("cast")
static int get_page_count(int count, int list_size){
	if(count % list_size > 0) {
		return (int)(count / list_size) + 1;
	}
	return (int)(count / list_size);
}

//-----------------------------------------------
String get_pagination(int count, int list_size, int page){
	int page_count = get_page_count(count, list_size);

	// Get start page of current page group.
	int curr_start = 0;
	if(page % 10 == 0){
		curr_start = page - ((page - 1) % 10);
	}
	else{
		curr_start = page - (page % 10) + 1;
	}

	// Get previous link.
	int prev_start = 0;
	String prev_link = "";
	if(curr_start > 10){	// If there's previous page group.
		prev_start = curr_start - 10;
		prev_link = String.format("<a href='javascript:go_page(%s)'>prev</a> ", prev_start);
	}
	else{
		prev_link = "prev ";
	}

	// Get page link.
	String page_link = "";
	int i = curr_start;
	while(i < curr_start + 10 && i <= page_count){
		if(page == i){
			page_link += " <span class='nolink'>" + i + "</span> ";
		}
		else{
			page_link += String.format(" <a href='javascript:go_page(%s)'>%s</a> ", i, i);
		}
		i++;
	}

	// Get next link.
	int next_start = 0;
	String next_link = "";
	if(curr_start + 10 <= page_count){	// If there's next page group.
		next_start = curr_start + 10;
		next_link = String.format(" <a href='javascript:go_page(%s)'>next</a>", next_start);
	}
	else{
		next_link = " next";
	}

	// Print link.
	return prev_link + page_link + next_link;
}

//-----------------------------------------------
boolean is_slave(){
	ClusterDao dao = new ClusterDao();
	return dao.is_slave();
}

//-----------------------------------------------
boolean check_permission(){
	// Check permission.
	if(!admin_login_dao.has_permission(permission)){
		try{
			response.sendRedirect("/admin.jsp");
		}
		catch(Exception e){}
		return false;
	}

	// Check if it's a slave node.
	if(is_slave() && request.getRequestURI().indexOf("cluster.jsp") == -1){
		try{
			response.sendRedirect("pages/config/cluster.jsp");
		}
		catch(Exception e){}
		return false;
	}

	return true;
}

//-----------------------------------------------
boolean is_allowed_ip(){
	if(!admin_login_dao.has_permission(permission)){
		try{
			response.sendRedirect("admin.jsp");
		}
		catch(Exception e){}
		return false;
	}
	return true;
}

//-----------------------------------------------
// From wLib.
boolean is_empty(String s){
	return wLib.is_empty(s);
}

//-----------------------------------------------
boolean is_not_empty(String s){
	return wLib.is_not_empty(s);
}

//-----------------------------------------------
String null2str(Object o) {
	return wLib.null2str(o);
}

//-----------------------------------------------
String strftime(String fmt){
	return wLib.strftime(fmt);
}

//-----------------------------------------------
String strftime(String fmt, Date d){
	return wLib.strftime(fmt, d);
}

//-----------------------------------------------
String strftime_add(String fmt, int sec){
	return wLib.strftime_add(fmt, sec);
}

//-----------------------------------------------
String strftime_add(String fmt, String sdate, int sec){
	return wLib.strftime_add(fmt, sdate, sec);
}

//-----------------------------------------------
static String strftime_new_fmt(String fmt, String new_fmt, String sdate) {
	return wLib.strftime_new_fmt(fmt, new_fmt, sdate);
}

//-----------------------------------------------
String read_text_file(String filename) {
	return wLib.read_text_file(filename);
}

//-----------------------------------------------
boolean write_text_file(String filename, String line) {
	return wLib.write_text_file(filename, line);
}

//-----------------------------------------------
long ip2long(String ip) {
	return wLib.ip2long(ip);
}

//-----------------------------------------------
String long2ip(long ip){
	return wLib.long2ip(ip);
}

//-----------------------------------------------
String join(String[] arr, String glue) {
	return wLib.join(arr, glue);
}

//-----------------------------------------------
String escape_html(String html){
	return wLib.escape_html(html);
}

//-----------------------------------------------
String[] get_exp_ymd_arr() {
	String[] ymd_arr = wLib.strftime_arr("yyyy-MM-dd", wLib.strftime("yyyy-MM-dd"), 86400, 60);
	return ymd_arr;
}

//-----------------------------------------------
String[] get_exp_hm_arr() {
	String[] hm_arr = wLib.strftime_arr("HH:mm", "08:00", 60 * 15, 24 * 4);
	return hm_arr;
}

//-----------------------------------------------
String safe_substring(String line, int start, int end){
	return wLib.safe_substring(line, start, end);
}

//-----------------------------------------------
String safe_substring(String line, int len){
	return wLib.safe_substring(line, len);
}

//-----------------------------------------------
boolean is_valid_ip(String ip){
	return wLib.is_valid_ip(ip);
}

//-----------------------------------------------
boolean is_valid_ipv6(String ip){
	return wLib.is_valid_ipv6(ip);
}

//-----------------------------------------------
boolean is_valid_domain(String domain){
	return wLib.is_valid_domain(domain);
}

//-----------------------------------------------
boolean is_valid_email(String email){
	return wLib.is_valid_email(email);
}

//-----------------------------------------------
boolean is_sha1hex(String s){
	return wLib.is_sha1hex(s);
}

//-----------------------------------------------
boolean system_output(String cmd, StringBuilder res_buf) {
        return wLib.system_output(cmd, res_buf);
}

//-----------------------------------------------
String system_output(String cmd) {
        return wLib.system_output(cmd);
}

//-----------------------------------------------
String read_map_file_val(String filename, String kw){
	return wLib.read_map_file_val(filename, kw);
}

//-----------------------------------------------
void write_map_file_val(String filename, String kw, String val){
	wLib.write_map_file_val(filename, kw, val);
}

//-----------------------------------------------
String http_get(String url, int timeout){
	return wLib.http_get(url, timeout);
}
// From wLib.

//-----------------------------------------------
void init_signal_flag() {
	String[] signal_arr = param_arr("signal_arr");

	// Init.
	param.set_str("signal_ping", "FALSE");
	param.set_str("signal_start", "FALSE");
	param.set_str("signal_stop_flag", "FALSE");
	param.set_str("signal_switch", "FALSE");
	param.set_str("signal_chgdns_flag", "FALSE");
	param.set_str("signal_ipupdate", "FALSE");

	if (signal_arr == null) {
		param.set_str("signal_ping", "TRUE");
		param.set_str("signal_start", "TRUE");
		param.set_str("signal_stop_flag", "TRUE");
		param.set_str("signal_switch", "TRUE");
		param.set_str("signal_chgdns_flag", "TRUE");
		param.set_str("signal_ipupdate", "TRUE");
	} else {
		for (String signal : signal_arr) {
			if (signal.equals("ping")) {
				param.set_str("signal_ping", "TRUE");
			} else if (signal.equals("start")) {
				param.set_str("signal_start", "TRUE");
			} else if (signal.equals("stop")) {
				param.set_str("signal_stop_flag", "TRUE");
			} else if (signal.equals("switch")) {
				param.set_str("signal_switch", "TRUE");
			} else if (signal.equals("chgdns")) {
				param.set_str("signal_chgdns_flag", "TRUE");
			} else if (signal.equals("ipupdate")) {
				param.set_str("signal_ipupdate", "TRUE");
			}
		}
	}
}

//-----------------------------------------------
List<String> get_hh_list() {
	List<String> list = new ArrayList<String>();
	for (int i = 0; i <= 24; i++) {
		String hh = i + "";
		if (i < 10) {
			hh = "0" + hh;
		}

		list.add(hh);
	}

	return list;
}

//-----------------------------------------------
List<String> get_mm_list() {
	List<String> list = new ArrayList<String>();
	for (int i = 0; i < 60; i++) {
		String mm = i + "";
		if (i < 10) {
			mm = "0" + mm;
		}

		list.add(mm);
	}

	return list;
}

//-----------------------------------------------
String get_page_name(){
        try{
                String uri = request.getRequestURI();
                String page_name = uri.substring(uri.lastIndexOf("/") + 1);
                return page_name;
        }
        catch(Exception e){
                //e.printStackTrace();
                System.out.println(e);
        }

        return "";
}

//-----------------------------------------------
boolean is_admin(){
	return admin_login_dao.is_admin();
}

//-----------------------------------------------
String get_admin_name(){
	return admin_login_dao.get_admin_name();
}

//-----------------------------------------------
Map<Integer, String> get_ldap_period_map(){
	Map<Integer, String> m = new LinkedHashMap<Integer, String>();
	m.put(0, "No sync");
	m.put(1, "Every minute");
	m.put(15, "Every 15 minutes");
	m.put(60, "Every hour");
	m.put(360, "Every 6 hours");
	m.put(1440, "Once a day");
	return m;
}

//-----------------------------------------------
String get_ldap_period_string(int period){
	Map<Integer, String> m = get_ldap_period_map();
	String s = m.get(period);
	return null2str(s);
}

//-----------------------------------------------
Map<Integer, String> get_alert_period_map(){
	Map<Integer, String> m = new LinkedHashMap<Integer, String>();
	m.put(0, "No alert");
	m.put(5, "Every 5 minutes");
	m.put(15, "Every 15 minutes");
	m.put(30, "Every 30 minutes");
	m.put(60, "Every hour");
	m.put(120, "Every 2 hours");
	return m;
}

//-----------------------------------------------
void chk_new_version(){
	if(admin_login_dao.has_new_version()){
		String new_ver = GlobalDao.get_new_version();

		succ_list.add("A new version of NxFilter is available!");
		succ_list.add("The newest version of NxFilter is " + new_ver + ".");
	}
}

//-----------------------------------------------
void chk_new_message(){
    if(admin_login_dao.has_new_message()){
        String new_msg = GlobalDao.get_new_message();

        String[] arr = new_msg.split("\n");
        for(String a : arr){
            if(is_not_empty(a)){
                succ_list.add(a.trim());
            }
        }
    }
}

//-----------------------------------------------
boolean is_user_page(){
	String page = get_page_name();
	if(is_empty(page)){
		return true;
	}
	if(page.equals("index.jsp")){
		return true;
	}
	if(page.equals("login.jsp")){
		return true;
	}
	if(page.equals("welcome.jsp")){
		return true;
	}

	return false;
}

//-----------------------------------------------
String format_file_size(long bytes) {
	int unit = 1000;
	if (bytes < unit) {
		return bytes + " B";
	}
	int exp = (int) (Math.log(bytes) / Math.log(unit));
	String pre = "KMGTPE".charAt(exp - 1) + "";
	return String.format("%.1f %sB", bytes / Math.pow(unit, exp), pre);
}

//-----------------------------------------------
boolean is_license_invalid() {
	return license_dao.is_invalid();
}

//-----------------------------------------------
boolean is_license_expired() {
	return license_dao.is_expired();
}
%>
<%
// Init library and do the ground work.
init_lib(pageContext);

if(!is_user_page()){
	// Check if it's from allowed IP.
	if(!admin_login_dao.is_allowed_ip()){
		out.println("This IP is not allowed!");
		return;
	}
	
	// Check SSL.
	if(admin_login_dao.is_ssl_required()){
		try{
			response.sendRedirect(admin_login_dao.get_ssl_admin_url());
		}
		catch(Exception e){}
		out.println("SSL only!");
		return;
	}

	// License check.
	// Allow only license update page.
	/*
	if(get_page_name().indexOf("config,license.jsp") == -1 && (is_license_invalid() || is_license_expired())){
		try{
			response.sendRedirect("/config,license.jsp");
		}
		catch(Exception e){}
	}
	*/
}
%>
