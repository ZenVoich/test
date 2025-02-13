import Text "mo:base/Text";

module {
	public func formatTestName(text : Text) : Text {
		Text.translate(text, func(c : Char) : Text {
			if (c == '\n') {
				"\\n"
			}
			else {
				Text.fromChar(c);
			}
		});
	};
};