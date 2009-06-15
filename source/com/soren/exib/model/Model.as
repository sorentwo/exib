/**
* Model
*
* <strong>CLASS MUST BE EXTENDED</strong>
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.model {

  import flash.events.Event
  import flash.events.EventDispatcher
  import com.soren.exib.core.IActionable
  import com.soren.exib.core.IEvaluatable
  
  public class Model extends EventDispatcher implements IModel, IActionable, IEvaluatable {
    
    public static var CHANGED:String = 'CHANGED'
    
    public function Model() {
      throw new Error('Abstract class only. Class must be extended.')
    }
    
    protected function dispatch():void {
      dispatchEvent(new Event(Model.CHANGED))
    }
    
    // --- These must be overridden by sub classes
    
    public function get value():* {}
    public function set value(value:*):void {}
    public function reset():void {}
    public override function toString():String { return this.value }
  }
}
