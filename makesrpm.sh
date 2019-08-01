#!/bin/bash
RPM_NAME=openmpi

rm -rf BUILD RPMS SOURCES SPECS SRPMS BUILDROOT

./contrib/dist/wfr-release.sh
./contrib/dist/make_tarball --no-git-update --greekonly --distdir $PWD

mkdir -p ./{BUILD,RPMS,SOURCES,SPECS,SRPMS,BUILDROOT}
dir=$PWD
cd contrib/dist/linux
rpmtopdir=$dir ./buildrpm.sh -R $dir $dir/$RPM_NAME-*.tar.gz
