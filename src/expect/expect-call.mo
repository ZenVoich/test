import Debug "mo:base/Debug";
import Error "mo:base/Error";

module {
	public class ExpectCall(fn : () -> async ()) {
		public func reject() : async () {
			try {
				await fn();
			}
			catch (err) {
				if (Error.code(err) == #canister_reject) {
					return;
				};
			};
			Debug.trap("expected to throw error");
		};

		// unable to catch
		// public func trap() : async () {
		// 	try {
		// 		await fn();
		// 	}
		// 	catch (err) {
		// 		if (Error.code(err) == #canister_error) {
		// 			return;
		// 		};
		// 	};
		// 	Debug.trap("expected to trap");
		// };
	};
};