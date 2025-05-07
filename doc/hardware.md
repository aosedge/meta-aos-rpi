# Hardware assignment

## Potential assignment

The following line shows the devices which potentially can be added to the
corresponding domains:

| Xen        | Dom0 - Zephyr | DomD - Linux  |
|------------|---------------|---------------|
|            | SPI10, I2C10, | I2S/PCM(RP1)  |
|            | HDMI0, HDMI1  | CSI/DSI,      |
|            |               | UART4, I2S0,  |
|            |               | I2S1, UART4,  |
|            |               | UART3, SPI3,  |
|            |               | I2C2, I2C1,   |
|            |               | I2C3, UART2,  |
|            |               | SDIO2, SPI2,  |
|            |               | UART1, SPI4,  |
|            |               | SPI0          |

### Hardware assignment on GPIO pins

The following list shows RaspberryPI 5 pinout diagram:

| Pin (L)        | Pin (R)          |
| -------------- | ---------------- |
| 3v3 power      | 5V               |
| gpio2(SDA)     | 5v               |
| gpio3(SCL)     | GND              |
| gpio4(GPCLK0)  | gpio14(TXD)      |
| GND            | gpio15(RXD)      |
| gpio17         | gpio18(pcm_clk)  |
| gpio27         | GND              |
| gpio22         | gpio23           |
| 3V3            | gpio24           |
| gpio10(MOSI)   | GND              |
| gpio9(MISO)    | gpio25           |
| gpio11(SCLK)   | gpio8(CE0)       |
| GND            | gpio7(CE1)       |
| gpio0(IO_SD)   | gpio1(IO_SC)     |
| gpio5          | GND              |
| gpio6          | gpio12(PWM0)     |
| gpio13(PWM1)   | GND              |
| gpio19(PCM_FS) | gpio16           |
| gpio25         | gpio20(PCM_DIN)  |
| GND            | gpio21(PCM_DOUT) |

The following HW can be assigned to the gpio pins:

| GPIO | Function |
| ---- | -------- |
| gpio0 and gpio1 | i2c3(RP1), dpi16bit, uart1(RP1), i2c0(RP1), spi2(RP1) |
| gpio2  | spi10, dpi16bit, uart1(RP1), sdio0(RP1), i2c1(RP1) |
| gpio3  | spi2(RP1), sdio2(RP1), spi10 |
| gpio4  | uart2(RP1), i2c2(RP1) |
| gpio5  | uart2(RP1), i2c2(RP1), spi3(RP1) |
| gpio6  | spi3(RP1), uart2(RP1) |
| gpio9  | uart3(RP1), spi4(RP1), spi0(RP1) |
| gpio10 | uart3(RP1), i2c1(RP1), spi4(RP1), spi0(RP1) |
| gpio11 | uart3(RP1), i2c1(RP1), spi4(RP1), spi0(RP1) |
| gpio12 | i2c2(RP1), uart4(RP1) |
| gpio13 | uart4(RP1), i2c2(RP1) |
| gpio14 | uart4(RP1), i2c3(RP1) |
| gpio15 | uart4(RP1), i2c3(RP1) |
| gpio16 | uart0(RP1) |
| gpio17 | uart0(RP1) |
| gpio18 | i2s0(RP1), i2s1(RP1) |
| gpio19 | i2s0(RP1), i2s1(RP1) |
| gpio20 | i2s0(RP1), i2s1(RP1) |
| gpio21 | i2s0(RP1), i2s1(RP1) |
