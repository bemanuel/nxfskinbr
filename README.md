NxFAdmin
========

Web administration template for NxFilter.

Extract archive contents to a location under your base NxFilter installation.  

For instance on linux and your NxFilter files are located in /nxd, then something like "tar zxf nxfadmin-v1.0.tar.gz -C /nxd/" will create /nxd/skins/nxfadmin containing the new GUI files.  

Edit /nxd/conf/cfg.properties and add "www_dir = skins/nxfadmin" at the bottom.  

Save the file and restart NxFilter to activate the new GUI.  

**To change back to the original GUI, just remove the "www_dir = xxxxx" parameter from cfg.properties and restart NxFilter.**