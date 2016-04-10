<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
boolean chk_param(AlertData data){
	ParamValidator pv = new ParamValidator();

	if (is_not_empty(data.admin_email) && !pv.is_valid_email(data.admin_email)) {
		err_list.add("Email do administrador com endere&ccedil;o inv&aacute;lido!");
		return false;
	}

	if (data.period > 0 && (is_empty(data.admin_email) || is_empty(data.smtp_host))) {
		err_list.add("O envio de alertas por email requer que sejam informados o email e o servidor de SMTP que ser&atilde;o usados!");
		return false;
	}

	return true;
}

//-----------------------------------------------
void update(AlertDao dao){
	AlertData data = new AlertData();

	data.admin_email = param_str("admin_email");
	data.smtp_host = param_str("smtp_host");
	data.smtp_port = param_int("smtp_port");
	data.smtp_ssl = param_bool("smtp_ssl");
	data.smtp_user = param_str("smtp_user");
	data.smtp_passwd = param_str("smtp_passwd");
	data.period = param_int("period");

	// Validate and update it.
	if(chk_param(data) && dao.update(data)){
		succ_list.add("Configura&ccedil;&otilde;es de Alerta atualizados com sucesso!");
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
AlertDao dao = new AlertDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update(dao);
}

// Global.
AlertData data = dao.select_one();
%>

<!DOCTYPE html>
<html>
    <jsp:include page="header.jsp">
       <jsp:param name="page" value="Alertas"/>
       <jsp:param name="version" value="GlobalDao.get_nx_version()"/>
    </jsp:include>
    <body class="skin-black">

        <!-- header logo: style can be found in header.less -->
        <header class="header">
	    <jsp:include page="inside-header.jsp">
		<jsp:param name="version" value="GlobalDao.get_nx_version()"/>
		<jsp:param name="admin_name" value="get_admin_name()" />
	    </jsp:include>
        </header>
        <div class="wrapper row-offcanvas row-offcanvas-left">
            <!-- Left side column. contains the logo and sidebar -->
	    <%@include file="sidebar.jsp" %>

            <!-- Right side column. Contains the navbar and content of the page -->
            <aside class="right-side">
                <!-- Content Header (Page header) -->
	        <jsp:include page="content-header.jsp">
		   <jsp:param name="page" value="Alertas"/>
	        </jsp:include>

                <!-- Main content -->
                <section class="content">
                    <div id="tipue_drop_content"></div> 
                    <!-- 1st row -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-comments"></i>
                                    <h3 class="box-title">Alerta - Configura&ccedil;&otilde;es</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <!-- start form -->
                                    <form role="form" id="alerts" action="<%= get_page_name()%>" method="post">
                                    <input type="hidden" name="action_flag" value="update">
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="admin_email">Email do administrador</label>
                                                <input type="text" class="form-control" id="admin_email" name="admin_email" value="<%= data.admin_email%>" placeholder="Email...">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="smtp_host">Servidor SMTP</label>
                                                <input type="text" class="form-control" id="smtp_host" name="smtp_host" value="<%= data.smtp_host%>" placeholder="Servidor SMTP...">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-1">
                                                <label class="control-label" for="smtp_port">Porta SMTP</label>
                                                <input type="text" class="form-control" id="smtp_port" name="smtp_port" value="<%= data.smtp_port%>" placeholder="25" >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="smtp_ssl">Usar SSL no SMTP ?</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="smtp_ssl" name="smtp_ssl" <%if(data.smtp_ssl){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="smtp_user">Usu&aacute;rio SMTP </label>
                                                <input type="text" class="form-control" id="smtp_user" name="smtp_user" value="<%= data.smtp_user%>" placeholder="Usu&aacute;rio SMTP...">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="smtp_passwd">Senha do usu&aacute;rio SMTP</label>
                                                <input type="password" class="form-control" id="smtp_passwd" name="smtp_passwd" value="<%= data.smtp_passwd%>" placeholder="Senha do SMTP..." >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="period">Per&iacute;odo dos alertas</label>
                                                <select class="form-control" id="period" name="period">
<%
Map<Integer, String> period_map = get_alert_period_map();
for(Map.Entry<Integer, String> entry : period_map.entrySet()){
	Integer key = entry.getKey();
	String val = entry.getValue();

	if(key == data.period){
		printf("<option value='%s' selected>%s", key, val);
	}
	else{
		printf("<option value='%s'>%s", key, val);
	}
}
%>
                                                </select>
                                            </div>
                                        </div>
                                    </form><!-- end form -->
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <button id="submitBtn" type="submit" form="alerts" class="btn btn-info">Enviar</button>
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
                    document.getElementById("alerts").submit();        
                });

                $('#alerts').submit(function(e) {
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
