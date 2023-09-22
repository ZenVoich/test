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

import {bindCompare; fail = _fail} "./utils";
import ExpectInt "./expect-int";
import ExpectChar "./expect-char";
import ExpectText "./expect-text";
import ExpectBool "./expect-bool";
import ExpectArray "./expect-array";
import ExpectBlob "./expect-blob";
import ExpectOption "./expect-option";

module {
	public let expect = {
		bool = ExpectBool.ExpectBool;
		option = ExpectOption.ExpectOption;
		int = ExpectInt.ExpectInt;
		int8 = func(val : Int8) : ExpectInt.ExpectInt = ExpectInt.ExpectInt(Int8.toInt(val));
		int16 = func(val : Int16) : ExpectInt.ExpectInt = ExpectInt.ExpectInt(Int16.toInt(val));
		int32 = func(val : Int32) : ExpectInt.ExpectInt = ExpectInt.ExpectInt(Int32.toInt(val));
		int64 = func(val : Int64) : ExpectInt.ExpectInt = ExpectInt.ExpectInt(Int64.toInt(val));
		nat = func(val : Nat) : ExpectInt.ExpectInt = ExpectInt.ExpectInt(val);
		nat8 = func(val : Nat8) : ExpectInt.ExpectInt = ExpectInt.ExpectInt(Nat8.toNat(val));
		nat16 = func(val : Nat16) : ExpectInt.ExpectInt = ExpectInt.ExpectInt(Nat16.toNat(val));
		nat32 = func(val : Nat32) : ExpectInt.ExpectInt = ExpectInt.ExpectInt(Nat32.toNat(val));
		nat64 = func(val : Nat64) : ExpectInt.ExpectInt = ExpectInt.ExpectInt(Nat64.toNat(val));
		char = ExpectChar.ExpectChar;
		text = ExpectText.ExpectText;
		array = ExpectArray.ExpectArray;
		blob = ExpectBlob.ExpectBlob;
	};

	public let fail = _fail;
};