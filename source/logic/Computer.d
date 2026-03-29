module logic.Computer;

import logic.Response;

interface Computer {
	void put(int v);
	Response calculate();
}