import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import {expect; compare; makeCompare; fail} "../src/expect";
import {test; suite} "../src";

type Custom = {
	x : Nat;
	y : Nat;
};

class expectCustom(a : Custom) {
	func show(x : Custom) : Text = debug_show(x);

	public func equal(b : Custom) {
		if (a != b) {
			fail(show(a), "to be ==", show(b));
		};
		// compare<Custom>(a, b, func(a, b) = a == b, show, "to be ==");
		// makeCompare<Custom>(func(a, b) = a == b, show)(a, b);
	};

	public func greater(b : Custom) {
		makeCompare<Custom>(func(a, b) = a.x > b.x and a.y > b.y, show)(a, b);
	};
};

test("nat", func() {
	let myNat = 33;
	expect.nat(myNat).notEqual(22);
	expect.nat(myNat).equal(33);
	expect.bool(true).isTrue();
	expect.bool(false).isFalse();
	expect.bool(true).equal(true);
	expect.bool(false).equal(false);
	expect.bool(true).notEqual(false);
	expect.nat(myNat).less(66);
});

// test("array", func() {
// 	expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText).has(1, Nat.equal);
// });

test("array", func() {
	expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText).has(6, Nat.equal);
	// expect.iter([1,2,3,4,5,6,7,8,9,0].vals(), Nat.toText).has(21, Nat.equal);
});

test("custom", func() {
	expectCustom({x = 1; y = 3}).equal({x = 1; y = 3});
	expectCustom({x = 2; y = 4}).greater({x = 1; y = 3});
});