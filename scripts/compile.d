#!/usr/bin/rdmd
module compile;

import dmake;

import std.stdio;
import std.process;

string[string] clientDepends;
string[string] serverDepends;
string[] derelictLibs;

version(X86)
	enum MODEL = "32";
version(X86_64)
	enum MODEL = "64";

static this()
{
	clientDepends =
	[
		"Derelict3": 	"../dependencies/Derelict3",
		//"GLFW3": 		"../dependencies/GLFW3",
		//"FreeImage": 	"../dependencies/FreeImage",
		"cl4d": 		"../dependencies/cl4d",
		"Vibe":			"../dependencies/vibe.d",
	];

	serverDepends = 
	[
		"Derelict3": 	"../dependencies/Derelict3",
		"Vibe":			"../dependencies/vibe.d",
	];

	derelictLibs =
	[
		"DerelictGL3",
		//"DerelictGLFW3",
		"DerelictUtil",
		"DerelictTCOD",
		//"DerelictFI",
	];
}

void compileFreeImage(string libPath)
{
	writeln("Building FreeImage...");

	version(linux)
	{
		system("cd "~libPath~` && make -f Makefile.fip`);
		system("cp "~libPath~"/libfreeimageplus-3.15.4.so "~getCurrentTarget().outDir~`/libfreeimage.so`);
	}
	version(Windows)
	{
		checkProgram("make", "Cannot find MinGW to build FreeImage! You can build manualy with Visual Studio and copy FreeImage.dll to output folder or get MinGW from http://www.mingw.org/wiki/Getting_Started");
		system("cd "~libPath~` && make -fMakefile.mingw`);
		system("copy "~libPath~"\\FreeImage.dll "~getCurrentTarget().outDir~"\\FreeImage.dll");
	}
}

void compileGLFW3(string libPath)
{
	writeln("Building GLFW3...");
	version(linux)
	{
		checkProgram("cmake", "Cannot find CMake to build GLFW3! You can get it from http://www.cmake.org/cmake/resources/software.html");
		system("cd "~libPath~` && cmake -D BUILD_SHARED_LIBS=ON ./`);
		system("cd "~libPath~` && make`);
		system("cp "~libPath~`/src/libglfw.so `~getCurrentTarget().outDir~`/libglfw.so`);
	}
	version(Windows)
	{
		checkProgram("cmake", "Cannot find CMake to build GLFW3! You can get it from http://www.cmake.org/cmake/resources/software.html");
		checkProgram("make", "Cannot find MinGW to build GLFW3! You can build manualy with GLFW3 and copy glfw.dll to output folder or get MinGW from http://www.mingw.org/wiki/Getting_Started");
		system("cd "~libPath~` & cmake -D BUILD_SHARED_LIBS=ON -G "MinGW Makefiles" .\`);
		system("cd "~libPath~` & make`);
		system("copy "~libPath~`\src\glfw3.dll `~getCurrentTarget().outDir~`\glfw3.dll`);
	}
}

void compileCl4d(string libPath)
{
	writeln("Building cl4d...");
	system("cd "~libPath~` && rdmd compile.d all release`);
}

void compileDerelict(string libPath)
{
	writeln("Building derelict...");
	version(Windows)
		system("cd "~libPath~`/build && dmd build.d && build.exe`);
	version(linux)
		system("cd "~libPath~`/build && dmd build.d && ./build`);	
}

void compileVibe(string libPath)
{
	writeln("Building vibe...");
	system("cd "~libPath~" && rdmd compile.d all debug");
}

//======================================================================
//							Main part
//======================================================================
int main(string[] args)
{
	// Клиент
	addCompTarget("client", "../bin", "client", BUILD.APP);
	setDependPaths(clientDepends);

	addLibraryFiles("Derelict3", "lib", derelictLibs, ["import"], &compileDerelict);
	addLibraryFiles("cl4d", ".", ["OpenCL","cl4d"], ["."], &compileCl4d);
	addLibraryFiles("Vibe", ".", ["vibe"], ["source"], &compileVibe);
	//checkSharedLibraries("GLFW3", ["glfw3"], &compileGLFW3);
	//checkSharedLibraries("FreeImage", ["freeimage"], &compileFreeImage);

	addSource("../src/client");
	addSource("../src/util");

	addCustomFlags("-D -Dd../docs ../docs/candydoc/candy.ddoc ../docs/candydoc/modules.ddoc");
	addCustomFlags("-version=CL_VERSION_1_1");
	addCustomFlags("-version=CLIENT_SIDE");

	// Сервер
	addCompTarget("server", "../bin", "server", BUILD.APP);
	setDependPaths(serverDepends);

	addLibraryFiles("Derelict3", "lib", derelictLibs, ["import"], &compileDerelict);
	addLibraryFiles("Vibe", ".", ["vibe"], ["source"], &compileVibe);

	addSource("../src/server");
	addSource("../src/util");
	
	addCustomFlags("-D -Dd../docs ../docs/candydoc/candy.ddoc ../docs/candydoc/modules.ddoc");
	addCustomFlags("-version=SERVER_SIDE");
	
	checkProgram("dmd", "Cannot find dmd to compile project! You can get it from http://dlang.org/download.html");
	// Компиляция!
	return proceedCmd(args);
}