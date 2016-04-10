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
ConfigDao dao = new ConfigDao();

// Action.
String action_flag = param_str("action_flag");
if(!demo_flag && action_flag.equals("backup")){
	String filename = dao.backup();
	if(is_not_empty(filename)){
		response.sendRedirect("../../pages/config/download.jsp?filename=" + filename);
		return;
    }
}

%>


<!DOCTYPE html>
<html>
    <jsp:include page="../../include/header.jsp">
       <jsp:param name="page" value="Backup"/>
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
		   <jsp:param name="page" value="Backup"/>
	        </jsp:include>

                <!-- Main content -->
                <section class="content">
                    <div id="tipue_drop_content"></div>       
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="notifications">
                                
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-success">
                                <div class="box-header">
                                    <i class="fa fa-download"></i>
                                    <h3 class="box-title">Backup Configuration</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body">


                               <form role="form" action="<%= get_page_name()%>" method="post">
                                    <input type='hidden' name='action_flag' value='backup'>
                                    <div class="box-body">
                                        <div class="form-group">
                                            <div class="alert alert-info alert-dismissable">
                                                <i class="fa fa-info"></i>
                                                <b>A zip archive file of your configuration will be downloaded when you click the Backup Current Configuration button below.  If you wish to restore from a backup file, <br>
                                                first stop NxFilter and then extract the 'config.h2.db' file from the dated zip archive and overwrite the existing '/nxfilter/db/config.h2.db' file.</b>
                                            </div>

                                    </div><!-- /.box-body -->

                                    <div class="box-footer">
                                        <button type="submit" class="btn btn-info btn-lg"><strong>Backup Current Configuration</strong></button>
                                    </div>
                                </form>
                                

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
        <!-- TipueDrop Search -->
        <script src="../../js/plugins/tipue/tipuedrop.min.js" type="text/javascript"></script>
         <!-- iCheck -->
        <script src="../../js/plugins/iCheck/icheck.min.js" type="text/javascript"></script>

        <!-- NxF App -->
        <script src="../../js/NxF/app.js" type="text/javascript"></script>

        <script type="text/javascript">
            $(function() {
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
            });

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
                $('#tipue_drop_input').tipuedrop({
                    'mode': 'json',
                    'contentLocation': '../../js/plugins/tipue/tipue_content.json'
                });          
            });

        </script>

    </body>
</html>
