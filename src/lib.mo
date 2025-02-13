import Debug "mo:base/Debug";
import {expect = _expect; fail = _fail} "./expect";
import {formatTestName} "./utils";

module {
	public func test(name : Text, fn : () -> ()) {
		Debug.print("mops:1:start " # formatTestName(name));
		fn();
		Debug.print("mops:1:end " # formatTestName(name));
	};

	public func testsys<system>(name : Text, fn : <system>() -> ()) {
		Debug.print("mops:1:start " # formatTestName(name));
		fn<system>();
		Debug.print("mops:1:end " # formatTestName(name));
	};

	public func suite(name : Text, fn : () -> ()) {
		test(name, fn);
	};

	public func skip(name : Text, _fn : () -> ()) {
		Debug.print("mops:1:skip " # formatTestName(name));
	};

	public let expect = _expect;
	public let fail = _fail;
};
