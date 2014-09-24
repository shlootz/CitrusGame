package com.pzuh.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	
	public class Basic
	{
		public function Basic()
		{
		
		}
		
		public static function degreeToRadian(valueDegree:Number):Number
		{
			var valueRadian:Number;
			
			valueRadian = valueDegree * Math.PI / 180;
			
			return valueRadian;
		}
		
		public static function radianToDegree(valueRadian:Number):Number
		{
			var valueDegree:Number;
			
			valueDegree = valueRadian * 180 / Math.PI;
			
			return valueDegree;
		}
		
		public static function getPointDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number;
			var dy:Number;
			var dist:Number;
			
			dx = x2 - x1;
			dy = y2 - y1;
			
			dist = Math.sqrt(dx * dx + dy * dy);
			
			return dist;
		}
		
		public static function getObjectDistance(object1:Object, object2:Object):Number
		{
			return getPointDistance(object1.x, object1.y, object2.x, object2.y);
		}
		
		public static function getPointAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number;
			var dy:Number;
			var angle:Number;
			
			dx = x2 - x1;
			dy = y2 - y1;
			angle = Math.atan2(dy, dx);
			
			return angle;
		}
		
		public static function getObjectAngle(object1:Object, object2:Object):Number
		{
			return getPointAngle(object1.x, object1.y, object2.x, object2.y);
		}
		
		public static function getRotation(valueRadian:Number):Number
		{
			var rotation:Number;
			
			rotation = radianToDegree(valueRadian);
			
			return rotation;
		}
		
		public static function generateRandomSign():int
		{
			var rand:int;
			
			rand = Math.ceil(Math.random() * 2);
			
			if (rand == 1)
			{
				return -1;
			}
			
			return 1;
		}
		
		public static function isElementOfArray(array:Array, object:Object):Boolean
		{
			if (array.indexOf(object) != -1)
			{
				return true;
			}
			
			return false;
		}
		
		public static function getUniqueArray(array:Array, convertToString:Boolean = false):Array
		{
			var uniqueArray:Array = new Array();
			
			var arrayLength:int = array.length;
			
			for (var i:int = 0; i < arrayLength; i++)
			{
				var found:Boolean = false;
				
				for (var j:int = 0; j < uniqueArray.length; j++)
				{
					if (!convertToString)
					{
						if (array[i] == uniqueArray[j])
						{
							found = true;
						}
					}
					else
					{
						if (array[i].toString() == uniqueArray[j].toString())
						{
							found = true;
						}
					}
				}
				
				if (found == false)
				{
					uniqueArray.push(array[i]);
				}
			}
			
			return uniqueArray;
		}
		
		public static function getAdjacent(angleDegree:Number, hypotenuse:Number):Number
		{
			var angleRadian:Number = degreeToRadian(angleDegree);
			
			return Math.cos(angleRadian) * hypotenuse;
		}
		
		public static function getOpposite(angleDegree:Number, hypotenuse:Number):Number
		{
			var angleRadian:Number = degreeToRadian(angleDegree);
			
			return Math.sin(angleRadian) * hypotenuse;
		}
		
		public static function removeAllChild(mc:DisplayObjectContainer):void
		{
			for (var i:int = mc.numChildren - 1; i >= 0; i--)
			{
				mc.removeChildAt(i);
			}
		}
		
		public static function registerMouseEvent(objectContainer:MovieClip, click:Function, over:Function, out:Function):void
		{
			var button:MovieClip;
			var object:DisplayObject;
			
			for (var i:int = 0; i < objectContainer.numChildren; i++)
			{
				object = objectContainer.getChildAt(i);
				
				if (object is MovieClip)
				{
					button = object as MovieClip;
					button.buttonMode = true;
					button.mouseChildren = false;
					
					button.addEventListener(MouseEvent.CLICK, click, false, 0, true);
					button.addEventListener(MouseEvent.MOUSE_OVER, over, false, 0, true);
					button.addEventListener(MouseEvent.MOUSE_OUT, out, false, 0, true);
				}
			}
		}
		
		public static function unregisterMouseEvent(objectContainer:MovieClip, click:Function, over:Function, out:Function):void
		{
			var button:MovieClip;
			var object:DisplayObject;
			
			for (var i:int = 0; i < objectContainer.numChildren; i++)
			{
				object = objectContainer.getChildAt(i);
				
				if (object is MovieClip)
				{
					button = object as MovieClip;
					
					if (button.hasEventListener(MouseEvent.CLICK))
					{
						button.removeEventListener(MouseEvent.CLICK, click);
					}
					
					if (button.hasEventListener(MouseEvent.MOUSE_OVER))
					{
						button.removeEventListener(MouseEvent.MOUSE_OVER, over);
					}
					
					if (button.hasEventListener(MouseEvent.MOUSE_OUT))
					{
						button.removeEventListener(MouseEvent.MOUSE_OUT, out);
					}
				}
			}
		}
		
		public static function replaceString(string:String, stringToReplace:String, replaceWith:String):String
		{
			return string.split(stringToReplace).join(replaceWith);
		}
		
		public static function getRandomBetween(minValue:Number, maxValue:Number):Number
		{
			return minValue + (maxValue - minValue) * Math.random();
		}
		
		public static function toTitleCase(original:String):String
		{
			var words:Array = original.split(" ");
			
			for (var i:int = 0; i < words.length; i++)
			{
				words[i] = toInitialCap(words[i]);
			}
			
			return (words.join(" "));
		}
		
		public static function toInitialCap(original:String):String
		{
			return original.charAt(0).toUpperCase() + original.substr(1).toLowerCase();
		}
		
		public static function formatTime(input:int):String
		{
			var hrs:String = (input > 3600 ? Math.floor(input / 3600) + ':' : '');
			var mins:String = (hrs && input % 3600 < 600 ? '0' : '') + Math.floor(input % 3600 / 60) + ':';
			var secs:String = (input % 60 < 10 ? '0' : '') + input % 60;
			return hrs + mins + secs;
		}	
	}
}