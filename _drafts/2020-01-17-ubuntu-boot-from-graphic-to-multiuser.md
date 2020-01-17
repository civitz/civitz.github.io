

```
# get current boot target (similar to runlevel)
systemctl get-default
# make note of this, in my case it was graphical.target

systemctl set-default multi-user.target


```
