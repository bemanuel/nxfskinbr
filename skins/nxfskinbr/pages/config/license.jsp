<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void update(LicenseDao dao){
	if(demo_flag){
		err_list.add("License update not allowed on demo site!");
		return;
	}

	if(dao.update_license_key(param_str("license_key"))){
        succ_list.add("License data updated successfully!");
        succ_list.add("Restarting NxFilter is required to apply the new license.");
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
// Need to pass err_list for this one.
LicenseDao dao = new LicenseDao(err_list);

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update(dao);
}

// Global.
LicenseData data = dao.select_one();
%>


<!DOCTYPE html>
<html>
    <jsp:include page="../../include/header.jsp">
       <jsp:param name="page" value="Licen&ccedil;a"/>
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
		   <jsp:param name="page" value="Licen&ccedil;a"/>
	        </jsp:include>

                <!-- Main content -->
                <section class="content">       
                    <div id="tipue_drop_content"></div>

                    <!-- 1st row -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-unlock-alt"></i>
                                    <h3 class="box-title">License Settings</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <!-- start form -->
                                    <form role="form" id="license" action="<%= get_page_name()%>" method="post">
                                    <input type="hidden" name="action_flag" value="update">

                                        <div class="form-group">
                                            <div class="input-group col-xs-4">
                                                <label class="control-label" for="license_key">License Key</label>
                                                <input type="text" class="form-control" id="license_key" name="license_key" placeholder="License Key...">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="end_date">End date</label>
                                                <input type="text" class="form-control" id="end_date" name="end_date" value="<%= data.end_date%>" disabled>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="max_user">Maximum Users</label>
                                                <input type="text" class="form-control" id="max_user" name="max_user" value="<%= data.max_user%>" disabled>
                                            </div>
                                        </div>
                                    </form><!-- end form -->
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <button id="submitBtn" type="submit" form="license" class="btn btn-info">Save License</button>
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
                
                $('#submitBtn').click(function() {
                    document.getElementById("license").submit();        
                });
                
                $('#license').submit(function(e) {
                    e.preventDefault();
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
