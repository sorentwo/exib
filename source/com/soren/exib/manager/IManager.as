/**
* IManager
*
* Interface for a basic manager
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information
**/

package com.soren.exib.manager {

  public interface IManager {
    function add(object:*, object_id:String):void
    function get(object_id:String):*
    function has(object_id:String):Boolean
    function reset():void
  }
}
