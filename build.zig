const std = @import("std");

pub fn build(b: *std.Build) void {
    // For embedded systems with limited flash, prefer ReleaseSmall
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSmall,
    });

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .os_tag = .freestanding,
        .abi = .eabi,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m3 },
    });

    const exe = b.addExecutable(.{
        .name = "hello",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // Link script for memory layout
    exe.setLinkerScript(b.path("src/linker.ld"));

    // Add startup code
    exe.addAssemblyFile(b.path("src/startup.s"));

    // Disable stack protector for embedded
    exe.root_module.stack_protector = false;
    
    // Strip symbols for smaller binary
    exe.root_module.strip = true;

    // Build options for memory constraints
    const options = b.addOptions();
    options.addOption(u32, "flash_size", 16 * 1024);
    options.addOption(u32, "ram_size", 4 * 1024);
    exe.root_module.addOptions("build_options", options);

    b.installArtifact(exe);

    // Create a raw binary for flashing
    const bin = b.addObjCopy(exe.getEmittedBin(), .{
        .format = .bin,
    });
    const install_bin = b.addInstallBinFile(bin.getOutput(), "hello.bin");
    b.getInstallStep().dependOn(&install_bin.step);

    // Size analysis step
    const size_cmd = b.addSystemCommand(&.{ "arm-none-eabi-size", "-A", "-x" });
    size_cmd.addArtifactArg(exe);
    const size_step = b.step("size", "Display the size of each section");
    size_step.dependOn(&size_cmd.step);
}