<%
// Error message.
if(!err_list.isEmpty()){
    String errms = "";
	for(String err : err_list){
		errms = errms + err + " ";
	}
        //Remove 3 types of line breaks to keep from breaking javascript notifications
        errms = errms.replaceAll("(\\r\\n|\\n|\\r)", "");
	out.println("errmsg = \"" + errms + "\";");
}

// Success message.
if(!succ_list.isEmpty()){
    String succms = "";
    for(String succ : succ_list){
        succms = succms + succ + " ";
    }
    //Remove 3 types of line breaks to keep from breaking javascript notifications
    succms = succms.replaceAll("(\\r\\n|\\n|\\r)", "");
    out.println("succmsg = \"" + succms + "\";");
}
%>
