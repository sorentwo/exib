/**
* Lightweight version of a tween engine. Makes use of Robert Penners easing
* algorithms.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.effect {
  
  import flash.display.Stage
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.utils.Dictionary
  import com.soren.exib.events.TweenEvent
  import com.soren.exib.view.Node
  
  public class Tween extends EventDispatcher {
    
    private static var _tween:Tween      = new Tween()
    private static var _list:Array       = new Array()
    private static var _cache:Dictionary = new Dictionary()
    
    private static var _stage:Stage
    private static var _fps:Number
    
    /**
    * Tween is a singleton, for performance reasons, and cannot be constructed.
    **/
    public function Tween() {
      if (_tween) throw new Error('Can only be accessed through Tween.getTween()')
    }
    
    /**
    * Returns the singleton instance.
    **/
    public static function getTween():Tween {
      return _tween
    }
    
    /**
    * Register the stage. This is required for accurate frame rate and enter frame
    * events. Without registering the stage the Tween class will not work.
    **/
    public function registerStage(stage:Stage):void {
      _stage = stage
      _fps   = _stage.frameRate
      
      _stage.addEventListener(Event.ENTER_FRAME, update)
    }
    
    /**
    * Add a new tween (animation or effect) to be tracked.
    * 
    * @param  target    The node that will be affected
    * @param  property  Which property will be affected on the node, i.e. 'x'
    * @param  easing    One of the easing functions from the easing package
    * @param  begin     The value at which tweening will start
    * @param  finish    The value at which tweening will finish
    * @param  duration  The length of time, in seconds, that the animation will take
    **/
    public function add(target:Node, property:String, easing:Function,
                        begin:Number, finish:Number, duration:Number,
                        yoyo_count:uint = 0):void {
      
      var total_frames:uint = uint(duration * _fps)
      var frame:uint        = 0
      
      // Ensure that there is only one tween active at a time per-target-property
      var existing_tween:TweenObject = findTweenByTargetAndProperty(target, property)
      if (existing_tween) remove(existing_tween)
      
      var new_tween:TweenObject = new TweenObject(target, property, easing, begin, finish, total_frames, frame, yoyo_count)
      
      // Double referenced. Needed for looping + anti-garbage-collection
      _list.push(new_tween)
      _cache[new_tween] = new_tween
    }
    
    /**
    * Fast-forward the tween to its final value.
    * 
    * @param  target    The node that will be effected
    * @param  property  The property that will be effected
    **/
    public function ff(target:Node, property:String):void {
      jump(target, property, true)
    }
    
    /**
    * Rewind the tween to its initial value.
    * 
    * @param  target    The node that will be effected
    * @param  property  The property that will be effected
    **/
    public function rw(target:Node, property:String):void {
      jump(target, property, false)
    }
    
    /**
    * Pause all tweens or only tweens relating to one target object.
    * 
    * @param  target  If given only the tweens effecting that target will be paused
    **/
    public function pause(target:Node = null):void {
      togglePause(target, true)
    }
    
    /**
    * Unpause all tweens or only tweens relating to one target object.
    * 
    * @param  target  If given only the tweens effecting that target will be unpaused
    **/
    public function unpause(target:Node = null):void {
      togglePause(target, false)
    }
    
    /**
    * Stop all tweens, all tweens for one target, or one particular tween. This
    * removes the tween permanently, unlike pausing.
    * 
    * @param  target    If given only the tween, or tweens, effecting that target
    *                   will be stopped.
    * @param  property  If given only the tween matching the target and property
    *                   will be stopped.
    **/
    public function stop(target:Node = null, property:String = null):void {
      var to_stop:Array = []
      
      if      (!target && property) { throw new Error('Target must be provided if property is given') }
      else if (target && property)  { to_stop.push(findTweenByTargetAndProperty(target, property))    }
      else if (target && !property) { to_stop = findTweensByTarget(target)                            }
      else                          { to_stop = _list }
      
      for each (var tween_object:TweenObject in to_stop) {
        remove(tween_object)
      }
    }
    
    // -------------------------------------------------------------------------
    
    /**
    * Checks the list and triggers rendering or removes completed tweens.
    **/
    private function update(event:Event):void {
      if (_list.length < 1) return
      
      for each (var tween_object:TweenObject in _list) {
        if (tween_object.paused == false) render(tween_object)

        if ((tween_object.yoyoing == false && tween_object.frame == tween_object.total_frames) ||
            (tween_object.yoyoing == true  && tween_object.frame == 0)) {
          if (tween_object.yoyo_count > 0) { yoyo(tween_object)     }
          else                             { complete(tween_object) }
        }
      }
    }
    
    /**
    * Updates the target node
    **/
    private function render(tween_object:TweenObject):void {
      tween_object.frame = (tween_object.yoyoing) ? tween_object.frame - 1 : tween_object.frame + 1

      var time:uint     = tween_object.frame
      var begin:Number  = tween_object.begin
      var finish:Number = tween_object.finish
      var total:uint    = tween_object.total_frames
      var ease:Number   = tween_object.easing.call(null, time, begin, finish, total)
      
      tween_object.target[tween_object.property] = ease
    }
    
    /**
    * Dual purpose, fast-forward or rewind.
    **/
    private function jump(target:Node, property:String, forward:Boolean):void {
      var tween_object:TweenObject = findTweenByTargetAndProperty(target, property)
      
      tween_object.target[tween_object.property] = (forward) ? tween_object.finish : tween_object.begin
      tween_object.frame = tween_object.total_frames
      
      complete(tween_object)
    }

    /**
    * Instructs the tweened animation to play in reverse from its last direction
    * of tweened property increments.
    **/
    private function yoyo(tween_object:TweenObject):void {
      tween_object.yoyoing     = (tween_object.yoyoing) ? false : true
      tween_object.yoyo_count -= 1
    }
    
    /**
    * Dual purpose, pause or unpause.
    **/
    private function togglePause(target:Node = null, toggle:Boolean = true):void {
      var to_pause:Array = (target) ? findTweensByTarget(target) : _list
      for each (var tween_object:TweenObject in to_pause) { tween_object.paused = toggle }
    }
    
    /**
    * Dispatch the complete event and remove the object from tracking
    **/
    private function complete(tween_object:TweenObject):void {
      remove(tween_object)
      
      dispatchEvent(new TweenEvent(TweenEvent.FINISH, tween_object.target))
    }
    
    /**
    * Remove an object from the list and the cache
    **/
    private function remove(tween_object:TweenObject):void {
      _list.splice(_list.indexOf(tween_object), 1)
      delete _cache[tween_object]
    }
    
    /**
    * Given the target object find all tween objects for a node.
    **/
    private function findTweensByTarget(target:Node):Array {
      var found_tweens:Array = []
      
      for each (var tween_object:TweenObject in _list) {
        if (tween_object.target == target) found_tweens.push(tween_object)
      }
      
      return found_tweens
    }
    
    /**
    * Given the target and the property find a particular tween object.
    **/
    private function findTweenByTargetAndProperty(target:Node, property:String):TweenObject {
      var found_tween:TweenObject
      
      for each (var tween_object:TweenObject in _list) {
        if (tween_object.target == target && tween_object.property == property) found_tween = tween_object
      }
      
      return found_tween
    }
  }
}
