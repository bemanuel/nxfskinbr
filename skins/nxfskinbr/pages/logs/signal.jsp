<%@include file="../../include/lib.jsp"%>
<%
//-----------------------------------------------
// Set permission for this page.
permission.add_admin();

//Check permission.
if(!check_permission()){
	return;
}

// Create data access object.
SignalDao dao = new SignalDao();
dao.limit = 5000;
dao.page = param_int("page", 1);

String stime = param_str("stime");
String etime = param_str("etime");
String fmtStime = stime;
String fmtEtime = etime;

stime = stime.replaceAll("\\D","");
etime = etime.replaceAll("\\D","");
dao.stime = stime;
dao.etime = etime;

dao.user = param_str("user");
dao.clt_ip = param_str("clt_ip");
dao.signal_ping = param_bool("signal_ping");
dao.signal_start = param_bool("signal_start");

dao.signal_stop = param_bool("signal_stop");
dao.signal_switch = param_bool("signal_switch");
dao.signal_ipupdate = param_bool("signal_ipupdate");

// Global.
int g_count = dao.select_count();
int g_page = dao.page;
int g_limit = dao.limit;
String g_curr_time12 = strftime("yyyyMMddHHmm");
String g_time_option = param_str("time_option", "2h");
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Signal</title>
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
                        <li class="treeview active">
                            <a href="#">
                                <i class="fa fa-folder-open"></i> <span>Logs</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="../../pages/logs/requests.jsp"><i class="fa fa-angle-double-right"></i> Requests</a></li>
                                <li class="active"><a href="../../pages/logs/signal.jsp"><i class="fa fa-angle-double-right"></i> Signal</a></li>
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
                        Logs
                        <small>Signal</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../../dashboard.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li><a href="#">Logs</a></li>
                        <li class="active">Signal</li>
                    </ol>
                </section>


                <!-- Main content -->
                <section class="content">
                	<div id="tipue_drop_content"></div>
                  
                    <!-- start form -->
                    <form role="form" id="search_form" name="search_form" action="<%= get_page_name()%>" method="get">
                    <input type="hidden" name="action_flag" value="">
                  
                            <div class="box box-navy">
                                <div class="box-header">
                                    <i class="fa  fa-signal"></i>
                                    <h3 class="box-title">Signal</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                   
                                        <div class="form-group">
                                            <label class="control-label col-xs-12">Search Interval</label>
                                        </div>

                                        <div class="form-group">
                                            <div class="col-xs-12">
                                                <div class="form-inline">
                                                    <div class="form-group">
                                                        <input type="text" class="form-control" id="stime" name="stime" value="<%= fmtStime%>" maxlength="16">
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="ft_etime">~</label>
                                                    </div>
                                                    <div class="form-group">
                                                        <input type="text" class="form-control" id="etime" name="etime" value="<%= fmtEtime%>" maxlength="16">
                                                    </div>
                                                </div>
                                            </div>
                                        </div> 
                                        <p class="help-block">&nbsp;Time Format - YYYY/MM/DD hh:mm</p>
                                        <div class="form-group">
                                            <div class="radio-inline" id="intervals">
                                                <label class="radio">
                                                    <input type="radio" class="flat-green interval" name="time_option" value="2h" <%if(g_time_option.equals("2h")){out.print("checked");}%>>&nbsp;Last 2 Hours
                                                </label>
                                            </div>
                                            <div class="radio-inline">
                                                <label class="radio">
                                                    <input type="radio" class="flat-green interval" name="time_option" value="24h" <%if(g_time_option.equals("24h")){out.print("checked");}%>>&nbsp;Last 24 Hours
                                                </label>
                                            </div>
                                            <div class="radio-inline">
                                                <label class="radio">
                                                    <input type="radio" class="flat-green interval" name="time_option" value="48h" <%if(g_time_option.equals("48h")){out.print("checked");}%>>&nbsp;Last 48 Hours
                                                </label>                                           
                                            </div><!-- /.checkbox-inline -->
                                            <!-- hidden option for user defined time interval -->
                                            <div class="radio-inline" style="display:none;">
                                                <label class="radio">
                                                    <input type="radio" class="flat-green interval" name="time_option" value="userdef" <%if(g_time_option.equals("userdef")){out.print("checked");}%>>&nbsp;User Defined
                                                </label>                                           
                                            </div><!-- /.checkbox-inline -->
                                        </div><!-- /.form-group -->
                                        

                                <div class="row">
                                    <div class="col-xs-12">
                                        <div class="row">
                                            <!-- Left side -->
                                            <div class="col-xs-6">
                                                <div class="row">
                                                    <div class="col-xs-12">
                                                        <div class="callout callout-info">
                                                            <h4>Refine Search Results By:</h4>
                                                        </div>
                                                    </div>

                                                    <!-- 1st column -->
                                                    <div class="col-xs-6">
                                                        <label class="control-label" for="user">User: </label>
                                                        <input type="text" class="form-control" id="user" name="user" value="<%= dao.user%>" >
                                                    </div>
                                                    <!-- 2nd column -->
                                                    <div class="col-xs-6">
                                                        <label class="control-label" for="clt_ip">Client IP: </label>
                                                        <input type="text" class="form-control" id="clt_ip" name="clt_ip" value="<%= dao.clt_ip%>" >
                                                    </div>

                                                    <!-- colspan 2 -->
                                                    <div class="col-xs-1">
                                                        <label>Signal: </span>
                                                    </div>
                                                    <div class="col-xs-11">
                                                        <div class="checkbox-inline">
                                                            <label class="checkbox">
                                                                <input type="checkbox" class="flat-red" name="signal_ping" <%if(dao.signal_ping){out.print("checked");}%> >&nbsp;Ping 
                                                            </label>
                                                        </div>
                                                        <div class="checkbox-inline">
                                                            <label class="checkbox">
                                                                <input type="checkbox" class="flat-red" name="signal_start" <%if(dao.signal_start){out.print("checked");}%> >&nbsp;Start 
                                                            </label>
                                                        </div>
                                                        <div class="checkbox-inline">
                                                            <label class="checkbox">
                                                                <input type="checkbox" class="flat-red" name="signal_stop" <%if(dao.signal_stop){out.print("checked");}%> >&nbsp;Stop 
                                                            </label>
                                                        </div>
                                                        <div class="checkbox-inline">
                                                            <label class="checkbox">
                                                                <input type="checkbox" class="flat-red" name="signal_ipupdate" <%if(dao.signal_ipupdate){out.print("checked");}%> >&nbsp;IPUpdate 
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
            
                                            <!-- Right side -->
                                            <div class="col-xs-6">
                                                <div class="row">
                                                    <!-- 3rd column -->
                                                    <div class="col-xs-6"></div>
                                                    <!-- 4th column -->
                                                    <div class="col-xs-6"></div>
                                                    <!-- colspan 2 -->
                                                    <div class="col-xs-12"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                        
                                </div><!-- /.box-body -->

                            <div class="box-footer">
                                <div class="btn-group">
                                    <button id="submitBtn" type="submit" form="search_form" class="btn btn-success margin">Submit</button>
                                    <button id="resetBtn" class="btn btn-info margin">Reset</button>
                                    <button id="clearBtn" class="btn btn-info margin">Clear</button>
                                </div>
                            </div>

                            </div><!-- /.box -->

                    </form><!-- end form -->

                    <!-- 2nd row -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid box-grey">
                                <div class="box-header">
                                    <i class="fa fa-list-alt"></i>
                                    <h3 class="box-title">Signal List</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <div class="row">
                                        <div class="col-md-4 col-md-offset-4">
                                            <!-- small box -->
                                            <div class="small-box bg-blue">
                                                <div class="inner">
                                                    <h3><%= g_count%></h3>
                                                    <p>Signals from: <br /><span class="Stime"></span>  ~  <span class="Etime"></span></p>
                                                </div>
                                                <div class="icon">
                                                    <i class="ion ion-radio-waves"></i>
                                                </div>
                                                <a href="#" class="small-box-footer">
                                                    <i class="fa fa-info-circle"></i> Search results limited to <%= dao.limit%> rows
                                                </a>
                                            </div>
                                        </div><!-- ./col -->
                                    </div><!-- ./row -->
                                    
                                    <!-- start table -->
                                    <table id="table" data-classes="table table-hover table-condensed" data-search="true" data-pagination="true">
                                        <thead>
                                        <tr>
                                            <th data-field="time" data-sortable="false">Time</th>
                                            <th data-field="user" data-sortable="true">User</th>
                                            <th data-field="client_ip" data-sortable="true">Client IP</th>
                                            <th data-field="signal" data-sortable="true">Signal</th>
                                        </tr>
                                        </thead>
                                    </table>

                                </div><!-- /.box-body -->

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
        <script src="../../js/plugins/tableExport/tableExport.js" type="text/javascript"></script>
        <script src="../../js/plugins/tableExport/FileSaver.min.js" type="text/javascript"></script>
        <script src="../../js/plugins/tableExport/html2canvas.js" type="text/javascript"></script>
        <script src="../../js/plugins/tableExport/bootstrap-table-Export.js" type="text/javascript"></script>
        <!-- datetimepicker -->
        <script src="../../js/plugins/datetimepicker/jquery.datetimepicker.js" type="text/javascript"></script>
        <script src="../../js/moment.min.js" type="text/javascript"></script>
    	<!-- TipueDrop Search -->
    	<script src="../../js/plugins/tipue/tipuedrop.min.js" type="text/javascript"></script>
        <!-- iCheck -->
        <script src="../../js/plugins/iCheck/icheck.min.js" type="text/javascript"></script>

        <!-- NxF App -->
        <script src="../../js/NxF/app.js" type="text/javascript"></script>

        <!-- Page script -->
        <script type="text/javascript">

var data = 
[
<%
List<SignalData> data_list = dao.select_list();

for(int i = 0; i < data_list.size(); i++){
    SignalData data = data_list.get(i);

    String fmt_ctime = strftime_new_fmt("yyyyMMddHHmm", "MM/dd HH:mm", data.ctime);
    
    // write data in json format for table.
    out.println("{\"time\": \"" + fmt_ctime + "\",\"user\": \"" + data.user + "\",\"client_ip\": \"" + data.clt_ip + "\",\"signal\": \"" + data.signal + "\"},");
}
%> 
]; 
                
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
                    document.forms["search_form"].action_flag.value = "submit";
                    document.getElementById("search_form").submit();
                    $(".Stime").text(stime);
                    $(".Etime").text(etime);        
                });
                
                $('#resetBtn').click(function() {
                    document.getElementById("search_form").reset();
                    $('input').iCheck('update');        
                });

                $('#clearBtn').click(function() {
                    $('input[type=text]').val("");
                    $('input').iCheck('uncheck');
                    $('input').iCheck('update');        
                });
                
                $('#search_form').submit(function(e) {
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

                $('#table').bootstrapTable({
                    data: data,
                    pageList: [10, 25, 50, "All"],
                    exportTypes: ['png', 'xml', 'csv', 'txt', 'sql', 'excel', 'doc'],
                    exportOptions: {fileName: 'NxFilter_Signal'}
                });

                jQuery('#stime').datetimepicker({
                    step:1,
                    mask:true,
                    theme:'dark'
                });
                jQuery('#etime').datetimepicker({
                    step:1,
                    mask:true,
                    theme:'dark'
                });

                 $('input[type="radio"][name="time_option"]').on('ifChanged', function(event){
                     var interval = $("input[name=time_option]:checked").val()
                     if(interval != undefined) {
                         //alert(event.type + " value = " + interval);
                         if (interval == "userdef") {
                             return;
                         }
                         if (interval == "2h") {
	                         var stime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').add('hours', -2).format('YYYY/MM/DD HH:mm');
	                         var etime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').format('YYYY/MM/DD HH:mm');
                         } else if (interval == "24h") {
	                         var stime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').add('hours', -24).format('YYYY/MM/DD HH:mm');
	                         var etime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').format('YYYY/MM/DD HH:mm');
                         } else if (interval == "48h") {
	                         var stime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').add('hours', -48).format('YYYY/MM/DD HH:mm');
	                         var etime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').format('YYYY/MM/DD HH:mm');
                         }
                         $('#stime').val(stime);
                         $('#etime').val(etime);
                     }
                 });

                 function initTimeOpt(timeOpt){
                     // check if page submitted. Get values from uri.
                     var flag = getUrlVars()["action_flag"];
                     if (flag == "submit") {
                         var param_stime = decodeURIComponent(getUrlVars()["stime"]);
                         var param_etime = decodeURIComponent(getUrlVars()["etime"]);
                         param_stime = param_stime.replace("+", " ");
                         param_etime = param_etime.replace("+", " ");
                         $(".Stime").html(param_stime);
                         $(".Etime").html(param_etime);
                         return;
                     }
                     var interval = timeOpt.val()
                     if(interval != undefined) {
                         if (interval == "userdef") {
                             return;
                         }
                         if (interval == "2h") {
	                         var stime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').add('hours', -2).format('YYYY/MM/DD HH:mm');
	                         var etime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').format('YYYY/MM/DD HH:mm');
                         } else if (interval == "24h") {
	                         var stime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').add('hours', -24).format('YYYY/MM/DD HH:mm');
	                         var etime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').format('YYYY/MM/DD HH:mm');
                         } else if (interval == "48h") {
	                         var stime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').add('hours', -48).format('YYYY/MM/DD HH:mm');
	                         var etime = moment('<%= g_curr_time12%>', 'YYYYMMDDHHmm').format('YYYY/MM/DD HH:mm');
                         }
                         $('#stime').val(stime);
                         $('#etime').val(etime);
                         $(".Stime").text(stime);
                         $(".Etime").text(etime);
                     }
                 } 
                 initTimeOpt($("input[name=time_option]:checked"));
                                  
                 $('#stime, #etime').on('change keyup paste', function() {
                     $('input[type="radio"][name="time_option"][value="userdef"]').prop('checked', true);
                     //alert("Value is " + $("input[name=time_option]:checked").val());
                     //$('.interval').prop('checked', false);
                     $('input').iCheck('update');
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

            // Read a page's GET URL variables and return them as an associative array.
            function getUrlVars() {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for(var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                return vars;
            }
        </script>
        
    </body>
</html>
