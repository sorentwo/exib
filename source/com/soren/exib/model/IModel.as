/**
* IModel
* 
* Interface for models
* 
* Copyright (c) 2008 Parker Selbert
* 
* See LICENSE.txt for full license information.
**/

package com.soren.exib.model {

  public interface IModel {
    function get value():*
    function set value(value:*):void
    function reset():void
  }
}
