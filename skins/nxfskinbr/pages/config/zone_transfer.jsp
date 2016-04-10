<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void insert(ZoneTransferDao dao){
	ZoneTransferData data = new ZoneTransferData();
	data.id = param_int("id");
	data.domain = param_str("domain");
	data.ip = param_str("ip");

	if (is_empty(data.domain)) {
		err_list.add("Zone Transfer domain is missing!");
		return;
	}

	if (!is_valid_ip(data.ip)) {
		err_list.add("Invalid DNS server IP address!");
		return;
	}

	if(dao.insert(data)){
		succ_list.add("Zone Transfer data updated successfully!");
	}
}

//-----------------------------------------------
void delete(ZoneTransferDao dao){
	if(dao.delete(param_int("id"))){
		succ_list.add("Zone Transfer deleted successfully!");
	}
}

//-----------------------------------------------
void test(ZoneTransferDao dao){
	try{
		dao.test(param_int("id"));
		succ_list.add("Zone Transfer worked!");
	}
	catch(Exception e){
		err_list.add("Transfer Error: " + e.toString());
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
ZoneTransferDao dao = new ZoneTransferDao();

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

// Global.
int g_count = dao.select_count();
%>

<!DOCTYPE html>
<html>
    <jsp:include page="../../include/header.jsp">
       <jsp:param name="page" value="Transfer&ecirc;ncia de Zona"/>
       <jsp:param name="version" value="GlobalDao.get_nx_version()"/>
    </jsp:include>
    <body class="skin-black">

        <!-- header logo: style can be found in header.less -->
        <header class="header">
	    <jsp:include page="../../include/inside-header.jsp">
		<jsp:param name="version" value="GlobalDao.get_nx_version()"/>
		<jsp:param name="admin_name" value="get_admin_name()" />
	    </jsp:include>
        </header>

        <div class="wrapper row-offcanvas row-offcanvas-left">
            <!-- Left side column. contains the logo and sidebar -->
	    <%@include file="../../include/sidebar.jsp" %>

            <!-- Right side column. Contains the navbar and content of the page -->
            <aside class="right-side">
                <!-- Content Header (Page header) -->
	        <jsp:include page="../../include/content-header.jsp">
		   <jsp:param name="page" value="Transfer&ecirc;ncia de Zona"/>
	        </jsp:include>

                <!-- Main content -->
                <section class="content"> 
                    <div id="tipue_drop_content"></div>
                    <!-- 1st row -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-exchange"></i>
                                    <h3 class="box-title">Transfer&ecirc;ncia de Zona</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <!-- start form -->
                                    <form role="form" id="addTrans" action="<%= get_page_name()%>" method="post">
                                    <input type="hidden" name="action_flag" value="insert">
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="domain">Domain</label>
                                                <input type="text" class="form-control" id="domain" name="domain" placeholder="Domain...">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="ip">DNS Server IP</label>
                                                <input type="text" class="form-control" id="ip" name="ip" placeholder="DNS Server...">
                                            </div>
                                        </div>
                                    </form><!-- end form -->
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <button id="add" type="submit" form="addTrans" class="btn btn-info">Add Zone Transfer</button>
                                </div>
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->

                    <!-- 2nd row -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box">
                                <div class="box-header">
                                    <i class="fa fa-copy"></i>
                                    <h3 class="box-title">Active Zone Transfers</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <!-- start table -->
                                    <table id="table" data-pagination="true" data-search="true">
                                        <thead>
                                        <tr>
                                            <th data-field="id" data-visible="false">ID</th>
                                            <th data-field="domain" data-sortable="true">Domain</th>
                                            <th data-field="ip" data-sortable="true">DNS Server IP</th>
                                            <th data-field="operate" data-formatter="operateFormatter" data-events="operateEvents" data-align="center">Actions</th>
                                        </tr>
                                        </thead>
                                    </table>
									<!-- start: Delete Redirection Modal -->
									<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
													 <h3 class="modal-title" id="myModalLabel">Confirm?</h3>

												</div>
												<div class="modal-body">
													 <h4>Are you sure you want to delete this record?</h4>
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
                                    <form name='go_form' method='get'>
                                    <input type='hidden' name='mode' value=''>
                                    <input type='hidden' name='action_flag' value=''>
                                    <input type='hidden' name='id' value=''>
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
                    document.getElementById("addTrans").submit();        
                });
                
                $('#addTrans').submit(function(e) {
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
List<ZoneTransferData> data_list = dao.select_list();

for(int i = 0; i < data_list.size(); i++){
    ZoneTransferData data = data_list.get(i);
    out.println("{\"id\": " + data.id + ",\"domain\": \"" + data.domain + "\",\"ip\": \"" + data.ip + "\"},");
}
%>    
];

$(function () {
    $('#table').bootstrapTable({
        data: data,
        pageList: [10, 25, 50, "All"]
    });
    
    $('#btnDelYes').click(function () {
        var id = $('#myModal').data('id');
        var domain = $('#myModal').data('domain');
        //alert("Domain = " + domain);
        $('#table').bootstrapTable('remove', {
            field: 'id',
            values: [id]
        });
        $('#myModal').modal('hide');
        goForm(id, "delete");
    });
});

function goForm(id, action) {
    var form = document.go_form;
    form.action_flag.value = action;
    form.id.value = id;
    form.submit();
}

function operateFormatter(value, row, index) {
    return [
        '<a class="test ml10" href="javascript:void(0)" title="Test">',
        '<i class="ion ion-wrench"></i>',
        '</a>&nbsp;&nbsp;',
        '<a class="remove ml10" href="javascript:void(0)" title="Delete">',
        '<i class="ion ion-close-circled text-red"></i>',
        '</a>'
    ].join('');
}

window.operateEvents = {
    'click .test': function (e, value, row, index) {
        //alert('Clicked test icon, row: ' + JSON.stringify(row));
        goForm(row.id, "test");
    },
    'click .remove': function (e, value, row, index) {
        $('#myModal').data('id', row.id);
        $('#myModal').data('domain', row.domain);
        $('#myModal').modal('show');
    }
};             
        </script>
        
    </body>
</html>
