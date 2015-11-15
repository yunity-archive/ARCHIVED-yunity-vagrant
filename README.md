# yunity-vagrant

A vagrant setup for yunity.

This allows you to either:
* run a complete yunity deployment inside a vm
* run a partial yunity deployment, so you can work on 1 or more of the repos

There are 4 yunity repos:
* yunity-core: a django webapp
* yunity-webapp-mobile: an angularjs mobile web frontend
* yunity-webapp: an angularjs web frontend
* yunity-webapp-common: common functionality between the two angularjs apps

And there are a handful of services running:
* postgresql
* redis
* elasticsearch (in the future)

If you want to run all this on your local machine, you might want to use the [yunity setup](https://github.com/yunity/yunity-setup).

## Prerequisites

You need vagrant and virtualbox installed, and you should get hold of yunity.box from somewhere (with `vagrant box add yunity <someurl or path>`)

You can get them how you want :)

#### From website

* [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
* [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

#### archlinux

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

## Run everything

```
git clone git@github.com:yunity/yunity-vagrant.git yunity
cd yunity
vagrant up
```

You can then visit [localhost:8091](http:///localhost:8091) for the mobile web app and [localhost:8090](http://localhost:8090) for the web app.

## Work on the mobile webapp

To work on just the mobile webapp, you have the code on your host machine, and they get mounted into the vm.

```
git clone git@github.com:yunity/yunity-webapp-common.git
git clone git@github.com:yunity/yunity-webapp-mobile.git
```

Then you must reload and reprovision the machine:

```
vagrant reload --provision
```

### How does it work?

The `Vagrantfile` checks to see if the directories exist and if so, mounts them into the app. The `bootstrap.sh` script runs the [`Makefile`](https://github.com/yunity/yunity-setup/blob/master/Makefile) from the yunity-setup project, which will configure it correctly.
