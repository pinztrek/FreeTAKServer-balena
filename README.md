# FreeTAKServer-balena

## Simple docker file to run FTS in Balena environment

Balena offers a docker environment along with the capability to make devices as IOT deployed devices. 
Specifically, it is optimized to manage a fleet of devices. 

If all you want is a standalone pi running FTS AND the capability to use it as a general purpose linux host, then this is not for you. 

But if you want a way to manage one or more devices running apps like FreeTAKServer, it can be a big win. 

This howto will not teach you all the nuances of Balena. There is full documentation on that you should 
explore. But you should be able to use this guide to get an FTS instance running on balena and play with it. 

### Quick Installation:

1. Create your account at <https://balena-cloud.com> and login
2. Create a new balena "application"  for FreeTAKserver using the following link:<br><br>
<https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/pinztrek/FreeTAKServer-balena>
<br> or this button: [![](https://www.balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy)

   * Select your Device type. (You can search with just a few letters ex: rasp)

   * The remainder of the create application menu can be left as defaults

   * The application should start building in the background. It will ask you to add a device.

   * Before you try to add a device, take a look at <br><https://www.balena.io/docs/learn/getting-started/raspberry-pi/nodejs/>

    ** Since you've already created your application, you should read starting at "Add your first device" <https://www.balena.io/docs/learn/getting-started/raspberry-pi/nodejs/#add-your-first-device> 

3. Click the Add Device button. It will pop a menu up
    * Select the type of device. Typically Pi's. Note that Pi3 & Pi4 can run a Pi0 application, but 
not vice versa. So you probably want to pick your actual device. 
    * Use defaults for the OS and version
    * Select Development initially. This will allow eash SSH in. <br><br>
You can switch to Production after you have debugged and setup your SSH keys. 
    * Select ethernet or wifi+ethernet. 
<br>You'll want to configure wifi if you ever intend to use it as it is much easier to configure in this step. 

4. Once ready, click Download balenaOS button. It will should download a small device image ready to flash

5. X out of the add device menu once you have downloaded the image. It should leave you on your "devices" page for the application

6. Flash the image using tool of your choice, though Balena-etcher makes it very easy. 

7. Boot up the device. As it wakes up, it should show up on your dashboard. 

8. If all goes well, you will see it provision the FreeTAKServer service, and start up. 

9. You can look at the logs, and also ssh into the host OS (which runs the supervisor) or into the container instance (often "main" or the name of the service). 

    If you selected the development OS, you can also ssh into is at port 22222. It will give you a root login. 

### Note

* Important: If you decide to change things, make sure you delete the device before deleting the application. 
If you leave a orphaned device it thinks is still running it will not let you delete the application. 

* Though much of the Balena docmentation refers to their command line tool (balena-cli), you 
can push builds to balene using git and not have to install node and the cli. <br><br>
The CLI is a bit easier, but also takes a bit to install. 

