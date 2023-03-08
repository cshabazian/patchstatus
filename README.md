# patchstatus

This is a set of bash scripts and an ansible playbook that will connect to RPM based servers (CentOS / RHEL / ALMA / Rocky / OEL / Scientific / etc.) and check the patch status of the server, then create an html dashboard of the status which can be viewed in your browser.

The dashboard contains the server hostname, number of updates available (security related ones in red, all updates in green), the version of linux, when it was last checked, and whether or not the system needs a reboot in order to ensure all installed patches and the latest kernel are running.
![patchstatus dashboard](https://user-images.githubusercontent.com/30184871/223853161-1e938fec-d294-492f-9276-7cc63aa495b4.jpg)
