// EFM32TG210F16 Register Definitions
// Based on datasheet for UART/USART configuration

pub const CMU_BASE = 0x400C8000;
pub const USART0_BASE = 0x4000C000;
pub const GPIO_BASE = 0x40006000;

// Clock Management Unit (CMU) registers
pub const CMU = struct {
    pub const HFPERCLKEN0 = @as(*volatile u32, @ptrFromInt(CMU_BASE + 0x044));
    pub const HFPERCLKEN0_USART0 = 1 << 3;
};

// USART registers
pub const USART0 = struct {
    pub const CTRL = @as(*volatile u32, @ptrFromInt(USART0_BASE + 0x000));
    pub const FRAME = @as(*volatile u32, @ptrFromInt(USART0_BASE + 0x004));
    pub const CMD = @as(*volatile u32, @ptrFromInt(USART0_BASE + 0x00C));
    pub const STATUS = @as(*volatile u32, @ptrFromInt(USART0_BASE + 0x010));
    pub const CLKDIV = @as(*volatile u32, @ptrFromInt(USART0_BASE + 0x014));
    pub const TXDATA = @as(*volatile u32, @ptrFromInt(USART0_BASE + 0x034));
    pub const ROUTE = @as(*volatile u32, @ptrFromInt(USART0_BASE + 0x054));

    // Control register bits
    pub const CTRL_SYNC = 1 << 0;    // 0 = Async, 1 = Sync
    pub const CTRL_TXEN = 1 << 2;    // TX Enable
    pub const CTRL_RXEN = 1 << 3;    // RX Enable
    
    // Command register bits
    pub const CMD_TXEN = 1 << 2;
    pub const CMD_RXEN = 1 << 3;
    pub const CMD_CLEARTX = 1 << 6;
    pub const CMD_CLEARRX = 1 << 7;
    
    // Status register bits
    pub const STATUS_TXBL = 1 << 6;  // TX Buffer Level
    pub const STATUS_TXC = 1 << 5;   // TX Complete

    // Route register bits
    pub const ROUTE_TXPEN = 1 << 0;  // TX Pin Enable
    pub const ROUTE_RXPEN = 1 << 1;  // RX Pin Enable
    pub const ROUTE_LOCATION_LOC0 = 0 << 8;
};

// GPIO registers
pub const GPIO = struct {
    pub const PA_MODEL = @as(*volatile u32, @ptrFromInt(GPIO_BASE + 0x004));
    pub const PA_MODEH = @as(*volatile u32, @ptrFromInt(GPIO_BASE + 0x008));
    
    // Mode settings
    pub const MODE_PUSHPULL = 0x4;
    pub const MODE_INPUT = 0x1;
};