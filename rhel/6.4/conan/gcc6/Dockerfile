FROM localhost:5000/aallrd/rhel-6.4-conan-base:latest
MAINTAINER "aallrd@github"

RUN yum install -y "devtoolset-6-toolchain" \
	&& yum clean all \
    && cd ~/.conan/profiles && ln -s rhel-gcc6 default

# export the devtoolset env variables
ENV PATH=/opt/rh/devtoolset-6/root/usr/bin${PATH:+:${PATH}} \
    LD_LIBRARY_PATH=/opt/rh/devtoolset-6/root/usr/lib64:/opt/rh/devtoolset-6/root/usr/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    PYTHONPATH=/opt/rh/devtoolset-6/root/usr/lib64/python2.6/site-packages:/opt/rh/devtoolset-6/root/usr/lib/python2.6/site-packages${PYTHONPATH:+:${PYTHONPATH}} \
    JAVACONFDIRS=/opt/rh/devtoolset-6/root/etc/java${JAVACONFDIRS:+:${JAVACONFDIRS}} \
    PERL5LIB=/opt/rh/devtoolset-6/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-6/root/usr/lib/perl5:/opt/rh/devtoolset-6/root//usr/share/perl5/vendor_perl${PERL5LIB:+:${PERL5LIB}}
