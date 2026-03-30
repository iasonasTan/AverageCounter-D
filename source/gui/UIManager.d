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
	private WidgetGroup historyWidgetGroup;

	// LOGIC
	private Computer computer;

	this() {
		window = Platform.instance.createWindow(UIString.fromRaw("Average Value Calculator."),null, WindowFlag.Modal);
		VerticalLayout layout = new VerticalLayout();
	    layout.margins = 20;

	    auto label = new TextWidget(null,UIString.fromRaw("Enter values below: "));
	    layout.addChild(label);

	    inputWidget = new EditLine(null);
	    layout.addChild(inputWidget);

	    outputWidget = new TextWidget(null,UIString.fromRaw("Average: 0"));
		layout.addChild(outputWidget);

        auto clearButton = new Button(null, UIString.fromRaw("Clear"));
        clearButton.click = delegate(Widget src) {
            computer.clear();
            clearUI();
            return true;
        };
        layout.addChild(clearButton);

	    auto calculateButton = new Button(null,UIString.fromRaw("Calculate!"));
	    calculateButton.click = delegate(Widget src) {
	    	try {
				const string inputStr = inputWidget.text.to!string;
		    	inputWidget.text = UIString.fromRaw("");
				computer.put(inputStr.to!int);
		    	Response res = computer.calculate();
				handleResponse(res);
				updateHistory(res, inputStr);
	    	} catch(Exception e) {
	    		outputWidget.text = UIString.fromRaw("That's not a number!");
	    		outputWidget.textColor = Color.red;
	    	}
	    	return true;
	    };
	    layout.addChild(calculateButton);

		auto historyLabel = new TextWidget(null, UIString.fromRaw("History:"));
		layout.addChild(historyLabel);

		historyWidgetGroup = new VerticalLayout();
		historyWidgetGroup.layoutWidth(WRAP_CONTENT).layoutHeight(WRAP_CONTENT);
		auto historyScroll = new ScrollWidget();
		historyScroll.layoutWidth(FILL_PARENT).layoutHeight(FILL_PARENT);
		historyScroll.contentWidget = historyWidgetGroup;
		layout.addChild(historyScroll);

		window.mainWidget = layout;
	}

	private void updateHistory(Response res, string inputStr) {
		string widgetText = "Added: "~inputStr;
		Response.Ok ok = cast(Response.Ok) res;
		if(ok !is null) {
			widgetText = widgetText~", Average: "~ok.value.to!string;
		}
		auto valueView = new TextWidget(null, UIString.fromRaw(widgetText));
		historyWidgetGroup.addChild(valueView);
	}

    private void clearUI() {
		outputWidget.text = UIString.fromRaw("Average: 0");
        outputWidget.textColor = Color.black;
		historyWidgetGroup.removeAllChildren();
    }

    private void handleResponse(Response res) {
        Response.Ok ok = cast(Response.Ok) res;
        if(ok !is null) {
            outputWidget.text = UIString.fromRaw("Average: "~ok.value.to!string);
            outputWidget.textColor = Color.black;
        }
		Response.Err err = cast(Response.Err) res;
		if(err !is null) {
            outputWidget.text = UIString.fromRaw(err.msg);
			outputWidget.textColor = Color.red;
        }
    }

	public void start(Computer computer) {
		this.computer = computer;
		window.show();
	}
}
