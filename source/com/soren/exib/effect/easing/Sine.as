package com.soren.exib.effect.easing {
  
	public class Sine {
	  
		private static const HALF_PI:Number = Math.PI / 2
		
	  /**
	  * Static container only
	  **/
	  public function Sine():void {
	    throw new Error('Sine class is a static container only')
	  }
		
		public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * Math.cos(t / d * HALF_PI) + c + b
		}
		
		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sin(t / d * HALF_PI) + b
		}
		
		public static function easeInOut(t:Number, b:Number, c:Number, d:Number):Number {
			return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b
		}
	}
}