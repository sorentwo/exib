/**
* A queueing class for creating more complex and sequenced effect chains.
*
* @copyright Copyright (c) 2009 Soren LLC
* @author    Parker Selbert — parker@sorentwo.com
**/

package com.soren.sfx {

  import flash.events.Event
  import flash.events.TimerEvent
  import flash.utils.Dictionary
  import flash.utils.Timer
  
  public class Queue {
    
    private var _enqueued:Array       = []
    private var _waiting:Array        = []
    private var _timers:Dictionary    = new Dictionary()
    private var _callbacks:Dictionary = new Dictionary()
    
    /**
    * Queue objects do not take an parameters for construction. To add effects to
    * the queue see the enqueue() action.
    * 
    * @see Queue.enqueue()
    **/
    public function Queue() {}
    
    /**
    * Retrieve the total number of items in the queue
    **/
    public function get length():int {
      return _enqueued.length
    }
    
    /**
    * Add an effect, plus sundries, to the queue.
    * @param  effect    A string representing an effect name.
    * @param  targets   An array of objects.
    * @param  options   A key/value hash of effect parameters.
    * @param  delay      An optional period to delay, in seconds.
    * @param  callback  An object with two properties, <code>object</code>, which
    *                   is the object to apply the callback method to, and
    *                   <code>function</code> which is the function to call.
    * 
    * @see com.soren.sfx.Effect
    **/
    public function enqueue(effect:String, targets:Array, options:Object,
                            delay:Number = NaN, callback:Object = null):void {
      
      var duration:Number = options.duration || NaN
      delay    = (Boolean(delay))    ? delay * 1000 : 0
      duration = (Boolean(duration)) ? duration * 1000 : 0
      
      var item:Object = { effect: effect,
                          targets: targets,
                          options: options,
                          delay: delay,
                          callback: callback,
                          duration: duration
                        }
      
      _enqueued.push(item)
    }
    
    /**
    * Start processing the queue.
    **/
    public function start():void {
      if (_waiting.length > 0) return
      
      for each (var eo:Object in _enqueued) {
        var delay_timer:Timer = new Timer(eo.delay, 1)
        delay_timer.addEventListener(TimerEvent.TIMER_COMPLETE, delayCompleteListener)
        delay_timer.start()
        
        _timers[delay_timer] = delay_timer

        if (eo.callback) {
          var callback_timer:Timer = new Timer(eo.delay + eo.duration, 1)
          callback_timer.addEventListener(TimerEvent.TIMER_COMPLETE, callbackCompleteListener)
          callback_timer.start()
          
          _callbacks[callback_timer] = { timer: callback_timer, callback: eo.callback } 
        }

        _waiting.push(eo)
      }
    }
    
    // PRIVATE -----------------------------------------------------------------
    
    private function startEffect(eo:Object):void {
      var effect:Effect = new Effect()
      effect[eo['effect']](eo['targets'], eo['options'])
    }
    
    private function delayCompleteListener(e:TimerEvent):void {
      startEffect(_waiting.shift())
      delete _timers[e.target]
    }
    
    private function callbackCompleteListener(e:TimerEvent):void {
      var object:Object = _callbacks[e.target]
      
      object.callback()
      delete _callbacks[e.target]
    }
  }
}
