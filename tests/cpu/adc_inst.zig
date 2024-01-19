const std = @import("std");
const Cpu = @import("pixeka").Cpu;
const parseHexDump = @import("../test_cpu.zig").parseHexDump;

const testing_allocator = std.testing.allocator;
const expect = std.testing.expect;

// Program Assembly
//
// lda #$81
// sta $0200
// adc $0200
//
// brk
test "ADC instruction (basic)" {
    const program_str =
        \\0600: a9 81 8d 00 02 6d 00 02 00
    ;
    const program = parseHexDump(program_str);

    var cpu = try Cpu.init(testing_allocator);
    defer cpu.deinit();

    try cpu.loadAndRun(false, program);

    // expected registers
    try expect(cpu.reg_a == 0x02);

    // expected flags
    try expect(!cpu.flags.N);
    try expect(cpu.flags.V);
    try expect(cpu.flags.B);
    try expect(!cpu.flags.D);
    try expect(cpu.flags.I);
    try expect(!cpu.flags.Z);
    try expect(cpu.flags.C);
}
