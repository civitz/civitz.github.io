---
layout: post
title: "It's never a network problem, until it is"
---

You know when you have a problem and you struggle to find the solution?

And you just try and try, maybe not even trying some solution because it could never be that THAT part is broken, right? Right?

Well... i struggled with git from within a VM and with a VPN: no git push, spotty git pull. I assumed it was a git problem, or a key problem. No, it was an MTU problem!

Turns out when you hop between increasingly strict networks (virtual switches, vpn, wifi packets, you name it) sometimes fragmentations can't cope with the whole thing...

So i had to run

```
sudo ip link set dev eth0 mtu 1400
```
to lower the MTU and finally being able to operate git.

(`sudo ifconfig eth0 mtu 1458` does not work because ubuntu 18+ does not ship with `ifconfig`)

