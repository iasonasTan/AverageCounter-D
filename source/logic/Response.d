module logic.Response;

interface Response {
	static final class Ok : Response {
		public const int value;

		this(int v) {
			value = v;
		}
	}

	static final class Err : Response {
		public const string msg;

		this(string msg) {
			this.msg = msg;
		}
	}
}