import dlangui;
import std.format : format;
import std.conv;
import std.stdio : writeln;

mixin APP_ENTRY_POINT;

final class UIManager {
	private static UIManager instance;

	public static UIManager get() {
		if(instance is null) {
			instance = new UIManager();
		}
		return instance;
	}

	// GUI
	private Window window;
	private EditLine inputWidget;
	private TextWidget outputWidget;

	// LOGIC
	private Computer computer;

	this() {
		window = Platform.instance.createWindow(
	    	UIString.fromRaw("Average Value Calculator."),
	    	null,
		);
		VerticalLayout layout = new VerticalLayout();
	    layout.margins = 20;

	    auto label = new TextWidget(
	    	null,
	    	UIString.fromRaw("Enter values below: "),
		);
	    layout.addChild(label);

	    inputWidget = new EditLine(null);
	    layout.addChild(inputWidget);

	    outputWidget = new TextWidget(
	    	null,
	    	UIString.fromRaw("Average: 0"),
		);
		layout.addChild(outputWidget);

	    auto btn = new Button(
	    	null,
	    	UIString.fromRaw("Calculate!"),
		);
	    btn.click = delegate(Widget src) {
	    	try {
		    	computer.put(inputWidget.text.to!int);
		    	string avgStr = computer.calculate().to!string;
		    	Response res = computer.calculate();
			Response.Ok ok = cast(Response.Ok) res;
			if(ok !is null) {
				outputWidget.text      = UIString.fromRaw("Average: "~ok.value.to!string);
				outputWidget.textColor = Color.black;
			} else {
				outputWidget.textColor = Color.red;
				outputWidget.text      = UIString("No values!");
			}
	    	} catch(Exception ignored) {
	    		outputWidget.text      = UIString.fromRaw("Error!");
	    		outputWidget.textColor = Color.red;
	    	}
	    	return true;
	    };
	    layout.addChild(btn);

	    window.mainWidget = layout;
	}

	public void start(Computer computer) {
		this.computer = computer;
		window.show();
	}
}

interface Response {
	static final class Ok : Response {
		public const int value;

		this(int v) {
			value = v;
		}
	}

	static final class Err : Response {
	}
}

interface Computer {
	void put(int v);
	Response calculate();
}

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

extern (C) int UIAppMain(string[] args) {
    UIManager.get().start(new AverageComputer());
    return Platform.instance.enterMessageLoop();
}
