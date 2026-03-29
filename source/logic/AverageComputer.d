module logic.AverageComputer;

import logic.Computer;
import logic.Response;

final class AverageComputer : Computer {
	private int counter = 0;
	private int sum     = 0;

	override public void put(int v) {
		counter += 1;
		sum     += v;
	}

	override public void clear() {
		counter = 0;
		sum     = 0;
	}

	override public Response calculate() {
		if(counter == 0){
			return new Response.Err("No values added.");
		}
		return new Response.Ok(sum/counter);
	}
}