---
layout: post
title: Boot ubuntu from graphic to text mode
---

I recently switched from working fulltime from a VM in graphical ubuntu, to using the VM from windows via SSH.
To avoid wasting resources, I wanted the VM to boot to cli, without even trying any graphical login.
Ubuntu is using systemd to control every service, including what was called runlevels.

To switch from graphical to text only boot (also called multi-user), first make note of the current boot target:

```bash
systemctl get-default
```

In my case it was `graphical.target`.

Then switch to multi-user:

```bash
systemctl set-default multi-user.target
```

Next time you boot the VM, you should not see the graphical login.

This trick also works in reverse if you change your mind, or if you are starting from an ubuntu server image and switching to a graphical boot.