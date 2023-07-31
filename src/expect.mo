import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Int8 "mo:base/Int8";
import Int16 "mo:base/Int16";
import Int32 "mo:base/Int32";
import Int64 "mo:base/Int64";
import Float "mo:base/Float";
import Char "mo:base/Char";
import Text "mo:base/Text";
import TrieMap "mo:base/TrieMap";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Bool "mo:base/Bool";
import Iter "mo:base/Iter";

module {
	public func compare<T>(a : T, b : T, comp : (T, T) -> Bool, toText : (T) -> Text, operator : Text) {
		let res = comp(a, b);
		if (not res) {
			fail(toText(b), operator, toText(a));
		};
	};

	public func fail(actual : Text, condition : Text, reference : Text) {
		// let prefix = "\1b[31m·\1b[0m";
		// let prefix = "\1b[31m•\1b[0m";
		// let prefix = "\1b[31m⚠\1b[0m";
		let prefix = "\1b[31m⌇\1b[0m";
		// let prefix = "\1b[31m!\1b[0m";
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

	public func makeCompare<T>(comp : (T, T) -> Bool, toText : (T) -> Text) : (T, T) -> () {
		return func(a : T, b : T) = compare<T>(a, b, comp, toText, "==");
	};

	public func bindCompare<T>(a : T, comp : (T, T) -> Bool, toText : (T) -> Text) : (T) -> () {
		return func(b : T) = compare<T>(a, b, comp, toText, "to be ==");
	};

	type ExpectBool = {
		isTrue : () -> ();
		isFalse : () -> ();
		equal : Bool -> ();
		notEqual : Bool -> ();
	};

	// type ExpectFloat = {
	// 	equalWithin : (Float, Float) -> Bool;
	// 	notEqualWithin : (Float, Float) -> Bool;
	// 	less : (Float) -> Bool;
	// 	lessOrEqual : (Float) -> Bool;
	// 	greater : (Float) -> Bool;
	// 	greaterOrEqual : (Float) -> Bool;
	// };

	type ExpectNum<T> = {
		equal : (T) -> ();
		notEqual : (T) -> ();
		less : (T) -> ();
		lessOrEqual : (T) -> ();
		greater : (T) -> ();
		greaterOrEqual : (T) -> ();
	};

	type NumModule<T> = {
		equal : (T, T) -> Bool;
		notEqual : (T, T) -> Bool;
		less : (T, T) -> Bool;
		lessOrEqual : (T, T) -> Bool;
		greater : (T, T) -> Bool;
		greaterOrEqual : (T, T) -> Bool;
		toText : (T) -> Text;
	};

	func makeExpectNum<T>(mod : NumModule<T>) : T -> ExpectNum<T> {
		func makeNumCompare(a : T, comp : (T, T) -> Bool, toText : (T) -> Text, condition : Text) : (T) -> () {
			return func(b : T) {
				if (not comp(a, b)) {
					fail(toText(a), condition, toText(b));
				};
			};
		};

		return func(val : T) : ExpectNum<T> {
			return {
				equal = makeNumCompare(val, mod.equal, mod.toText, "to be ==");
				notEqual = makeNumCompare(val, mod.notEqual, mod.toText, "to be !=");
				less = makeNumCompare(val, mod.less, mod.toText, "to be <");
				lessOrEqual = makeNumCompare(val, mod.lessOrEqual, mod.toText, "to be <=");
				greater = makeNumCompare(val, mod.greater, mod.toText, "to be >");
				greaterOrEqual = makeNumCompare(val, mod.greaterOrEqual, mod.toText, "to be >=");
			}
		};
	};

	public let expect = {
		bool = func(a : Bool) : ExpectBool {
			return {
				isTrue = func() {
					if (a != true) {
						fail(Bool.toText(a), "to be ==", Bool.toText(true));
					};
				};
				isFalse = func() {
					if (a != false) {
						fail(Bool.toText(a), "to be ==", Bool.toText(false));
					};
				};
				equal = func(b : Bool) {
					if (a != b) {
						fail(Bool.toText(a), "to be ==", Bool.toText(b));
					};
				};
				notEqual = func(b : Bool) {
					if (a == b) {
						fail(Bool.toText(a), "to be !=", Bool.toText(b));
					};
				};
			};
		};
		nat = func(a : Nat) : ExpectNum<Nat> {
			makeExpectNum<Nat.Nat>({
				equal = Nat.equal;
				notEqual = Nat.notEqual;
				less = Nat.less;
				lessOrEqual = Nat.lessOrEqual;
				greater = Nat.greater;
				greaterOrEqual = Nat.greaterOrEqual;
				toText = Nat.toText;
			})(a);
		};
		nat8 = func(a : Nat8) : ExpectNum<Nat8> {
			makeExpectNum<Nat8.Nat8>({
				equal = Nat8.equal;
				notEqual = Nat8.notEqual;
				less = Nat8.less;
				lessOrEqual = Nat8.lessOrEqual;
				greater = Nat8.greater;
				greaterOrEqual = Nat8.greaterOrEqual;
				toText = Nat8.toText;
			})(a);
		};
		nat16 = func(a : Nat16) : ExpectNum<Nat16> {
			makeExpectNum<Nat16.Nat16>({
				equal = Nat16.equal;
				notEqual = Nat16.notEqual;
				less = Nat16.less;
				lessOrEqual = Nat16.lessOrEqual;
				greater = Nat16.greater;
				greaterOrEqual = Nat16.greaterOrEqual;
				toText = Nat16.toText;
			})(a);
		};
		nat32 = func(a : Nat32) : ExpectNum<Nat32> {
			makeExpectNum<Nat32.Nat32>({
				equal = Nat32.equal;
				notEqual = Nat32.notEqual;
				less = Nat32.less;
				lessOrEqual = Nat32.lessOrEqual;
				greater = Nat32.greater;
				greaterOrEqual = Nat32.greaterOrEqual;
				toText = Nat32.toText;
			})(a);
		};
		nat64 = func(a : Nat64) : ExpectNum<Nat64> {
			makeExpectNum<Nat64.Nat64>({
				equal = Nat64.equal;
				notEqual = Nat64.notEqual;
				less = Nat64.less;
				lessOrEqual = Nat64.lessOrEqual;
				greater = Nat64.greater;
				greaterOrEqual = Nat64.greaterOrEqual;
				toText = Nat64.toText;
			})(a);
		};
		int = func(a : Int) : ExpectNum<Int> {
			makeExpectNum<Int.Int>({
				equal = Int.equal;
				notEqual = Int.notEqual;
				less = Int.less;
				lessOrEqual = Int.lessOrEqual;
				greater = Int.greater;
				greaterOrEqual = Int.greaterOrEqual;
				toText = Int.toText;
			})(a);
		};
		int8 = func(a : Int8) : ExpectNum<Int8> {
			makeExpectNum<Int8.Int8>({
				equal = Int8.equal;
				notEqual = Int8.notEqual;
				less = Int8.less;
				lessOrEqual = Int8.lessOrEqual;
				greater = Int8.greater;
				greaterOrEqual = Int8.greaterOrEqual;
				toText = Int8.toText;
			})(a);
		};
		int16 = func(a : Int16) : ExpectNum<Int16> {
			makeExpectNum<Int16.Int16>({
				equal = Int16.equal;
				notEqual = Int16.notEqual;
				less = Int16.less;
				lessOrEqual = Int16.lessOrEqual;
				greater = Int16.greater;
				greaterOrEqual = Int16.greaterOrEqual;
				toText = Int16.toText;
			})(a);
		};
		int32 = func(a : Int32) : ExpectNum<Int32> {
			makeExpectNum<Int32.Int32>({
				equal = Int32.equal;
				notEqual = Int32.notEqual;
				less = Int32.less;
				lessOrEqual = Int32.lessOrEqual;
				greater = Int32.greater;
				greaterOrEqual = Int32.greaterOrEqual;
				toText = Int32.toText;
			})(a);
		};
		int64 = func(a : Int64) : ExpectNum<Int64> {
			makeExpectNum<Int64.Int64>({
				equal = Int64.equal;
				notEqual = Int64.notEqual;
				less = Int64.less;
				lessOrEqual = Int64.lessOrEqual;
				greater = Int64.greater;
				greaterOrEqual = Int64.greaterOrEqual;
				toText = Int64.toText;
			})(a);
		};
		// float = func(val : Float) : ExpectFloat {
		// 	func equalWithin(b : Float, epsilon : Float) : Bool {
		// 		Float.equalWithin(val, b, epsilon);
		// 	};
		// 	{
		// 		equalWithin = func(b : Float, epsilon : Float) : Bool {
		// 			compare<Float>(val, b, equalWithin, Float.toText);
		// 		};
		// 		notEqualWithin = bindCompare<Float>(val, Float.notEqualWithin, Float.toText);
		// 		less = bindCompare<Float>(val, Float.less, Float.toText);
		// 		lessOrEqual = bindCompare<Float>(val, Float.lessOrEqual, Float.toText);
		// 		greater = bindCompare<Float>(val, Float.greater, Float.toText);
		// 		greaterOrEqual = bindCompare<Float>(val, Float.greaterOrEqual, Float.toText);
		// 	};
		// };
		char = func(val : Char) : ExpectNum<Char> {
			{
				equal = bindCompare<Char>(val, Char.equal, Char.toText);
				notEqual = bindCompare<Char>(val, Char.notEqual, Char.toText);
				less = bindCompare<Char>(val, Char.less, Char.toText);
				lessOrEqual = bindCompare<Char>(val, Char.lessOrEqual, Char.toText);
				greater = bindCompare<Char>(val, Char.greater, Char.toText);
				greaterOrEqual = bindCompare<Char>(val, Char.greaterOrEqual, Char.toText);
			};
		};
		text = func(val : Text) : ExpectNum<Text> {
			{
				equal = bindCompare<Text>(val, Text.equal, func(a) = a);
				notEqual = bindCompare<Text>(val, Text.notEqual, func(a) = a);
				less = bindCompare<Text>(val, Text.less, func(a) = a);
				lessOrEqual = bindCompare<Text>(val, Text.lessOrEqual, func(a) = a);
				greater = bindCompare<Text>(val, Text.greater, func(a) = a);
				greaterOrEqual = bindCompare<Text>(val, Text.greaterOrEqual, func(a) = a);
				contains = bindCompare<Text>(val, func(a : Text, b) = Text.contains(a, #text b), func(a) = a);
				startsWith = bindCompare<Text>(val, func(a : Text, b) = Text.startsWith(a, #text b), func(a) = a);
				endsWith = bindCompare<Text>(val, func(a : Text, b) = Text.endsWith(a, #text b), func(a) = a);
			};
		};
		array = func<T>(ar : [T], itemToText : (T) -> Text) : {has : (T, (T, T) -> Bool) -> ()} {
			func arrayToText(ar : [T]) : Text {
				var text = "[";
				label l do {
					for (i in ar.keys()) {
						text #= itemToText(ar[i]);

						if (i + 1 < ar.size()) {
							if (text.size() > 100) {
								text #= "...";
								break l;
							};
							text #= ", ";
						};
					};
					text #= "]";
				};
				return text;
			};

			return {
				has = func(a : T, equal : (T, T) -> Bool) {
					let has = Array.find<T>(ar, func b = equal(a, b));
					if (Option.isNull(has)) {
						fail(arrayToText(ar), "to have item", itemToText(a));
					};
				};
			};
		};
		iter = func<T>(iter : Iter.Iter<T>, itemToText : (T) -> Text) : {has : (T, (T, T) -> Bool) -> ()} {
			func iterToText(iter : Iter.Iter<T>) : Text {
				var text = "";
				let iterCopy = Iter.map<T, T>(iter, func(x) = x);
				var i = 0;

				label l while (true) {
					let ?item = iterCopy.next() else break l;

					if (i != 0) {
						text #= ", ";
					};
					text #= itemToText(item);
					i += 1;

					if (text.size() > 100) {
						break l;
					};
				};

				if (Option.isNull(iterCopy.next())) {
					text #= "...";
				};

				return text;
			};

			func iterFind<T>(iter : Iter.Iter<T>, predicate : (T) -> Bool) : ?T {
				let iterCopy = Iter.map<T, T>(iter, func(x) = x);

				label l while (true) {
					let ?item = iterCopy.next() else return null;
					if (predicate(item)) {
						return ?item;
					};
				};

				return null;
			};

			return {
				has = func(a : T, equal : (T, T) -> Bool) {
					let has = iterFind<T>(iter, func b = equal(a, b));
					if (Option.isNull(has)) {
						fail(iterToText(iter), "to have item", itemToText(a));
					};
				};
			};
		};
	};
};