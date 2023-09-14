import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import {expect; compare; makeCompare; fail} "../src/expect";
import {test; suite} "../src";

test("bool", func() {
	expect.bool(true).isTrue();
	expect.bool(false).isFalse();
	expect.bool(true).equal(true);
	expect.bool(false).equal(false);
	expect.bool(true).notEqual(false);
});

test("option", func() {
	expect.option<Nat>(null, Nat.toText).isNull();
	expect.option<Nat>(?1, Nat.toText).isSome();
});

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

test("array has", func() {
	expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText, Nat.equal).has(6);
	let exAr = expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText, Nat.equal);
	exAr.has(6);
	exAr.has(1);
	exAr.has(0);
});

test("array equal", func() {
	expect.array([1,2,3,4], Nat.toText, Nat.equal).equal([1,2,3,4]);
	expect.array([1,2,3,4], Nat.toText, Nat.equal).notEqual([1,2,2,4]);
	expect.array([1,2,3,4], Nat.toText, Nat.equal).notEqual([1,2,3,4,5]);
	expect.array([1,2,3,4], Nat.toText, Nat.equal).notEqual([1,2,3]);
});

test("expect custom", func() {
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
		};

		public func greater(b : Custom) {
			makeCompare<Custom>(func(a, b) = a.x > b.x and a.y > b.y, show)(a, b);
		};
	};

	expectCustom({x = 1; y = 3}).equal({x = 1; y = 3});
	expectCustom({x = 2; y = 4}).greater({x = 1; y = 3});
});