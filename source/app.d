import std.format : format;
import std.conv;
import std.stdio : writeln;
import gui.UIManager;
import logic.AverageComputer;
import dlangui;

extern (C) int UIAppMain(string[] args) {
    UIManager.get().start(new AverageComputer());
    return Platform.instance.enterMessageLoop();
}
