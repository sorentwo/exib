/**
* KeyUtil
*
* Simple static class for retrieiving key codes.
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.util {

  public class KeyUtil {

    public function KeyUtil() {
      throw new Error("KeyUtil class is a static container only")
    }
    
    /**
    * Returns the numerical key code of the supplied letter. Only works
    * with a-z, lower case.
    * 
    * @param  character   A single lower case letter
    * @return The corresponding key code value
    **/
    public static function getKeyCode(character:String):uint {
      var code_hash:Object = {a: 65, b: 66, c: 67, d: 68, e: 69, f: 70,
                              g: 71, h: 72, i: 73, j: 74, k: 75, l: 76,
                              m: 77, n: 78, o: 79, p: 80, q: 81, r: 82,
                              s: 83, t: 84, u: 85, v: 86, w: 87, x: 88,
                              y: 89, z: 90 }
      
      try {
        var key_code:uint = code_hash[character]
      } catch (e:Error) {
        throw new Error("No key code found for the character: " + character +
                        ". Use a character a-z")
      }
      
      return key_code
    }
  }
}
