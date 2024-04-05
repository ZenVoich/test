import Debug "mo:base/Debug";
import {test; testsys} "../src";

func sys<system>() {};

test("test", func() {
	assert true;
});

testsys<system>("test 1", func<system>() {
	testsys<system>("test 1.1", func<system>() {
		sys<system>();
	});

	testsys<system>("test 1.2", func<system>() {
		sys<system>();
	});
});