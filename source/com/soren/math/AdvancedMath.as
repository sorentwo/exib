/**
* AdvancedMath
* 
* A complementary set of more specialized or advanced math functions.
* 
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.math {
  
  public class AdvancedMath {
    
    public function AdvancedMath() {
      throw new Error("AdvancedMath class is a static container only")
    }
    
    /**
    * Calculate the Greatest Common Divisor for a given pair of integers
    *
    * @param   value_a   The first value
    * @param   value_b   The second value
    * @return  An integer representing the greatest common divisor of value
    *          values a and b
    **/
    public static function gcd(value_a:int, value_b:int):int {
      if (value_a == 0) return value_b

      var remainder:Number

      while (value_b != 0) {
        remainder = value_a % value_b
        value_a = value_b
        value_b = remainder
      }

      return value_a
    }

    /**
    * Calculate the least common multiple for a given pair of integers
    *
    * @param   value_a   The first integer value
    * @param   value_b   The second integer value
    * @return  A number representing the least common multiple of values a and b
    **/
    public static function lcm(value_a:int, value_b:int):Number {
      var store_a:int = value_a
      var store_b:int = value_b
      var remainder:Number

      do {
        if ((remainder = value_a % value_b) == 0) break
        value_a = value_b
        value_b = remainder
      } while (1)

      return store_a * (store_b / value_b)
    }
    
    /**
    * Returns an unsigned integer as numerator/denominator pair
    *
    * @param   decimal   Unsigned integer value to convert to a fraction
    * @return  The numerator and denominator as a string in the form
    *          numerator/denominator
    **/
    public static function toFraction(decimal:uint):String {
      if (decimal == 0) return decimal.toString()
      if (decimal.toString().indexOf(".") == -1) return decimal.toString()

      var split_values:Array = decimal.toString().split(".")
      var integer:int        = split_values.shift()
      var mantissa:int       = split_values.shift()

      var mantissa_length:Number = mantissa.toString().length
      var base:Number            = Math.pow(10, mantissa_length)
      var gcd:Number             = gcd(mantissa, base)
      var numerator:Number       = mantissa / gcd
      var denominator:Number     = base / gcd

      var fraction:String = (integer == 0)
                          ? numerator + "/" + denominator
                          : integer + " " + numerator + "/" + denominator

      return fraction
    }
  }  
}