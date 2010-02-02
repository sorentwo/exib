/**
* IModel
* 
* Interface for models
* 
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.model {

  public interface IModel {
    function get value():*
    function set value(value:*):void
    function reset():void
  }
}
