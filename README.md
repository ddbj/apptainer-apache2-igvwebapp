# apptainer-apache2-igvwebapp
A set of files for starting an apptainer instance that runs igv-webapp and apache2. Generate the apptainer image locally from ubuntu-20.04-apache-2.4-igvwebapp-1.13.def using the apptainer build command, or copy the file on the NIG supercomputer to run it on the NIG supercomputer.

## build of image file

    $ sudo apptainer build ubuntu-20.04-apache-2.4-igv-webapp-1.13.sif ubuntu-20.04-apache-2.4-webapp-1.13.def


## settings
### httpd.conf

    ServerRoot "/usr/local/apache2"
    
    Listen 38080
    User user1
    Group group1

Change user1 to your account name, group1 to your group name, and 38030 to the port number used by apache2. If you check with the netstat command that port 38080 is not in use, no changes are necessary.

### package.json

    {
      "name": "igv-webapp",
      "version": "1.13.11",
      "description": "igv web app",
      "keywords": [],
      "author": "Douglass Turner and Jim Robinson",
      "license": "MIT",
      "scripts": {
        "start": "npx http-server -p 38081 dist",
        "build": "node scripts/updateVersion.js && node scripts/clean.js && rollup -c && node scripts/copyArtifacts.js"

Change 38081 to the port number used by igv-webapp.
If you check with the netstat command that port 38081 is not in use, no changes are necessary.


## start of apptainer instance

    $ bash start_container.sh

On the NIG supercomputer, an image file is copied form /lustre7/software/experimental/igv-webapp/ubuntu-20.04-apache-2.4-igv-webapp-1.13.sif at the first execution.

If you are not on a NIG supercomputer, please build the image file before execution.

Additionally, cgi-bin, htdocs, and logs directories are created.

When executed on the NIG supercomputer, the sample bam file and index file are also copied to the htdocs directory.

Place the bam file and index file that you want to display with igv-webapp in the htdocs directory.

## accessing igv-webapp

Open http://&lt;host IP address&gt;:&lt;port number set in package.json&gt; in your web browser.

To add a track, select the URL ... from Tracks menu and input belows.

* http://&lt;host IP address&gt;:&lt;port number set in httpd.conf&gt;/&lt;bam file placed in htdocs directory&gt;
* http://&lt;host IP address&gt;:&lt;port number set in httpd.conf&gt;/&lt;index ifle placed in htdocs directory&gt;


