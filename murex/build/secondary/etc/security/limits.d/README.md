# About the tuning of ulimit

Who exactly reads _/etc/limits.d/*_?

This is the job of **pam_limits.so**, which is loaded by libpam.so according to rules in _/etc/pam.d_.
Normal processes do not load **libpam.so**, only security-concerned processes such as `passwd`, `login`, `su`, `sudo`, `ssh`...

Because Docker launches processes without going through any authentication,
even asking Docker to run a process as a non-root user does not cause _/etc/limits.d_ to be read:

```
$ docker run --rm -u nobody localhost:5000/internal/rhel:6.4 grep process /proc/self/limits
Max processes             unlimited            unlimited            processes
```

You have to go out of your way to cause libpam.so to kick in, but it's feasible:

```
$ docker run --rm localhost:5000/internal/rhel:6.4 su -s /bin/sh -c 'grep process /proc/self/limits' nobody
Max processes             1024                 unlimited            processes
```

If that last scenario looks convoluted, consider that something similar will happen if you ever run an SSH daemon in your container.

So, these limits can have an effect on processes in a container. But why do we really care ? 1024 processes seems enough for one container.

Unfortunately, the Linux kernel still considers nobody (actually, UID 99) in one container to be the same user as UID 99 in any other container (or outside any container).

So limits are applied across containers! This is clearly demonstrated at https://docs.docker.com/engine/reference/commandline/run/#for-nproc-usage

Added to the fact that those default limits in 90-nproc.conf are only enforced, as seen above, in some situations, 
this gives us a good reason for getting rid of that default nproc limit (since the default for nproc is unlimited).
