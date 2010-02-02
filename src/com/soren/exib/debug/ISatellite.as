/**
* ISatellite
*
* Interface for logger satellites.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.debug {

  public interface ISatellite {
    function clear():void
    function write(output:String):void
  }
}
