<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void update(PolicyDao dao){
	PolicyData data = new PolicyData();

	data.id = param_int("id");
	data.points = param_int("points");
	data.description = param_str("description");
	data.enable_filter = param_bool("enable_filter");

	data.block_all = param_bool("block_all");
	data.block_unclass = param_bool("block_unclass");
	data.ad_remove = param_bool("ad_remove");
	data.max_domain_len = param_int("max_domain_len");

	data.block_covert_chan = param_bool("block_covert_chan");
	data.block_mailer_worm = param_bool("block_mailer_worm");
	data.block_dns_rebinding = param_bool("block_dns_rebinding");

	data.a_record_only = param_bool("a_record_only");
	data.quota = param_int("quota");
	data.quota_all = param_bool("quota_all");
	data.bwdt_limit = param_long("bwdt_limit");

	data.safe_search = param_bool("safe_search");
	data.disable_application_control = param_bool("disable_application_control");
	data.disable_proxy = param_bool("disable_proxy");
	data.log_only = param_bool("log_only");
	data.block_category_arr = param_arr("block_category");

	data.quota_category_arr = param_arr("quota_category");

	if(dao.update(data)){
		succ_list.add("Policy data updated successfully.");
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
PolicyDao dao = new PolicyDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update(dao);
}

// Global.
PolicyData data = dao.select_one(param_int("id"));
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Edit Policy</title>
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
        <!-- iCheck for checkboxes and radio inputs -->
        <link href="../../css/iCheck/all.css" rel="stylesheet" type="text/css" />

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
                        <li class="treeview">
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
                        <li class="treeview active">
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
                        Policies
                        <small>Edit Policy</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../../dashboard.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li><a href="#">Policies</a></li>
                        <li class="active">Edit Policy</li>
                    </ol>
                </section>


                <!-- Main content -->
                <section class="content"> 
                	<div id="tipue_drop_content"></div>
                    <!-- start form -->
                    <form class="form" role="form" id="updatePolicy" name="updatePolicy" action="<%= get_page_name()%>" method="post">
                    <input type="hidden" name="action_flag" value="update">
                    <input type="hidden" name="id" value="<%= data.id%>">
                        <div class="box box-purple">

                            <div class="box box-purple">
                                <div class="box-header">
                                    <i class="fa  fa-file-text-o"></i>
                                    <h3 class="box-title">Edit Policy</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="name">Name</label>
                                                <input type="text" class="form-control" id="name" name="name" value="<%= data.name%>" disabled />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                                <label class="control-label" for="points">Priority Points</label>
                                            <div class="input-group col-xs-3">
                                                <input type="text" class="form-control" id="points" name="points" value="<%= data.points%>" />
                                                <span class="input-group-addon">0 ~ 1000</span>
                                            </div>
                                            <p class="help-block">When a user has multiple policies, the policy having the highest points will be applied.</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-4">
                                                <label class="control-label" for="description">Description</label>
                                                <input type="text" class="form-control" id="description" name="description" value="<%= data.description%>" >
                                            </div>
                                            <p class="help-block">Domain for user authentication</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="enable_filter">Enable Filter</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="enable_filter" name="enable_filter" <%if(data.enable_filter){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="block_all">Block All</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="block_all" name="block_all" <%if(data.block_all){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="block_unclass">Block Unclassified</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="block_unclass" name="block_unclass" <%if(data.block_unclass){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="ad_remove">Ad-Remove</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="ad_remove" name="ad_remove" <%if(data.ad_remove){out.print("checked");}%> >
                                            </div>
                                            <p class="help-block">Block adware with blank-page.</p>
                                        </div>
                                        <div class="form-group">
                                                <label class="control-label" for="max_domain_len">Max Domain Length</label>
                                            <div class="input-group col-xs-3">
                                                <input type="text" class="form-control" id="max_domain_len" name="max_domain_len" value="<%= data.max_domain_len%>" >
                                                <span class="input-group-addon">0 ~ 1000</span>
                                            </div>
                                            <p class="help-block">NxFilter doesn't apply 'Max domain length' against 30,000 of the most well known domains. 0 = bypass</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="block_covert_chan">Block Covert Channel</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="block_covert_chan" name="block_covert_chan" <%if(data.block_covert_chan){out.print("checked");}%> >
                                            </div>
                                            <p class="help-block">Detect hidden communication.</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="block_mailer_worm">Block Mailer Worm</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="block_mailer_worm" name="block_mailer_worm" <%if(data.block_mailer_worm){out.print("checked");}%> >
                                            </div>
                                            <p class="help-block">MX record will be blocked.</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="block_dns_rebinding">Block DNS Rebinding</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="block_dns_rebinding" name="block_dns_rebinding" <%if(data.block_dns_rebinding){out.print("checked");}%> >
                                            </div>
                                            <p class="help-block">DNS response with private IP will be blocked.</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="a_record_only">Allow 'A' record only</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="a_record_only" name="a_record_only" <%if(data.a_record_only){out.print("checked");}%> >
                                            </div>
                                            <p class="help-block">Block all except A, AAAA, PTR, CNAME records.</p>
                                        </div>
                                        <div class="form-group">
                                                <label class="control-label" for="quota">Quota</label>
                                            <div class="input-group col-xs-3">
                                                <input type="text" class="form-control" id="quota" name="quota" value="<%= data.quota%>" >
                                                <span class="input-group-addon">minutes</span>
                                            </div>
                                            <p class="help-block">You can allow users to use 'Quotaed Categories' for a specific amount of time.  When there's no remaining quota for a user, 'Quotaed Categories' will be working the same way as 'Blocked Categories'. 0 ~ 1440</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="quota_all">Quota All</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="quota_all" name="quota_all" <%if(data.quota_all){out.print("checked");}%> >
                                            </div>
                                            <p class="help-block">Quota will be applied for all domains including unclassified domains.</p>
                                        </div>
                                        <div class="form-group">
                                                <label class="control-label" for="bwdt_limit">Bandwidth Limit</label>
                                            <div class="input-group col-xs-3">
                                                <input type="text" class="form-control" id="bwdt_limit" name="bwdt_limit" value="<%= data.bwdt_limit%>" >
                                                <span class="input-group-addon">MB</span>
                                            </div>
                                            <p class="help-block">You must run Netflow collector to use bandwidth control. 0 = bypass</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="safe_search">Safe Search</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="safe_search" name="safe_search" <%if(data.safe_search){out.print("checked");}%> >
                                            </div>
                                            <p class="help-block">* Currently NxFilter DNS safe-search only applies to Google and Bing.</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="disable_application_control">Disable Application Control</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="disable_application_control" name="disable_application_control" <%if(data.disable_application_control){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="disable_proxy">Disable Proxy Filtering</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="disable_proxy" name="disable_proxy" <%if(data.disable_proxy){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="log_only">Logging Only</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="log_only" name="log_only" <%if(data.log_only){out.print("checked");}%> >
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->

                            </div><!-- /.box box-lime -->  



                            <div class="box box-teal">
                                <div class="box-header">
                                    <i class="fa text-red fa-ban"></i>
                                    <h3 class="box-title">Blocked Categories</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->

                                    <div class="box-body">
                                        <div class="form-group">
                                            <label class="checkbox">
                                               <input type="checkbox" class="flat-red" id="allBlock" name="allBlock"> Toggle-All
                                            </label>
                                            <div class="checkbox-inline" id="blocked">
<%
for(int i = 0; i < data.block_category_list.size(); i++){
	CategoryData cd = data.block_category_list.get(i);

	String chk = "";
	if(cd.check_flag){
		chk = "checked";	
	}

	if(i > 0 && i % 16 == 0) {
            out.println("</div>");
		out.println("<div class=\"checkbox-inline\">");
	}
%>
<label class="checkbox">
    <input type="checkbox" class="chkBlocked flat-red" name="block_category" value='<%= cd.id%>' <%= chk%>>&nbsp;<%= cd.name%>
</label>
<%}%>
                                            
                                            </div><!-- /.checkbox-inline -->
                                        </div><!-- /.form-group -->

                                    </div><!-- /.box-body -->

                            </div><!-- /.box box-teal-->  



                            <div class="box box-maroon">
                                <div class="box-header">
                                    <i class="fa fa-stack-overflow"></i>
                                    <h3 class="box-title">Quota Categories</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->

                                    <div class="box-body">

                                            <div class="form-group">
                                            <label class="checkbox">
                                               <input type="checkbox" class="flat-green" id="allQuota" name="allQuota"> Toggle-All
                                            </label>
                                            <div class="checkbox-inline" id="quota">
<%
for(int i = 0; i < data.quota_category_list.size(); i++){
	CategoryData cd = data.quota_category_list.get(i);

	String chk = "";
	if(cd.check_flag){
		chk = "checked";	
	}

	if(i > 0 && i % 16 == 0) {
            out.println("</div>");
		out.println("<div class=\"checkbox-inline\">");
	}
%>
<label class="checkbox">
    <input type="checkbox" class="chkQuota flat-green" name="quota_category" value='<%= cd.id%>' <%= chk%>>&nbsp;<%= cd.name%>
</label>
<%}%>

                                            </div><!-- /.checkbox-inline -->
                                        </div><!-- /.control-group -->

                                    </div><!-- /.box-body -->
                                        
                            </div><!-- /.box box-maroon -->  



                        <div class="box-footer">
                            <button id="submitBtn" type="submit" form="updatePolicy" class="btn btn-info btn-lg margin">Update All Policy Settings</button>
                            <button id="resetBtn" class="btn btn-warning margin">Reset Form</button>
                        </div>

                        </div><!-- /main .box -->
                    </form><!-- form end -->

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
                           
                $('#submitBtn').click(function() {
                    document.getElementById("updatePolicy").submit();        
                });
                
                $('#resetBtn').click(function() {
                    document.getElementById("updatePolicy").reset();
                    $('input').iCheck('update');        
                });
                
                $('#updatePolicy').submit(function(e) {
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

                $('input[type="checkbox"][name="allQuota"]').on('ifToggled', function(event){
                    setCbQuota($('#allQuota').prop('checked'));
                 });

                $('input[type="checkbox"][name="allBlock"]').on('ifToggled', function(event){
                    setCbBlock($('#allBlock').prop('checked'));
                 });                

                 function setCbBlock(state){
                     if(state) {
                         $('input[type="checkbox"][name="block_category"]').iCheck('check');
                     } else {
                         $('input[type="checkbox"][name="block_category"]').iCheck('uncheck');
                     }
                 }         
           
                 function setCbQuota(state){
                     if(state) {
                         $('input[type="checkbox"][name="quota_category"]').iCheck('check');
                     } else {
                         $('input[type="checkbox"][name="quota_category"]').iCheck('uncheck');
                     }
                 }
             
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
