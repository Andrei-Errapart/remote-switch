const std = @import("std");
const efm32 = @import("efm32tg.zig");

// System clock frequency (14MHz default for EFM32TG)
const SYSTEM_CLOCK = 14_000_000;
const BAUDRATE = 115200;

// Custom panic handler for embedded systems
pub fn panic(message: []const u8, error_return_trace: ?*std.builtin.StackTrace, ret_addr: ?usize) noreturn {
    _ = message;
    _ = error_return_trace;
    _ = ret_addr;
    while (true) {}
}

export fn main() void {
    // Initialize UART
    uart_init();
    
    // Main loop - print message every 10 seconds
    while (true) {
        // Send "Hello, World!" message
        const message = "Hello, World!\r\n";
        for (message) |c| {
            uart_putc(c);
        }
        
        // Delay for 10 seconds
        delay_ms(10000);
    }
}

fn uart_init() void {
    // Enable clock for USART0
    efm32.CMU.HFPERCLKEN0.* |= efm32.CMU.HFPERCLKEN0_USART0;
    
    // Configure GPIO pins for UART (PA0 = TX, PA1 = RX)
    // Set PA0 as push-pull output for TX
    const pa_model = efm32.GPIO.PA_MODEL.*;
    efm32.GPIO.PA_MODEL.* = (pa_model & ~@as(u32, 0xF)) | (efm32.GPIO.MODE_PUSHPULL << 0);
    
    // Reset USART0
    efm32.USART0.CMD.* = efm32.USART0.CMD_CLEARTX | efm32.USART0.CMD_CLEARRX;
    
    // Configure USART for async mode
    efm32.USART0.CTRL.* = 0; // Clear all bits, async mode
    
    // Set frame format: 8 data bits, no parity, 1 stop bit (default)
    efm32.USART0.FRAME.* = 0x0005; // 8-N-1
    
    // Calculate and set baud rate
    // CLKDIV = 256 * ((fsystem / (baudrate * oversample)) - 1)
    // For async mode, oversample = 16
    const clkdiv = @as(u32, 256 * ((SYSTEM_CLOCK / (BAUDRATE * 16)) - 1));
    efm32.USART0.CLKDIV.* = clkdiv;
    
    // Enable TX pin and set location to LOC0 (PA0/PA1)
    efm32.USART0.ROUTE.* = efm32.USART0.ROUTE_TXPEN | efm32.USART0.ROUTE_LOCATION_LOC0;
    
    // Enable transmitter
    efm32.USART0.CMD.* = efm32.USART0.CMD_TXEN;
}

fn uart_putc(c: u8) void {
    // Wait until TX buffer is empty
    while ((efm32.USART0.STATUS.* & efm32.USART0.STATUS_TXBL) == 0) {}
    
    // Send character
    efm32.USART0.TXDATA.* = c;
}

// Simple delay function using busy-wait loop
// Calibrated for 14MHz system clock
fn delay_ms(ms: u32) void {
    // At 14MHz, we need approximately 14000 cycles per millisecond
    // This is a rough approximation - adjust the constant if needed
    const cycles_per_ms = 14000 / 4; // Divide by 4 for loop overhead
    
    var i: u32 = 0;
    while (i < ms) : (i += 1) {
        var j: u32 = 0;
        while (j < cycles_per_ms) : (j += 1) {
            // Force the compiler to keep this loop
            asm volatile ("nop");
        }
    }
}