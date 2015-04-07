NxFAdmin
========

Web administration template for NxFilter.

Extract archive contents to a location under your base NxFilter installation.  

For instance on linux and your NxFilter files are located in /nxd, then something like "tar zxf nxfadmin-v1.0.tar.gz -C /nxd/" will create /nxd/skins/nxfadmin containing the new GUI files.  

Edit /nxd/conf/cfg.properties and add "www_dir = skins/nxfadmin" at the bottom.  

Save the file and restart NxFilter to activate the new GUI.  

**To change back to the default GUI, just remove the "www_dir = skins/nxfadmin" parameter from cfg.properties and restart NxFilter.**

================================================================================================================

In order to use the default login HTML with NxFAdmin, you'll also need to change one line for the login page to post back to "login.jsp" instead of "block,login.jsp".  If you'll goto configuration - block page, find and change the following for the login page html, that should take care of users not being able to login using NxFAdmin.

Find:
```
#!html
<form action='block,login.jsp' method='post'>
```


Change to:
```
#!html
<form action='login.jsp' method='post'>
```

**This HTML change will need to be reversed if you revert back to the default GUI**
