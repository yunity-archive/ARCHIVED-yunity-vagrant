# box

This is for building the yunity.box image, used by the directory above.

It is basically exactly the same, except it doesn't mount filesystems or map ports.

To package it up, first install/run it, then:

```
vagrant package --output yunity.box
```