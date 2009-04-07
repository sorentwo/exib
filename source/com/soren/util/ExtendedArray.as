/**
* ExtendedArray
* 
*	An extension to the standard Array class that provides expanded functionality,
* largely methods implemented in ruby.
*
* Copyright (c) 2008 Parker Selbert
* 
* See LICENSE.txt for full license information.
**/

package com.soren.util {
  
  import com.soren.debug.Log
  
  public dynamic class ExtendedArray extends Array {

    public function ExtendedArray(...args) {
      for each (var arg:* in args) { this.push(arg) }
    }

    /**
    * Determines whether this instance contains any arrays. Useful for
    * establishing that an array has multiple dimensions.
    **/
    public function containsArray():Boolean {
      for each (var element:* in this) { if (element is Array) return true }
      return false
    }
    
    /**
    * Flattens a multi-dimensional array, returning a single level array with
    * all elements in a preserved order.
    **/
    public function flatten(limit:uint = 100):ExtendedArray {
      var array:ExtendedArray = this
      var i:int  = 0
      var b:uint = 0

      while (i < array.length) {
        while (array[i] is Array) {
          var spliced:Array = array[i]
          array.splice(i, 1)
          
          for (var k:int = 0; k < spliced.length; k++) {
            array.splice(i + k, 0, spliced[k])
          }
          
          if (b < limit) { b += 1  } else { break }
        }

        i += 1
      }

      return array
    }
    
    /**
    * Returns a boolean indication of whether the array is empty, meaning zero
    * length.
    **/
    public function isEmpty():Boolean {
      return (this.length > 0) ? false : true
    }
	}
}
