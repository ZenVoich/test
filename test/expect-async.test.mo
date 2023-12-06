import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Error "mo:base/Error";
import {test; suite; expect; fail} "../src/async";

await test("bool", func() : async () {
	expect.bool(true).isTrue();
	expect.bool(false).isFalse();
	expect.bool(true).equal(true);
	expect.bool(false).equal(false);
	expect.bool(true).notEqual(false);
});

await test("option", func() : async () {
	expect.option(null, Nat.toText, Nat.equal).isNull();
	expect.option(?1, Nat.toText, Nat.equal).isSome();
	expect.option(?2, Nat.toText, Nat.equal).equal(?2);
	expect.option(?3, Nat.toText, Nat.equal).notEqual(?44);
	expect.option(?3, Nat.toText, Nat.equal).notEqual(null);
	expect.option(null, Nat.toText, Nat.equal).equal(null);
});

await test("option custom type", func() : async () {
	type MyType = {
		x : Nat;
		y : Nat;
	};
	let v = ?{x = 1; y = 2};

	func showMyType(a : MyType) : Text {
		debug_show(a);
	};

	func equalMyType(a : MyType, b : MyType) : Bool {
		a.x == b.x and a.y == b.y
	};

	expect.option(v, showMyType, equalMyType).notEqual(null);
	expect.option(v, showMyType, equalMyType).equal(?{x = 1; y = 2});
});

await test("char", func() : async () {
	expect.char('a').equal('a');
	expect.char('a').notEqual('A');
});

await test("text", func() : async () {
	expect.text("hello motoko").endsWith("motoko");
	expect.text("hello motoko").contains("mot");
});

await test("nat", func() : async () {
	let myNat = 33;
	expect.nat(myNat).notEqual(22);
	expect.nat(myNat).equal(33);
	expect.nat(myNat).less(66);
});

await test("intX, natX", func() : async () {
	let myNat : Nat = 22;
	let myNat8 : Nat8 = 33;
	let myInt : Int = -44;
	let myInt8 : Int8 = -44;
	let myFloat : Float = 1.313;
	expect.int(myNat).equal(22);
	expect.nat8(myNat8).equal(33);
	expect.nat(myNat).equal(22);
	expect.nat(myNat).less(66);

	expect.int(myNat).notEqual(221);
	expect.int8(myInt8).equal(myInt8);
	expect.int64(123123123123).notEqual(1231231231232);
	expect.nat8(myNat8).notEqual(32);
	expect.nat(myNat).notEqual(221);
	expect.nat8(myNat8).lessOrEqual(33);
});

await test("array contains", func() : async () {
	expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText, Nat.equal).contains(6);
	let exAr = expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText, Nat.equal);
	exAr.contains(6);
	exAr.contains(1);
	exAr.contains(0);
	exAr.notContains(88);
	exAr.notContains(21);
	exAr.size(10);
});

await test("array size", func() : async () {
	expect.array([1,2,3,4,5,6,7,8,9,0], Nat.toText, Nat.equal).size(10);
});

await test("array equal", func() : async () {
	expect.array([1,2,3,4], Nat.toText, Nat.equal).equal([1,2,3,4]);
	expect.array([1,2,3,4], Nat.toText, Nat.equal).notEqual([1,2,2,4]);
	expect.array([1,2,3,4], Nat.toText, Nat.equal).notEqual([1,2,3,4,5]);
	expect.array([1,2,3,4], Nat.toText, Nat.equal).notEqual([1,2,3]);
});

await test("blob", func() : async () {
	expect.blob(Blob.fromArray([1,2,3,4])).equal(Blob.fromArray([1,2,3,4]));
	expect.blob(Blob.fromArray([1,2,3,4])).notEqual(Blob.fromArray([2,2,3,4]));
	expect.blob(Blob.fromArray([1,2,3,4])).size(4);
});

await test("principal", func() : async () {
	expect.principal(Principal.fromBlob(Blob.fromArray([1,2,3,4]))).equal(Principal.fromBlob(Blob.fromArray([1,2,3,4])));
	expect.principal(Principal.fromBlob(Blob.fromArray([1,2,3,4]))).notEqual(Principal.fromBlob(Blob.fromArray([1,2,3,5])));
	expect.principal(Principal.fromBlob("\04")).isAnonymous();
	expect.principal(Principal.fromBlob(Blob.fromArray([4]))).isAnonymous();
});

await test("result", func() : async () {
	type MyRes = Result.Result<Nat, Text>;
	let ok : MyRes = #ok(22);
	let err : MyRes = #err("error");

	let expectOk = expect.result<Nat, Text>(ok, func(a) = debug_show(a), func(a, b) = a == b);
	let expectErr = expect.result<Nat, Text>(err, func(a) = debug_show(a), func(a, b) = a == b);

	expectOk.isOk();
	expectOk.equal(#ok(22));

	expectErr.isErr();
	expectErr.equal(#err("error"));
	expectErr.notEqual(#err("other error"));
});

await test("result opt ok", func() : async () {
	type MyRes = Result.Result<?Nat, Text>;
	let ok : MyRes = #ok(?22);
	let err : MyRes = #err("error");

	let expectOk = expect.result<?Nat, Text>(ok, func(a) = debug_show(a), func(a, b) = a == b);
	let expectErr = expect.result<?Nat, Text>(err, func(a) = debug_show(a), func(a, b) = a == b);

	expectOk.isOk();
	expectOk.equal(#ok(?22));

	expectErr.isErr();
	expectErr.equal(#err("error"));
});

await test("expect custom", func() : async () {
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

await test("expectAsync.call", func() : async () {
	// test throw error
	func myFunc() : async () {
		throw Error.reject("error");
	};

	await expect.call(myFunc).reject();
});