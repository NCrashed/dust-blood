//          Copyright Gushcha Anton, Shamyan Roman 2012.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)
module util.iprotocol;

import util.protocol;
import util.serialization.serializer;
import util.log;
import util.messages;

import std.stdio;
import std.stream;
import std.traits;
import std.stream;

enum MAX_BUF_SIZE = 1024;

private void foo(){};

ubyte[] writeObject(T)(T object)
{
	static assert(is(T:TcpMessage), "undefined Message. "~T.stringof~" must inherit TcpMessage.");
	
	ubyte[] buf;
	Stream stream;
	try
	{
		stream = serialize!BinaryArchive(object);
	}
	catch(Exception e)
	{	
		debug {
			string message = moduleName!foo;
			message ~= ":(Maybe) Serialize exception: ";
			//writeLog(message, LOG_ERROR_LEVEL.NOTICE, sockManager.LOG_NAME);
			writeln(message~e.msg);
		}
		return new ubyte[0];
	}

	Stream t = new MemoryStream;

	t.write(stream.size);

	t.copyFrom(stream);

	buf = new ubyte[cast(size_t) t.size()];

	t.read(buf);

	return buf;

}


int readObjects(ubyte[] buf, out TcpMessage[] objects, out size_t sumReads, out size_t rest)
{
	sumReads = 0;
	rest = 0;
	int res = 0;
	
	Stream stream = new MemoryStream(buf);

	while (!stream.eof)
	{
		
		ulong msgSize;
		try
		{
			stream.read(msgSize);
		}
		catch (ReadException e)
		{
			debug {
				writeln("ReadException: "~e.msg);
			}
			return -1;
		}
		
		if (msgSize > MAX_BUF_SIZE)
		{
			debug{
				writeln("Too big size msg");
			}
			return res;
		}

		int id;
		stream.read(id);
		ubyte[] msg;
		
		msg = new ubyte[cast(size_t)msgSize];

		auto reads = stream.read(msg);
		

		if (reads < msgSize)
		{
			//rest = cast(int) stream.size -(reads + id.sizeof + msgSize.sizeof);
			rest = cast(int)(msgSize - reads);
			return res;
		}

		sumReads += reads + id.sizeof + msgSize.sizeof;
		rest = cast(int)(stream.size - sumReads);

		
		debug 
		{
			//writeln("Getted message id is ",id);	
		}

		try
		{
			Stream str = new MemoryStream(msg);
			str.position = 0;
			auto message = dispatchMessage!(deserialize)(id, str, "MSG");
			if (res == 0)
				objects = new TcpMessage[0];

			objects ~= message;
			res++;
		}
		catch (Exception e)
		{
			debug {
				string message = moduleName!writeObject;
				message ~= ":(Maybe) Deserialize exception:";
				writeln(message~e.msg);
			}
		}
	
	}
	return res;
}

/*
class Amsg : TcpMessage
{
	int a;
	string name;

	this() {}

	this(int pa, string pb)
	{
		a = pa;
		name = pb;
	}

	void opCall()
	{
		writeln("AMsg call with ", a, " ",name);
	}
}

class Bmsg : TcpMessage
{
	int a;
	string name;

	this() {}

	this(int pa, string pb)
	{
		a = pa;
		name = pb;
	}

	void opCall()
	{
		writeln("BMsg call with ", a, " ",name);
	}
}

class Cmsg : TcpMessage
{
	int a;
	string name;

	this() {}

	this(int pa, string pb)
	{
		a = pa;
		name = pb;
	}

	void opCall()
	{
		writeln("CMsg call with ", a, " ",name);
	}
}


unittest {
	//auto buf = writeObject(msg1);

	auto buf1 = constructMessage!Bmsg(10,"Hello Wolrd");
	auto buf2 = constructMessage!Cmsg(1005001010,"Hi Wolrd");
	//auto buf = buf1~buf2;
	auto buf = buf1[0..$/2];
	auto addBuf = buf1[$/2..$] ~ buf2;
	//writeln(buf);
	writeln("buf size:",buf.length);
	//writeln(buf);

	PMessage[] msgs;
//
	int a,b;

	auto count = readObjects(buf,msgs,a,b);

	writeln("count:",count," sumReads:",a," rest:",b);
	if ((b > 0) && (addBuf.length >= b))
	{
		readObjects(buf~addBuf, msgs, a,b);
		writeln("length:",(buf~addBuf).length," count:",count," sumReads:",a," rest:",b);
	}
	foreach(i; 0..count)
		msgs[i]();

}
*/