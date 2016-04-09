<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void update(GroupDao dao){
	GroupData data = new GroupData();
	data.id = param_int("id");
	data.policy_id = param_int("policy_id");
	data.ft_policy_id = param_int("ft_policy_id");
	data.description = param_str("description");

    String stime = param_str("ft_stime");
    String etime = param_str("ft_etime");
    stime = stime.replaceAll(":","");
    etime = etime.replaceAll(":","");
    data.ft_stime = stime;
    data.ft_etime = etime;


	if(dao.update(data)){
		succ_list.add("Group Settings updated.");
	}
}

//-----------------------------------------------
void move_user(GroupDao dao){
	if(dao.move_user(param_int("id"), param_str("user_id_line"))){
		succ_list.add("Group Membership successfully updated.");
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
GroupDao dao = new GroupDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update(dao);
}
if(action_flag.equals("move_user")){
	move_user(dao);
}

// Global.
GroupData data = dao.select_one(param_int("id"));

String ftStime = data.ft_stime;
if(ftStime.length() > 2) {
    ftStime = ftStime.substring(0, 2) + ":" + ftStime.substring(Math.max(ftStime.length() - 2, 0));
}

String ftEtime = data.ft_etime;
if(ftEtime.length() > 2) {
    ftEtime = ftEtime.substring(0, 2) + ":" + ftEtime.substring(Math.max(ftEtime.length() - 2, 0));
}

// Get policy list.
List<PolicyData> g_policy_list = new PolicyDao().select_list();
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Edit Group</title>
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
        <!-- bootstrap dual listbox -->
        <link href="../../css/duallistbox/bootstrap-duallistbox.css" rel="stylesheet" type="text/css" />
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
                    <form role="form" id="group_edit_form" name="group_edit_form" action="<%= get_page_name()%>" method="post">
                    <input type="hidden" name="action_flag" value="">
                    <input type="hidden" name="id" value="<%= data.id%>">
                    <input type="hidden" name="user_id_line" value="">
                    
                            <div class="box box-navy">
                                <div class="box-header">
                                    <i class="fa fa-group"></i>
                                    <h3 class="box-title">Edit Group</h3>
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
                                            <label class="control-label col-xs-12">Group Specific Free-Time</label>
                                        </div>

                                        <div class="form-group">
                                            <div class="col-xs-12">
                                                <div class="form-inline">
                                                    <div class="form-group">
                                                        <input type="text" class="form-control" id="ft_stime" name="ft_stime" value="<%= ftStime %>" maxlength="5">
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="ft_etime">~</label>
                                                    </div>
                                                    <div class="form-group">
                                                        <input type="text" class="form-control" id="ft_etime" name="ft_etime" value="<%= ftEtime %>" maxlength="5">
                                                    </div>
                                                </div>
                                            </div>
                                        </div> 

                                        <div class="callout callout-info">
                                            <h4>24hr Time Format: hh:mm</h4>
                                            <p>When a user belongs to multiple groups and one of the groups fall into the free-time range, NxFilter applies the free-time policy for the user. NxFilter applies group specific free-time first and then global free-time next.</p>
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
                                    <button id="submitBtn" type="submit" form="group_edit_form" class="btn btn-info margin">Save Settings</button>
                                    <button id="resetBtn" class="btn btn-warning margin">Reset</button>
                                </div>
                            </div>

                            </div><!-- /.box -->

<!-- show move user box if not LDAP group -->
<%if(!data.is_ldap_group()){%>
<!--  -->
                            <div class="box box-solid box-grey">
                                <div class="box-header">
                                    <i class="fa fa-desktop"></i>
                                    <h3 class="box-title">Move User</h3>
                                </div><!-- /.box-header -->

                                <div class="box-body">
                                     <div class="form-group"> 
                                            <div class="input-group col-xs-6">                                     

<select id="grpMembership" multiple="multiple" size="20" name="grpMembership" class="grpMembers">
<%
// member user list
for(UserData ud : data.user_list){
    printf("<option value=\"%s\" selected=\"selected\">%s</option>", ud.id, ud.name);
}
// Non member users
for(GroupUserRelationData rd : data.group_user_relation_list){
        printf("<option value=\"%s\">%s</option>", rd.user_id, rd.to_str());
}
%>
</select>

                                            </div>
                                        </div> 
                                        
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <div class="btn-group">
                                        <button id="moveUser" class="btn btn-primary margin">Move User</button>
                                    </div>
                                </div><!-- /.box-footer -->
                            </div><!-- /.box-aqua -->
<%}%>
                    </form><!-- end form -->

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
        <script src="../../js/plugins/duallistbox/jquery.bootstrap-duallistbox.js" type="text/javascript"></script>
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
            var grpMembers = jQuery('select[name="grpMembership"]').bootstrapDualListbox({
                nonselectedlistlabel: 'All Users',
                selectedlistlabel: 'Group Members',
                preserveselectiononmove: 'moved',
                moveonselect: false
            });
                
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
                           
                $('#moveUser').click(function() {
                    document.forms["group_edit_form"].action_flag.value = "move_user";
                    document.forms["group_edit_form"].user_id_line.value = $('[name="grpMembership"]').val();
                    document.getElementById("group_edit_form").submit();        
                });

                $('#submitBtn').click(function() {
                    document.forms["group_edit_form"].action_flag.value = "update";
                    document.getElementById("group_edit_form").submit();        
                });
                
                $('#resetBtn').click(function() {
                    document.getElementById("group_edit_form").reset();        
                });
                
                $('#group_edit_form').submit(function(e) {
                    e.preventDefault();
                });           
                
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

                jQuery('#ft_stime, #ft_etime').datetimepicker({
                    datepicker:false,
                    format:'H:i',
                    step:1,
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

        </script>
        
    </body>
</html>
