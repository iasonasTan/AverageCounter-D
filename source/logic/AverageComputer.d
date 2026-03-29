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

	override public Response calculate() {
		if(counter == 0){
			return new Response.Err();
		}
		return new Response.Ok(sum/counter);
	}
}