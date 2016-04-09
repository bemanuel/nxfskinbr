<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void update(AllowedIpDao dao){
	if(demo_flag){
		err_list.add("Update not allowed on demo site!");
		return;
	}

	AllowedIpData data = new AllowedIpData();
	data.dns_allowed = param_str("dns_allowed");
	data.dns_blocked = param_str("dns_blocked");
	data.login_allowed = param_str("login_allowed");
	data.gui_allowed = param_str("gui_allowed");

	if(dao.update(data)){
		succ_list.add("IP access control settings updated successfully!");
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
AllowedIpDao dao = new AllowedIpDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update(dao);
}

// Global.
AllowedIpData data = dao.select_one();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Allowed IP</title>
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
	    <%@include file="sidebar.jsp" %>

            <!-- Right side column. Contains the navbar and content of the page -->
            <aside class="right-side">
                <!-- Content Header (Page header) -->
                <section class="content-header">
                    <h1>
                        Configuration
                        <small>Allowed IP</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../../dashboard.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li><a href="#">Configuration</a></li>
                        <li class="active">Allowed IP</li>
                    </ol>
                </section>


                <!-- Main content -->
                <section class="content">       
                    <div id="tipue_drop_content"></div>

                    <div class="callout callout-info">
                        <h4>IP based access restriction functions for DNS, Web GUI, and login redirection.</h4>
                        <p class="text-yellow"><strong>If you add IP addresses here, then any unregistered IP will be blocked.</strong></p>
                        <p>You can add IP addresses in the following forms.</p>
                        <dl class="dl-horizontal">
                            <dt>192.168.1</dt>
                            <dd>All IP address which start with "192.168.1"</dd>
                            <dt>192.168.1 192.168.2</dt>
                            <dd>Multiple IP addresses separated by spaces.</dd>
                        </dl>
                    </div>

                    <!-- form start -->
                    <form role="form" id="acl" action="<%= get_page_name()%>" method="post">
                    <input type="hidden" name="action_flag" value="update">
                        <div class="box box-purple">

                            <div class="box box-purple">
                                <div class="box-header">
                                    <i class="fa fa-thumbs-up"></i>
                                    <h3 class="box-title">IP's Allowed DNS Service</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="dns_allowed">Allowed IP's for DNS</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="dns_allowed" name="dns_allowed" rows="4"><%= escape_html(data.dns_allowed)%></textarea>
                                                <p class="help-block">If there are no entries here, everyone can access your DNS services.</p>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->
                            </div><!-- /.box box-purple -->  


                            <div class="box box-lime">
                                <div class="box-header">
                                    <i class="fa fa-thumbs-down"></i>
                                    <h3 class="box-title">IP's Blocked from DNS Service</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="dns_blocked">Blocked IP's for DNS</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="dns_blocked" name="dns_blocked" rows="4"><%= escape_html(data.dns_blocked)%></textarea>
                                                <p class="help-block">Blacklist for access control of DNS services.  Overrides entries in "Allowed IP's for DNS".</p>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->
                            </div><!-- /.box box-lime-->  


                            <div class="box box-maroon">
                                <div class="box-header">
                                    <i class="fa fa-thumbs-o-up"></i>
                                    <h3 class="box-title">IP's Allowed GUI Access</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="gui_allowed">Allowed IP's for GUI</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="gui_allowed" name="gui_allowed" rows="4"><%= escape_html(data.gui_allowed)%></textarea>
                                                <p class="help-block">IP list allowed access to web admin GUI.  'localhost' or '127.0.0.1' are always allowed access. </p>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->  
                            </div><!-- /.box box-maroon --> 
                            
                            
                            <div class="box box-teal">
                                <div class="box-header">
                                    <i class="fa fa-retweet"></i>
                                    <h3 class="box-title">IP's Allowed for Login Redirection</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="login_allowed">Allowed IP's for Login</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="login_allowed" name="login_allowed" rows="4"><%= escape_html(data.login_allowed)%></textarea>
                                                <p class="help-block">If there are no entries here, all unauthenticated users will be redirect to the login page.</p>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->
                            </div><!-- /.box box-teal-->   


                        <div class="box-footer">
                            <div class="btn-group">
                                <button id="submitBtn" type="submit" form="acl" class="btn btn-info margin">Update Settings</button>
                                <button id="resetBtn" class="btn btn-warning margin">Reset</button>
                            </div>
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
                    document.getElementById("acl").submit();        
                });

                $('#resetBtn').click(function() {
                    document.getElementById("acl").reset();        
                });

                $('#acl').submit(function(e) {
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
