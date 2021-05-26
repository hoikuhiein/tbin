#!/bin/bash
export PATH=$PATH:/data/share/jdk1.7.0_71/bin
cd `dirname $0`
./es $@
