# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an embedded systems project targeting the EFM32TG210F16 microcontroller (ARM Cortex-M3) with the following constraints:
- 16kB flash memory
- 4kB RAM
- Programming language: Zig

## Development Commands

Since this is a new project without existing build infrastructure, you'll need to set up:

1. **Build System**: Create a `build.zig` file for the Zig build system
2. **Memory Layout**: Configure linker script for 16kB flash / 4kB RAM constraints
3. **Target Configuration**: Set up cross-compilation for `thumb-freestanding-eabi` target

Common commands that will be needed once set up:
- `zig build` - Build the project
- `zig build -Doptimize=ReleaseSmall` - Build optimized for size
- `zig build flash` - Flash to device (requires flash tool configuration)

## Architecture Considerations

### Memory Constraints
- Total flash: 16kB (must include code, constants, and vector table)
- Total RAM: 4kB (must include stack, heap if used, and global variables)
- Optimize for size over speed
- Avoid dynamic memory allocation where possible

### Microcontroller Specifics
- EFM32TG210F16 is based on ARM Cortex-M3
- Requires proper startup code and vector table
- Hardware documentation available in `doc/efm32tg-datasheet.pdf`

### Future Considerations
- SX1211 RF transceiver documentation is present (`doc/SX1211_Rev8.0_STD.pdf`), suggesting potential wireless communication features

## Development Approach

When implementing for this constrained embedded system:
1. Start with minimal startup code and vector table
2. Use static memory allocation
3. Keep dependencies minimal
4. Test size constraints regularly with `zig build -Doptimize=ReleaseSmall`
5. Consider using `@setRuntimeSafety(false)` in release builds to save space