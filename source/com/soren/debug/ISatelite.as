/**
* ISatelite
*
* Interface for logger satelites.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information
**/

package com.soren.debug {

  public interface ISatelite {
    function clear():void
    function write(output:String):void
  }
}
