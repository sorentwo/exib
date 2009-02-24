/**
* ExtendedArray
* 
*	An extension to the standard Array class that provides expanded functionality,
* including, but not limited to, methods implemented in ruby.
*
* Copyright (c) 2008 Parker Selbert
* 
* See LICENSE.txt for full license information.
**/

package com.soren.util {

  public dynamic class ExtendedArray extends Array {

    public static const MAX_LOOP_DEPTH_EXCEEDED:String = 'Loop broken, maximum depth exceeded'
    public static const MAX_LOOP_DEPTH:uint = 10

    public function ExtendedArray(...args) {
      super()
      
      for each (var arg:* in args) {
        this.push(arg)
      }
    }

    /**
    * Flattens a multi-dimensional array up to the <tt>MAX_DEPTH</tt>,
    * returning a single level array with all elements in a preserved order.
    **/
    public function flatten():Array {
      var array:Array = this
      
      for (var i:int = 0; i < array.length; i++) {
        if (array[i] is Array) {
          var sub:Array = array[i]
          array.splice(i, 1)

          for (var k:int = 0; k < sub.length; k++) {
            array.splice(i + k, 0, sub[k])
          }

          i = 0
        }
      }

      return array
    }

    /**
    * Determines whether this instance contains any arrays. Useful for
    * establishing that an array has multiple dimensions.
    **/
    public function containsArray():Boolean {
      for each (var element:* in this) {
        if (element is Array) return true
      }

      return false
    }
	}
}
