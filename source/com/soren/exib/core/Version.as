/**
* ExibVersion
*
* This class is merely to indicate the current version of the framework. A simple
* major / minor version scheme has been implemented.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.core {

  public class Version {
    
    public static const MAJOR_VERSION:uint = 0
    public static const MINOR_VERSION:uint = 7
    
    public function Version() {}
    
    /**
    * Returns the current version as a single string.
    **/
    public static function version():String {
      return MAJOR_VERSION + '.' + MINOR_VERSION
    }
  }
}
