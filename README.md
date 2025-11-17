# Introduction

This is the firmware for the remote controlled switch based on an EFM32TG210F16 paired to a SX1211.

# Versions

## Hello, world

Outputs "Hello, World" on the USART at 115200 baud once every 10 seconds.

## Test transmitter

Outputs some 8 bytes of random data + checksum (for a total of 9 bytes) to the SX1211 to be sent at least 10 times per second.

## Test receiver

Outputs received signal level on UART once every 5 seconds.

Turns LED on and off as instructed


# Hardware

The main components are the following:
1) Microcontroller - EFM32TG210F16
2) Radio - SX1211

The EFM32TG210F16 is a Cortex-M3 microcontroller, with the following features:
* Flash: 16kB
* RAM: 4kB
* USART
* Low-Energy UART
* I2C
* GPIO
* Timer/Counter
* LESENSE
* Low-Energy Timer
* Real-time Counter
* Pulse Counter
* Watchdog Timer
* ADC
* Operational amplifier
* LCD Controller
* DAC
* Analog Comparator

