# Firmware

Firmware is created with [ESPHome](https://esphome.io/index.html) -  it is a system to control your ESP8266/ESP32 by simple yet powerful configuration files and control them remotely through Home Automation systems.

The files below are those needed to be loaded into ESPHome

- [`iaq_board.yaml`](iaq_board.yaml) - this is the configuration for esphome
- [`iaq_board.bin`](iaq_board.bin) - this is the binary file of the compiled firmware and can be directly uploaded in the MCU

## How to flash (or program) the controller?
1. Download [the bin file](iaq_board.bin) on your PC.
2. Install [esphome-flasher](https://github.com/esphome/esphome-flasher).
3. Connect the MCU board with mini USB cable not yet connecting it on PCB.
4. Start esphome-flasher, select the correct COM port which is the MCU as [explained here](https://esphome.io/guides/faq.html#i-can-t-get-flashing-over-usb-to-work) and flash it.

***That's it! Connect the MCU on the board, then power it on and it should work.***

If you want to go deeper, [follow the instructions](https://esphome.io/guides/getting_started_command_line.html) how to build the binary file from the yaml and upload it to the MCU from command line.
