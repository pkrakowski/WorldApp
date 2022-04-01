#!/bin/bash
set -e

echo "Starting SSH ..."
service ssh start

echo "Starting Apache ..."
apachectl -D FOREGROUND