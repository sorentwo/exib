/**
* Container class with pre-defined properties. Entirely for performance.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.effect {
  
  import com.soren.exib.view.Node

  public class TweenObject {
    
    private var _target:Node
    private var _property:String
    private var _easing:Function
    private var _begin:Number
    private var _finish:Number
    private var _total_frames:uint
    
    private var _frame:uint
    private var _yoyo_count:uint
    private var _paused:Boolean  = false
    private var _yoyoing:Boolean = false
    
    public function TweenObject(target:Node, property:String, easing:Function,
                                begin:Number, finish:Number, total_frames:uint,
                                frame:uint, yoyo_count:uint) {
      _target       = target
      _property     = property
      _easing       = easing
      _begin        = begin
      _finish       = finish
      _total_frames = total_frames
      
      _frame        = frame
      _yoyo_count   = yoyo_count
    }
    
    // Read Only
    public function get target():Node {
      return _target
    }
    
    public function get property():String {
      return _property
    }
    
    public function get easing():Function {
      return _easing
    }
    
    public function get begin():Number {
      return _begin
    }
    
    public function get finish():Number {
      return _finish
    }
    
    public function get total_frames():uint {
      return _total_frames
    }
    
    // Read / Write
    public function get frame():uint {
      return _frame
    }
    
    public function set frame(new_frame:uint):void {
      _frame = new_frame
    }
    
    public function get paused():Boolean {
      return _paused
    }
    
    public function set paused(is_paused:Boolean):void {
      _paused = is_paused
    }
    
    public function get yoyoing():Boolean {
      return _yoyoing
    }
    
    public function set yoyoing(is_yoyoing:Boolean):void {
      _yoyoing = is_yoyoing
    }
    
    public function get yoyo_count():uint {
      return _yoyo_count
    }
    
    public function set yoyo_count(new_count:uint):void {
      _yoyo_count = new_count
    }
  }
}
