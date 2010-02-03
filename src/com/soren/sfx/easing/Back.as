package com.soren.sfx.easing {
  
  public class Back {
    
    private static const SEED:Number = 1.70158
    
    /**
    * Static container only.
    **/
    public function Back():void {
      throw new Error('Back class is a static container only')
    }
    
    public static function easeIn (t:Number, b:Number, c:Number, d:Number, s:Number = SEED):Number {
      return c * (t/=d) * t * ((s+1) * t - s) + b
    }
    
    public static function easeOut (t:Number, b:Number, c:Number, d:Number, s:Number = SEED):Number {
      return c * ((t = t/d - 1) * t * ((s + 1) * t + s) + 1) + b
    }
    
    public static function easeInOut (t:Number, b:Number, c:Number, d:Number, s:Number = SEED):Number {
      if ((t /= d / 2) < 1) { return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b }
      else                  { return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b }
    }
  }
}
