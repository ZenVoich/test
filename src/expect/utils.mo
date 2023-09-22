import Debug "mo:base/Debug";

module {
	public func fail1(actual : Text, condition : Text, reference : Text) {
		// let prefix = "\1b[31m·\1b[0m";
		// let prefix = "\1b[31m⚠\1b[0m";
		// let prefix = "\1b[31m⌇\1b[0m";
		// let prefix = "\1b[31m!\1b[0m";
		let prefix = "\1b[31m•\1b[0m";
		var msg = "\n" # prefix # " expected \1b[31m" # actual # "\1b[0m ";
		if (condition != "") {
			msg #= "\n" # prefix # " \1b[30m" # condition # "\1b[0m";
		}
		else {
			msg #= prefix # "";
		};
		msg #= " " # reference # "";

		Debug.trap(msg);
	};

	public func fail2(actual : Text, condition : Text, reference : Text) {
		let prefix = "\1b[31m•\1b[0m";
		var msg = "\n" # prefix # " received          \1b[31m" # actual # "\1b[0m ";
		if (condition != "") {
			msg #= "\n" # prefix # " expected" # " \1b[30m" # condition # "\1b[0m";
		}
		else {
			msg #= prefix # "";
		};
		msg #= " " # reference # "";

		Debug.trap(msg);
	};

	public func fail3(actual : Text, condition : Text, reference : Text) {
		let prefix = "\1b[31m!\1b[0m";
		var msg = "\n" # prefix # " \1b[30mreceived\1b[0m \1b[31m" # actual # "\1b[0m ";
		if (condition != "") {
			msg #= "\n" # prefix # " \1b[30mexpected\1b[0m" # " \1b[30m" # condition # "\1b[0m";
		}
		else {
			msg #= "\n" # prefix # " \1b[30mexpected\1b[0m";
		};
		msg #= " \1b[32m" # reference # "\1b[0m";

		Debug.trap(msg);
	};

	public let fail = fail3;

	public func compare<T>(a : T, b : T, comp : (T, T) -> Bool, toText : (T) -> Text, condition : Text) {
		let res = comp(a, b);
		if (not res) {
			fail(toText(b), condition, toText(a));
		};
	};

	public func bindCompare<T>(a : T, comp : (T, T) -> Bool, toText : (T) -> Text, condition : Text) : (T) -> () {
		return func(b : T) = compare<T>(a, b, comp, toText, condition);
	};
};