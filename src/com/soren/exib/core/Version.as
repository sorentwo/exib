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
    
    public static const MAJOR:uint    = 0
    public static const MINOR:uint    = 8
    public static const REVISION:uint = 1
    
    /**
    * Returns the current version as a single string.
    **/
    public static function version():String {
      return [MAJOR, MINOR, REVISION].join('.')
    }
  }
}
