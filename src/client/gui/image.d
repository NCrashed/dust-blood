// Written in D programming language
/*
Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/
/**
*	Gui static image.
*	It is port of C++ libtcod-gui library.
*
*	Authors: Gushcha Anton, Jice & Mingos
*	License: Boost v1.0
*/
module gui.image;

import derelict.tcod.libtcod;
import gui.widget;

class Image : Widget
{
	public
	{
		this(int x, int y, int w, int h, string tip = "")
		{
			super(x, y, w, h);
			back = TCOD_color_t(0, 0, 0);
			setTip(tip);
		}

		void setBackgroundColor(const TCOD_color_t col)
		{
			back = col;
			TCOD_console_rect(con, x, y, w, h, true, TCOD_BKGND_SET);
		}

		override void render()
		{
			TCOD_console_set_default_background(con, back);

		}
	}
	protected
	{
		override void expand(int width, int height)
		{
			if (width > w) w = width;
			if (height > h) h = height;
		}

		TCOD_color_t back;
	}
}