# Simple Sensing

Dual-channel NAMUR sensor firmware for the Nuvoton MS51FB9AE.

## Visualizer

The project includes a standalone browser visualizer:

- `visualizer.html`

To view it locally, open `visualizer.html` in a web browser.

To view it from GitHub, use GitHub Pages. After Pages is enabled for this
repository, the visualizer URL will be:

```text
https://vijja4git.github.io/simple-sensing/visualizer.html
```

If the visualizer is only on the `implementing-2-channels` branch, configure
GitHub Pages to publish from that branch and the repository root. If the branch
is later merged into `main`, GitHub Pages can publish from `main` instead.

## Firmware Files

- `main.c` contains the dual-channel firmware logic.
- `MS51_16K.h` contains the MS51 register definitions used by the firmware.
- `docs.txt` contains the hardware and firmware behavior guide.
- `Makefile` builds the firmware with SDCC.

## Build

```sh
make clean
make
```

The generated HEX file is written to:

```text
build/main.hex
```
