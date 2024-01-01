
I am using <b>Ubuntu 22.04</b> and <b>Windows 10</b> on <b>dual boot</b> mode. Only 40 GB of SSD is assigned to Ubuntu and the rest 256 GB of SSD is assigned to Windows along with 1 TB of HDD( which are logically divided in 5 partitions, 1 of which contains system files probably). 
Now, I want full access to the partitions of HDD from Ubuntu too, i.e. I want to also mount the HDD partitions on Ubuntu. In short, I want to share HDD between both Windows and Ubuntu.

# Mount non-assigned disk partition to Linux user

### 1. List available partitions
At first, find out the partitions present in the storage devices.
```bash
lsblk
```
<b>N.B:</b>This command shows all the partitions and/or devices (both mounted and unmounted) physically present in the computer.

In my case, <b><i>sda2, sda3, sda4, sda5</i></b> are the partitions that I want to mount. `nvme1p0n3` contains Windows `C:/` drive and `nvme1p0n5` contains Ubuntu `root` directory.


### 2. Create directory for mounting partitions or disks
Now, create mounting points for the partitions. The mounting point must be in `/media` directory. The command is:
```bash
sudo mkdir /media/username/mounting_point_name
```
<b>N.B:</b>  `/media` directory contains the <b>mounted</b> partitions and/or drives (CD, USB, HDD, SSD, any memory device)

I will create 4 directories in the  ```media/naeem/``` directory of ```root```/`/` for mounting the partitions, as I wish to mount 4 partitions.
```bash
#!/bin/bash
sudo mkdir /media/naeem/Personal
sudo mkdir /media/naeem/study
sudo mkdir /media/naeem/Apps
sudo mkdir /media/naeem/Etc
```


### 3. Mount the partitions on the mounting points
To mount the partitions to the directory, the command structure is :
```bash
sudo mount /dev/unmounted_partition /media/username/mounting_point
```
<b>N.B: </b> Note the ```/dev``` part of the of the partition address. ``lsblk`` doesn't include this part when showing the partitions. Include it in the command as it is part of absolute address. 

I will mount 4 partitions to their intended directories. The command used is:
```bash
sudo mount /dev/sda2 /media/naeem/Personal
sudo mount /dev/sda4 /media/naeem/study
sudo mount /dev/sda5 /media/naeem/Apps
sudo mount /dev/sda3 /media/naeem/Etc
```

# Limitation
The mounting is temporary and partitions will be unmounted every time the computer shuts down.

# Bypassing limitation: Making the mounting appear permanent
By running the mounting portion of code every time the computer boots, we can make the mounting of the partitions to appear to be permanent. We can use `crontab` to run a script every time PC boots.


Firstly, create a bash file (let's name it `mount.sh`)  with shebang/`#!bin/bash`, (to avoid typing `bash` in terminal command) with the mounting commands in a directory. 

So,  I will create the file in `/usr` directory and edit it with `nano` editor. To do that, I will need `sudo` permission as alternating anything outside `/home` directory needs <b><i>super user permission</i></b>. So, write 
```bash
sudo touch /usr/mount.sh
sudo nano /usr/mount.sh
``` 

<b>N.B:</b> Devian based distributions face problem when the script or bash file is in user's `/home/`/ `~/` directory. Apparently, `crontab` runs even before `/home` is mounted, so, if the script is in home, it will not be executed. That's why file should be in other directory than `~`.
in terminal and write the commands below on that bash file from terminal's nano editor. (Note that any activity <b><i>not</i></b> in home directory needs `sudo` permission, and mounting is done in `/media` directory) .
```bash
#!/bin/bash
sudo mount /dev/sda2 /media/naeem/Personal
sudo mount /dev/sda4 /media/naeem/study
sudo mount /dev/sda5 /media/naeem/Apps
sudo mount /dev/sda3 /media/naeem/Etc
```


Secondly,  give execution permission to the bash file. To do it, open terminal from `mount.sh`'s directory or `cd` to there. Then type 
```bash
sudo chmod +x mount.sh
```

Thirdly, enter the command below to the terminal. 
```bash
sudo crontab -e
```
Now, navigate to the bottom of the opened file and add the absolute path of `mount.sh` after typing `@reboot` in a newline. 
```bash
# some command lines that might be already present.
# ...
@reboot /usr/mount.sh
```

Save and exit the terminal. Now, I should be good to go. 

# Conclusion

The bash file <i>mount.sh</i> is executed every time Ubuntu is turned on. So, mount.sh mounts the drive partitions every time Ubuntu is booted by using `crontab`.
### Alternatives
This auto execution of commands on startup can also be done by adding the bash file path to the end of `/etc/rc.local` file or by using `/etc/init.d` file. `~/.bashrc` was also suggested, but apparently, it executes every time terminal is opened, not when Ubuntu is booted.