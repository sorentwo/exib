/**
* AxibHelper
* 
* Package of static helper methods
* 
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.helper {

	import flash.utils.describeType
  
  public class AxibHelper {

    public function AxibHelper() {
      throw new Error('AxibHelper class is a static container only')
    }
    
    /**
    * Establishes whether an object has a value accessor
    **/
    public static function returnsValue(object:*):Boolean {
      var description:XML = describeType(object)
      
      for each (var accessor:XML in description..accessor) {
        if (accessor.@name == 'value') return true
      }
      
      return false
    }
	}	
}