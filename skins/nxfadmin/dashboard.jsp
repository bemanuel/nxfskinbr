<%@include file="include/lib.jsp"%>
<%
//-----------------------------------------------
// Set permission for this page.
permission.add_admin();

//Check permission.
if(!check_permission()){
	return;
}
%>
<%
// end time
//String etime = param_str("etime");

// Create data access object for 24hr stats.
//H24ReportDao dao = new H24ReportDao(etime, "");

// If there's a user it becomes user specific report.
String stime = param_str("stime");

// Create data access object for 24hr stats.
D1ReportDao dao = new D1ReportDao(stime, "");
ReportStatsData stats24 = dao.get_stats();

// Create data access object for chart.
H2ReportDao report_dao = new H2ReportDao();
ReportStatsData stats = report_dao.get_stats();
ReportChartData request_trend = report_dao.get_request_trend();
ReportChartData domain_top = report_dao.get_domain_top(5);
ReportChartData category_top = report_dao.get_category_top(5);

// set max for jquery knobs.  Sometimes 2hr result can be higher than previous 24hr.
int rMaxSum = (stats.req_sum > stats24.req_sum) ? stats.req_sum : stats24.req_sum;
int rMaxCnt = (stats.req_cnt > stats24.req_cnt) ? stats.req_cnt : stats24.req_cnt;
int bMaxSum = (stats.block_sum > stats24.block_sum) ? stats.block_sum : stats24.block_sum;
int bMaxCnt = (stats.block_cnt > stats24.block_cnt) ? stats.block_cnt : stats24.block_cnt;


// Create data access object for blocked list.
RequestDao request_dao = new RequestDao();
request_dao.page = 1;
request_dao.limit = 10;
request_dao.stime = strftime_add("yyyyMMddHHmm", 60 * 60 * -12);  // 12 hours ago.
request_dao.etime = strftime("yyyyMMddHHmm");
request_dao.block_flag = true;

// Version check.
chk_new_version();
chk_new_message();

// Global.
String g_stime = strftime_new_fmt("yyyyMMddHHmm", "MM/dd HH:mm", report_dao.stime);
String g_etime = strftime_new_fmt("yyyyMMddHHmm", "MM/dd HH:mm", report_dao.etime);

// Get popup.
String popup_html = admin_login_dao.get_popup();
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Dashboard</title>
        <meta http-equiv='Expires' content='-1'> 
        <meta http-equiv='Pragma' content='no-cache'> 
        <meta http-equiv='Cache-Control' content='no-cache'>
        <!-- meta http-equiv="refresh" content="120" -->
        <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="css/tipue/tipuedrop.css" rel="stylesheet" type="text/css" />
        <!-- Ionicons -->
        <link href="css/ionicons.min.css" rel="stylesheet" type="text/css" />
        <!-- Morris chart -->
        <link href="css/morris/morris.css" rel="stylesheet" type="text/css" />

        <!-- Theme style -->
        <link href="css/NxF.css" rel="stylesheet" type="text/css" />

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
            <a href="dashboard.jsp" class="logo">
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
                                    <img src="img/avatar6.png" class="img-circle" alt="User Image" />
                                    <p>
                                        <%= get_admin_name()%> - NxF Admin
                                        <small>Member since Oct. 2014</small>
                                    </p>
                                </li>
                                <!-- Menu Body -->

                                <!-- Menu Footer-->
                                <li class="user-footer">
                                    <div class="pull-left">
                                        <a href="config,admin.jsp" class="btn btn-default btn-flat">Profile</a>
                                    </div>
                                    <div class="pull-right">
                                        <a href="admin.jsp?action_flag=logout" class="btn btn-default btn-flat">Sign out</a>
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
                            <img src="img/avatar6.png" class="img-circle" alt="User Image" />
                        </div>
                        <div class="pull-left info">
                            <p>Hello, <%= get_admin_name()%></p>
                        </div>
                    </div>
                    <!-- search form -->
                    <form action="pages/search.jsp" method="get" class="sidebar-form" name="search">
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
                        <li class="active">
                            <a href="dashboard.jsp">
                                <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                            </a>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-gears"></i> <span>Configuration</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="pages/config/config.jsp"><i class="fa fa-angle-double-right"></i> Settings</a></li>
                                <li><a href="pages/config/alert.jsp"><i class="fa fa-angle-double-right"></i> Alerts</a></li>
                                <li><a href="pages/config/block_page.jsp"><i class="fa fa-angle-double-right"></i> Block Page</a></li>
                                <li><a href="pages/config/allowed_ip.jsp"><i class="fa fa-angle-double-right"></i> Allowed IP's</a></li>
                                <li><a href="pages/config/redirection.jsp"><i class="fa fa-angle-double-right"></i> Redirection</a></li>
                                <li><a href="pages/config/zone_transfer.jsp"><i class="fa fa-angle-double-right"></i> Zone Transfer</a></li>
                                <li><a href="pages/config/cluster.jsp"><i class="fa fa-angle-double-right"></i> Cluster</a></li>
                                <li><a href="pages/config/backup.jsp"><i class="fa fa-angle-double-right"></i> Backup</a></li>
                                <li><a href="pages/config/profile.jsp"><i class="fa fa-angle-double-right"></i> Profile</a></li>
                            </ul>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-user"></i> <span>Users & Groups</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="pages/directory/users.jsp"><i class="fa fa-angle-double-right"></i> Users</a></li>
                                <li><a href="pages/directory/groups.jsp"><i class="fa fa-angle-double-right"></i> Groups</a></li>
                                <li><a href="pages/directory/ad.jsp"><i class="fa fa-angle-double-right"></i> Active Directory</a></li>
                                <li><a href="pages/directory/ldap.jsp"><i class="fa fa-angle-double-right"></i> LDAP</a></li>
                            </ul>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-pencil"></i> <span>Policies</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="pages/policies/policy.jsp"><i class="fa fa-angle-double-right"></i> Policy</a></li>
                                <li><a href="pages/policies/free_time.jsp"><i class="fa fa-angle-double-right"></i> Free Time</a></li>
                                <li><a href="pages/policies/application.jsp"><i class="fa fa-angle-double-right"></i> Application</a></li>
                                <li><a href="pages/policies/proxy.jsp"><i class="fa fa-angle-double-right"></i> Proxy</a></li>
                            </ul>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-book"></i> <span>Categories</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="pages/categories/custom.jsp"><i class="fa fa-angle-double-right"></i> Custom</a></li>
                                <li class="treeview">
                                    <a href="#">
                                        <i class="fa fa-angle-double-right"></i> <span>Whitelists</span>
                                        <i class="fa fa-angle-left pull-right"></i>
                                    </a>
                                    <ul class="treeview-menu">
                                        <li><a href="pages/categories/domain.jsp"><i class="fa fa-angle-double-right"></i> By Domain</a></li>
                                        <li><a href="pages/categories/keyword.jsp"><i class="fa fa-angle-double-right"></i> By Keyword</a></li>
                                    </ul>
                                </li>
                                <li><a href="pages/categories/system.jsp"><i class="fa fa-angle-double-right"></i> System</a></li>
                                <li><a href="pages/categories/domain_test.jsp"><i class="fa fa-angle-double-right"></i> Domain Test</a></li>
                            </ul>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-bar-chart"></i>
                                <span>Reports</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="pages/reports/daily.jsp"><i class="fa fa-angle-double-right"></i> Daily</a></li>
                                <li><a href="pages/reports/weekly.jsp"><i class="fa fa-angle-double-right"></i> Weekly</a></li>
                                <li><a href="pages/reports/usage.jsp"><i class="fa fa-angle-double-right"></i> Usage</a></li>
                            </ul>
                        </li>
                        <li class="treeview">
                            <a href="#">
                                <i class="fa fa-folder-open"></i> <span>Logs</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="pages/logs/requests.jsp"><i class="fa fa-angle-double-right"></i> Requests</a></li>
                                <li><a href="pages/logs/signal.jsp"><i class="fa fa-angle-double-right"></i> Signal</a></li>
                                <li><a href="pages/logs/netflow.jsp"><i class="fa fa-angle-double-right"></i> Netflow</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="pages/system/restart.jsp">
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
                        Dashboard
                        <small>Control panel</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li class="active">Dashboard</li>
                    </ol>
                </section>


                <!-- Main content -->
                <section class="content">       
                    <div id="tipue_drop_content"></div>
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-calendar"></i>
                                    <h3 class="box-title">Statistics from: <%= g_stime%> ~ <%= g_etime%></h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                        <button class="btn btn-default btn-sm" data-widget="remove"><i class="fa fa-times"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <!-- Stats tiles -->
                                    <div class="row">
                                       <div class="col-md-4">
                                           <!-- domains tile -->
                                           <div class="box box-solid bg-olive">
                                               <div class="box-body text-center">
                                                   <h3><%= stats.domain_cnt%> Domains</h3>
                                               </div><!-- /.box-body -->
                                           </div><!-- /.box -->
                                       </div><!-- /.col -->
                                       <div class="col-md-4">
                                           <!-- users tile -->
                                           <div class="box box-solid bg-olive">
                                               <div class="box-body text-center">
                                                   <h3><%= stats.user_cnt%> Users</h3>
                                               </div><!-- /.box-body -->
                                           </div><!-- /.box -->
                                       </div><!-- /.col -->
                                        <div class="col-md-4">
                                            <!-- client-ip time -->
                                            <div class="box box-solid bg-olive">
                                                <div class="box-body text-center">
                                                    <h3><%= stats.clt_ip_cnt%> Client IP's</h3>
                                                </div><!-- /.box-body -->
                                            </div><!-- /.box -->
                                        </div><!-- /.col -->
                                    </div><!-- /.row -->

                                    <!-- Stats knobs -->
                                    <div class="row">
                                        <div class="col-xs-2 col-md-3 text-center">
                                            <input type="text" class="knob" data-skin="tron" data-readonly="true" value="<%= stats.req_sum%>" data-min="0" data-max="<%= rMaxSum %>" data-width="120" data-height="120" data-thickness="0.2" data-fgColor="#3c8dbc"/>
                                            <div class="knob-label">New Requests</div>
                                        </div><!-- ./col -->
                                        <div class="col-xs-2 col-md-3 text-center">
                                            <input type="text" class="knob" data-skin="tron" data-readonly="true" value="<%= stats.req_cnt%>" data-min="0" data-max="<%= rMaxCnt %>" data-width="120" data-height="120" data-thickness="0.2" data-fgColor="#85144b"/>
                                            <div class="knob-label">Domains Requested</div>
                                        </div><!-- ./col -->
                                        <div class="col-xs-2 col-md-3 text-center">
                                            <input type="text" class="knob" data-skin="tron"  data-readonly="true" value="<%= stats.block_sum%>" data-min="0" data-max="<%= bMaxSum %>" data-width="120" data-height="120" data-thickness="0.2" data-fgColor="#f56954"/>
                                            <div class="knob-label">Blocked Requests</div>
                                        </div><!-- ./col -->
                                        <div class="col-xs-2 col-md-3 text-center">
                                            <input type="text" class="knob" data-skin="tron" data-readonly="true" value="<%= stats.block_cnt%>" data-min="0" data-max="<%= bMaxCnt %>" data-width="120" data-height="120" data-thickness="0.2" data-fgColor="#f012be"/>
                                            <div class="knob-label">Blocked Domains</div>
                                        </div><!-- ./col -->
                                    </div><!-- /.row -->

                                </div><!-- /.box-body -->
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->


                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-pie-chart"></i>
                                    <h3 class="box-title">Activity Trends</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                        <button class="btn btn-default btn-sm" data-widget="remove"><i class="fa fa-times"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <!-- requests row -->
                                    <div class="row">
                                        <!-- Left col -->
                                        <section class="col-lg-6 connectedSortable">
							
                                            <!-- Requests Chart with tabs-->
                                            <div class="nav-tabs-custom">
                                                <!-- Tabs within a box -->
                                                <ul class="nav nav-tabs pull-right">
                                                    <li class="active"><a href="#trend-chart" data-toggle="tab" data-identifier="area">Graph</a></li>
                                                    <li><a href="#top5-domain-chart" data-toggle="tab" data-identifier="donut">Top 5 Domains</a></li>
                                                    <li><a href="#top5-cat-chart" data-toggle="tab" data-identifier="donut">Top 5 Categories</a></li>
                                                    <li class="pull-left header"><i class="fa fa-area-chart"></i> Requests</li>
                                                </ul>
                                                <div class="tab-content no-padding">
                                                    <!-- Morris chart - trends -->
                                                    <div class="chart tab-pane active" id="trend-chart" style="position: relative; height: 300px;"></div>
                                                    <div class="chart tab-pane" id="top5-domain-chart" style="position: relative; height: 300px;"></div>
                                                    <div class="chart tab-pane" id="top5-cat-chart" style="position: relative; height: 300px;"></div>
                                                </div>
                                            </div><!-- /.nav-tabs-custom -->

                                        </section><!-- /.Left col -->


                                        <!-- right col (We are only adding the ID to make the widgets sortable)-->
                                        <section class="col-lg-6 connectedSortable"> 

                                            <!-- Block Chart with tabs-->
                                            <div class="nav-tabs-custom">
                                                <!-- Tabs within a box -->
                                                <ul class="nav nav-tabs pull-right">
                                                    <li class="active"><a href="#blocked-chart" data-toggle="tab" data-identifier="area">Graph</a></li>
                                                    <li><a href="#top5-domain-block" data-toggle="tab" data-identifier="donut">Top 5 Domains</a></li>
                                                    <li><a href="#top5-cat-block" data-toggle="tab" data-identifier="donut">Top 5 Categories</a></li>
                                                    <li class="pull-left header"><i class="fa fa-area-chart"></i> Blocked</li>
                                                </ul>
                                                <div class="tab-content no-padding">
                                                    <!-- Morris chart - trends -->
                                                    <div class="chart tab-pane active" id="blocked-chart" style="position: relative; height: 300px;"></div>
                                                    <div class="chart tab-pane" id="top5-domain-block" style="position: relative; height: 300px;"></div>
                                                    <div class="chart tab-pane" id="top5-cat-block" style="position: relative; height: 300px;"></div>
                                                </div>
                                            </div><!-- /.nav-tabs-custom -->                           

                                        </section><!-- right col -->
                                    </div><!-- /.row (request row) -->

                                </div><!-- /.box-body -->
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->


                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-table"></i>
                                    <h3 class="box-title">Recent Blocked Activity</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                        <button class="btn btn-default btn-sm" data-widget="remove"><i class="fa fa-times"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <!-- Most Recent Blocked Activity Table -->
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="box">

                                                <div class="box-body table-responsive no-padding">
                                                    <table class="table table-hover">
                                                        <tr>
                                                            <th>Time</th>
                                                            <th>Blocked</th>
                                                            <th>Count</th>
                                                            <th>Type</th>
                                                            <th>Domain</th>
                                                            <th>User</th>
                                                            <th>Client IP</th>
                                                            <th>Group</th>
                                                            <th>Policy</th>
                                                            <th>Category</th>
                                                            <th>Reason Blocked</th>
                                                        </tr>
<%
List<RequestData> data_list = request_dao.select_list();
//if(data_list.isEmpty()){
//	out.println("                                                        <tr class='row'>");
//	out.println("                                                            <td colspan='11' align='center'>No data</td>");
//	out.println("                                                        </tr>");
//}

for(int i = 0; i < data_list.size(); i++){
	RequestData recent = data_list.get(i);

	String fmt_ctime = strftime_new_fmt("yyyyMMddHHmm", "MM/dd HH:mm", recent.ctime);

	// Only first category.
	String category_line = recent.category.replaceFirst(",.*", "");

	// Only first grp.
	String grp_line = recent.grp.replaceFirst(",.*", "");
%>
                                                        <tr>
                                                            <td><%= fmt_ctime%></td>
                                                            <td><%= recent.get_block_yn()%></td>
                                                            <td><%= recent.cnt%></td>
                                                            <td><%= recent.get_type_code()%></td>
                                                            <td><a href='javascript:window_open("http://" + "<%= recent.domain%>")'><%= recent.domain%></a></td>
                                                            <td><%= recent.user%></td>
                                                            <td><%= recent.clt_ip%></td>
                                                            <td title='<%= recent.grp%>'><%= grp_line%></td>
                                                            <td><%= recent.policy%></td>
                                                            <td title='<%= recent.category%>'><%= category_line%></td>
                                                            <td><%= recent.get_reason()%></td>
                                                        </tr>
<%}%>

                                                    </table>
                                                </div><!-- /.box-body -->
                                            </div><!-- /.box -->
                                        </div>
                                    </div><!-- /.row -->

                                </div><!-- /.box-body -->
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->

                </section><!-- /.content -->
            </aside><!-- /.right-side -->
        </div><!-- ./wrapper -->


        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.min.js" type="text/javascript"></script>
        <script src="js/jquery-ui.min.js" type="text/javascript"></script>
        <script src="js/jquery.noty.packaged.min.js" type="text/javascript" ></script>
        <!-- Morris.js charts -->
        <script src="js/raphael-min.js"></script>
        <script src="js/plugins/morris/morris.min.js" type="text/javascript"></script>
        
        <!-- Sparkline -->
        <script src="js/plugins/sparkline/jquery.sparkline.min.js" type="text/javascript"></script>
       
        <!-- jQuery Knob Chart -->
        <script src="js/plugins/jqueryKnob/jquery.knob.js" type="text/javascript"></script>

        <!-- FLOT CHARTS -->
        <script src="js/plugins/flot/jquery.flot.min.js" type="text/javascript"></script>
        <!-- FLOT RESIZE PLUGIN - allows the chart to redraw when the window is resized -->
        <script src="js/plugins/flot/jquery.flot.resize.min.js" type="text/javascript"></script>
        <!-- FLOT PIE PLUGIN - also used to draw donut charts -->
        <script src="js/plugins/flot/jquery.flot.pie.min.js" type="text/javascript"></script>
        <!-- FLOT CATEGORIES PLUGIN - Used to draw bar charts -->
        <script src="js/plugins/flot/jquery.flot.categories.min.js" type="text/javascript"></script>

        <!-- TipueDrop Search -->
        <script src="js/plugins/tipue/tipuedrop.min.js" type="text/javascript"></script>

        <!-- NxF App -->
        <script src="js/NxF/app.js" type="text/javascript"></script>

        <!-- NxF dashboard js -->
        <script src="js/NxF/dashboard.js" type="text/javascript"></script>

        <!-- Page script -->
        <script type="text/javascript">
            
            $(document).ready(function () {
                var errmsg = "";
                var succmsg = "";
                <%@include file="include/messages.jsp"%>
                
                if (errmsg != null && !(errmsg === "")) {
                    //generateDiv('div#notifications', 'error', errmsg, 'topCenter');
                    generate('error', errmsg, 'topCenter');
                }
                if (succmsg != null && !(succmsg === "")) {
                    //generateDiv('div#notifications', 'success', succmsg, 'topCenter');
                    generate('success', succmsg, 'topCenter');
                }
                $('#tipue_drop_input').tipuedrop({
                    'mode': 'json',
                    'contentLocation': 'js/plugins/tipue/tipue_content.json'
                });             
            });

                //Fix for charts under tabs
                $('.box ul.nav a').on('shown.bs.tab', function(e) {
                    var types = $(this).attr("data-identifier");
                    var typesArray = types.split(",");
                    $.each(typesArray, function (key, value) {
                        eval(value + ".redraw()");
                    })
                 });

            $(function() {
                /* Morris.js Charts */
                // Request trend chart
                var area = new Morris.Area({
                    element: 'trend-chart',
                    resize: true,
                    smooth: false,
                    parseTime: false,
                    data: [
<%
List<String[]> arr_list = request_trend.get_data_list();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf("{y: '%s', requests: %s},", arr[0], arr[1]);
}
%>
                    ],
                    xkey: 'y',
                    ykeys: ['requests'],
                    labels: ['Requests'],
                    lineColors: ['#3c8dbc'],
                    hideHover: 'auto'
                });


                //top 5 domain Donut Chart
                var donut = new Morris.Donut({
                    element: 'top5-domain-chart',
                    resize: true,
                    colors: ["#3c8dbc", "#f56954", "#00a65a", "#932ab6", "#ff851b"],
                    data: [
<%
arr_list = domain_top.get_data_list();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf("{label: '%s', value: %s},", arr[0], arr[1]);
}
%>
                    ],
                    hideHover: 'auto'
                });

                //top 5 category Chart
                var donut = new Morris.Donut({
                    element: 'top5-cat-chart',
                    resize: true,
                    colors: ["#3c8dbc", "#f56954", "#00a65a", "#932ab6", "#ff851b"],
                    data: [
<%
arr_list = category_top.get_data_list();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf("{label: '%s', value: %s},", arr[0], arr[1]);
}
%>
                    ],
                    hideHover: 'auto'
                });


                // Block trend chart
                var area = new Morris.Area({
                    element: 'blocked-chart',
                    resize: true,
                    smooth: false,
                    parseTime: false,
                    data: [
<%
arr_list = request_trend.get_data_list_blocked();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);
	printf("{y: '%s', requests: %s},", arr[0], arr[1]);
}
%>
                    ],
                    xkey: 'y',
                    ykeys: ['requests'],
                    labels: ['Blocked'],
                    lineColors: ['#bc3c3c'],
                    hideHover: 'auto'
                });


                //top 5 blocked domain Donut 
                var donut = new Morris.Donut({
                    element: 'top5-domain-block',
                    resize: true,
                    colors: ["#3c8dbc", "#f56954", "#00a65a", "#932ab6", "#ff851b"],
                    data: [
<%
arr_list = domain_top.get_data_list_blocked();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);
	printf("{label: '%s', value: %s},", arr[0], arr[1]);
}
%>
                    ],
                    hideHover: 'auto'
                });

				//top 5 category blocked donut
                var donut = new Morris.Donut({
                    element: 'top5-cat-block',
                    resize: true,
                    colors: ["#3c8dbc", "#f56954", "#00a65a", "#932ab6", "#ff851b"],
                    data: [
<%
arr_list = category_top.get_data_list_blocked();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);
	printf("{label: '%s', value: %s},", arr[0], arr[1]);
}
%>
                    ],
                    hideHover: 'auto'
                });

            });

        </script>
        
<%= popup_html%>
    </body>
</html>
