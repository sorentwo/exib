package com.soren.exib.effect.easing {

	public class Circular {

	  /**
	  * Static container only
	  **/
	  public function Circular():void {
	    throw new Error('Circular class is a static container only')
	  }

		public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b
		}

		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sqrt(1 - (t = t / d - 1) * t) + b
		}

		public static function easeInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d / 2) < 1) { return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b       }
			else                  { return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b }
		}
	}
}