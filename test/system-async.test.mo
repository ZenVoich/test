import Debug "mo:base/Debug";
import {test; testsys} "../src/async";

func sys<system>() {};

await test("test", func() : async () {
	assert true;
});

testsys<system>("test 1", func<system>() : async() {
	await testsys<system>("test 1.1", func<system>() : async() {
		sys<system>();
	});

	await testsys<system>("test 1.2", func<system>() : async() {
		sys<system>();
	});
});