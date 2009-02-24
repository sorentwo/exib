/**
* Description
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information
**/

package com.soren.exib.view {

  public interface INode {
    function set id(node_id:String):void
    function get id():String
    function set group(kind_id:String):void
    function get group():String
    function position(coordinates:String):void
    function update():void
  }
}
