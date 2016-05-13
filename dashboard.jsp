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

// Global.
//String g_stime = strftime_new_fmt("yyyyMMddHHmm", "MM/dd HH:mm", report_dao.stime);
//String g_etime = strftime_new_fmt("yyyyMMddHHmm", "MM/dd HH:mm", report_dao.etime);

// Get popup.
//String popup_html = admin_login_dao.get_popup();
%>

<!DOCTYPE html>
<html>

<head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="Alisson">

        <link rel="shortcut icon" href="assets/images/favicon_1.ico">
        <!--Morris C3 CSS -->
        <link href="assets/plugins/c3/c3.css" rel="stylesheet" type="text/css"  />
        <!--Morris Chart CSS -->
        <link rel="stylesheet" href="assets/plugins/morris/morris.css">

        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Dashboard</title>

        <!-- Sweet Alert CSS -->
        <link href="assets/plugins/sweetalert/dist/sweetalert.css" rel="stylesheet" type="text/css">

        <link href="assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="assets/css/core.css" rel="stylesheet" type="text/css" />
        <link href="assets/css/components.css" rel="stylesheet" type="text/css" />
        <link href="assets/css/icons.css" rel="stylesheet" type="text/css" />
        <link href="assets/css/pages.css" rel="stylesheet" type="text/css" />
        <link href="assets/css/responsive.css" rel="stylesheet" type="text/css" />

        <!-- HTML5 Shiv and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
        <![endif]-->
<!-- LOOP PAGE
        <script src="assets/js/modernizr.min.js"></script>

        <script language="JavaScript">

           window.onload=function(){

              setTimeout("window.location='dashboard.jsp'", 4000) 

           }

        </script> -->

    </head>


    <body class="fixed-left">

        <div class="bg-img-main"></div>

        <!-- Begin page -->
        <div id="wrapper">

            <!-- Top Bar Start -->
            <div class="topbar">

                <!-- LOGO -->
                <div class="topbar-left">
                    <div class="text-center">
                        <a href="dashboard.jsp" class="logo"><i class="icon-c-logo"></i><span><strong class="text-danger">NX</strong>Filter</span></a>
                    </div>
                </div>

                <!-- Button mobile view to collapse sidebar menu -->
                <div class="navbar navbar-default" role="navigation">
                    <div class="container">
                        <div class="">
                            <div class="pull-left">
                                <button class="button-menu-mobile open-left">
                                    <i class="ion-navicon"></i>
                                </button>
                                <span class="clearfix"></span>
                            </div>

                            <form role="search" class="navbar-left app-search pull-left hidden-xs">
			                     <input type="text" placeholder="Buscar" class="form-control">
			                     <a href="#"><i class="fa fa-search"></i></a>
			                </form>


                            <ul class="nav navbar-nav navbar-right pull-right">
                                <li class="hidden-xs">
                                    <a href="#" id="btn-fullscreen" class="waves-effect"><i class="icon-size-fullscreen"></i></a>
                                </li>
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle profile waves-effect" data-toggle="dropdown" aria-expanded="true"><img src="assets/images/users/avatar-men.jpg" alt="user-img" class="img-circle"> </a>
                                    <ul class="dropdown-menu">
                                        <li><a href="admin.jsp?action_flag=logout"><i class="ti-power-off m-r-5"></i> Sair</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <!--/.nav-collapse -->
                    </div>
                </div>
            </div>
            <!-- Top Bar End -->


            <!-- ========== Left Sidebar Start ========== -->

            <div class="left side-menu">
                <div class="sidebar-inner slimscrollleft">
                    <!--- Divider -->
                    <div id="sidebar-menu">
                        <ul>

                        	<li class="text-muted menu-title">Navega&ccedil;&atilde;o</li>

                            <li class="has_sub">
                                <a href="dashboard.jsp" class="waves-effect waves-light active"><i class="ti-home"></i> <span> Dashboard </span> </a>
                            </li>

                            <li class="has_sub">
                                <a href="#" class="waves-effect waves-light"><i class=" ti-settings"></i> <span> Configura&ccedil;&atilde;o </span> </a>
                                <ul class="list-unstyled">
                                    <li><a href="pages/setup.jsp">Propriedades</a></li>
                                    <li><a href="pages/profile.jsp">Perfil</a></li>
                                    <li><a href="pages/alert">Alertas</a></li>
                                    <li><a href="pages/allowed_ip.jsp">IP's Permitidos</a></li>
                                    <li><a href="pages/dns,redirection.jsp">Redirecionamento</a></li>
                                    <li><a href="pages/dns,zone_transfer.jsp">Transfer&ecirc;ncia de Zona</a></li>
                                    <li><a href="pages/backup.jsp">Backup</a></li>
                                    <li><a href="pages/block_pages">P&aacute;ginas de Bloqueio</a></li>
                                    <li><a href="pages/cluster.jsp">Cluster</a></li>
                                </ul>
                            </li>

                            <li class="has_sub">
                                <a href="#" class="waves-effect waves-light"><i class=" ti-user"></i> <span> Usu&aacute;rios/Grupos </span> </a>
                                <ul class="list-unstyled">
                                	<li><a href="pages/user,user.jsp">Usu&aacute;rios</a></li>
                                    <li><a href="pages/user,group.jsp">Grupos</a></li>
                                    <li><a href="pages/user,adap.jsp">Active Directory</a></li>
                                    <li><a href="pages/user,ldap.jsp">LDAP</a></li>
                                </ul>
                            </li>

                            <li class="has_sub">
                                <a href="#" class="waves-effect waves-light"><i class="ti-pencil"></i><span> Pol&iacute;ticas & Regras </span></a>
                                <ul class="list-unstyled">
                                    <li><a href="pages/policy,policy.jsp">Pol&iacute;ticas</a></li>
                                    <li><a href="pages/policy,free_time.jsp">Tempo Gr&aacute;tis</a></li>
                                    <li><a href="pages/policy,application.jsp">Controle de Aplica&ccedil;&atilde;o</a></li>
                                    <li><a href="pages/policy,proxy.jsp">Filtro Proxy</a></li>
                                </ul>
                            </li>

                            <li class="has_sub">
                                <a href="#" class="waves-effect waves-light"><i class=" ti-layers-alt"></i><span> Categorias </span></a>
                                <ul class="list-unstyled">
                                    <li><a href="pages/category,system.jsp">Categoria do Sistema</a></li>
                                    <li><a href="pages/category,custom.jsp">Categorias Personalizadas</a></li>
                                    <li><a href="pages/category,domain_test.jsp">Teste de Dom&iacute;nio</a></li>
                                </ul>
                            </li>

                            <li class="has_sub">
                                <a href="#" class="waves-effect waves-light"><i class="ti-bar-chart"></i><span> Relat&oacute;rios </span></a>
                                <ul class="list-unstyled">
                                	<li><a href="pages/report,daily.jsp">Di&aacute;rio</a></li>
                                    <li><a href="pages/report,weekly.jsp">Semanal</a></li>
                                    <li><a href="pages/report,usage.jsp">Uso</a></li>
                                </ul>
                            </li>

                            <li class="has_sub">
                                <a href="#" class="waves-effect waves-light"><i class="ti-server"></i><span> Logs </span></a>
                                <ul class="list-unstyled">
                                    <li><a href="pages/logging,request.jsp">Requisi&ccedil;&otilde;<element></element>s</a></li>
                                    <li><a href="pages/logging,signal.jsp">Sinal</a></li>
                                    <li><a href="pages/logging,netflow.jsp">Netflow</a></li>
                                </ul>
                            </li>
                        </ul>
                        <div class="clearfix"></div>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
            <!-- Left Sidebar End -->



            <!-- ============================================================== -->
            <!-- Start right Content here -->
            <!-- ============================================================== -->
            <div class="content-page">
                <!-- Start content -->
                <div class="content">
                    <div class="container">

                        <!-- Page-Title -->
                        <div class="row">
                            <div class="col-sm-12">
                                <h4 class="page-title">Dashboard</h4>
                                <p class="text-muted page-title-alt">Bem Vindo NXFilter admin!</br>Estat&iacute;sticas: <%= report_dao.get_stime()%> ~ <%= report_dao.get_etime()%></p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 col-lg-3">
                                <div class="widget-bg-color-icon card-box fadeInDown animated">
                                    <div class="bg-icon bg-icon-custom pull-left">
                                        <i class="md-language text-custom"></i>
                                    </div>
                                    <div class="text-center">
                                        <h3 class=""><b class="counter"><%= stats.domain_cnt%></b></h3>
                                        <p class="text-muted">Dom&iacute;nios</p>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>
                            </div>

                            <div class="col-md-6 col-lg-3">
                                <div class="widget-bg-color-icon card-box">
                                    <div class="bg-icon bg-icon-success pull-left">
                                        <i class="md-people text-success"></i>
                                    </div>
                                    <div class="text-center">
                                        <h3 class=""><b class="counter"><%= stats.user_cnt%></b></h3>
                                        <p class="text-muted">Usu&aacute;rios</p>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>
                            </div>

                            <div class="col-md-6 col-lg-3">
                                <div class="widget-bg-color-icon card-box">
                                    <div class="bg-icon bg-icon-info pull-left">
                                        <i class="md-contacts text-info"></i>
                                    </div>
                                    <div class="text-center">
                                        <h3 class=""><b class="counter"><%= stats.clt_ip_cnt%></b></h3>
                                        <p class="text-muted">IP's Cliente</p>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>
                            </div>

                            <div class="col-md-6 col-lg-3">
                                <div class="widget-bg-color-icon card-box">
                                    <div class="bg-icon bg-icon-warning pull-left">
                                        <i class="md-remove-red-eye text-warning"></i>
                                    </div>
                                    <div class="text-right">
                                        <h3 class=""><b class="counter"><%= stats.req_sum%></b></h3>
                                        <p class="text-muted">Total de Requisi&ccedil;&otilde;os</p>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>
                            </div>
                        </div>
                        <!-- end row -->

                        <div class="row">
							<div class="col-lg-6">
								<div class="card-box">
									<h4 class="m-t-0 m-b-30 header-title"><b>Requisi&ccedil;&otilde;es</b></h4>
									
									<div id="chart-req"></div>
								</div>
							</div>
							<div class="col-lg-6">
								<div class="card-box">
									<h4 class="m-t-0 m-b-30 header-title"><b>Bloqueados</b></h4>
									
									<div id="chart-block"></div>
								</div>
							</div>							
						</div>
						<!-- end row -->

						<div class="row">
							<div class="col-lg-3">
								<div class="card-box">
									<h4 class="m-t-0 m-b-30 header-title"><b>Top 5 dom&iacute;nios</b></h4>
									
									<div id="top5-domain-chart"></div>
								</div>
							</div>
							
							
							<div class="col-lg-3">
								<div class="card-box">
									<h4 class="m-t-0 m-b-30 header-title"><b>Top 5 dom&iacute;nios Bloqueados</b></h4>
									
									<div id="pie-chart-top5-dominios-block"></div>
								</div>
							</div>
							<div class="col-lg-3">
								<div class="card-box">
									<h4 class="m-t-0 m-b-30 header-title"><b>Top 5 Categorias</b></h4>
									
									<div id="pie-chart-top5-categorias"></div>
								</div>
							</div>
							<div class="col-lg-3">
								<div class="card-box">
									<h4 class="m-t-0 m-b-30 header-title"><b>Top 5 Categorias Bloqueadas</b></h4>
									
									<div id="pie-chart-top5-categorias-block"></div>
								</div>
							</div>
						</div>
						<!-- End row -->

                        

                        <div class="row">
                            <div class="col-lg-12">
                            	<div class="portlet"><!-- /primary heading -->
                            <div class="portlet-heading">
                                <h3 class="portlet-title text-uppercase">
                                    Bloqueios Recentes
                                </h3>
                                <div class="portlet-widgets">
                                    <span class="divider"></span>
                                    <a data-toggle="collapse" data-parent="#accordion1" href="#portlet2"><i class="ion-minus-round"></i></a>
                                    <span class="divider"></span>
                                    <a href="#" data-toggle="remove"><i class="ion-close-round"></i></a>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div id="portlet2" class="panel-collapse collapse in">
                                <div class="portlet-body">
                                    <div class="table-responsive">
                                        <table class="table">
                                                        <tr>
                                                            <th>Time</th>
                                                            <th>Bloqueado</th>
                                                            <th>Contagem</th>
                                                            <th>Tipo</th>
                                                            <th>Dom&iacute;nio</th>
                                                            <th>Usu&aacute;rio</th>
                                                            <th>IP Origem</th>
                                                            <th>Grupo</th>
                                                            <th>Pol&iacute;tica</th>
                                                            <th>Categoria</th>
                                                            <th>Motivo Bloqueio</th>
                                                        </tr>
<%
List<RequestData> data_list = request_dao.select_list();

for(int i = 0; i < data_list.size(); i++){

	RequestData data = data_list.get(i);

	String category_line = data.category;
	if(category_line.length() > 30){
		category_line = safe_substring(data.category, 30) + "..";
	}
	
%>
                                                        <tr>
                                                            <td><%= data.get_ctime()%></td>
                                                            <td><%= data.get_block_yn()%></td>
                                                            <td><%= data.cnt%></td>
                                                            <td><%= data.get_type_code()%></td>
                                                            <td><a href='javascript:window_open("http://" + "<%= data.domain%>")'><%= data.domain%></a></td>
                                                            <td><%= data.user%></td>
                                                            <td><%= data.clt_ip%></td>
                                                            <td title='<%= data.grp%>'><%= data.get_first_grp()%></td>
                                                            <td><%= data.policy%></td>
                                                            <td title='<%= data.category%>'><%= category_line%></td>
                                                            <td><%= data.get_reason()%></td>
                                                        </tr>
<%}%>

                                                    </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div> <!-- container -->

                </div> <!-- content -->

                <footer class="footer text-right">
                    2016 &copy; NXFilter.
                </footer>

            </div>


            <!-- ============================================================== -->
            <!-- End Right content here -->
            <!-- ============================================================== -->


            <!-- Right Sidebar -->
            <div class="side-bar right-bar nicescroll">
                <h4 class="text-center">Chat</h4>
                <div class="contact-list nicescroll">
                    <ul class="list-group contacts-list">
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-1.jpg" alt="">
                                </div>
                                <span class="name">Chadengle</span>
                                <i class="fa fa-circle online"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-2.jpg" alt="">
                                </div>
                                <span class="name">Tomaslau</span>
                                <i class="fa fa-circle online"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-3.jpg" alt="">
                                </div>
                                <span class="name">Stillnotdavid</span>
                                <i class="fa fa-circle online"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-4.jpg" alt="">
                                </div>
                                <span class="name">Kurafire</span>
                                <i class="fa fa-circle online"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-5.jpg" alt="">
                                </div>
                                <span class="name">Shahedk</span>
                                <i class="fa fa-circle away"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-6.jpg" alt="">
                                </div>
                                <span class="name">Adhamdannaway</span>
                                <i class="fa fa-circle away"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-7.jpg" alt="">
                                </div>
                                <span class="name">Ok</span>
                                <i class="fa fa-circle away"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-8.jpg" alt="">
                                </div>
                                <span class="name">Arashasghari</span>
                                <i class="fa fa-circle offline"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-9.jpg" alt="">
                                </div>
                                <span class="name">Joshaustin</span>
                                <i class="fa fa-circle offline"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                        <li class="list-group-item">
                            <a href="#">
                                <div class="avatar">
                                    <img src="assets/images/users/avatar-10.jpg" alt="">
                                </div>
                                <span class="name">Sortino</span>
                                <i class="fa fa-circle offline"></i>
                            </a>
                            <span class="clearfix"></span>
                        </li>
                    </ul>
                </div>
            </div>
            <!-- /Right-bar -->

        </div>
        <!-- END wrapper -->



        <script>
            var resizefunc = [];
        </script>

        <!-- jQuery  -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/detect.js"></script>
        <script src="assets/js/fastclick.js"></script>

        <script src="assets/js/jquery.slimscroll.js"></script>
        <script src="assets/js/jquery.blockUI.js"></script>
        <script src="assets/js/waves.js"></script>
        <script src="assets/js/wow.min.js"></script>
        <script src="assets/js/jquery.nicescroll.js"></script>
        <script src="assets/js/jquery.scrollTo.min.js"></script>

        <script src="assets/plugins/peity/jquery.peity.min.js"></script>

        <!-- jQuery  -->
        <script src="assets/plugins/moment/moment.js"></script>

        <!-- jQuery  -->
        <script src="assets/plugins/sweetalert/dist/sweetalert.min.js"></script>

        <!-- jQuery  -->
        <script src="assets/plugins/waypoints/lib/jquery.waypoints.js"></script>
        <script src="assets/plugins/counterup/jquery.counterup.min.js"></script>

        <script src="assets/plugins/jquery-knob/jquery.knob.js"></script>

        <!-- Todojs  -->
        <script src="assets/pages/jquery.todo.js"></script>

        <!--C3 Chart-->
        <script type="text/javascript" src="assets/plugins/d3/d3.min.js"></script>
        <script type="text/javascript" src="assets/plugins/c3/c3.js"></script>
        <script src="assets/pages/jquery.c3-chart.init.js"></script>

        <!--Morris Chart-->
        <script src="assets/plugins/morris/morris.min.js"></script>
        <script src="assets/plugins/raphael/raphael-min.js"></script>
        <script src="assets/pages/morris.init.js"></script>


        <script src="assets/plugins/jquery-sparkline/jquery.sparkline.min.js"></script>

        <script src="assets/pages/jquery.dashboard.js"></script>

        <script src="assets/js/jquery.core.js"></script>
        <script src="assets/js/jquery.app.js"></script>

        <script type="text/javascript">
            jQuery(document).ready(function($) {
                $('.counter').counterUp({
                    delay: 100,
                    time: 1200
                });

                $(".knob").knob();

            });
        </script>

        <!-- charts script -->
        <script type="text/javascript" charset="utf-8">
        // chart de requisições
            var chart = c3.generate({
                bindto: '#chart-req',
                data: {
                    json: [<%
            List<String[]> arr_list = request_trend.get_data_list();
            for(int i = 0; i < arr_list.size(); i++){
                String[] arr = arr_list.get(i);

                printf("{time: '%s', requests: %s},", arr[0], arr[1]);
            }
            %>],
            
            types: {
                requests: 'area',
            },
                keys: {
                   x: 'time', // it's possible to specify 'x' when category axis
                  value: ['requests'],
                }
              },
              legend: {
                show: false
              },
              axis: {
                x: {
                 type: 'category', // type: 'category'
                 tick: {
                        rotate: 75,
                        multiline: false
                    },
                }
              }
            });
            // chart de bloqueio
            var chart = c3.generate({
                bindto: '#chart-block',
                data: {
                    json: [<%
            arr_list = request_trend.get_data_list_blocked();
            for(int i = 0; i < arr_list.size(); i++){
                String[] arr = arr_list.get(i);
                printf("{time: '%s', block: %s},", arr[0], arr[1]);
            }
            %>],

            colors: {
                block: '#EF5350'
            },
            
            types: {
                block: 'area',
            },
                keys: {
                   x: 'time', // it's possible to specify 'x' when category axis
                  value: ['block'],
                }
              },
              legend: {
                show: false
              },
              axis: {
                x: {
                 type: 'category', // type: 'category'
                 tick: {
                        rotate: 75,
                        multiline: false
                    },
                }
              }
            });
        </script>

        <script type="text/javascript">
            // pie top 5 dominios
            var chart = c3.generate({
                bindto: '#top5-domain-chart',
                data: {
                columns: [
                    ['Lulu', 46],
                    ['Olaf', 24],
                    ['Item 3', 30]
                    [<%
arr_list = domain_top.get_data_list();
for(int i = 0; i < arr_list.size(); i++){
    String[] arr = arr_list.get(i);

    printf("{lab: '%s', val: %s},", arr[0], arr[1]);
}
%>],
                ],
                type : 'pie'
            },
            color: {
                pattern: ["#ef5350", "#ab47bc", "#42a5f5", "#66bb6a", "#ff7043"]
            },
            pie: {
                label: {
                  show: true
                }
            }
        });
            // top5-domain-chart
        </script>

        
    </body>

</html>