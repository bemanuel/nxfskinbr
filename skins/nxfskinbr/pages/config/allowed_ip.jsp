<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
void update(AllowedIpDao dao){
	if(demo_flag){
		err_list.add("Atualiza&ccedil;&otilde;es no site demo n&atilde;o s&atilde;o permitidas!");
		return;
	}

	AllowedIpData data = new AllowedIpData();
	data.dns_allowed = param_str("dns_allowed");
	data.dns_blocked = param_str("dns_blocked");
	data.login_allowed = param_str("login_allowed");
	data.gui_allowed = param_str("gui_allowed");

	if(dao.update(data)){
		succ_list.add("Configura&ccedil;&otilde;es na área de permiss&otilde;es de acesso atualizadas com sucesso!");
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
    <jsp:include page="../../include/header.jsp">
       <jsp:param name="page" value="IPs Permitidos"/>
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
		   <jsp:param name="page" value="IP's Permitidos"/>
	        </jsp:include>

                <!-- Main content -->
                <section class="content">       
                    <div id="tipue_drop_content"></div>

                    <div class="callout callout-info">
                        <h4>Restri&ccedil;&otilde;es de acesso por IP a fun&ccedil;&otilde;es como Consulta DNS, GUI de Administra&ccedil;&atilde;o e redireciomento de login.</h4>
                        <p class="text-yellow"><strong>Se voc&ecirc; adicionar um endere&ccedil;o IP aqui, ent&atilde;o qualquer IP que n&atilde;o esteja registrado ser&aacute; bloqueado.</strong></p>
                        <p>Voc&ecirc; pode ainda adicionar endere&ccedil;os IP da seguinte forma:</p>
                        <dl class="dl-horizontal">
                            <dt>192.168.1</dt>
                            <dd>Todos os IPs come&ccedil;ados com "192.168.1"</dd>
                            <dt>192.168.1 192.168.2</dt>
                            <dd>V&aacute;rios endere&ccedil;os IP separados por espa&ccedil;o.</dd>
                        </dl>
                    </div>

                    <!-- form start -->
                    <form role="form" id="acl" action="<%= get_page_name()%>" method="post">
                    <input type="hidden" name="action_flag" value="update">
                        <div class="box box-purple">

                            <div class="box box-purple">
                                <div class="box-header">
                                    <i class="fa fa-thumbs-up"></i>
                                    <h3 class="box-title">IP's que podem fazer consultas DNS</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="dns_allowed">IP's permitidos para consulta DNS</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="dns_allowed" name="dns_allowed" rows="4"><%= escape_html(data.dns_allowed)%></textarea>
                                                <p class="help-block">Se n&atilde;o tiver nenhum registro aqui, qualquer um pode usar os servic&ccedil;os de DNS.</p>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->
                            </div><!-- /.box box-purple -->  


                            <div class="box box-lime">
                                <div class="box-header">
                                    <i class="fa fa-thumbs-down"></i>
                                    <h3 class="box-title">IP's bloqueados para o uso dos servi&ccedil;os DNS</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="dns_blocked">IP's bloqueados para consultas DNS</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="dns_blocked" name="dns_blocked" rows="4"><%= escape_html(data.dns_blocked)%></textarea>
                                                <p class="help-block">Lista negra de acesso aos servi&ccedil;os DNS. Sobrep&otilde;e os registros em "IP's permitidos".</p>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->
                            </div><!-- /.box box-lime-->  


                            <div class="box box-maroon">
                                <div class="box-header">
                                    <i class="fa fa-thumbs-o-up"></i>
                                    <h3 class="box-title">IP's que podem acessar a GUI de Administra&ccedil;&atilde;o</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="gui_allowed">IP's com acesso a GUI</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="gui_allowed" name="gui_allowed" rows="4"><%= escape_html(data.gui_allowed)%></textarea>
                                                <p class="help-block">Lista de IP's com permiss&atilde;o de acesso a GUI.  'localhost' ou '127.0.0.1' sempre tem permiss&atilde;o de acesso. </p>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->  
                            </div><!-- /.box box-maroon --> 
                            
                            
                            <div class="box box-teal">
                                <div class="box-header">
                                    <i class="fa fa-retweet"></i>
                                    <h3 class="box-title">IP's que podem se autenticar</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">

                                        <div class="form-group">
                                            <label class="control-label" for="login_allowed">IP's com permiss&atilde;o de login</label>
                                            <div class="input-group col-xs-12">
                                                <textarea class="form-control" id="login_allowed" name="login_allowed" rows="4"><%= escape_html(data.login_allowed)%></textarea>
                                                <p class="help-block">Se n&atilde;o houverem registros aqui, todos os usu&aacute;rios sem autentica&ccedil;&atilde;o ser&atilde;o redirecionados para a p&aacute;gina de login.</p>
                                            </div>
                                        </div>

                                    </div><!-- /.box-body -->
                            </div><!-- /.box box-teal-->   


                        <div class="box-footer">
                            <div class="btn-group">
                                <button id="submitBtn" type="submit" form="acl" class="btn btn-info margin">Atualizar registros</button>
                                <button id="resetBtn" class="btn btn-warning margin">Resetar</button>
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
