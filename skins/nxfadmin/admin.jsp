<%@include file="include/lib.jsp"%>
<%
// Create data access object.
AdminLoginDao dao = new AdminLoginDao(request);

// Action.
String action_flag = param_str("action_flag");
if(action_flag.equals("logout")){
	dao.logout();
}
if(action_flag.equals("login")){
	if(dao.login(param_str("uname"), param_str("passwd"))){
		// Start page for admin.
		response.sendRedirect("dashboard.jsp");
		return;
	}
	else{
		err_list.add("Login Incorrect!");
	}
}
%>
<!DOCTYPE html>
<html class="bg-black">
    <head>
        <meta charset="UTF-8">
        <title><%= GlobalDao.get_nx_name()%> v<%= GlobalDao.get_nx_version()%> | Log in</title>
        <meta http-equiv='Expires' content='-1'> 
        <meta http-equiv='Pragma' content='no-cache'> 
        <meta http-equiv='Cache-Control' content='no-cache'> 
        <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <!-- Theme style -->
        <link href="css/NxF.css" rel="stylesheet" type="text/css" />

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
          <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
        <![endif]-->
    </head>
    <body class="bg-black">

        <div class="form-box" id="login-box">
            <div class="header">Admin Login</div>
            <form action='<%= get_page_name()%>' method="post">
                <input type='hidden' name='action_flag' value='login'>
                <div class="body bg-gray">
                    <div class="form-group">
                        <input type="text" id="uname" name="uname" class="form-control" placeholder="User Name..."/>
                    </div>
                    <div class="form-group">
                        <input type="password" name="passwd" class="form-control" placeholder="Password..."/>
                    </div>
<%if(dao.is_first_login()){%>
                    <div class="form-group">
                        <ul>
                           <li>Initial name & password is 'admin' & 'admin'</li>
                           <li>Tutorial is available here: <a target='_blank' href='<%= GlobalDao.get_nx_tutorial()%>'>NxFilter</a></li>
                        </ul>
                    </div>
<%}%>          
                </div>
                <div class="footer">                                                               
                    <button type="submit" class="btn bg-light-blue btn-block">Sign Me In</button>  
                </div>
            </form>
        </div>
            <br />
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.min.js" type="text/javascript"></script>
        <script src="js/jquery.noty.packaged.min.js" type="text/javascript" ></script>
        <!-- NxF App -->
        <script src="js/NxF/app.js" type="text/javascript"></script>
        <!-- page script -->
        <script type="text/javascript">
            $(document).ready(function () {
                var errmsg = "";
                var succmsg = "";
                <%@include file="include/messages.jsp"%>
                
                if (errmsg != null && !(errmsg === "")) {
                    //generateDiv('div#notifications', 'error', errmsg, 'topCenter');
                    generate('error', errmsg, 'topCenter');
                }
                if (succmsg != null && !(succmsg === "")) {
                    //generateDiv('div#notifications', 'success', succmsg, 'topCenter');
                    generate('success', succmsg, 'topCenter');
                }

                $('#uname').focus(); 
             
            });


        </script>
    </body>
</html>
