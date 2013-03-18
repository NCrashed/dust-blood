module compile;

import dmake;
import std.algorithm;
import std.array;
import std.ascii;
import std.conv;
import std.exception;
import std.file;
import std.getopt;
import std.process;


private string[] getLibs()
{
	version(Windows)
	{
		auto libDir = ".\\lib\\win-i386\\";
		return [
			libDir ~ "ws2_32.lib",
			libDir ~ "event2.lib",
			libDir ~ "eay.lib",
			libDir ~ "ssl.lib"];
	}
	version(Posix)
	{
		return split(environment.get("LIBS", "-L-levent_openssl -L-levent"));
	}
}	

int main(string[] args)
{
	addCompTarget("vibe", "./", "vibe", BUILD.LIB);
	addSource("./source");

	addCustomFlags(join(getLibs(), " "));
	checkProgram("dmd", "Cannot find dmd to compile project! You can get it from http://dlang.org/download.html");
	return proceedCmd(args);	
}