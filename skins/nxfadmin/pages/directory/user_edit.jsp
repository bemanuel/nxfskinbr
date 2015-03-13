<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
boolean chk_param(UserData data){
	ParamValidator pv = new ParamValidator();

	// Check password only if there's a password updated.
	if (!is_empty(data.passwd) && !is_sha1hex(data.passwd)) {
		if (!pv.is_valid_passwd_len(data.passwd)) {
			err_list.add(ParamValidator.ERR_PASSWD_LEN);
			return false;
		}

		if (!pv.is_valid_passwd_char(data.passwd)) {
			err_list.add(ParamValidator.ERR_PASSWD_CHAR);
			return false;
		}
	}

	// token.
	if (!is_empty(data.token) && !pv.is_valid_token(data.token)) {
		err_list.add(ParamValidator.ERR_TOKEN_INVALID);
		return false;
	}

	return true;
}

//-----------------------------------------------
void update(UserDao dao){
	UserData data = new UserData();

    String expire = param_str("exp_date");
    expire = expire.replaceAll("\\s","");

	data.id = param_int("id");
	data.passwd = param_str("passwd");
	data.policy_id = param_int("policy_id");
	data.ft_policy_id = param_int("ft_policy_id");
    data.exp_date = expire;
//	data.exp_date = param_str("exp_ymd") + param_str("exp_hm");
	data.token = param_str("token");
	data.description = param_str("description");

	// Validate and update it.
	if(chk_param(data) && dao.update(data)){
		succ_list.add("User data updated successfully!");
	}
}

//-----------------------------------------------
void new_token(UserDao dao){
	UserData data = new UserData();
	data.id = param_int("id");
	data.token = param_str("token");

	if(dao.new_token(data.id)){
		succ_list.add("New user token updated.");
	}
}

//-----------------------------------------------
void add_ip(UserDao dao){
	UserIpData data = new UserIpData();
	data.user_id = param_int("id");
	data.start_ip = param_str("start_ip");
	data.end_ip = param_str("end_ip");

	// Param validation.
	if (!is_valid_ip(data.start_ip)) {
		err_list.add("Invalid start IP!");
		return;
	}

	if (is_not_empty(data.end_ip) && !is_valid_ip(data.end_ip)) {
		err_list.add("Invalid end IP!");
		return;
	}

	if(dao.add_ip(data)){
		succ_list.add("User IP data successfully added.");
	}
}

//-----------------------------------------------
void delete_ip(UserDao dao){
	if(dao.delete_ip(param_int("ip_id"))){
		succ_list.add("User IP data deleted!");
	}
}
%>
<%
//-----------------------------------------------
// Set permission for this page.
permission.add_admin();

//Check permission.
if(!check_permission()){
	return;
}

// Create data access object.
UserDao dao = new UserDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update(dao);
}
if(action_flag.equals("new_token")){
	new_token(dao);
}
if(action_flag.equals("add_ip")){
	add_ip(dao);
}
if(action_flag.equals("delete_ip")){
	delete_ip(dao);
}

// Global.
UserData data = dao.select_one(param_int("id"));

String expDate = "";
if(!is_empty(data.get_exp_ymd())){
	expDate = data.get_exp_ymd();
	if(!is_empty(data.get_exp_hm())){
	    expDate = expDate + " " + data.get_exp_hm();
    } else {
        expDate = expDate + " 0000";
    }
}


// Get policy list.
List<PolicyData> g_policy_list = new PolicyDao().select_list();
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Edit User</title>
        <meta http-equiv='Expires' content='-1'> 
        <meta http-equiv='Pragma' content='no-cache'> 
        <meta http-equiv='Cache-Control' content='no-cache'>
        <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <link href="../../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="../../css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    	<link href="../../css/tipue/tipuedrop.css" rel="stylesheet" type="text/css" />
        <!-- Ionicons -->
        <link href="../../css/ionicons.min.css" rel="stylesheet" type="text/css" />
        <!-- datetimepicker -->
        <link href="../../css/datetimepicker/jquery.datetimepicker.css" rel="stylesheet" type="text/css" />
        <!-- iCheck for checkboxes and radio inputs -->
        <link href="../../css/iCheck/all.css" rel="stylesheet" type="text/css" />
        <!-- bootstrap table -->
        <link href="../../css/bootstrap-table/bootstrap-table.min.css" rel="stylesheet" type="text/css" />
        <!-- Theme style -->
        <link href="../../css/NxF.css" rel="stylesheet" type="text/css" />

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
          <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
        <![endif]-->
    </head>
    <body class="skin-black">

        <!-- header logo: style can be found in header.less -->
        <header class="header">
            <a href="../../dashboard.jsp" class="logo">
                <!-- Add the class icon to your logo image or logo icon to add the margining -->
                NxFilter v<%= GlobalDao.get_nx_version()%>
            </a>
            <!-- Header Navbar: style can be found in header.less -->
            <nav class="navbar navbar-static-top" role="navigation">
                <!-- Sidebar toggle button-->
                <a href="#" class="navbar-btn sidebar-toggle" data-toggle="offcanvas" role="button">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </a>
                <div class="navbar-right">
                    <ul class="nav navbar-nav">
                        <!-- Notifications: style can be found in dropdown.less -->
                        <li class="dropdown notifications-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <i class="fa fa-warning"></i>
                            </a>
                        </li>
                        <!-- User Account: style can be found in dropdown.less -->
                        <li class="dropdown user user-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <i class="glyphicon glyphicon-user"></i>
                                <span><%= get_admin_name()%> <i class="caret"></i></span>
                            </a>
                            <ul class="dropdown-menu">
                                <!-- User image -->
                                <li class="user-header bg-light-blue">
                                    <img src="../../img/avatar6.png" class="img-circle" alt="User Image" />
                                    <p>
                                        <%= get_admin_name()%> - NxF Admin
                                        <small>Member since Oct. 2014</small>
                                    </p>
                                </li>
                                <!-- Menu Body -->

                                <!-- Menu Footer-->
                                <li class="user-footer">
                                    <div class="pull-left">
                                        <a href="../../pages/config/profile.jsp" class="btn btn-default btn-flat">Profile</a>
                                    </div>
                                    <div class="pull-right">
                                        <a href="../../admin.jsp?action_flag=logout" class="btn btn-default btn-flat">Sign out</a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>
        <div class="wrapper row-offcanvas row-offcanvas-left">
            <!-- Left side column. contains the logo and sidebar -->
            <aside class="left-side sidebar-offcanvas">
                <!-- sidebar: style can be found in sidebar.less -->
                <section class="sidebar">
                    <!-- Sidebar user panel -->
                    <div class="user-panel">
                        <div class="pull-left image">
                            <img src="../../img/avatar6.png" class="img-circle" alt="User Image" />
                        </div>
                        <div class="pull-left info">
                            <p>Hello, <%= get_admin_name() %></p>
                        </div>
                    </div>
                	<!-- search form -->
                	<form action="../search.jsp" method="get" class="sidebar-form" name="search">
                    	<div class="input-group">
                        	<input type="text" name="q" class="form-control" placeholder="Search..." id="tipue_drop_input" autocomplete="off" required/>
                        	<span class="input-group-btn">
                            	<button type='submit' name='seach' id='search-btn' class="btn btn-flat"><i class="fa fa-search"></i></button>
                        	</span>
                    	</div>
                	</form>
                	<!-- /.search form -->
                    <!-- sidebar menu: : style can be found in sidebar.less -->
                    <ul class="sidebar-menu">
                        <li>
                            <a href="../../dashboard.jsp">
                                <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                            </a>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-gears"></i> <span>Configuration</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="../../pages/config/config.jsp"><i class="fa fa-angle-double-right"></i> Settings</a></li>
                                <li><a href="../../pages/config/alert.jsp"><i class="fa fa-angle-double-right"></i> Alerts</a></li>
                                <li><a href="../../pages/config/block_page.jsp"><i class="fa fa-angle-double-right"></i> Block Page</a></li>
                                <li><a href="../../pages/config/allowed_ip.jsp"><i class="fa fa-angle-double-right"></i> Allowed IP's</a></li>
                                <li><a href="../../pages/config/redirection.jsp"><i class="fa fa-angle-double-right"></i> Redirection</a></li>
                                <li><a href="../../pages/config/zone_transfer.jsp"><i class="fa fa-angle-double-right"></i> Zone Transfer</a></li>
                                <li><a href="../../pages/config/cluster.jsp"><i class="fa fa-angle-double-right"></i> Cluster</a></li>
                                <li><a href="../../pages/config/backup.jsp"><i class="fa fa-angle-double-right"></i> Backup</a></li>
                                <li><a href="../../pages/config/profile.jsp"><i class="fa fa-angle-double-right"></i> Profile</a></li>
                            </ul>
                        </li>
                        <li class="treeview active">
                            <a href="#">
                                <i class="fa fa-user"></i> <span>Users & Groups</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="../../pages/directory/users.jsp"><i class="fa fa-angle-double-right"></i> Users</a></li>
                                <li><a href="../../pages/directory/groups.jsp"><i class="fa fa-angle-double-right"></i> Groups</a></li>
                                <li><a href="../../pages/directory/ad.jsp"><i class="fa fa-angle-double-right"></i> Active Directory</a></li>
                                <li><a href="../../pages/directory/ldap.jsp"><i class="fa fa-angle-double-right"></i> LDAP</a></li>
                            </ul>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-pencil"></i> <span>Policies</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="../../pages/policies/policy.jsp"><i class="fa fa-angle-double-right"></i> Policy</a></li>
                                <li><a href="../../pages/policies/free_time.jsp"><i class="fa fa-angle-double-right"></i> Free Time</a></li>
                                <li><a href="../../pages/policies/application.jsp"><i class="fa fa-angle-double-right"></i> Application</a></li>
                                <li><a href="../../pages/policies/proxy.jsp"><i class="fa fa-angle-double-right"></i> Proxy</a></li>
                            </ul>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-book"></i> <span>Categories</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="../../pages/categories/custom.jsp"><i class="fa fa-angle-double-right"></i> Custom</a></li>
                                <li class="treeview">
                                    <a href="#">
                                        <i class="fa fa-angle-double-right"></i> <span>Whitelists</span>
                                        <i class="fa fa-angle-left pull-right"></i>
                                    </a>
                                    <ul class="treeview-menu">
                                        <li><a href="../../pages/categories/domain.jsp"><i class="fa fa-angle-double-right"></i> By Domain</a></li>
                                        <li><a href="../../pages/categories/keyword.jsp"><i class="fa fa-angle-double-right"></i> By Keyword</a></li>
                                    </ul>
                                </li>
                                <li><a href="../../pages/categories/system.jsp"><i class="fa fa-angle-double-right"></i> System</a></li>
                                <li><a href="../../pages/categories/domain_test.jsp"><i class="fa fa-angle-double-right"></i> Domain Test</a></li>
                            </ul>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-bar-chart"></i>
                                <span>Reports</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="../../pages/reports/daily.jsp"><i class="fa fa-angle-double-right"></i> Daily</a></li>
                                <li><a href="../../pages/reports/weekly.jsp"><i class="fa fa-angle-double-right"></i> Weekly</a></li>
                                <li><a href="../../pages/reports/usage.jsp"><i class="fa fa-angle-double-right"></i> Usage</a></li>
                            </ul>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-folder-open"></i> <span>Logs</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="../../pages/logs/requests.jsp"><i class="fa fa-angle-double-right"></i> Requests</a></li>
                                <li><a href="../../pages/logs/signal.jsp"><i class="fa fa-angle-double-right"></i> Signal</a></li>
                                <li><a href="../../pages/logs/netflow.jsp"><i class="fa fa-angle-double-right"></i> Netflow</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="../../pages/system/restart.jsp">
                                <i class="fa fa-power-off"></i> <span>Restart</span>
                            </a>
                        </li>
                    </ul>
                </section>
                <!-- /.sidebar -->
            </aside>

            <!-- Right side column. Contains the navbar and content of the page -->
            <aside class="right-side">
                <!-- Content Header (Page header) -->
                <section class="content-header">
                    <h1>
                        Users & Groups
                        <small>Edit</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../../dashboard.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li><a href="#">Users & Groups</a></li>
                        <li class="active">Edit</li>
                    </ol>
                </section>


                <!-- Main content -->
                <section class="content">
                	<div id="tipue_drop_content"></div>

                    <!-- start form -->
                    <form role="form" id="user_edit_form" name="user_edit_form" action="<%= get_page_name()%>" method="post">
                    <input type="hidden" name="action_flag" value="edit">
                    <input type="hidden" name="id" value="<%= data.id%>">
                    <input type="hidden" name="ip_id" value="">
                    
                            <div class="box box-grey">
                                <div class="box-header">
                                    <i class="fa fa-user"></i>
                                    <h3 class="box-title">Edit User</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="name">Name</label>
                                                <input type="text" class="form-control" id="name" name="name" value="<%= data.name%>" disabled>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="passwd">Password</label>
                                                <input type="password" class="form-control" id="passwd" name="passwd" value="<%= data.passwd%>" placeholder="Password..." maxlength="12">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="policy_id">Work-Time Policy</label>
                                                <select class="form-control" id="policy_id" name="policy_id">
<%
for(PolicyData pd : g_policy_list){
	if(pd.id == data.policy_id){
		printf("<option value='%s' selected>%s\n", pd.id, pd.name);
	}
	else{
		printf("<option value='%s'>%s\n", pd.id, pd.name);
	}
}
%>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="ft_policy_id">Free-Time Policy</label>
                                                <select class="form-control" id="ft_policy_id" name="ft_policy_id">
	                                                <option value='0'>Same as work-time policy
<%
for(PolicyData pd : g_policy_list){
	if(pd.id == data.ft_policy_id){
		printf("<option value='%s' selected>%s\n", pd.id, pd.name);
	}
	else{
		printf("<option value='%s'>%s\n", pd.id, pd.name);
	}
}
%>
                                                </select>
                                            </div>
                                        </div>


                                     
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="exp_date">Expiration Date</label>
                                                <input type="text" class="form-control" id="exp_date" name="exp_date" value="<%= expDate %>" >
                                            </div>
                                        </div>


                                        <div class="form-group">
                                            <label class="control-label" for="token">Login Token</label>
                                            <div class="input-group col-xs-2">
                                                <input type="text" class="form-control" id="token" name="token" value="<%= data.token%>" placeholder="Token..." maxlength="8" >
                                                <span class="input-group-btn">
                                                    <button id="new-token" class="btn btn-primary" type="button">New Token</button>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="group">Group</label>
                                                <input type="text" class="form-control" id="group" name="group" value="<%= data.get_group_line()%>" disabled>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="description">Description</label>
                                                <input type="text" class="form-control" id="description" name="description" value="<%= data.description%>" placeholder="Description..." >
                                            </div>
                                        </div>
                                        
                                </div><!-- /.box-body -->

                            <div class="box-footer">
                                <div class="btn-group">
                                    <button id="submitBtn" type="submit" form="user_edit_form" class="btn btn-info margin">Save Settings</button>
                                    <button id="resetBtn" class="btn btn-warning margin">Reset</button>
                                </div>
                            </div>

                            </div><!-- /.box -->



                            <div class="box box-solid box-grey">
                                <div class="box-header">
                                    <i class="fa fa-desktop"></i>
                                    <h3 class="box-title">Add IP</h3>
                                </div><!-- /.box-header -->
                                <div class="callout callout-info">
                                    <h4>IP based authentication.</h4>                                
                                    <p>A user having an associated IP address gets authenticated based on IP address.  You can associate a user to a single IP, several IP addresses or an IP address range.</p>
                                    <p class="text-yellow"><strong>* This is a method of authentication. You need to enable authentication first to see the username in log views.</strong></p>
                                </div>
                                <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="start_ip">Start IP</label>
                                            <div class="input-group col-xs-3">                                         
                                                <input type="text" class="form-control" id="start_ip" name="start_ip" data-inputmask="'alias': 'ip'" data-mask/ placeholder="Start IP..." >
                                                <span class="input-group-btn">
                                                    <button id="add-ip" class="btn btn-primary" type="button">Add</button>
                                                </span>
                                            </div>
                                            <p class="help-block text-blue"><b>Note:</b>  If entering a single IP you can submit 'Start IP' only.</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="end_ip">End IP</label>
                                                <input type="text" class="form-control" id="end_ip" name="end_ip" data-inputmask="'alias': 'ip'" data-mask/ placeholder="End IP..." >
                                            </div>
                                        </div>
                                    <!-- start table -->
                                    <table id="table">
                                        <thead>
                                        <tr>
                                            <th data-field="id" data-visible="false">ID</th>
                                            <th data-field="ip" data-sortable="true">IP</th>
                                            <th data-field="operate" data-formatter="operateFormatter" data-events="operateEvents">Actions</th>
                                        </tr>
                                        </thead>
                                    </table>
                            </div><!-- /.box -->

                    </form><!-- end form -->

                    <!-- start: Delete Redirection Modal -->
                    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h3 class="modal-title" id="myModalLabel">Confirm?</h3>
                                </div>
                                <div class="modal-body">
                                    <h4>Are you sure you want to delete this record?</h4>
                                </div>
                                <!--/modal-body-collapse -->
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-danger" id="btnDelYes" href="#">Yes</button>
                                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                                </div>
                                <!--/modal-footer-collapse -->
                            </div>
                            <!-- /.modal-content -->
                        </div>
                        <!-- /.modal-dialog -->
                    </div>
                    <!-- /.modal -->

                </section><!-- /.content -->

            </aside><!-- /.right-side -->
        </div><!-- ./wrapper -->


        <script src="../../js/jquery.min.js"></script>
        <script src="../../js/bootstrap.min.js" type="text/javascript"></script>
        <script src="../../js/jquery-ui.min.js" type="text/javascript"></script>
        <script src="../../js/jquery.noty.packaged.min.js" type="text/javascript" ></script>
        <script src="../../js/plugins/input-mask/jquery.inputmask.js" type="text/javascript"></script>
        <script src="../../js/plugins/input-mask/jquery.inputmask.date.extensions.js" type="text/javascript"></script>
        <script src="../../js/plugins/input-mask/jquery.inputmask.extensions.js" type="text/javascript"></script>
        <script src="../../js/plugins/bootstrap-table/bootstrap-table.min.js" type="text/javascript"></script>
        <!-- datetimepicker -->
        <script src="../../js/plugins/datetimepicker/jquery.datetimepicker.js" type="text/javascript"></script>

    	<!-- TipueDrop Search -->
    	<script src="../../js/plugins/tipue/tipuedrop.min.js" type="text/javascript"></script>
    	
        <!-- iCheck -->
        <script src="../../js/plugins/iCheck/icheck.min.js" type="text/javascript"></script>

        <!-- NxF App -->
        <script src="../../js/NxF/app.js" type="text/javascript"></script>

        <!-- Page script -->
        <script type="text/javascript">
            
            // Noty notification messages       
            $(document).ready(function () {
                var errmsg = "";
                var succmsg = "";
                <%@include file="../../include/messages.jsp"%>
                
                if (errmsg != null && !(errmsg === "")) {
                    //generateDiv('div#notifications', 'error', errmsg, 'topCenter');
                    generate('error', errmsg, 'topCenter');
                }
                if (succmsg != null && !(succmsg === "")) {
                    //generateDiv('div#notifications', 'success', succmsg, 'topCenter');
                    generate('success', succmsg, 'topCenter');
                }
                           
                $('#add-ip').click(function() {
                    document.forms["user_edit_form"].action_flag.value = "add_ip";
                    document.getElementById("user_edit_form").submit();        
                });

                $('#new-token').click(function() {
                    document.forms["user_edit_form"].action_flag.value = "new_token";
                    document.getElementById("user_edit_form").submit();        
                });

                $('#submitBtn').click(function() {
                    document.forms["user_edit_form"].action_flag.value = "update";
                    document.getElementById("user_edit_form").submit();        
                });
                
                $('#resetBtn').click(function() {
                    document.getElementById("user_edit_form").reset();        
                });
                
                $('#user_edit_form').submit(function(e) {
                    e.preventDefault();
                });
               
                $("[data-mask]").inputmask(); 
                //iCheck for checkbox and radio inputs
                $('input[type="checkbox"].minimal, input[type="radio"].minimal').iCheck({
                    checkboxClass: 'icheckbox_minimal',
                    radioClass: 'iradio_minimal'
                });
                //Red color scheme for iCheck
                $('input[type="checkbox"].minimal-red, input[type="radio"].minimal-red').iCheck({
                    checkboxClass: 'icheckbox_minimal-red',
                    radioClass: 'iradio_minimal-red'
                });
                //Flat red color scheme for iCheck
                $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                    checkboxClass: 'icheckbox_flat-red',
                    radioClass: 'iradio_flat-red'
                });
                //Green color scheme for iCheck
                $('input[type="checkbox"].minimal-green, input[type="radio"].minimal-green').iCheck({
                    checkboxClass: 'icheckbox_minimal-green',
                    radioClass: 'iradio_minimal-green'
                });
                //Flat green color scheme for iCheck
                $('input[type="checkbox"].flat-green, input[type="radio"].flat-green').iCheck({
                    checkboxClass: 'icheckbox_flat-green',
                    radioClass: 'iradio_flat-green'
                });

                jQuery('#exp_date').datetimepicker({
                    format:'Y-m-d H:i',
                    minDate:0,
                    minTime:0,
                    step:5,
                    theme:'dark'
                });
                
                //Prevent return key submitting form
                function stopRetKey(evt) {
                    var evt = (evt) ? evt : ((event) ? event : null);
                    var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
                    if ((evt.keyCode == 13) && ((node.type=="text") || (node.type=="radio") || (node.type=="checkbox")) )  {return false;}
                }
                document.onkeypress = stopRetKey;

            	$('#tipue_drop_input').tipuedrop({
                	'mode': 'json',
                	'contentLocation': '../../js/plugins/tipue/tipue_content.json'
            	});        
            });

var data = 
[
<%
for(int i = 0; i < data.ip_list.size(); i++){
	UserIpData uip = data.ip_list.get(i);
        out.println("{\"id\": " + uip.id + ",\"ip\": \"" + uip.to_str() + "\"},");
}
%>    
];

$(function () {
    $('#table').bootstrapTable({
        data: data
    });
    
    $('#btnDelYes').click(function () {
        var id = $('#myModal').data('id');
        $('#table').bootstrapTable('remove', {
            field: 'id',
            values: [id]
        });
        $('#myModal').modal('hide');
	    var form = document.user_edit_form;
	    form.action_flag.value = 'delete_ip';
	    form.ip_id.value = id;
	    form.submit();
    });
});

function operateFormatter(value, row, index) {
    return [
        '<a class="remove ml10" href="javascript:void(0)" title="Delete">',
        '<i class="ion ion-close-circled text-red"></i>',
        '</a>'
    ].join('');
}

window.operateEvents = {
    'click .remove': function (e, value, row, index) {
        $('#myModal').data('id', row.id);
        $('#myModal').data('ip', row.ip);
        $('#myModal').modal('show');
    }
}; 
        </script>
        
    </body>
</html>
