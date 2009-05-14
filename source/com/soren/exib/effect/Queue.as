/**
* Queue
*
* A queueing class for creating more complex and sequenced effect chains.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.effect {

  import flash.utils.Timer
  import flash.utils.Dictionary
  import flash.events.Event
  import flash.events.TimerEvent
  import com.soren.exib.core.Generator
  import com.soren.exib.core.Space
  import com.soren.exib.helper.ActionSet
  import com.soren.exib.core.IActionable
  import com.soren.exib.view.ScreenController
  
  public class Queue implements IActionable {

    private var _space:Space = Space.getSpace()
    private var _screen_controller:ScreenController
    
    private var _before:Array  = []
    private var _after:Array   = []
    private var _waiting:Array = []
    
    private var _effects:Dictionary = new Dictionary()
    private var _timers:Dictionary  = new Dictionary()
    
    private var _callback:ActionSet
    private var _processing_before:Boolean
    private var _after_wait:uint = 0
    
    /**
    * Queue objects do not take an parameters for construction. To add effects to
    * the queue see the enqueue() action.
    * 
    * @see Queue.enqueue()
    **/
    public function Queue() {}
      
    /**
    * Pushes a new effect into the queue.
    * 
    * @param  effect  A string representing an effect name. See the Effect class
    *                 for valid effects.
    * @param  targets An array of Nodes, node groups, or node id's. If groups or
    *                 id's are provided the Effect will attempt to resolve them
    *                 from the ScreenController.
    * @param  options A key/value hash of effect parameters.
    * @param  before  Use <code>true</code> to add to the before queue, 
    *                 <code>false</code> to add to the after queue.
    * @param  wait    An optional period to wait, in seconds. Accepts float values.
    **/
    public function enqueue(effect:String, targets:Array, options:Object,
                            before:Boolean = true, wait:Number = NaN):void {
      
      var effect_hash:Object = { effect: effect, targets: targets, options: options }

      if (Boolean(wait)) effect_hash['wait'] = wait * 1000

      if (before) { _before.push(effect_hash) }
      else        { _after.push(effect_hash)  }
    }

    /**
    * Remove the current callback action.
    **/
    public function clearCallback():void {
      _callback = null
    }
    
    /**
    * Set a new callback action. Callbacks are triggered between the before and
    * after queues.
    * 
    * @param  callback  An action set to trigger.
    **/
    public function setCallback(callback:ActionSet):void {
      _callback = callback
    }
    
    /**
    * Starts processing the queue. If an action string is provided it will be
    * parsed into an action set and triggered between the before queue and the
    * after queue.
    **/
    public function start(action_string:String = ''):void {
      if (_waiting.length > 0) return // We don't want to interrupt a queue already going
      
      if (_space && !_screen_controller) _screen_controller = _space.get('_screen')
      
      clearCallback()

      if (_space && Boolean(action_string)) {
        var psuedo_xml:XML = <psuedo><action>{action_string}</action></psuedo>
        setCallback(new Generator().genActionSet(psuedo_xml.action))
      }

      _after_wait = (_before.length > 0) ? _before[_before.length - 1].options.duration * 1000 || 0 : 0
      
           if (_before.length > 0) { process(_before, true)             }
      else if (_before.length < 1) { triggerCallback(); process(_after) }
    }
    
    // ---
    
    /**
    * Creats and plays queued effects.
    **/
    private function playEffect(eo:Object):void {
      var effect:Effect
      effect = (_screen_controller) ? new Effect(_screen_controller) : new Effect()
      effect.addEventListener(Effect.EFFECT_COMPLETE, effectCompleteListener)
      effect[eo['effect']](eo['targets'], eo['options'])
      
      _effects[effect] = effect // Stored for strong reference
    }
    
    
    /**
    * @private
    **/
    private function process(queue:Array, processing_before:Boolean = false):void {
      _processing_before = processing_before
      
      for (var i:int = 0; i < queue.length; i++) {
        var eo:Object = queue[i]
        
        if (!eo.hasOwnProperty('wait')) eo.wait = 0
        
        var wait_timer:Timer
        wait_timer = new Timer(eo['wait'], 1)
        wait_timer.addEventListener(TimerEvent.TIMER_COMPLETE, waitCompleteListener)
        wait_timer.start()
         
         _timers[wait_timer] = wait_timer // Stored for strong reference
        
        _waiting.push(eo)
      }
    }
    
    /**
    * Calls the callback action if it was provided.
    **/
    private function triggerCallback():void {
      if (_callback) _callback.act()
    }
    
    /**
    * Signals the end of the before queue and starts the after queue. 
    **/
    private function beforeCompleteListener(event:TimerEvent):void {
      triggerCallback()
      process(_after)
      
      delete _timers[event.target]
    }
    
    /**
    * Trigger by an effect timer finishing. Plays the next effect in the queue.
    **/
    private function waitCompleteListener(event:TimerEvent):void {
      playEffect(_waiting.shift())
      
      if (_processing_before && _waiting.length < 1) {
             
        var after_timer:Timer = new Timer(_after_wait, 1)
        after_timer.addEventListener(TimerEvent.TIMER_COMPLETE, beforeCompleteListener)
        after_timer.start()
        
        _timers[after_timer] = after_timer
        
        _processing_before = false
      }
      
      delete _timers[event.target]
    }
    
    /**
    * Remove the dictionary's strong reference.
    **/
    private function effectCompleteListener(event:Event):void {
      delete _effects[event.target]
    }
  }
}
