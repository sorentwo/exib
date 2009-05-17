/**
* Description
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  public interface INode {
    function set id(node_id:String):void
    function get id():String
    function set groups(groups:Array):void
    function get groups():Array
    function position(coordinates:String):void
    function update():void
  }
}
