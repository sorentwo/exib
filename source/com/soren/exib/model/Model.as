/**
* Model
*
* <strong>CLASS MUST BE EXTENDED</strong>
*
* Copyright (c) 2008 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.model {

  import flash.events.*
  import com.soren.exib.helper.IActionable
  
  public class Model extends EventDispatcher implements IModel, IActionable {
    
    public static var CHANGED:String = 'CHANGED'
    
    public function Model() {}
    
    protected function dispatch():void {
      dispatchEvent(new Event(Model.CHANGED))
    }
    
    // --- These must be overridden by sub classes
    
    public function get value():* {}
    public function set value(value:*):void {}
    public function reset():void {}
    public override function toString():String { return '' }
  }
}
