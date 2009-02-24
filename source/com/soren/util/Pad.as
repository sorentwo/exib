/**
* Pad
*
* A variety of padding utilities for modifying integers, floats, and strings.
*
* Copyright (c) 2008 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.util {

  public class Pad {

    public function Pad() {
      throw new Error('Pad class is a static container only')
    }
    
    /**
    * Ensures that there is a decimal and trailing zero for whole numbers.
    * Somewhat oddly this tool can only be used on numbers, but it fits best
    * logically within the StringUtil package.
    *
    * @param  input       The number to decimal pad
    * @param  pad_length  The number of trailing digits, after the decimal point
    *                     that will be padded to. By default this will be 2 spaces.
    *
    * @return A string representing the input value with a trailing decimal
    *         to the number of places specified in padding, i.e decPad(1, 2)
    *         -> 1.00
    **/
    public static function decPad(input:*, pad_length:uint = 2):String {
      var string_input:String = input.toString() + "."
      var dotIndex:int        = string_input.indexOf('.')

      while ((string_input.length - dotIndex) < pad_length + 1) {
        string_input = string_input.concat("0")
      }

      return string_input
    }
    
    /**
    * Pad a string with an arbitrary number of characters
    * @param    input       String to pad
    * @param    pad_length  Number of places to pad to
    * @param    pad_char    Character to pad with
    *
    * @return   Padded string
    **/
    public static function pad(input:*,
                               pad_length:uint = 2,
                               pad_char:String = " "):String {
      
      var string_input:String = input.toString()

      while (string_input.length < pad_length) {
        string_input = pad_char.concat(string_input)
      }

      return string_input
    }
    
    /**
    * Pad a float to the number of digits specified
    * @param    raw       The input number to pad
    * @param    decimals  Places to pad to, default is 2
    *
    * @return   Padded string
    */
    public static function padFloat(input:Number, decimals:int = 2):String {
      var power:int     = Math.pow(10, decimals)
      var numStr:String = (Math.round(input * power) / power).toString()

      if (numStr.indexOf(".") == -1) numStr += ".0"

      var buffer:Array = []
      var dotIndex:int = decimals - numStr.substr(numStr.indexOf(".") + 1).length
      
      for (var i:int = 0; i < dotIndex; i++) { buffer.push("0") }

      buffer.unshift(numStr)
      return buffer.join('')
    }

    /**
    * Pad a string with an arbitrary number of 0's. This is really an alias of
    * pad with '0' as the only character choice.
    *
    * @param    input       String or Number to pad
    * @param    pad_length  Number of places to pad to
    *
    * @return   Padding string
    **/
    public static function zeroPad(input:*, pad_length:uint = 2):String {
      return pad(input, pad_length, '0')
    }
  }
}
