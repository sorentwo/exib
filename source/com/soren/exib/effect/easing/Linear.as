package com.soren.exib.effect.easing {
  
	public class Linear {
	  
	  /**
	  * Static container only
	  **/
	  public function Linear():void {
	    throw new Error('Linear class is a static container only')
	  }
		
		public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number {
			return easeAll(t, b, c, d)
		}
		
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return easeAll(t, b, c, d)
		}
		
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			return easeAll(t, b, c, d)
		}
		
		private function easeAll(t:Number, b:Number, c:Number, d:Number):Number {
		  return c * t / d + b
		}
	}
}