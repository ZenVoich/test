import Debug "mo:base/Debug";
import {suite; test} "../src/async";

await suite("async suite", func(): async () {
	await test("async test", func(): async () {
		assert true;
	});

	await test("async test", func(): async () {
		assert true;
	});
});

await test("sole async test", func(): async () {
	assert true;
});