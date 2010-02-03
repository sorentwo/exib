package com.soren.sfx.easing {
  
	public class Quad {
	  
	  /**
	  * Static container only
	  **/
	  public function Quad():void {
	    throw new Error('Quad class is a static container only')
	  }
	  
		public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number {
			return c * (t /= d) * t + b
		}
		
		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * (t /= d) * (t - 2) + b
		}
		
		public static function easeInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d / 2) < 1) return c / 2 * t * t + b
			else                  return -c / 2 * ((--t) * (t - 2) - 1) + b
		}
	}
}