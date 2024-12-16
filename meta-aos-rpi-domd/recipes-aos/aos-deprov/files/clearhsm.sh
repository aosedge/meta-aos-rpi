#!/bin/sh

# Clear OP-TEE storage
rm /var/lib/tee/* -rf

# Reboot unit
xenstore-write data/user-reboot 2
