/**
 * Copyright (c) 2012 - 2100 Sindney
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package bloom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import bloom.core.ButtonBase;
	import bloom.events.BrushEvent;
	import bloom.themes.ThemeBase;
	
	/**
	 * Button
	 * 
	 * @author sindney
	 */
	public class Button extends ButtonBase {
		
		private var _title:Label;
		
		public function Button(p:DisplayObjectContainer = null, text:String = "", click:Function = null) {
			super(p);
			
			_title = new Label(this, text);
			_title.brush = ThemeBase.Text_Button;
			_title.addEventListener(Event.CHANGE, onTitleChanged);
			_title.addEventListener(BrushEvent.REDRAW, onTitleChanged);
			
			if (click != null) addEventListener(MouseEvent.CLICK, click);
			size(100, 20);
		}
		
		protected function onTitleChanged(e:Event):void {
			_title.move((_width - _title.width) * 0.5, (_height - _title.height) * 0.5);
		}
		
		override protected function draw(e:Event):void {
			super.draw(null);
			
			switch(_state) {
				case 0:
					_title.brush = ThemeBase.Text_Button;
					break;
				case 1:
					_title.brush = ThemeBase.Text_Button_Over;
					break;
				case 2:
					_title.brush = ThemeBase.Text_Button_Down;
					break;
			}
			
			_title.move((_width - _title.width) * 0.5, (_height - _title.height) * 0.5);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get title():Label {
			return _title;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		override public function toString():String {
			return "[bloom.Button]";
		}
		
	}

}