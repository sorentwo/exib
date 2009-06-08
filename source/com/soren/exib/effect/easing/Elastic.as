package com.soren.exib.effect.easing {
  
	public class Elastic {
	  
		public static const PI2:Number = Math.PI * 2
		
	  /**
	  * Static container only
	  **/
	  public function Elastic():void {
	    throw new Error('Elastic class is a static container only')
	  }
		
		public static function easeIn(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number
			
			if (t == 0)         return b
			if ((t /= d) == 1)  return b + c
			
			if (!p) p = d * .3
			
			if (!a || a < Math.abs(c)) { a=c; s = p / 4                  }
			else                       { s = p / PI2 * Math.asin (c / a) }
			
			return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * PI2 / p )) + b
		}
		
		public static function easeOut(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number
			
			if (t == 0)        return b
			if ((t /= d) == 1) return b + c
			
			if (!p) p = d *.3
			
			if (!a || a < Math.abs(c)) { a = c; s = p / 4               }
			else                       { s = p / PI2 * Math.asin(c / a) }
			
			return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * PI2 / p) + c + b)
		}
		
		public static function easeInOut(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number
			
			if (t == 0)            return b
			if ((t /= d / 2) == 2) return b + c
			
			if (!p) p = d * (.3 * 1.5)
			
			if (!a || a < Math.abs(c)) { a = c; s = p / 4               }
			else                       { s = p / PI2 * Math.asin(c / a) }
			
			if (t < 1) { return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * PI2 / p)) + b   }
			else       { return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * PI2 / p) * .5 + c + b }
		}
	}
}