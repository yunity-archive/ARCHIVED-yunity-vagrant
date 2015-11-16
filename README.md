# yunity-vagrant

A vagrant setup for yunity.

This allows you to either:
* run a complete yunity deployment inside a vm
* run a partial yunity deployment, so you can work on 1 or more of the repos

If you just want to set things up directly on your local machine, check out [yunity setup](https://github.com/yunity/yunity-setup). This repo will do the setup inside a vagrant vm.

## Prerequisites

vagrant (version 1.7 or higher) and virtualbox (version 5 or higher) are required.

Either get them using your package manager or download them from:

* [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
* [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

### Ubuntu/Debian

The packaged version of vagrant is probably too old, you can install a good version from the vagrant site:

```
wget https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.deb
sudo dpkg -i vagrant_1.7.4_x86_64.deb
```

### archlinux

This will install vagrant and virtualbox and configure the kernel module.

```
sudo pacman -S vagrant virtualbox virtualbox-host-dkms linux-headers
sudo dkms install vboxhost/5.0.8 # this version could change of course...
sudo /sbin/rcvboxdrv
```

Optionally, if you want to have dkms rebuild on kernel upgrade, you must enable it:
```
systemctl enable dkms.service
```

If you want to load the module on boot, edit:
```
/etc/modules-load.d/virtualbox.conf
```

(the kernel modules needed should be `vboxnetadp vboxnetflt vboxpci vboxdrv`)

## Quick start

This will run everything.

Get the box/image first! (you might be able to find a local copy that will download quicker...)

```
vagrant box add yunity http://p12607.ngcobalt20.manitu.net/download.php?file=yunity.box
```

If you are at a wuppdays event you can download it from our local server:
```
vagrant box add yunity http://loewenbraeu/upload/yunity.box
```

Then:

```
git clone git@github.com:yunity/yunity-vagrant.git yunity
cd yunity
vagrant up --provision
```

You can then visit [localhost:8091](http:///localhost:8091) for the mobile web app and [localhost:8090](http://localhost:8090) for the web app.

For now you always need to include the `--provision` option (`vagrant up --provision`) as this not only sets the box up, but starts the apps running (this will not always be true).

## Work on the frontend

If you want to work on the frontend, you can clone the repos (in the same directory as the vagrant setup).

```
# you can clone any or all of these as you wish
git clone git@github.com:yunity/yunity-webapp.git
git clone git@github.com:yunity/yunity-webapp-common.git
git clone git@github.com:yunity/yunity-webapp-mobile.git
```

Then you must reload and reprovision the machine:

```
vagrant reload --provision
```

It will then mount those directories inside the vm to let you work on them from the host machine.

## Updating

To update the setup, have your vagrant up and running then:

```
make update
```
