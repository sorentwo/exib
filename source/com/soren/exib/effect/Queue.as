/**
* Queue
*
* A queueing class for creating more complex and sequenced effect chains.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.effect {

  import flash.utils.Timer
  import flash.events.TimerEvent
  import com.soren.exib.generator.Generator
  import com.soren.exib.helper.ActionSet
  import com.soren.exib.helper.IActionable
  import com.soren.exib.manager.Supervisor
  import com.soren.exib.view.ScreenController
  
  public class Queue implements IActionable {

    private var _supervisor:Supervisor
    private var _screen_controller:ScreenController
    
    private var _before:Array  = []
    private var _after:Array   = []
    private var _waiting:Array = []
    
    private var _callback:ActionSet
    private var _processing_before:Boolean
    private var _after_wait:uint = 0
    
    /**
    * Constructor
    **/
    public function Queue(supervisor:Supervisor = null) {
      _supervisor = supervisor
    }
      
    /**
    **/
    public function clearCallback():void {
      _callback = null
    }

    /**
    **/
    public function enqueue(effect:String, targets:Array, options:Object,
                            before:Boolean = true, wait:Number = NaN):void {
      
      var effect_hash:Object = { effect: effect, targets: targets, options: options }

      if (Boolean(wait)) effect_hash['wait'] = wait * 1000

      if (before) { _before.push(effect_hash) }
      else        { _after.push(effect_hash)  }
    }

    /**
    **/
    public function setCallback(callback:ActionSet):void {
      _callback = callback
    }
    
    /**
    **/
    public function start(action_string:String = ''):void {
      if (_waiting.length > 0) return // We don't want to interrupt a queue already going
      
      if (_supervisor && !_screen_controller) _screen_controller = _supervisor.get('actionable', 'screen')
      
      clearCallback()
      
      if (_supervisor && Boolean(action_string)) {
        var psuedo_xml:XML = <psuedo><action>{action_string}</action></psuedo>
        setCallback(new Generator(_supervisor).genActionSet(psuedo_xml.action))
      }
      
      _after_wait = _before[_before.length - 1].options.duration * 1000 || 0

      if      (_before.length > 0)              { process(_before, true) }
      else if (_before.length < 1 && _callback) { triggerCallback()      }
      else                                      { process(_after)        }
    }
    
    // ---
    
    /**
    * @private
    **/
    private function playEffect(eo:Object):void {
      var effect:Effect = (_screen_controller) ? new Effect(_screen_controller) : new Effect()
      effect[eo['effect']](eo['targets'], eo['options'])
    }
    
    
    /**
    * @private
    **/
    private function process(queue:Array, processing_before:Boolean = false):void {
      _processing_before = processing_before
      
      for (var i:int = 0; i < queue.length; i++) {
        var eo:Object = queue[i]
        
        if (!eo.hasOwnProperty('wait')) eo.wait = 0
        
        var wait_timer:Timer = new Timer(eo['wait'], 1)
        wait_timer.addEventListener(TimerEvent.TIMER_COMPLETE, waitCompleteListener)
        wait_timer.start()
        
        _waiting.push(eo)
      }
    }
    
    /**
    * @private
    **/
    private function triggerCallback():void {
      _callback.act()
    }
    
    /**
    * @private
    **/
    private function beforeCompleteListener(event:TimerEvent):void {
      if (_callback) triggerCallback()
      process(_after)
    }
    
    /**
    * @private
    **/
    private function waitCompleteListener(event:TimerEvent):void {
      playEffect(_waiting.shift())
      
      if (_processing_before && _waiting.length < 1) {
             
        var after_timer:Timer = new Timer(_after_wait, 1)
        after_timer.addEventListener(TimerEvent.TIMER_COMPLETE, beforeCompleteListener)
        after_timer.start()
        
        _processing_before = false
      } else {
        
      }
    }
  }
}
