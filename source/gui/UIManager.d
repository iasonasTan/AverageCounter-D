module gui.UIManager;

import dlangui;
import logic.Computer;
import logic.Response;

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
		window = Platform.instance.createWindow(UIString.fromRaw("Average Value Calculator."),null);
		VerticalLayout layout = new VerticalLayout();
	    layout.margins = 20;

	    auto label = new TextWidget(null,UIString.fromRaw("Enter values below: "));
	    layout.addChild(label);

	    inputWidget = new EditLine(null);
	    layout.addChild(inputWidget);

	    outputWidget = new TextWidget(null,UIString.fromRaw("Average: 0"));
		layout.addChild(outputWidget);

	    auto btn = new Button(null,UIString.fromRaw("Calculate!"));
	    btn.click = delegate(Widget src) {
	    	try {
		    	computer.put(inputWidget.text.to!int);
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