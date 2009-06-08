/**
* Lightweight version of a tween engine. Makes use of Robert Penners easing
* algorithms.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.effect {
  
  import flash.events.EventDispatcher
  import flash.events.TimerEvent
  import flash.utils.Timer
  import com.soren.exib.effect.easing.*
  import com.soren.exib.events.TweenEvent
  import com.soren.exib.view.Node
  
  public class Tween extends EventDispatcher {
    
    private var _begin:Number    = 0
    private var _duration:Number = 1
    private var _easing:Function = Linear.easeInOut
    private var _finish:Number   = 1
    private var _property:String = 'x'
    private var _target:Node     = null
    
    private var _timer:Timer
    
    /**
    * Creates and instance of the tween class.
    **/
    public function Tween(target:Node, property:String, easing:Function,
                          begin:Number, finish:Number, duration:Number) {
      
      if (duration < 0.001) throw new Error('Duration too short: ' + duration)
      
      _begin    = begin
      _easing   = easing
      _finish   = finish
      _property = property
      _target   = target
      
      var fps:Number        = _target.stage.frameRate
      var frame_rate:uint   = uint(1000 / fps)
      var total_frames:uint = uint(duration * fps)
      
      _timer = new Timer(frame_rate, total_frames)
    }
    
    // ---
    
    /**
    * The initial value of the target object's designated property before the
    * tween starts.
    **/
    public function get begin():Number {
      return _begin
    }
    
    /**
    * The easing function which is used with the tween.
    **/
    public function get easing():Function {
      return _easing
    }
    
    /**
    * A number indicating the ending value of the target object property that is
    * to be tweened.
    **/
    public function get finish():Object {
      return _finish
    }
    
    /**
    * The name of the property affected by the tween of the target object.
    **/
    public function get property():String {
      return _property
    }
    
    /**
    * The current time within the duration of the animation.
    **/
    public function get time():Number {
      return _timer.currentCount
    }
    
    // ---
    
    /**
    * Fast-forward the tween to its final value.
    **/
    public function ff():void {
      jump(true)
    }
    
    /**
    * Rewind the tween to its initial value.
    **/
    public function rw():void {
      jump(false)
    }
    
    /**
    * Begin the tween.
    **/
    public function start():void {
      _timer.start()
      _timer.addEventListener(TimerEvent.TIMER, render)
      _timer.addEventListener(TimerEvent.TIMER_COMPLETE, complete)
      
      dispatchEvent(new TweenEvent(TweenEvent.START))
    }
    
    /**
    * Stop the tween.
    **/
    public function stop():void {
      _timer.stop()
      
      dispatchEvent(new TweenEvent(TweenEvent.STOP))
    }
    
    /**
    * Instructs the tweened animation to play in reverse from its last direction
    * of tweened property increments.
    **/
    public function yoyo():void {
      var orig_begin:Number  = _begin
      var orig_finish:Number = _finish
      
      _begin  = orig_finish
      _finish = orig_begin
      
      _timer.reset()
      _timer.start()
    }
    
    // ---
    
    /**
    * Clean up event listeners after tween is finished.
    **/
    private function complete(event:TimerEvent):void {
      _timer.removeEventListener(TimerEvent.TIMER, render)
      _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, complete)
      
      dispatchEvent(new TweenEvent(TweenEvent.FINISH))
    }
    
    private function jump(forward:Boolean):void {      
      _target[_property] = (forward) ? _finish : _begin
      _timer.stop()
      
      dispatchEvent(new TweenEvent(TweenEvent.CHANGE))
      complete(new TimerEvent(TimerEvent.TIMER_COMPLETE))
    }
    
    /**
    * Takes the current time and updates the target node.
    **/
    private function render(event:TimerEvent):void {
      var time:uint  = _timer.currentCount
      var total:uint = _timer.repeatCount
      
      _target[_property] = _easing.call(null, time, _begin, _finish, total)
      
      dispatchEvent(new TweenEvent(TweenEvent.CHANGE))
    }
  }
}
