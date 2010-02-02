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
    * Converts a number to fraction. The result is stored in an array with the
    * first element being the numerator and the second being the denominator. If
    * the value given is greater than one it will only return the fractional
    * portion.
    *
    * @param   input Value to convert to a fraction
    * @return  The numerator and denominator as an array in the form
    *          [numerator, denominator], where numerator and denominator are both
    *          unsigned integers.
    **/
    public static function toFraction(input:Number):Array {
      if ((input == 0) || (int(input) == input)) {
        return [0,0]
      }
      
      var split_values:Array = input.toString().split(".")
      var integer:int        = int(split_values.shift())
      var mantissa:int       = int(split_values.shift())

      var mantissa_length:Number = mantissa.toString().length
      var base:Number            = Math.pow(10, mantissa_length)
      var gcd:Number             = gcd(mantissa, base)
      
      var numerator:uint    = uint(mantissa / gcd)
      var denominator:uint  = uint(base / gcd)
      
      if (numerator == 33 && denominator == 100) { numerator = 1; denominator = 3 }
      if (numerator == 33 && denominator == 50)  { numerator = 2; denominator = 3 }
      
      return [numerator, denominator]
    }
    
    /**
    * Uses the toFraction method to extract only the denominator from a fraction.
    * 
    * @param  input   Value to extract the denominator from
    * @return         Denominator as an unsigned integer
    * 
    * @see toFraction
    * @see numerator
    **/
    public static function denominator(input:Number):uint {
      return uint(toFraction(input)[1])        
    }
    
    /**
    * Uses the toFraction method to extract only the numerator from a fraction. In
    * the case of an improper fraction the numerator will only be what remains
    * after making the fraction proper. I.E., 0.5 and 1.5 will both yield a
    * numerator of 1 (and a denominator of 2).
    * 
    * @param  input Value to extract the numerator from 
    * @return Numerator as an unsigned integer
    * 
    * @see toFraction
    **/
    public static function numerator(input:Number):uint {
      return uint(toFraction(input)[0])
    }
  }  
}