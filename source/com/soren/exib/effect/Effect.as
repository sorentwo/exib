/**
* Effect
*
* Simple shortcuts for creating tweened animation effects such as blurring, fading,
* and sliding.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.effect {

  import fl.transitions.Tween
  import fl.transitions.TweenEvent
  import fl.transitions.easing.*
  import flash.filters.BlurFilter
  import com.soren.exib.helper.IActionable
  import com.soren.exib.view.ScreenController
  import com.soren.exib.view.Node
  
  public class Effect implements IActionable {
    
    private const DEFAULT_ALPHA:uint       = 1
    private const DEFAULT_DURATION:uint    = 1
    private const DEFAULT_EASING:String    = 'linear_in'
    private const DEFAULT_FADE_FROM:uint   = 1
    private const DEFAULT_FADE_TO:uint     = 0
    private const DEFAULT_PULSE_COUNT:uint = 4
    private const DEFAULT_PULSE_FROM:uint  = 1
    private const DEFAULT_PULSE_TO:uint    = 0
    private const DEFAULT_RELATIVE:Boolean = true
    
    private var _options:Object
    private var _screen_controller:ScreenController
    
    private var _blur_tween:Tween
    private var _fade_tween:Tween
    private var _slide_tween:Tween
    
    private var _blurred:Array      = []
    private var _pulse_tweens:Array = []
    private var _pulse_count:uint   = 0
    
    /**
    * Constructor
    **/
    public function Effect(screen_controller:ScreenController = null) {
      _screen_controller = screen_controller
    }
    
    /**
    **/
    public function blur(targets:Array, options:Object = null):void {
      mergeOptions(options)
      
      if (_screen_controller) targets = resolveTargets(targets)
      
      _blurred = []
      
      for each (var node:Node in targets) {
        if (_options.hasOwnProperty('blur_x_from')) _blur_tween = new Tween(node, 'blur_x', _options['easing'], _options['blur_x_from'], _options['blur_x_to'], _options['duration'], true)
        if (_options.hasOwnProperty('blur_y_from')) _blur_tween = new Tween(node, 'blur_y', _options['easing'], _options['blur_y_from'], _options['blur_y_to'], _options['duration'], true)
        _blurred.push(node)
      }
      
      // Blur is not a normal property, here it is simulated by an a event
      _blur_tween.addEventListener(TweenEvent.MOTION_CHANGE, blurTweenUpdate)
    }
    
    /**
    **/
    public function fade(targets:Array, options:Object = null):void {
      mergeOptions(options)

      if (_screen_controller) targets = resolveTargets(targets)
      
      for each (var node:Node in targets) {
        _fade_tween = new Tween(node, 'alpha', _options['easing'], _options['fade_from'], _options['fade_to'], _options['duration'], true)
      }
    }
    
    /**
    **/
    public function hide(targets:Array, options:Object = null):void {
      if (_screen_controller) targets = resolveTargets(targets)
      
      for each (var node:Node in targets) {
        node.visible = false
      }
    }
    
    /**
    * Not much of an effect. The move() method simply moves the targets a specified
    * distance, there is no animation to it.
    **/
    public function move(targets:Array, options:Object = null):void {
      mergeOptions(options)
      
      if (_screen_controller) targets = resolveTargets(targets)
      
      for each (var node:Node in targets) {
        for each (var prop:String in ['x', 'y']) {
          if (_options.hasOwnProperty(prop)) {
            
            node[prop] = (_options['relative'])
                       ? node[prop] + int(_options[prop])
                       : int(_options[prop])
            
          }
        }
      }
    }
    
    /**
    **/
    public function opacity(targets:Array, options:Object = null):void {
      mergeOptions(options)
      
      if (_screen_controller) targets = resolveTargets(targets)
      
      for each (var node:Node in targets) { node.alpha = _options['alpha'] }
    }
    
    /**
    **/
    public function pulse(targets:Array, options:Object = null):void {
      mergeOptions(options)
      
      if (_screen_controller) targets = resolveTargets(targets)
      
      _pulse_tweens = []
      
      var pulse_tween:Tween
      for each (var node:Node in targets) {
        pulse_tween = new Tween(node, 'alpha', _options['easing'], _options['pulse_from'], _options['pulse_to'], _options['duration'], true)
        _pulse_tweens.push(pulse_tween)
      }
      
      _pulse_tweens[0].addEventListener(TweenEvent.MOTION_FINISH, pulseTweenFinish)
    }
    
    /**
    **/
    public function show(targets:Array, options:Object = null):void {
      if (_screen_controller) targets = resolveTargets(targets)
      
      for each (var node:Node in targets) { node.visible = true }
    }
    
    /**
    **/
    public function slide(targets:Array, options:Object = null):void {
      mergeOptions(options)
      
      if (_screen_controller) targets = resolveTargets(targets)
      
      var start_x:int
      var end_x:int
      var start_y:int
      var end_y:int
      
      for each (var node:Node in targets) {
        if (_options.hasOwnProperty('start_x')) {
          start_x = (_options['relative'])
                  ? node.x + int(_options['start_x'])
                  : _options['start_x']
          end_x   = (_options['relative'])
                  ? node.x + int(_options['end_x'])
                  : _options['end_x']
          _slide_tween = new Tween(node, 'x', _options['easing'], start_x, end_x, _options['duration'], true)
        }
        
        if (_options.hasOwnProperty('start_y')) {
          start_y = (_options['relative'])
                  ? node.y + int(_options['start_y'])
                  : _options['start_y']
          end_y   = (_options['relative'])
                  ? node.y + int(_options['end_y'])
                  : _options['end_y']
          _slide_tween = new Tween(node, 'y', _options['easing'], start_y, end_y, _options['duration'], true)
        }
      }
    }
    
    /**
    **/
    public function kill():void {
      if (_blur_tween  != null)      { _blur_tween.stop();  _blur_tween.rewind()  }
      if (_fade_tween  != null)      { _fade_tween.stop();  _fade_tween.rewind()  }
      if (_slide_tween != null)      { _slide_tween.stop(); _slide_tween.rewind() }
      if (_pulse_tweens.length != 0) { for each (var tween:Tween in _pulse_tweens) { tween.stop(); tween.obj.alpha = tween.finish; }}
    }
    
    /**
    **/
    public function reset():void {
      defineDefaultOptions()
    }
    
    // ---
    
    /**
    * @private
    **/
    private function defineDefaultOptions():void {
      _options = {}
      
      _options['alpha']       = DEFAULT_ALPHA
      _options['duration']    = DEFAULT_DURATION
      _options['easing']      = DEFAULT_EASING
      _options['fade_from']   = DEFAULT_FADE_FROM
      _options['fade_to']     = DEFAULT_FADE_TO
      _options['times']       = DEFAULT_PULSE_COUNT
      _options['pulse_from']  = DEFAULT_PULSE_FROM
      _options['pulse_to']    = DEFAULT_PULSE_TO
      _options['relative']    = DEFAULT_RELATIVE
    }

    /**
    * @private
    **/
    private function blurTweenUpdate(event:TweenEvent):void {
      if (event.type == TweenEvent.MOTION_CHANGE) {
        for each (var node:Node in _blurred) {
          node.filters = [ new BlurFilter(node.blur_x, node.blur_y, 2) ]
        }
      }
    }
    
    /**
    * @private
    **/
    private function mergeOptions(options:Object):void {
      defineDefaultOptions()

      for (var prop:String in options) { _options[prop] = options[prop] }
      
      _options['easing'] = resolveEasing(_options['easing'])
      _options['relative'] = (_options['relative'] == 'true') ? true : false
    }
      
    /**
    * @private
    **/
    private function pulseTweenFinish(event:TweenEvent):void {
      _pulse_count += 1
      
      if (_pulse_count >= _options['times'])            { _pulse_count = 0; _pulse_tweens = [] }
      else { for each(var tween:Tween in _pulse_tweens) { tween.yoyo() } }
    }
    
    /**
    * @private
    **/
    private function resolveEasing(easing_id:String):Function {
      var easing_method:Function
      
      switch (easing_id.toLowerCase()) {
        case 'back_in':
          easing_method = Back.easeIn
          break
        case 'back_in_out':
          easing_method = Back.easeInOut
          break
        case 'back_out':
          easing_method = Back.easeOut
          break
        case 'bounce_in':
          easing_method = Bounce.easeIn
          break
        case 'bounce_in_out':
          easing_method = Bounce.easeInOut
          break
        case 'bounce_out':
          easing_method = Bounce.easeOut
          break
        case 'linear_in':
          easing_method = Regular.easeIn
          break
        case 'linear_in_out':
          easing_method = Regular.easeInOut
          break
        case 'linear_out':
          easing_method = Regular.easeOut
          break
        case 'quint_in':
          easing_method = Strong.easeIn
          break
        case 'quint_in_out':
          easing_method = Strong.easeInOut
          break
        case 'quint_out':
          easing_method = Strong.easeOut
          break
        case 'sine_in':
          easing_method = Strong.easeIn
          break
        case 'sine_in_out':
          easing_method = Strong.easeInOut
          break
        case 'sine_out':
          easing_method = Strong.easeOut
          break
      }
      
      return easing_method
    }
  
    /**
    * @private
    **/
    private function resolveTargets(targets:Array):Array {
      var group_pattern:RegExp = /^\.([a-zA-Z]+)/

      var screen:Node = _screen_controller.current
      var resolved:Array = []

      for each (var target:String in targets) {
        if (group_pattern.test(target)) {
          resolved = resolved.concat(screen.getChildrenByGroup(target.replace(group_pattern, "$1")))
        } else {
          resolved = resolved.concat(screen.getChildById(target))
        }
      }

      return resolved
    }
  }
}
