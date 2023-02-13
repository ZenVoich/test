import Debug "mo:base/Debug";

module {
	public func test(name: Text, fn: () -> ()) {
		Debug.print("mops:1:start " # name);
		fn();
		Debug.print("mops:1:end " # name);
	};

	public func suite(name: Text, fn: () -> ()) {
		test(name, fn);
	};

	public func skip(name: Text, fn: () -> ()) {
		Debug.print("mops:1:skip " # name);
	};
};