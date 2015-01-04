<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void insert(AdapDao dao){
	LdapData data = new LdapData();
	data.host = param_str("host");
	data.admin = param_str("admin");
	data.passwd = param_str("passwd");
	data.basedn = param_str("basedn");
	data.domain = param_str("domain");
	data.zone_transfer = param_bool("zone_transfer");
	data.period = param_int("period");

	// Param validation.
	if (!is_valid_ip(data.host)) {
		err_list.add("AD Host is Invalid!");
		return;
	}
	   
	if (is_empty(data.admin)) {
		err_list.add("Admin username is missing!");
		return;
	}

	if (is_empty(data.basedn)) {
		err_list.add("AD Base DN is missing!");
		return;
	}

	if (data.zone_transfer && is_empty(data.domain)) {
		err_list.add("AD Zone-transfer needs a domain name!");
		return;
	}

	if(dao.insert(data)){
		succ_list.add("AD settings added successfully!");
	}
}

//-----------------------------------------------
void delete(AdapDao dao){
	if(dao.delete(param_int("id"))){
		succ_list.add("AD settings & information deleted!");
	}
}

//-----------------------------------------------
void test(AdapDao dao){
	try{
		dao.test(param_int("id"));
		succ_list.add("AD connection test succeeded!");
	}
	catch(Exception e){
		err_list.add(e.toString());
	}
}

//-----------------------------------------------
void import_ldap(AdapDao dao){
	String res = dao.import_ldap(param_int("id"));
    if(res != null){
        succ_list.add("AD information successfully imported!");
        succ_list.add(res);
    } else {
        err_list.add("AD import failed!");
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
AdapDao dao = new AdapDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("insert")){
	insert(dao);
}
if(action_flag.equals("delete")){
	delete(dao);
}
if(action_flag.equals("test")){
	test(dao);
}
if(action_flag.equals("import_ldap")){
	import_ldap(dao);
}

// Global.
int g_count = dao.select_count();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>NxFilter v<%= GlobalDao.get_nx_version()%> | Active Directory</title>
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
                        <li class="treeview active">
                            <a href="#">
                                <i class="fa fa-user"></i> <span>Users & Groups</span>
                                <i class="fa fa-angle-left pull-right"></i>
                            </a>
                            <ul class="treeview-menu">
                                <li><a href="../../pages/directory/users.jsp"><i class="fa fa-angle-double-right"></i> Users</a></li>
                                <li><a href="../../pages/directory/groups.jsp"><i class="fa fa-angle-double-right"></i> Groups</a></li>
                                <li class="active"><a href="../../pages/directory/ad.jsp"><i class="fa fa-angle-double-right"></i> Active Directory</a></li>
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
                        Users & Groups
                        <small>Active Directory</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../../dashboard.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                        <li><a href="#">Users & Groups</a></li>
                        <li class="active">Active Directory</li>
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
                                    <i class="fa fa-windows"></i>
                                    <h3 class="box-title">AD Settings</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <!-- start form -->
                                    <form role="form" id="addAD" action="<%= get_page_name()%>" method="post">
                                    <input type="hidden" name="action_flag" value="insert">
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="host">Host</label>
                                                <input type="text" class="form-control" id="host" name="host" placeholder="Host...">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="admin">Domain Administrator</label>
                                                <input type="text" class="form-control" id="admin" name="admin" placeholder="Admin...">
                                            </div>
                                            <p class="help-block">ex) Administrator@nxfilter.local</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="passwd">Password</label>
                                                <input type="password" class="form-control" id="passwd" name="passwd" placeholder="Password...">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-4">
                                                <label class="control-label" for="basedn">Base DN</label>
                                                <input type="text" class="form-control" id="basedn" name="basedn" placeholder="Base DN...">
                                            </div>
                                            <p class="help-block">ex) cn=users,dc=nxfilter,dc=local</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-4">
                                                <label class="control-label" for="domain">AD Domain</label>
                                                <input type="text" class="form-control" id="domain" name="domain" placeholder="Domain...">
                                            </div>
                                            <p class="help-block">ex) nxfilter.local</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="zone_transfer">Zone Transfer</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="zone_transfer" name="zone_transfer">
                                            </div>
                                            <p class="help-block">Import Active Directory DNS zone information</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="period">Auto Sync Interval</label>
                                                <select class="form-control" id="period" name="period">
<%
Map<Integer, String> period_map = get_ldap_period_map();
for(Map.Entry<Integer, String> entry : period_map.entrySet()){
	Integer key = entry.getKey();
	String val = entry.getValue();

	printf("<option value='%s'>%s", key, val);
}
%>
                                                </select>
                                            </div>
                                        </div>
                                    </form><!-- end form -->
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <button id="add" type="submit" form="addAD" class="btn btn-info">Add Directory</button>
                                </div>
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->

                    <!-- 2nd row -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid box-grey">
                                <div class="box-header">
                                    <i class="fa fa-list-alt"></i>
                                    <h3 class="box-title">Directory List</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body">

                                    <!-- start table -->
                                    <table id="table" data-classes="table table-hover">
                                        <thead>
                                        <tr>
                                            <th data-field="id" data-visible="false">ID</th>
                                            <th data-field="host" data-sortable="true">Host</th>
                                            <th data-field="admin" data-sortable="true">Admin</th>
                                            <th data-field="basedn" data-sortable="true">Base DN</th>
                                            <th data-field="domain" data-sortable="true">Domain</th>
                                            <th data-field="zone_transfer" data-sortable="true">Zone Transfer</th>
                                            <th data-field="period" data-sortable="true">Auto Sync</th>
                                            <th data-field="operate" data-formatter="operateFormatter" data-events="operateEvents" data-align="center">Actions</th>
                                        </tr>
                                        </thead>
                                    </table>

					<!-- start: Delete Record Modal -->
					<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
									<h3 class="modal-title" id="myModalLabel">Confirm?</h3>
								</div>
								<div class="modal-body">
									<h4>Are you sure you want to delete this record?</h4>
									<p class="text-red" id="warn"></p>
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

				    <!-- go_form -->
                                    <form action="<%= get_page_name()%>" name="go_form" method="get">
                                        <input type='hidden' name='mode' value=''>
                                        <input type='hidden' name='action_flag' value=''>
                                        <input type='hidden' name='id' value=''>
                                        <input type='hidden' name='host' value=''>
                                    </form>
                                    <!-- /go_form -->

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
                           
                $('#add').click(function() {
                    document.getElementById("addAD").submit();        
                });
                
                $('#addAD').submit(function(e) {
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
            
var data = 
[
<%
List<LdapData> data_list = dao.select_list();

for(int i = 0; i < data_list.size(); i++){
	LdapData data = data_list.get(i);

    out.println("{\"id\": " + data.id + ",\"host\": \"" + data.host + "\",\"admin\": \"" + data.admin + "\",\"basedn\": \"" + data.basedn + "\",\"domain\": \"" + data.domain + "\",\"zone_transfer\": \"" + data.get_zone_transfer_yn() + "\",\"period\": \"" + get_ldap_period_string(data.period) + "\"},");

}
%>   
];

$(function () {
    $('#table').bootstrapTable({
        data: data
    });
    
    $('#btnDelYes').click(function () {
        var id = $('#myModal').data('id');
        //var host = $('#myModal').data('host');
        //alert("Host = " + host);
        $('#table').bootstrapTable('remove', {
            field: 'id',
            values: [id]
        });
        $('#myModal').modal('hide');
        goForm(id, name, "delete", "<%= get_page_name()%>");
    });
});
    
function goForm(id, name, flag, action) {
    var form = document.go_form;
    form.action = action;
    form.action_flag.value = flag;
    form.id.value = id;
    form.name.value = name;
    form.submit();
}

function operateFormatter(value, row, index) {
    return [
        '<a class="test" href="javascript:void(0)" title="Test">',
        '<i class="ion ion-eye"></i>',
        '</a>&nbsp;&nbsp;',
        '<a class="import ml10" href="javascript:void(0)" title="Import">',
        '<i class="ion ion-android-download"></i>',
        '</a>&nbsp;&nbsp;',
        '<a class="edit ml10" href="javascript:void(0)" title="Edit">',
        '<i class="ion ion-edit"></i>',
        '</a>&nbsp;&nbsp;',
        '<a class="remove ml10" href="javascript:void(0)" title="Delete">',
        '<i class="ion ion-close-circled text-red"></i>',
        '</a>'
    ].join('');
}

window.operateEvents = {
    'click .test': function (e, value, row, index) {
        //alert('Clicked test icon, row: ' + JSON.stringify(row));
        goForm(row.id, row.host, "test", "");
    },
    'click .import': function (e, value, row, index) {
        //alert('Clicked import icon, row: ' + JSON.stringify(row));
        goForm(row.id, row.host, "import_ldap", "");
    },
    'click .edit': function (e, value, row, index) {
        //alert('Clicked edit icon, row: ' + JSON.stringify(row));
        goForm(row.id, row.host, "", "ad_edit.jsp");
    },
    'click .remove': function (e, value, row, index) {
        $('#myModal').data('id', row.id);
        $('#warn').html("All imported users and groups associated with " + row.host + " will be removed!");
        $('#myModal').modal('show');
    }
};             
        </script>
        
    </body>
</html>
