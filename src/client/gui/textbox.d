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
*	Editable text field.
*	It is port of C++ libtcod-gui library.
*
*	Authors: Gushcha Anton, Jice & Mingos
*	License: Boost v1.0
*/
module gui.textbox;

import derelict.tcod.libtcod;
import gui.widget;
import std.string;

class TextBox : Widget 
{
	public
	{
		this(int x, int y, int w, int maxw, string label, string tip = "")
		{
			super(x, y, w, 1);
			this.maxw = maxw;
			insert = true;

			if (maxw > 0)
			{
				txt = label;
			}
			setTip(tip);
			this.label = label;
			boxw = w;
			boxx = label.length+1;
			this.w += boxx;
		}

		override void render()
		{
			TCOD_console_set_default_background(con, back);
			TCOD_console_set_default_foreground(con, fore);
			TCOD_console_rect(con, x, y, w, h, true, TCOD_BKGND_SET);
			if (label.length > 0)
			{
				TCOD_console_print_ex(con, x, y, TCOD_BKGND_NONE, TCOD_LEFT, toStringz(label));
			}

			TCOD_console_set_default_background(con, keyboardFocus == this ? foreFocus : fore);
			TCOD_console_set_default_foreground(con, keyboardFocus == this ? backFocus : back);
			TCOD_console_rect(con, x+boxx, y, boxw, h, false, TCOD_BKGND_SET);
			size_t len = txt.length - offset;
			if (len > boxw) len = boxw;
			if (txt.length > 0)
			{
				TCOD_console_print_ex(con, x+boxx, y, TCOD_BKGND_NONE, TCOD_LEFT, toStringz(txt));
			}
			if (keyboardFocus == this && blink > 0.0f)
			{
				if (insert) 
				{
					TCOD_console_set_char_background(con, x+boxx+pos-offset, y, fore, TCOD_BKGND_SET);
					TCOD_console_set_char_foreground(con, x+boxx+pos-offset, y, back);
				} else
				{
					TCOD_console_set_char_background(con, x+boxx+pos-offset, y, back, TCOD_BKGND_SET);
					TCOD_console_set_char_foreground(con, x+boxx+pos-offset, y, fore);					
				}
			}
		}

		override void update(const TCOD_key_t k)
		{
			if (keyboardFocus == this)
			{
				blink -= elapsed;
				if (blink < -blinkingDelay) blink += 2*blinkingDelay;
				if (k.vk == TCODK_CHAR ||
					(k.vk >= TCODK_0 && k.vk <= TCODK_9) ||
					(k.vk >= TCODK_KP0 && k.vk <= TCODK_KP9))
				{
					if (!insert || txt.length < maxw)
					{
						if (insert && pos < txt.length)
						{
							txt = txt[0..pos]~k.c~txt[pos..$];
						} else if(pos < txt.length)
						{
							txt = txt[0..pos]~k.c~txt[pos+1..$];
						} else
						{
							txt ~= k.c;
						}
					}
					if (pos < maxw) pos++;
					if (pos >= w) offset = pos-w+1;
					if (txtcbk !is null) txtcbk(this, txt);
				}
				blink = blinkingDelay;
			}
			switch (k.vk)
			{
				case TCODK_LEFT:
				{
					if (pos > 0) pos--;
					if (pos < offset) offset = pos;
					blink = blinkingDelay;
					break;
				}
				case TCODK_RIGHT:
				{
					if (pos < txt.length) pos++;
					if (pos >= w) offset = pos-w+1;
					blink = blinkingDelay;
					break;
				}
				case TCODK_HOME:
				{
					pos = offset = 0;
					blink = blinkingDelay;
					break;
				}
				case TCODK_BACKSPACE:
				{
					if (pos > 0)
					{
						if(pos < txt.length)
							txt = txt[0..pos]~txt[pos+1..$];
						else 
							txt = txt[0..$-1];
						pos--;
						if(txtcbk !is null) txtcbk(this, txt);
					}
					blink = blinkingDelay;
					break;
				}
				case TCODK_DELETE:
				{
					if(pos < txt.length)
						txt = txt[0..pos]~txt[pos+1..$];
					else 
					{
						txt = txt[0..$-1];
						pos--;
					}
					if(txtcbk !is null) txtcbk(this, txt); 
					blink = blinkingDelay;
					break;
				}
				case TCODK_INSERT:
				{
					insert = !insert;
					blink = blinkingDelay;
					break;
				}
				case TCODK_END:
				{
					pos = txt.length;
					if(pos >= w) offset = pos-w+1;
					blink = blinkingDelay;
				}
				default:
			}
			super.update(k);
		}

		void setText(string txt)
		{
			if(txt.length <= maxw)
			{
				this.txt = txt;
			} else
			{
				this.txt = txt[0..maxw];
			}
		}

		string getValue()
		{
			return txt;
		}

		alias void delegate(Widget wid, string val) Callback;
		void setCallback(Callback cbk)
		{
			txtcbk = cbk;
		}

		static void setBlinkingDelay(float delay)
		{
			blinkingDelay = delay;
		}
	}
	protected
	{
		static float blinkingDelay = 0.5f;
		string label;
		string txt;

		float blink;
		int pos, offset;
		int boxx, boxw, maxw;
		bool insert;
		Callback txtcbk;

		override void onButtonClick()
		{
			if ( mouse.cx >= x+boxx && mouse.cx < x+boxx+boxw ) 
				keyboardFocus=this;
		}
	}
}