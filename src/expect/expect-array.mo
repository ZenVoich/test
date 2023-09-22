import Array "mo:base/Array";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import {fail} "./utils";

module {
	public class ExpectArray<T>(arr : [T], itemToText : (T) -> Text, itemEqual : (T, T) -> Bool) {
		func _arrayToText(arr : [T]) : Text {
			var text = "[";
			label l do {
				for (i in arr.keys()) {
					text #= itemToText(arr[i]);

					if (i + 1 < arr.size()) {
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

		public func equal(other : [T]) {
			if (not Array.equal<T>(arr, other, itemEqual)) {
				fail(_arrayToText(arr), "", _arrayToText(other));
			};
		};

		public func notEqual(other : [T]) {
			if (Array.equal<T>(arr, other, itemEqual)) {
				fail(_arrayToText(arr), "", _arrayToText(other));
			};
		};

		public func has(a : T) {
			let has = Array.find<T>(arr, func b = itemEqual(a, b));
			if (Option.isNull(has)) {
				fail(_arrayToText(arr), "to have item", itemToText(a));
			};
		};

		public func notHas(a : T) {
			let has = Array.find<T>(arr, func b = itemEqual(a, b));
			if (Option.isSome(has)) {
				fail(_arrayToText(arr), "to not have item", itemToText(a));
			};
		};
	};
};