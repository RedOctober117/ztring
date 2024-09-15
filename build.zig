const std = @import("std");

const test_targets = [_]std.Target.Query{
    .{},
    // .{
    //     .cpu_arch = .x86_64,
    //     .os_tag = .linux,
    // },
    // .{
    //     .cpu_arch = .aarch64,
    //     .os_tag = .macos,
    // },
};

pub fn build(b: *std.Build) void {
    const target_op = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run unit tests");
    for (test_targets) |target| {
        const unit_tests = b.addTest(.{
            .root_source_file = b.path("src/test.zig"),
            .target = b.resolveTargetQuery(target),
        });
        const run_unit_tests = b.addRunArtifact(unit_tests);
        test_step.dependOn(&run_unit_tests.step);
    }

    const ztring_lib = b.addStaticLibrary(.{
        .name = "ztring",
        .root_source_file = b.path("src/root.zig"),
        .target = target_op,
        .optimize = optimize,
    });

    b.installArtifact(ztring_lib);
}
