# Motoko Testing
Easy way to write tests in Motoko and run them with `mops test`.

The library supports [Mops Message Format v1.0](https://github.com/ZenVoich/mops-message-format#v10).

## Install
```
mops add test --dev
```

## Usage
Put your tests in `test` directory in `*.test.mo` files.

Use `test` and `suite` functions in conjunction with `assert` expression.

Run `mops test` to run tests.

## Simple test

```motoko
import {test} "mo:test";

test("simple test", func() {
	assert true;
});

test("test my number", func() {
	assert 1 > 0;
});
```

## Test suites
Use `suite` to group your tests.

```motoko
import {test; suite} "mo:test";

suite("my test suite", func() {
	test("simple test", func() {
		assert true;
	});

	test("test my number", func() {
		assert 1 > 0;
	});
});
```

## Skip test
Use `skip` to skip tests.

```motoko
import {test; skip} "mo:test";

skip("this test will never run", func() {
	assert false;
});

test("this test will run", func() {
	assert true;
});
```

## Async tests
If there are `await`s in your tests, use functions from `mo:test/async`.

```motoko
import {test; suite} "mo:test/async";

await suite("my async test suite", func(): async () {
	await test("async test", func(): async () {
		let res = await myAsyncFn();
		assert Result.isOk(res);
	});

	test("should generate unique values", func(): async () {
		let a = await generate();
		let b = await generate();
		assert a != b;
	});
});
```
