#!/bin/bash
tree|sed 's/└/`/g;s/─/-/g;s/├/|/g'
