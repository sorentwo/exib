/**
* TweenEvent
**/

package com.soren.exib.events {
  
  import flash.events.Event
  
  public class TweenEvent extends Event {
    
    public static const CHANGE:String = 'change'
    public static const FINISH:String = 'finish'
    public static const START:String  = 'start'
    public static const STOP:String   = 'stop'
    
    private var _target:Object
    
    public function TweenEvent(type:String, target:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
      super(type, bubbles, cancelable)
    }
    
    override public function get target():Object {
      return _target
    }
  }
}
