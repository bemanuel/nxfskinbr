<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void update_name(AdminDao dao){
	if(demo_flag){
		err_list.add("Updating admin name not allowed on demo site!");
		return;
	}

	AdminData data = new AdminData();
	data.name = param_str("admin_name");

	// Param validation.
	ParamValidator pv = new ParamValidator();

	if(!pv.is_valid_name_len(data.name)){
		err_list.add(ParamValidator.ERR_NAME_LEN);
		return;
	}
	
	if(!pv.is_valid_name_char(data.name)){
		err_list.add(ParamValidator.ERR_NAME_CHAR);
		return;
	}

	if(dao.update(data)){
		succ_list.add("Admin name successfully changed to: " + data.name);
	}
}

//-----------------------------------------------
void update_admin_pw(AdminDao dao){
	if(demo_flag){
		err_list.add("Updating admin password not allowed on demo site!");
		return;
	}

	String new_pw = param_str("new_pw");
	String new_pw2 = param_str("new_pw2");
	String admin_pw = param_str("admin_pw");

	// Validate and update it.
	ParamValidator pv = new ParamValidator();
	
	if(!pv.is_valid_passwd_len(new_pw)){
		err_list.add("Password length must be between 4 and 16 characters!");
		return;
	}
	
	if(!pv.is_valid_passwd_char(new_pw)){
		err_list.add("Only ascii character allowed in password!");
		return;
	}

	if(!dao.is_admin_pw(admin_pw)){
		err_list.add("Current admin password incorrect!");
		return;
	}

	if(!new_pw.equals(new_pw2)){
		err_list.add("New password and confirm password don't match!");
		return;
	}

	if(dao.update_admin_pw(new_pw)){
		succ_list.add("Admin password successfully changed.");
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
AdminDao dao = new AdminDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update_name(dao);
}
if(action_flag.equals("admin_pw")){
	update_admin_pw(dao);
}

// Global.
AdminData data = dao.select_one();
%>

<!DOCTYPE html>
<html>
    <jsp:include page="../../include/header.jsp">
       <jsp:param name="page" value="Perfil"/>
       <jsp:param name="version" value="<%=GlobalDao.get_nx_version()%>"/>
    </jsp:include>
    <body class="skin-black">

        <!-- header logo: style can be found in header.less -->
        <header class="header">
	    <jsp:include page="../../include/inside-header.jsp">
		<jsp:param name="version" value="<%=GlobalDao.get_nx_version()%>"/>
		<jsp:param name="admin_name" value="<%=get_admin_name()%>" />
	    </jsp:include>
        </header>
        <div class="wrapper row-offcanvas row-offcanvas-left">
            <!-- Left side column. contains the logo and sidebar -->
	    <%@include file="../../include/sidebar.jsp" %>

            <!-- Right side column. Contains the navbar and content of the page -->
            <aside class="right-side">
                <!-- Content Header (Page header) -->
	        <jsp:include page="../../include/content-header.jsp">
		   <jsp:param name="page" value="Perfil"/>
	        </jsp:include>

                <!-- Main content -->
                <section class="content">
                    <div id="tipue_drop_content"></div> 
                    <!-- 1st row -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-pencil"></i>
                                    <h3 class="box-title">Senha do Administrador</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <!-- start form -->
                                    <form role="form" id="chgPasswd" action="<%= get_page_name()%>" method="post">
                                    <input type="hidden" name="action_flag" value="admin_pw">
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="admin_pw">Senha atual</label>
                                                <input type="password" class="form-control" id="admin_pw" name="admin_pw" placeholder="Senha atual...">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="new_pw">Nova senha</label>
                                                <input type="password" class="form-control" id="new_pw" name="new_pw" placeholder="Nova senha...">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="new_pw2">Confirmar nova senha</label>
                                                <input type="password" class="form-control" id="new_pw2" name="new_pw2" placeholder="Repita a nova senha..." >
                                            </div>
                                        </div>
                                    </form><!-- end form -->
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <button id="chpass" type="submit" form="chgPasswd" class="btn btn-info">Confirma altera&ccedil;&atilde;o</button>
                                </div>
                            </div><!-- /.box -->
                        </div><!-- /.col -->
                    </div><!-- /.row -->

                    <!-- 2nd row -->
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box box-solid">
                                <div class="box-header">
                                    <i class="fa fa-user"></i>
                                    <h3 class="box-title">Usu&aacute;rio do administrador</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <!-- start form -->
                                    <form role="form" id="chgAdmin" action="<%= get_page_name()%>" method="post">
                                    <input type="hidden" name="action_flag" value="update">
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="admin_name">Usu&aacute;rio atual</label>
                                                <input type="text" class="form-control" id="admin_name" name="admin_name" value="<%= data.name%>">
                                            </div>
                                            <p class="help-block text-blue"><b>Obs:</b>  Usu&aacute;rio ser&aacute; mudado no pr&oacute;ximo login.</p>
                                        </div>
                                    </form><!-- end form -->
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <button id="chadmin" type="submit" form="chgAdmin" class="btn btn-info">Confirmar mudan&ccedil;a de usu&aacute;rio</button>
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
                           
                $('#chpass').click(function() {
                    document.getElementById("chgPasswd").submit();        
                });

                $('#chadmin').click(function() {
                    document.getElementById("chgAdmin").submit();        
                });
                
                $('#chgPasswd').submit(function(e) {
                    e.preventDefault();
                });

                $('#chgAdmin').submit(function(e) {
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
                    if ((evt.keyCode == 13) && ((node.type=="text") || (node.type=="password") || (node.type=="radio") || (node.type=="checkbox")) )  {return false;}
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
