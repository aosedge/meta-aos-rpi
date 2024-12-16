# HOWTO

## How to switch between consoles

After successful boot, the active console is Dom0 Zephyr console.
To switch between Dom0, DomD and Xen consoles press the `Ctrl+a` combination five times.

Dom0 console displays AosEdge zephyr application logs. Bunch of useful commands are available there.
Try command `help` to see all the supported by zephyr application commands.

DomD console is general Linux console with all Linux commands provided by DomD.

## How to access user domain console

`xu` command in Dom0 allows to see launched user domains, their statuses and allows to attach to their consoles.
Use `xu list` to see list of running domains. Then input `xu console <domid>` to attach to the desired domain console.
`<domid>` is ID of desired domain.
