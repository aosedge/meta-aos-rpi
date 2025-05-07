# Troubleshooting

## Remote access

AosEdge `DomD` has SSH server enabled. Once, `DomD` IP is determined, it can be accessible using SSH client. See
[Connect to an SSH server](https://www.raspberrypi.com/documentation/computers/remote-access.html#connect-to-an-ssh-server)
document for details.

## Retrieving system logs

You can review AosEdge and system logs using the systemd journal. Run the following command to investigate potential
issues:

```console
journalctl
```
