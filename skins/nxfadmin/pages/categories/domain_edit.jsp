<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void update(WhitelistDomainDao dao){
	WhitelistData data = new WhitelistData();
	data.id = param_int("id");
	data.bypass_auth = param_bool("bypass_auth");
	data.bypass_filter = param_bool("bypass_filter");
	data.bypass_log = param_bool("bypass_log");
	data.admin_block = param_bool("admin_block");
	data.applied_policy_arr = param_arr("applied_policy");

	if(dao.update(data)){
		succ_list.add("Whitelist domain updated successfully!");
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
WhitelistDomainDao dao = new WhitelistDomainDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update(dao);
}

// Global.
WhitelistData data = dao.select_one(param_int("id"));

// Get policy list.
List<PolicyData> g_policy_list = new PolicyDao().select_list();
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Edit By Domain</title>
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
                        <li class="treeview active">
                            <a href="#">
                                <i class="fa fa-book"></i> <span>Categories</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="../../pages/categories/custom.jsp"><i class="fa fa-angle-double-right"></i> Custom</a></li>
                                <li class="treeview active">
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
                                <i class="fa fa-power-off"></i> <span>Restart</span> <small class="badge pull-right bg-green">new</small>
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
                        Categories
                        <small>Edit Whitelist</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../../dashboard.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li><a href="#">Categories</a></li>
                        <li><a href="#">Whitelist</a></li>
                        <li class="active">Edit Domain</li>
                    </ol>
                </section>


                <!-- Main content -->
                <section class="content"> 
                    <div id="tipue_drop_content"></div>
                    <!-- 1st row -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-navy">
                                <div class="box-header">
                                    <i class="fa fa-check-square-o"></i>
                                    <h3 class="box-title">Whitelist by Domain</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <!-- start form -->
                                    <form role="form" id="editDomain" action="<%= get_page_name()%>" method="post">
                                    <input type="hidden" name="action_flag" value="update">
                                    <input type="hidden" name="id" value="<%= data.id%>">
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="domain">Domain</label>
                                                <input type="text" class="form-control" id="domain" name="domain" value="<%= data.domain%>" disabled>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="bypass_auth">Bypass Authentication</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="bypass_auth" name="bypass_auth" <%if(data.bypass_auth){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="bypass_filter">Bypass Filtering</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="bypass_filter" name="bypass_filter" <%if(data.bypass_filter){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="bypass_log">Bypass Logging</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="bypass_log" name="bypass_log" <%if(data.bypass_log){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="admin_block">Admin Block</label>
                                                <br />
                                                <input type="checkbox" class="flat-red" id="admin_block" name="admin_block" <%if(data.admin_block){out.print("checked");}%> >
                                            </div>
                                        </div> 
                                        <br />
                                        <div class="callout callout-info">
                                            <h4 class="text-navy">If there is no applied policy, it becomes a global whitelist.</h4>
                                        </div>

                                        <label for="applied_policy">Applied Policy </label>
                                        <div class="form-group">
                                            <div class="checkbox-inline" id="policy">
<%
int i = 0;
for(PolicyData pd : g_policy_list){

	String chk = "";
	if(data.is_applied_policy(pd.id)){
		chk = "checked";	
	}

	if(i > 0 && i % 10 == 0) {
            out.println("</div>");
		out.println("<div class=\"checkbox-inline\">");
	}
	i++;
%>
<label class="checkbox">
    <input type="checkbox" class="chkPolicy flat-green" name="applied_policy" value="<%= pd.id%>" <%= chk%>>&nbsp;<%= pd.name%>
</label>
<%}%>

                                            </div><!-- /.checkbox-inline -->
                                        </div><!-- /.form-group -->
                                    </form><!-- end form -->
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <button id="edit" type="submit" form="editDomain" class="btn btn-info">Save Settings</button>
                                </div>
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->

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
                           
                $('#edit').click(function() {
                    document.getElementById("editDomain").submit();        
                });
                
                $('#editDomain').submit(function(e) {
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
