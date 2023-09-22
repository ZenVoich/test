import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import {bindCompare} "./utils";

module {
	public class ExpectBlob<T>(val : Blob) {
		func show(v : Blob) : Text = "" # debug_show(v) # "";

		public let equal = bindCompare<Blob>(val, Blob.equal, show, "");
		public let notEqual = bindCompare<Blob>(val, Blob.notEqual, show, "!=");
		public let less = bindCompare<Blob>(val, Blob.less, show, "<");
		public let lessOrEqual = bindCompare<Blob>(val, Blob.lessOrEqual, show, "<=");
		public let greater = bindCompare<Blob>(val, Blob.greater, show, ">");
		public let greaterOrEqual = bindCompare<Blob>(val, Blob.greaterOrEqual, show, ">=");
	};
};