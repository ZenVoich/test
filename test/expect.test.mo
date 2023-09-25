import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import {test; suite; expect; fail} "../src";

test("bool", func() {
	expect.bool(true).isTrue();
	expect.bool(false).isFalse();
	expect.bool(true).equal(true);
	expect.bool(false).equal(false);
	expect.bool(true).notEqual(false);
});

test("option", func() {
	expect.option<Nat>(null, Nat.toText, Nat.equal).isNull();
	expect.option<Nat>(?1, Nat.toText, Nat.equal).isSome();
	expect.option<Nat>(?2, Nat.toText, Nat.equal).equal(?2);
	expect.option<Nat>(?3, Nat.toText, Nat.equal).notEqual(?44);
	expect.option<Nat>(?3, Nat.toText, Nat.equal).notEqual(null);
	expect.option<Nat>(null, Nat.toText, Nat.equal).equal(null);
});

test("char", func() {
	expect.char('a').equal('a');
	expect.char('a').notEqual('A');
});

test("text", func() {
	expect.text("hello motoko").endsWith("motoko");
	expect.text("hello motoko").contains("mot");
});

test("nat", func() {
	let myNat = 33;
	expect.nat(myNat).notEqual(22);
	expect.nat(myNat).equal(33);
	expect.nat(myNat).less(66);
});

test("intX, natX", func() {
	let myNat : Nat = 22;
	let myNat8 : Nat8 = 33;
	let myInt : Int = -44;
	let myFloat : Float = 1.313;
	expect.int(myNat).equal(22);
	expect.nat8(myNat8).equal(33);
	expect.nat(myNat).equal(22);
	expect.nat(myNat).less(66);

	expect.int(myNat).notEqual(221);
	expect.int64(123123123123).notEqual(1231231231232);
	expect.nat8(myNat8).notEqual(331);
	expect.nat(myNat).notEqual(221);
	expect.nat8(myNat8).lessOrEqual(33);
});

test("array has", func() {
	expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText, Nat.equal).has(6);
	let exAr = expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText, Nat.equal);
	exAr.has(6);
	exAr.has(1);
	exAr.has(0);
	exAr.notHas(21);
});

test("array size", func() {
	expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText, Nat.equal).size(10);
});

test("array equal", func() {
	expect.array([1,2,3,4], Nat.toText, Nat.equal).equal([1,2,3,4]);
	expect.array([1,2,3,4], Nat.toText, Nat.equal).notEqual([1,2,2,4]);
	expect.array([1,2,3,4], Nat.toText, Nat.equal).notEqual([1,2,3,4,5]);
	expect.array([1,2,3,4], Nat.toText, Nat.equal).notEqual([1,2,3]);
});

test("blob", func() {
	expect.blob(Blob.fromArray([1,2,3,4])).equal(Blob.fromArray([1,2,3,4]));
	// expect.blob(Blob.fromArray([1,2,3,4])).notEqual(Blob.fromArray([1,2,3,4]));
});

test("principal", func() {
	expect.principal(Principal.fromBlob(Blob.fromArray([1,2,3,4]))).equal(Principal.fromBlob(Blob.fromArray([1,2,3,4])));
	expect.principal(Principal.fromBlob("\04")).isAnonymous();
	expect.principal(Principal.fromBlob(Blob.fromArray([4]))).isAnonymous();
});

test("result", func() {
	type MyRes = Result.Result<Nat, Text>;
	let ok : MyRes = #ok(22);
	let err : MyRes = #err("error");

	let expectOk = expect.res<Nat, Text>(ok, func(a) = debug_show(a), func(a, b) = a == b);
	let expectErr = expect.res<Nat, Text>(err, func(a) = debug_show(a), func(a, b) = a == b);

	expectOk.isOk();
	expectOk.equal(#ok(22));

	expectErr.isErr();
	expectErr.equal(#err("error"));
});

test("result opt ok", func() {
	type MyRes = Result.Result<?Nat, Text>;
	let ok : MyRes = #ok(?22);
	let err : MyRes = #err("error");

	let expectOk = expect.res<?Nat, Text>(ok, func(a) = debug_show(a), func(a, b) = a == b);
	let expectErr = expect.res<?Nat, Text>(err, func(a) = debug_show(a), func(a, b) = a == b);

	expectOk.isOk();
	expectOk.equal(#ok(?22));

	expectErr.isErr();
	expectErr.equal(#err("error"));
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
			let ok = a.x > b.x and a.y > b.y;
			if (not ok) {
				fail(show(a), ">=", show(b));
			};
		};
	};

	expectCustom({x = 1; y = 3}).equal({x = 1; y = 3});
	expectCustom({x = 2; y = 4}).greater({x = 1; y = 3});
});