<%@include file="../../include/lib.jsp"%>
<%!
//-----------------------------------------------
boolean chk_param(ConfigData data){
	ParamValidator pv = new ParamValidator();

	// Redirection IP.
	if (!pv.is_valid_block_ip(data.block_redi_ip)) {
	    err_list.add("Invalid block redirection IP!");
	    return false;
	}

	if (is_not_empty(data.rf_block_redi_ip)) {
	    if (!pv.is_valid_block_ip(data.rf_block_redi_ip)) {
		    err_list.add("Invalid External redirection IP!");
			return false;
	    }
	}

	if (is_not_empty(data.ipv6_block_redi_ip)) {
	    if (!is_valid_ipv6(data.ipv6_block_redi_ip)) {
		    err_list.add("Invalid IPv6 redirection IP!");
			return false;
	    }
	}
	
	// Login, logout domain.
	if (!pv.is_valid_domain(data.login_domain)) {
		err_list.add("Invalid login domain!");
		return false;
	}

	if (!pv.is_valid_domain(data.logout_domain)) {
		err_list.add("Invalid logout domain!");
		return false;
	}

	// Forwarding DNS.
	if (!pv.is_valid_ip(data.fw_dns1)) {
		err_list.add("Invalid IP address for DNS server #1!");
		return false;
	}

	if (is_not_empty(data.fw_dns2) && !pv.is_valid_ip(data.fw_dns2)) {
		err_list.add("Invalid IP address for DNS server #2!");
		return false;
	}

	if (is_not_empty(data.fw_dns3) && !pv.is_valid_ip(data.fw_dns3)) {
	    err_list.add("Invalid IP address for DNS server #3!");
	    return false;
	}

	// Syslog.
	if (is_not_empty(data.syslog_host) && !pv.is_valid_ip(data.syslog_host)) {
		err_list.add("Invalid IP address for Syslog host!");
		return false;
	}

	if (data.remote_logging && is_empty(data.syslog_host)) {
	    err_list.add("Remote logging option requires a syslog host!");
	    return false;
	}

	// Netflow.
	if (is_not_empty(data.netflow_ip) && !pv.is_valid_ip(data.netflow_ip)) {
		err_list.add("Invalid netflow router IP!");
		return false;
	}

	if (data.use_netflow && is_empty(data.netflow_ip)) {
	    err_list.add("Netflow router IP is missing!");
	    return false;
	}

	// Misc.
	if (!pv.is_valid_domain(data.admin_domain)) {
	    err_list.add("Invalid admin domain!");
	    return false;
	}

	return true;
}

//-----------------------------------------------
void update(ConfigDao dao){
	if(demo_flag){
		err_list.add("Update not allowed on demo site!");
		return;
	}

	ConfigData data = new ConfigData();

	// Block and authentication.
    data.block_redi_ip = param_str("block_redi_ip");
    data.rf_block_redi_ip = param_str("rf_block_redi_ip");
    data.ipv6_block_redi_ip = param_str("ipv6_block_redi_ip");
    data.enable_login = param_bool("enable_login");
    data.login_domain = param_str("login_domain");
    data.logout_domain = param_str("logout_domain");
    data.login_session_ttl = param_int("login_session_ttl");

	// DNS setup.	
	data.fw_dns1 = param_str("fw_dns1");
    data.fw_dns2 = param_str("fw_dns2");
    data.fw_dns3 = param_str("fw_dns3");
    data.fw_timeout = param_int("fw_timeout");
    data.clt_cache_ttl = param_int("clt_cache_ttl");
    data.max_cache_size = param_int("max_cache_size");

	// Syslog.
    data.syslog_host = param_str("syslog_host");
    data.export_blocked_only = param_bool("export_blocked_only");
    data.remote_logging = param_bool("remote_logging");

    // Netflow.
	data.netflow_ip = param_str("netflow_ip");
    data.netflow_port = param_int("netflow_port");
    data.use_netflow = param_bool("use_netflow");

	// Misc.
    data.admin_domain = param_str("admin_domain");
    data.bypass_ms_update = param_bool("bypass_ms_update");
    data.log_retention_days = param_int("log_retention_days");
    data.ssl_only = param_bool("ssl_only");
	data.auto_backup_days = param_int("auto_backup_days");
	data.agent_policy_update_period = param_int("agent_policy_update_period");

	// Validate and update it.
	if(chk_param(data) && dao.update(data)){
		succ_list.add("Propriedades atualizadas!");
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
ConfigDao dao = new ConfigDao();

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("update")){
	update(dao);
}

// Global.
ConfigData data = dao.select_one();
%>

<!DOCTYPE html>
<html>
    <jsp:include page="../../include/header.jsp" flush="true">
       <jsp:param name="page" value="Propriedades"/>
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
		   <jsp:param name="page" value="Propriedades"/>
	        </jsp:include>

                <!-- Main content -->
                <section class="content">       
                    <div id="tipue_drop_content"></div>

                    <!-- form start -->
                    <form role="form" id="config" action="<%= get_page_name()%>" method="post">
                    <input type="hidden" name="action_flag" value="update">
                        <div class="box box-lime">

                            <div class="box box-lime">
                                <div class="box-header">
                                    <i class="fa fa-sign-in"></i>
                                    <h3 class="box-title">Autentica&ccedil;&atilde;o</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->
                                    <div class="box-body">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="enable_login">Habilitar autentica&ccedil;&atilde;o</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="enable_login" name="enable_login" <%if(data.enable_login){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="block_redi_ip">IP Destino - Bloqueio interno</label>
                                                <input type="text" class="form-control" id="block_redi_ip" name="block_redi_ip" value="<%= data.block_redi_ip%>" />
                                                <!-- input type="text" class="form-control" id="block_redi_ip" name="block_redi_ip" value="<%= data.block_redi_ip%>" data-inputmask="'alias': 'ip'" data-mask/ -->
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="rf_block_redi_ip">IP Destino - Bloqueio Externo</label>
                                                <input type="text" class="form-control" id="rf_block_redi_ip" name="rf_block_redi_ip" value="<%= data.rf_block_redi_ip%>" data-inputmask="'alias': 'ip'" data-mask/>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="ipv6_block_redi_ip">IPv6 Destino - Bloqueio</label>
                                                <input type="text" class="form-control" id="ipv6_block_redi_ip" name="ipv6_block_redi_ip" value="<%= data.ipv6_block_redi_ip%>" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="login_domain">FQDN Login</label>
                                                <input type="text" class="form-control" id="login_domain" name="login_domain" value="<%= data.login_domain%>" >
                                            </div>
                                            <p class="help-block">Endere&ccedil;o para autentica&ccedil;&atilde;o/login do usu&aacute;rio - Ex.: login.nxfbrasil.internal</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="logout_domain">FQDN Logout</label>
                                                <input type="text" class="form-control" id="logout_domain" name="logout_domain" value="<%= data.logout_domain%>" >
                                            </div>
                                            <p class="help-block">Endere&ccedil;o para logout - Ex.: logout.nxfbrasil.internal</p>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="login_session_ttl">TTL da Sess&atilde;o de Login</label>
                                            <div class="input-group col-xs-2">
                                                <input type="text" class="form-control" id="login_session_ttl" name="login_session_ttl" value="<%= data.login_session_ttl%>" maxlength="4" >
                                                <span class="input-group-addon">minutos</span>
                                            </div>
                                            <p class="help-block">Prazo para expira&ccedil;&atilde;o da sess&atilde;o de login por inatividade.  5 ~ 1440 minutos </p>
                                        </div>
                                    </div><!-- /.box-body -->

                            </div><!-- /.box box-lime -->  



                            <div class="box box-maroon">
                                <div class="box-header">
                                    <i class="fa fa-globe"></i>
                                    <h3 class="box-title">DNS Settings</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->

                                    <div class="box-body">
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="fw_dns1">Forwarding DNS Server #1</label>
                                                <input type="text" class="form-control" id="fw_dns1" name="fw_dns1" value="<%= data.fw_dns1%>" data-inputmask="'alias': 'ip'" data-mask/>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="fw_dns2">Forwarding DNS Server #2</label>
                                                <input type="text" class="form-control" id="fw_dns2" name="fw_dns2" value="<%= data.fw_dns2%>" data-inputmask="'alias': 'ip'" data-mask/>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="fw_dns3">Forwarding DNS Server #3</label>
                                                <input type="text" class="form-control" id="fw_dns3" name="fw_dns3" value="<%= data.fw_dns3%>" data-inputmask="'alias': 'ip'" data-mask/>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="fw_timeout">Forwarding DNS Server Query Timeout</label>
                                            <div class="input-group col-xs-2">
                                                <input type="text" class="form-control" id="fw_timeout" name="fw_timeout" value="<%= data.fw_timeout%>" maxlength="2" >
                                                <span class="input-group-addon">seconds</span>
                                            </div>
                                            <p class="help-block">1 ~ 20 seconds </p>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="clt_cache_ttl">Max Client Cache TTL</label>
                                            <div class="input-group col-xs-2">
                                                <input type="text" class="form-control" id="clt_cache_ttl" name="clt_cache_ttl" value="<%= data.clt_cache_ttl%>" maxlength="5" >
                                                <span class="input-group-addon">seconds</span>
                                            </div>
                                            <p class="help-block">60 ~ 86400 seconds, 0 = bypass</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="max_cache_size">Response Cache Size</label>
                                                <input type="text" class="form-control" id="max_cache_size" name="max_cache_size" value="<%= data.max_cache_size%>" >
                                            </div>
                                            <p class="help-block">100,000 ~ 2,000,000</p>
                                        </div>
                                    </div><!-- /.box-body -->

                            </div><!-- /.box box-maroon-->  



                            <div class="box box-teal">
                                <div class="box-header">
                                    <i class="fa fa-newspaper-o"></i>
                                    <h3 class="box-title">Syslog</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->

                                    <div class="box-body">
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="syslog_host">Syslog Host IP</label>
                                                <input type="text" class="form-control" id="syslog_host" name="syslog_host" value="<%= data.syslog_host%>" data-inputmask="'alias': 'ip'" data-mask/>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="export_blocked_only">Export Blocked only</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="export_blocked_only" name="export_blocked_only" <%if(data.export_blocked_only){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="remote_logging">Enable Remote Logging</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="remote_logging" name="remote_logging" <%if(data.remote_logging){out.print("checked");}%> >
                                            </div>
                                        </div>
                                    </div><!-- /.box-body -->
                                        
                            </div><!-- /.box box-teal -->  



                            <div class="box box-purple">
                                <div class="box-header">
                                    <i class="fa fa-share-square-o"></i>
                                    <h3 class="box-title">Netflow</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->

                                    <div class="box-body">
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="netflow_ip">Router IP</label>
                                                <input type="text" class="form-control" id="netflow_ip" name="netflow_ip" value="<%= data.netflow_ip%>" data-inputmask="'alias': 'ip'" data-mask/>
                                            </div>
                                            <p class="help-block text-yellow"><b>Attention!</b>  Restart of NxFilter required when changing netflow settings!</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group col-xs-2">
                                                <label class="control-label" for="netflow_port">Listen Port</label>
                                                <input type="text" class="form-control" id="netflow_port" name="netflow_port" value="<%= data.netflow_port%>" >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="use_netflow">Run Collector</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="use_netflow" name="use_netflow" <%if(data.use_netflow){out.print("checked");}%> >
                                            </div>
                                        </div>
                                    </div><!-- /.box-body -->
                                        
                            </div><!-- /.box box-purple -->  



                            <div class="box box-primary">
                                <div class="box-header">
                                    <i class="fa fa-stack-overflow"></i>
                                    <h3 class="box-title">Miscellaneous</h3>
                                    <div class="box-tools pull-right">
                                        <button class="btn btn-default btn-sm" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div><!-- /.box-header -->

                                    <div class="box-body">
                                        <div class="form-group">
                                            <div class="input-group col-xs-3">
                                                <label class="control-label" for="admin_domain">Admin Domain</label>
                                                <input type="text" class="form-control" id="admin_domain" name="admin_domain" value="<%= data.admin_domain%>" >
                                            </div>
                                            <p class="help-block">Domain for NxFilter Administration</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="bypass_ms_update">Bypass Microsoft Updates</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="bypass_ms_update" name="bypass_ms_update" <%if(data.bypass_ms_update){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="log_retention_days">Log Retention Days</label>
                                            <div class="input-group col-xs-2">
                                                <input type="text" class="form-control" id="log_retention_days" name="log_retention_days" value="<%= data.log_retention_days%>" maxlength="2" >
                                                <span class="input-group-addon">days</span>
                                            </div>
                                            <p class="help-block">3 ~ 90</p>
                                        </div>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <label class="control-label" for="ssl_only">Admin Page SSL Only</label>
                                                <br />
                                                <input type="checkbox" class="flat-green" id="ssl_only" name="ssl_only" <%if(data.ssl_only){out.print("checked");}%> >
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="auto_backup_days">Auto Backup</label>
                                            <div class="input-group col-xs-2">
                                                <input type="text" class="form-control" id="auto_backup_days" name="auto_backup_days" value="<%= data.auto_backup_days%>" maxlength="2" >
                                                <span class="input-group-addon">days</span>
                                            </div>
                                            <p class="help-block">Number of daily backups to save. 0 ~ 30</p>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label" for="agent_policy_update_period">Agent Policy Update Period</label>
                                            <div class="input-group col-xs-2">
                                                <input type="text" class="form-control" id="agent_policy_update_period" name="agent_policy_update_period" value="<%= data.agent_policy_update_period%>" maxlength="3" >
                                                <span class="input-group-addon">seconds</span>
                                            </div>
                                            <p class="help-block">NxFilter agents policy update frequency. 60 ~ 600</p>
                                        </div>
                                    </div><!-- /.box-body -->

                            </div><!-- /.box box-primary-->  

                        <div class="box-footer">
                            <button id="submitBtn" type="submit" form="config" class="btn btn-info">Save All Settings</button>
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
                    document.getElementById("config").submit();        
                });
                
                $('#config').submit(function(e) {
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
