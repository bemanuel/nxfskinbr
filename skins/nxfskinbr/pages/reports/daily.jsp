<%@include file="../../include/lib.jsp"%>
<%
//-----------------------------------------------
// Set permission for this page.
permission.add_admin();

//Check permission.
if(!check_permission()){
	return;
}

// If there's a user it becomes user specific report.
String stime = param_str("stime");
String user = param_str("user");

// Create data access object.
D1ReportDao dao = new D1ReportDao(stime, user);
ReportStatsData stats = dao.get_stats();
ReportChartData request_trend = dao.get_request_trend();
ReportChartData domain_top = dao.get_domain_top(5);
ReportChartData category_top = dao.get_category_top(5);
ReportChartData user_top = dao.get_user_top(5);
ReportChartData clt_ip_top = dao.get_clt_ip_top(5);

// Global.
String g_stime = strftime_add("yyyyMMdd", -86400);
String g_stime_show = strftime_new_fmt("yyyyMMdd", "yyyy/MM/dd", dao.stime);

String g_time_option = param_str("time_option", "yesterday");
String g_user = param_str("user");
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Di&aacute;rio</title>
        <meta http-equiv='Expires' content='-1'> 
        <meta http-equiv='Pragma' content='no-cache'> 
        <meta http-equiv='Cache-Control' content='no-cache'>
        <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <link href="../../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="../../css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    	<link href="../../css/tipue/tipuedrop.css" rel="stylesheet" type="text/css" />
        <!-- datetimepicker -->
        <link href="../../css/datetimepicker/jquery.datetimepicker.css" rel="stylesheet" type="text/css" />
        <!-- iCheck for checkboxes and radio inputs -->
        <link href="../../css/iCheck/all.css" rel="stylesheet" type="text/css" />
        <!-- Ionicons -->
        <link href="../../css/ionicons.min.css" rel="stylesheet" type="text/css" />
        <!-- Morris chart -->
        <link href="../../css/morris/morris.css" rel="stylesheet" type="text/css" />

        <!-- Theme style -->
        <link href="../../css/NxF.css" rel="stylesheet" type="text/css" />

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js does not work if you view the page via file:// -->
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
                                        <%= get_admin_name()%> - NxF Skin BR 
                                        <small>Membro desde Fev. 2016</small>
                                    </p>
                                </li>
                                <!-- Menu Body -->

                                <!-- Menu Footer-->
                                <li class="user-footer">
                                    <div class="pull-left">
                                        <a href="../../pages/config/profile.jsp" class="btn btn-default btn-flat">Perfil</a>
                                    </div>
                                    <div class="pull-right">
                                        <a href="../../admin.jsp?action_flag=logout" class="btn btn-default btn-flat">Sair</a>
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
                            <p>Ol&aacute;, <%= get_admin_name()%></p>
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
                                <i class="fa fa-gears"></i> <span>Configura&ccedil;&atilde;o</span>
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
                                <i class="fa fa-user"></i> <span>Usu&aacute;rios/Grupos</span>
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
                                <i class="fa fa-pencil"></i> <span>Pol&iacute;ticas</span>
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
                                <i class="fa fa-book"></i> <span>Categorias</span>
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
                        <li class="treeview active">
                            <a href="#">
                                <i class="fa fa-bar-chart"></i>
                                <span>Relat&oacute;rios</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li class="active"><a href="../../pages/reports/daily.jsp"><i class="fa fa-angle-double-right"></i> Di&aacute;rio</a></li>
                                <li><a href="../../pages/reports/weekly.jsp"><i class="fa fa-angle-double-right"></i> Semanal</a></li>
                                <li><a href="../../pages/reports/usage.jsp"><i class="fa fa-angle-double-right"></i> Uso</a></li>
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
                                <i class="fa fa-power-off"></i> <span>Reiniciar</span>
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
                        Relat&oacute;rios
                        <small>Di&aacute;rio</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../../dashboard.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li><a href="#">Relat&oacute;rios</a></li>
                        <li class="active">Di&aacute;rio</li>
                    </ol>
                </section>


                <!-- Main content -->
                <section class="content">       
                	<div id="tipue_drop_content"></div>
                    <!-- start form -->
                    <form role="form" id="search_form" name="search_form" action="<%= get_page_name()%>" method="get">
                    <input type="hidden" name="action_flag" value="">
                  
                            <div class="box box-blue">
                                <div class="box-header">
                                    <i class="fa fa-clock-o"></i>
                                    <h3 class="box-title">Relat&oacute;rio Di&aacute;rio</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                   
                                        <div class="form-group">
                                            <label class="control-label col-xs-12">A partir de</label>
                                        </div>

                                        <div class="form-group">
                                            <div class="col-xs-12">
                                                <div class="form-inline">
                                                    <div class="form-group">
                                                        <input type="text" class="form-control" id="stime" name="stime" value="<%= dao.stime%>" maxlength="10">
                                                    </div>
                                                </div>
                                            </div>
                                        </div> 
                                        <p class="help-block">&nbsp;Formato da data - AAAAMMDD</p>
                                        <div class="form-group">
                                            <div style="display: none;" class="radio-inline" id="intervals">
                                                <label class="radio">
                                                    <input type="radio" class="flat-green interval" name="time_option" value="userdef" <%if(g_time_option.equals("userdef")){out.print("checked");}%>>&nbsp;Definido pelo Usu&aacute;rio
                                                </label>
                                            </div>
                                            <div class="radio-inline">
                                                <label class="radio">
                                                    <input type="radio" class="flat-green interval" name="time_option" value="yesterday" <%if(g_time_option.equals("yesterday")){out.print("checked");}%>>&nbsp;Ontem
                                                </label>
                                            </div>
                                            <div class="radio-inline">
                                                <label class="radio">
                                                    <input type="radio" class="flat-green interval" name="time_option" value="2days" <%if(g_time_option.equals("2days")){out.print("checked");}%>>&nbsp;2 Dias atr&aacute;s
                                                </label>
                                            </div>
                                            <div class="radio-inline">
                                                <label class="radio">
                                                    <input type="radio" class="flat-green interval" name="time_option" value="3days" <%if(g_time_option.equals("3days")){out.print("checked");}%>>&nbsp;3 Dias atr&aacute;s 
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
                                                            <h4>Filtrar por:</h4>
                                                        </div>
                                                    </div>
                                                    <!-- 1st column -->
                                                    <div class="col-xs-8">
                                                        <label class="control-label" for="user">Usu&aacute;rio </label>
                                                        <input type="text" class="form-control" id="user" name="user" value="<%= g_user%>" >
                                                    </div>
                                                    <!-- 3rd column -->
                                                    <div class="col-xs-4">
                                                        <label class="control-label" for="selUser">Logged Users:</label>
                                                        <select class="form-control" id="selUser" name="selUser" onchange="javascript:this.form.user.value=this.value">
			                                    <option value=''> Escolha usu&aacute;rio
<%
List<String> user_list = dao.get_log_user_list();
for(String uname : user_list){
	printf("<option value='%s'>%s", uname, uname);
}
%>
                                                        </select>
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
                                    <button id="submitBtn" type="submit" form="search_form" class="btn btn-success margin">Enviar</button>
                                    <button id="resetBtn" class="btn btn-warning margin">Limpar</button>
                                </div>
                            </div>

                            </div><!-- /.box -->

                    </form><!-- end form -->



                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-calendar"></i>
                                    <h3 class="box-title">
                                        Daily Report from: <%= g_stime_show%>
                                        <%
                                        if(!is_empty(g_user)){
	                                    out.print(" for " + g_user);
                                        }
                                        %>
                                    </h3>
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
                                           <div class="box box-solid bg-navy">
                                               <div class="box-body text-center">
                                                   <h3><%= stats.domain_cnt%> Domains</h3>
                                               </div><!-- /.box-body -->
                                           </div><!-- /.box -->
                                       </div><!-- /.col -->
                                       <div class="col-md-4">
                                           <!-- users tile -->
                                           <div class="box box-solid bg-navy">
                                               <div class="box-body text-center">
                                                   <h3><%= stats.user_cnt%> Users</h3>
                                               </div><!-- /.box-body -->
                                           </div><!-- /.box -->
                                       </div><!-- /.col -->
                                        <div class="col-md-4">
                                            <!-- client-ip time -->
                                            <div class="box box-solid bg-navy">
                                                <div class="box-body text-center">
                                                    <h3><%= stats.clt_ip_cnt%> Client IP's</h3>
                                                </div><!-- /.box-body -->
                                            </div><!-- /.box -->
                                        </div><!-- /.col -->
                                    </div><!-- /.row -->

                                    <!-- Stats knobs -->
                                    <div class="row">
                                        <div class="col-xs-2 col-md-3 text-center">
                                            <input type="text" class="knob" data-readonly="true" value="<%= stats.req_sum%>" data-min="0" data-max="<%= stats.req_sum%>" data-width="120" data-height="120" data-fgColor="#3c8dbc"/>
                                            <div class="knob-label">Total Requests</div>
                                        </div><!-- ./col -->
                                        <div class="col-xs-2 col-md-3 text-center">
                                            <input type="text" class="knob" data-readonly="true" value="<%= stats.req_cnt%>" data-min="0" data-max="<%= stats.req_cnt%>" data-width="120" data-height="120" data-fgColor="#85144b"/>
                                            <div class="knob-label">Unique Requests</div>
                                        </div><!-- ./col -->
                                        <div class="col-xs-2 col-md-3 text-center">
                                            <input type="text" class="knob" data-readonly="true" value="<%= stats.block_sum%>" data-min="0" data-max="<%= stats.block_sum%>" data-width="120" data-height="120" data-fgColor="#f56954"/>
                                            <div class="knob-label">Blocked Requests</div>
                                        </div><!-- ./col -->
                                        <div class="col-xs-2 col-md-3 text-center">
                                            <input type="text" class="knob" data-readonly="true" value="<%= stats.block_cnt%>" data-min="0" data-max="<%= stats.block_cnt%>" data-width="120" data-height="120" data-fgColor="#f012be"/>
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
                                    <i class="fa fa-line-chart"></i>
                                    <h3 class="box-title">Trend Charts</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <!-- requests row -->
                                    <div class="row">
                                        <!-- Left col -->
                                        <section class="col-lg-6 connectedSortable">
							
                                            <!-- Requests Chart -->
                                            <div class="box box-success">
                                                <div class="box-header">
                                                    <i class="fa fa-area-chart"></i>
                                                    <h3 class="box-title">Request Trend</h3>
                                                </div>
                                                <div class="box-body border-radius-none">
                                                    <div class="chart" id="trend-chart" style="height: 250px;"></div>                                    
                                                </div><!-- /.box-body -->
                                            </div><!-- /.box --> 

                                        </section><!-- /.Left col -->


                                        <!-- right col (We are only adding the ID to make the widgets sortable)-->
                                        <section class="col-lg-6 connectedSortable"> 

                                            <!-- Block Chart with tabs-->
                                            <div class="box box-danger">
                                                <div class="box-header">
                                                    <i class="fa fa-area-chart"></i>
                                                    <h3 class="box-title">Block Trend</h3>
                                                </div>
                                                <div class="box-body border-radius-none">
                                                    <div class="chart" id="blocked-chart" style="height: 250px;"></div>                                    
                                                </div><!-- /.box-body -->
                                            </div><!-- /.box -->                           

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
                                    <i class="fa fa-globe"></i>
                                    <h3 class="box-title">Top 5 Domains</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <!-- Left side -->
                                                <div class="col-xs-6">
                                                    <div id="chart_domain_top" style="height: 300px;"></div>
                                                </div>
            
                                                <!-- Right side -->
                                                <div class="col-xs-6">
                                                    <div id="chart_domain_block"  style="height: 300px;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div><!-- /.box-body -->
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->


                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-book"></i>
                                    <h3 class="box-title">Top 5 Categories</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <!-- Left side -->
                                                <div class="col-xs-6">
                                                    <div id="chart_category_top" style="height: 300px;"></div>
                                                </div>
            
                                                <!-- Right side -->
                                                <div class="col-xs-6">
                                                    <div id="chart_category_block" style="height: 300px;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div><!-- /.box-body -->
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->

                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-user"></i>
                                    <h3 class="box-title">Top 5 Users</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <!-- Left side -->
                                                <div class="col-xs-6">
                                                    <div id="chart_user_top" style="height: 300px;"></div>
                                                </div>
            
                                                <!-- Right side -->
                                                <div class="col-xs-6">
                                                    <div id="chart_user_block" style="height: 300px;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div><!-- /.box-body -->
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->

                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-desktop"></i>
                                    <h3 class="box-title">Top 5 Client IP's</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <!-- Left side -->
                                                <div class="col-xs-6">
                                                    <div id="chart_clt_ip_top" style="height: 300px;"></div>
                                                </div>
            
                                                <!-- Right side -->
                                                <div class="col-xs-6">
                                                    <div id="chart_clt_ip_block" style="height: 300px;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

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
        <!-- Morris.js charts -->
        <script src="../../js/raphael-min.js"></script>
        <script src="../../js/plugins/morris/morris.min.js" type="text/javascript"></script>
              
        <!-- jQuery Knob Chart -->
        <script src="../../js/plugins/jqueryKnob/jquery.knob.js" type="text/javascript"></script>

        <!-- datetimepicker -->
        <script src="../../js/plugins/datetimepicker/jquery.datetimepicker.js" type="text/javascript"></script>
        <script src="../../js/moment.min.js" type="text/javascript"></script>

    	<!-- TipueDrop Search -->
    	<script src="../../js/plugins/tipue/tipuedrop.min.js" type="text/javascript"></script>
    	
        <!-- iCheck -->
        <script src="../../js/plugins/iCheck/icheck.min.js" type="text/javascript"></script>

        <!-- NxF App -->
        <script src="../../js/NxF/app.js" type="text/javascript"></script>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>        
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
                    document.forms["search_form"].action_flag.value = "";
                    document.getElementById("search_form").submit();
                    $(".Etime").text(stime);        
                });
                
                $('#resetBtn').click(function() {
                    document.getElementById("search_form").reset();
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

            	$('#tipue_drop_input').tipuedrop({
                	'mode': 'json',
                	'contentLocation': '../../js/plugins/tipue/tipue_content.json'
            	});
            	
                jQuery('#stime').datetimepicker({
                    timepicker:false,
                    format:'Ymd',
                    theme:'dark'
                });

                 $('input[type="radio"][name="time_option"]').on('ifChanged', function(event){
                     var interval = $("input[name=time_option]:checked").val()
                     var stime = moment('<%= g_stime%>', 'YYYYMMDD').add(-24, 'hours').format('YYYYMMDD');
                     if(interval != undefined) {
                         //console.log("Changed interval = " + interval);
                         if (interval == "2days") {
	                         stime = moment('<%= g_stime%>', 'YYYYMMDD').add(-48, 'hours').format('YYYYMMDD');
                         } else if (interval == "3days") {
	                         stime = moment('<%= g_stime%>', 'YYYYMMDD').add(-72, 'hours').format('YYYYMMDD');
                         } else if (interval == "userdef") {
	                         stime = moment('<%= g_stime%>', 'YYYYMMDD').format('YYYYMMDD');
                         }
                     }
                     $('#stime').val(stime);
                 });

/*
                 function initTimeOpt(timeOpt){
                     var interval = timeOpt.val()
                     var stime = moment('<%= g_stime%>', 'YYYYMMDD').format('YYYYMMDD');
                     if(interval != undefined) {
                         //console.log("Init interval = " + interval);
                         if (interval == "2days") {
	                     stime = moment('<%= g_stime%>', 'YYYYMMDD').add(-24, 'hours').format('YYYYMMDD');
                         } else if (interval == "3days") {
	                     stime = moment('<%= g_stime%>', 'YYYYMMDD').add(-48, 'hours').format('YYYYMMDD');
                         } else if (interval == "userdef") {
	                     stime = moment('<%= g_stime%>', 'YYYYMMDD').format('YYYYMMDD');
                         }
                     }
                     $('#stime').val(stime);
                     $(".Etime").text(stime);
                 } 
                 initTimeOpt($("input[name=time_option]:checked"));
*/
                                  
                 $('#stime').on('change keyup paste', function() {
                     //console.log("Time changed " + $('#stime').val());
                     $('.interval')[0].checked = true;
                     //$('.interval').prop('checked', false);
                     $('input').iCheck('update');
                 });

            $(function() {
                /* jQueryKnob */

               $(".knob").knob({
                   /* change : function (value) {
                      console.log("change : " + value);
                   },
                   release : function (value) {
                      console.log("release : " + value);
                   },
                   cancel : function () {
                      console.log("cancel : " + this.value);
                   },*/
    
                   draw: function() {
                       // "tron" case
                       if (this.$.data('skin') == 'tron') {

                           var a = this.angle(this.cv)  // Angle
                               , sa = this.startAngle          // Previous start angle
                               , sat = this.startAngle         // Start angle
                               , ea                            // Previous end angle
                               , eat = sat + a                 // End angle
                               , r = true;

                           this.g.lineWidth = this.lineWidth;

                           this.o.cursor
                               && (sat = eat - 0.3)
                               && (eat = eat + 0.3);

                           if (this.o.displayPrevious) {
                               ea = this.startAngle + this.angle(this.value);
                               this.o.cursor
                                   && (sa = ea - 0.3)
                                   && (ea = ea + 0.3);
                               this.g.beginPath();
                               this.g.strokeStyle = this.previousColor;
                               this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, sa, ea, false);
                               this.g.stroke();
                           }

                           this.g.beginPath();
                           this.g.strokeStyle = r ? this.o.fgColor : this.fgColor;
                           this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, sat, eat, false);
                           this.g.stroke();

                           this.g.lineWidth = 2;
                           this.g.beginPath();
                           this.g.strokeStyle = this.o.fgColor;
                           this.g.arc(this.xy, this.xy, this.radius - this.lineWidth + 1 + this.lineWidth * 2 / 3, 0, 2 * Math.PI, false);
                           this.g.stroke();

                           return false;
                       }
                   }
               });
           });
           /* END JQUERY KNOB */         
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
            });
            

// Google charts
google.load("visualization", "1", {packages:["corechart"]});


// Draw domain top chart.
google.setOnLoadCallback(draw_domain_top);
function draw_domain_top() {
	var data = google.visualization.arrayToDataTable([
		['Domain', 'Request']
<%
arr_list = domain_top.get_data_list();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf(", ['%s', %s]", arr[0], arr[1]);
}
%>
	]);

	var options = {
		title: 'Top 5 Domains Requested',
        pieHole: 0.4
	};

	var chart = new google.visualization.PieChart(document.getElementById('chart_domain_top'));
	chart.draw(data, options);
}

// Draw domain block chart.
google.setOnLoadCallback(draw_domain_block);
function draw_domain_block() {
	var data = google.visualization.arrayToDataTable([
		['Domain', 'Block']
<%
arr_list = domain_top.get_data_list_blocked();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf(", ['%s', %s]", arr[0], arr[1]);
}
%>
	]);

	var options = {
		title: 'Top 5 Domains Blocked',
        pieHole: 0.4
	};

	var chart = new google.visualization.PieChart(document.getElementById('chart_domain_block'));
	chart.draw(data, options);
}

// Draw category top chart.
google.setOnLoadCallback(draw_category_top);
function draw_category_top() {
	var data = google.visualization.arrayToDataTable([
		['Category', 'Request']
<%
arr_list = category_top.get_data_list();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf(", ['%s', %s]", arr[0], arr[1]);
}
%>
	]);

	var options = {
		title: 'Top 5 category by request',
        pieHole: 0.4
	};

	var chart = new google.visualization.PieChart(document.getElementById('chart_category_top'));
	chart.draw(data, options);
}

// Draw category block chart.
google.setOnLoadCallback(draw_category_block);
function draw_category_block() {
	var data = google.visualization.arrayToDataTable([
		['Category', 'Block']
<%
arr_list = category_top.get_data_list_blocked();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf(", ['%s', %s]", arr[0], arr[1]);
}
%>
	]);

	var options = {
		title: 'Top 5 category by block',
        pieHole: 0.4
	};

	var chart = new google.visualization.PieChart(document.getElementById('chart_category_block'));
	chart.draw(data, options);
}

// Draw user top chart.
google.setOnLoadCallback(draw_user_top);
function draw_user_top() {
	var data = google.visualization.arrayToDataTable([
		['User', 'Request']
<%
arr_list = user_top.get_data_list();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf(", ['%s', %s]", arr[0], arr[1]);
}
%>
	]);

	var options = {
		title: 'Top 5 user by request',
        pieHole: 0.4
	};

	var chart = new google.visualization.PieChart(document.getElementById('chart_user_top'));
	chart.draw(data, options);
}

// Draw user block chart.
google.setOnLoadCallback(draw_user_block);
function draw_user_block() {
	var data = google.visualization.arrayToDataTable([
		['User', 'Block']
<%
arr_list = user_top.get_data_list_blocked();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf(", ['%s', %s]", arr[0], arr[1]);
}
%>
	]);

	var options = {
		title: 'Top 5 user by block',
        pieHole: 0.4
	};

	var chart = new google.visualization.PieChart(document.getElementById('chart_user_block'));
	chart.draw(data, options);
}

// Draw clt_ip top chart.
google.setOnLoadCallback(draw_clt_ip);
function draw_clt_ip() {
	var data = google.visualization.arrayToDataTable([
		['IP', 'Request']
<%
arr_list = clt_ip_top.get_data_list();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf(", ['%s', %s]", arr[0], arr[1]);
}
%>
	]);

	var options = {
		title: 'Top 5 client-ip by request',
        pieHole: 0.4
	};

	var chart = new google.visualization.PieChart(document.getElementById('chart_clt_ip_top'));
	chart.draw(data, options);
}

// Draw clt_ip block chart.
google.setOnLoadCallback(draw_clt_ip_block);
function draw_clt_ip_block() {
	var data = google.visualization.arrayToDataTable([
		['IP', 'Block']
<%
arr_list = clt_ip_top.get_data_list_blocked();
for(int i = 0; i < arr_list.size(); i++){
	String[] arr = arr_list.get(i);

	printf(", ['%s', %s]", arr[0], arr[1]);
}
%>
	]);

	var options = {
		title: 'Top 5 client-ip by block',
        pieHole: 0.4
	};

	var chart = new google.visualization.PieChart(document.getElementById('chart_clt_ip_block'));
	chart.draw(data, options);
}
        </script>

    </body>
</html>
