// @testmode wasi
import {suite; test; expect} "../src";

suite("simple suite", func() {
	test("simple test", func() {
		assert true;
	});
	test("expect.bool", func() {
		expect.bool(true).isTrue();
		expect.bool(false).isFalse();
	});
});