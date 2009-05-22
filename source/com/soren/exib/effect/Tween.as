/**
* Lightweight version of a tween engine. Makes use of Robert Penners easing
* algorithms.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.effect {
  
  import com.soren.exib.view.Node
  
  public class Tween extends EventDispatcher {
    
    public static const CHANGE:String = 'change'
    public static const FINISH:String = 'finish'
    public static const START:String  = 'start'
    public static const STOP:String   = 'stop'
    
    private var _begin:Number    = 0
    private var _duration:Number = 0.001
    private var _easing:Function = Linear.easeNone
    private var _finish:Number   = 1
    private var _position:Number = NaN
    private var _property:String = 'x'
    private var _target:Node     = null
    private var _time:Number     = NaN
    
    /**
    * Creates and instance of the tween class.
    **/
    public function Tween(target:Node, duration:Number, options:Object = null) {
      set_properties(options)
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
    * The duration of the tweened animation in frames or seconds.
    **/
    public function get duration():Number {
      return _duration
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
    * The current value of the target object property being tweened.
    **/
    public function get position():Number {
      return _position
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
      return _time
    }
    
    // ---
    
    /**
    * 
    **/
    public function start():void {
      
    }
    
    /**
    * 
    **/
    public function stop():void {
      
    }
    
    // ---
    
    public function setProperties(options:Object):void {
      _begin:Number    = 0
      _duration:Number = 1
      _easing:Function = Linear.easeNone
      _finish:Number   = 1
      _position:Number = NaN
      _property:String = 'x'
      _target:Node     = null
      _time:Number     = NaN
    }
  }
}
