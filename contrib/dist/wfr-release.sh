#!/bin/sh
# Copyright (c) 2014 Intel Corporation. All rights reserved.

# Tags are expected to be of the form wfr-orig-vX.Y{.Z}.  X.Y.Z is the Open MPI
# version, for example 1.8 or 1.8.2.  Examples of valid full tags:
# wfr-orig-v1.8 or wfr-orig-v1.8.2

# The release number is calculated as the number of git commits since the last
# tag of the above form.

TAG="wfr-orig-v"
RELEASE="release"
SPEC="contrib/dist/linux/openmpi.spec"

CDUP=`git rev-parse --show-cdup`
if [ "$CDUP" ]; then
	echo "CDUP $CDUP"
	cd $CDUP
fi

if [ ! -e .git ]; then
	echo "This script is only to be run inside a WFR Open MPI git tree; aborting."
	exit 1
fi

if [ ! -f $SPEC ]; then
	echo "SPEC file $SPEC not found; aborting.  Is this really a WFR Open MPI git tree?"
	exit 1
fi

# git describe has output in the form: wfr-v1.8-9-g840c2f7
# In that example, this command extracts just the '9'.
#RELEASE=`git describe --tags --long --match="$TAG*" | sed -r -e "s/$TAG[0-9]+(\.[0-9]+)+-[0-9]+\.[0-9]+-//" -e 's/-g.*$//'`
RELEASE=`git describe --tags --long --match="$TAG*" | sed -r -e "s/$TAG[0-9]+(\.[0-9]+)+-//" -e 's/-g.*$//'`

if ! [[ $RELEASE =~ ^[0-9]+$ ]]; then
	RELEASE=`git describe --match "v*" | cut -d'-' -f2`
fi
echo "WFR commit number: $RELEASE"

sed -i $SPEC -r -e "s/Release: [0-9]+/Release: $RELEASE/"

