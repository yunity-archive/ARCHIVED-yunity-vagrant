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

## Run everything

```
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
