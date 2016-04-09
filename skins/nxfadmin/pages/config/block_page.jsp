<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void update(BlockPageDao dao){
	if(demo_flag){
		err_list.add("Page updates not allowed on demo site!");
		return;
	}

	BlockPageData data = new BlockPageData();

	// We use request_str here to preserve all the special characters.
	data.block_page = request_str("block_page");
	data.login_page = request_str("login_page");
	data.welcome_page = request_str("welcome_page");

	if(dao.update(data)){
		succ_list.add("Page Data updated successfully!");
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
BlockPageDao dao = new BlockPageDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update(dao);
}
if(action_flag.equals("restore")){
	if(dao.restore_default()){
		succ_list.add("Page Data Defaults Restored!");
	}
}

// Global.
BlockPageData data = dao.select_one();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Block Page</title>
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
                        <small>Block Page</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../../dashboard.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li><a href="#">Configuration</a></li>
                        <li class="active">Block Page</li>
                    </ol>
                </section>


                <!-- Main content -->
                <section class="content">       
                    <div id="tipue_drop_content"></div>

                    <div class="callout callout-info">
                        <h4>Setup for custom block-page, login-page, and welcome-page.</h4>
                        <p>When you edit your block-page, you can use the following variables populated by NxFilter to make your block-page more informative.</p>
                        <dl class="dl-horizontal">
                            <dt>\#{domain}</dt>
                            <dd>Blocked domain</dd>
                            <dt>\#{reason}</dt>
                            <dd>Reason domain was blocked</dd>
                            <dt>\#{user}</dt>
                            <dd>Logged-in username</dd>
                            <dt>\#{group}</dt>
                            <dd>Groups the logged-in username belongs to</dd>
                            <dt>\#{policy}</dt>
                            <dd>The applied policy setting</dd>
                            <dt>\#{category}</dt>
                            <dd>Categories the blocked domain was found in</dd>
                        </dl>
                    </div>

                    <!-- form start -->
                    <form role="form" id="pages" action="<%= get_page_name()%>" method="post">
                    <input type="hidden" name="action_flag" value="update">
                        <div class="box box-primary">

                            <div class="box box-primary">
                                <div class="box-header">
                                    <i class="fa fa-ban"></i>
                                    <h3 class="box-title">Block Page</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="block_page">Block Page HTML</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="block_page" name="block_page" rows="6"><%= escape_html(data.block_page)%></textarea>
                                                <span class="input-group-btn">
                                                    <button id="preBlock" class="btn btn-success btn-flat" type="button">Preview</button>
                                                </span>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->
                            </div><!-- /.box box-primary -->  



                            <div class="box box-fuchsia">
                                <div class="box-header">
                                    <i class="fa fa-sign-in"></i>
                                    <h3 class="box-title">Login Page</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="login_page">Login Page HTML</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="login_page" name="login_page" rows="6"><%= escape_html(data.login_page)%></textarea>
                                                <span class="input-group-btn">
                                                    <button id="preLogin" class="btn btn-success btn-flat" type="button">Preview</button>
                                                </span>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->
                            </div><!-- /.box box-fuchsia-->  



                            <div class="box box-danger">
                                <div class="box-header">
                                    <i class="fa fa-smile-o"></i>
                                    <h3 class="box-title">Welcome Page</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="welcome_page">Welcome Page HTML</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="welcome_page" name="welcome_page" rows="8"><%= escape_html(data.welcome_page)%></textarea>
                                                <span class="input-group-btn">
                                                    <button id="preWelcome" class="btn btn-success btn-flat" type="button">Preview</button>
                                                </span>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->  
                            </div><!-- /.box box-danger -->  

                        <div class="box-footer">
                            <div class="btn-group">
                                <button id="submitBtn" type="submit" form="pages" class="btn btn-info margin">Update All Pages</button>
                                <button id="resetBtn" class="btn btn-warning margin">Reset Forms</button>
                                <button id="restore" class="btn btn-danger margin">Restore Page Defaults</button>
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
                    document.getElementById("pages").submit();        
                });

                $('#resetBtn').click(function() {
                    document.getElementById("pages").reset();        
                });

                $('#pages').submit(function(e) {
                    e.preventDefault();
                });

                $('#preBlock').click(function() {
                    var v = document.getElementById("block_page").value;
                    preview(v);
                });

                $('#preLogin').click(function() {
                    var v = document.getElementById("login_page").value;
                    preview(v);
                });

                $('#preWelcome').click(function() {
                    var v = document.getElementById("welcome_page").value;
                    preview(v);
                });

                $('#restore').click(function() {
                    document.getElementById("pages").action_flag.value = "restore";
                    document.getElementById("pages").submit();
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

                function preview(text){
                    var width, height, leftPosition, topPosition;
                    width = 1024;
                    height = 600;
                    leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
                    topPosition = (window.screen.height / 2) - ((height / 2) + 50);
                    var w = window.open("", "preview_window", "status=no,height=" + height + ",width=" + width + ",resizable=yes,left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ",toolbar=no,menubar=no,scrollbars=no,location=no,directories=no");
                    w.document.body.innerHTML = text;
                }

                function restore_default(form){
                    form.action_flag.value = "restore";
                    form.submit();
                }             
            });
            
        </script>
        
    </body>
</html>
