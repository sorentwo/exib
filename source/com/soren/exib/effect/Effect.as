/**
* The Effect class provides simple shortcuts for animating one or more objects.
* It is designed to be used on the children of a screen instance, but if no
* ScreenController is provided to the instance it assumes that effects are being
* performed directly on objects provided.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.effect {

  import fl.transitions.Tween
  import fl.transitions.TweenEvent
  import fl.transitions.easing.*
  import flash.filters.BlurFilter
  import com.soren.exib.core.IActionable
  import com.soren.exib.debug.Log
  import com.soren.exib.view.ScreenController
  import com.soren.exib.view.Node

  public class Effect implements IActionable {

    public static const DEFAULT_ALPHA:uint       = 1
    public static const DEFAULT_DURATION:uint    = 1
    public static const DEFAULT_EASING:String    = 'linear_in'
    public static const DEFAULT_FADE_FROM:uint   = 1
    public static const DEFAULT_FADE_TO:uint     = 0
    public static const DEFAULT_PULSE_COUNT:uint = 4
    public static const DEFAULT_PULSE_FROM:uint  = 1
    public static const DEFAULT_PULSE_TO:uint    = 0
    public static const DEFAULT_RELATIVE:Boolean = true
    public static const DEFAULT_ROTATION:uint    = 180
    public static const DEFAULT_SCALE:uint       = 2
    public static const DEFAULT_SPIN:uint        = 360
    
    private static const GROUP_PATTERN:RegExp = /^\.([a-zA-Z]+)/

    private var _screen_controller:ScreenController

    private var _blur_tweens:Array  = []
    private var _fade_tweens:Array  = []
    private var _scale_tweens:Array = []
    private var _slide_tweens:Array = []
    private var _spin_tweens:Array  = []
    private var _pulse_tweens:Array = []
    private var _active_tweens:Array = [_blur_tweens, _fade_tweens, _scale_tweens,
                                        _slide_tweens, _spin_tweens, _pulse_tweens]

    /**
    * Create an instance of the Effect class and optionally define its association
    * with a ScreenController.
    *
    * @param screen_controller  If a ScreenController instance is provided all
    *                           targets provided are assumed to be id or group
    *                           names and Effect will attempt to resolve display
    *                           objects from the current Screen.
    **/
    public function Effect(screen_controller:ScreenController = null) {
      if (screen_controller) _screen_controller = screen_controller
    }

    /**
    * Perform a timed blur on one or more objects.
    *
    * @param  targets   An array of display objects or, if a ScreenController is
    *                   present, a list of object groups and ids that will be used
    *                   to attempt to resolve display objects from the current
    *                   screen.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>blur_x_from -> An integer between 0 and 32, where x
    *                   axis blurring will begin. Multiples of two are optimized.
    *                   </li>
    *                   <li>blur_y_from -> An integer between 0 and 32, where y
    *                   axis blurring will begin. Multiples of two are optimized.
    *                   </li>
    *                   <li>blur_x_to -> An integer between 0 and 32, where x
    *                   axis blurring will end. Multiples of two are optimized.
    *                   </li>
    *                   <li>blur_y_to -> An integer between 0 and 32, where y
    *                   axis blurring will end. Multiples of two are optimized.
    *                   </li>
    *                   <li>duration -> Seconds, a number in greater than 0</li>
    *                   <li>easing -> One of the valid easing algorithms</li>
    *                   </ul>
    *
    * @example  The following code shows a typical blur on objects found within
    *           a screen instance. It assumes that there is a ScreenController
    *           named screen_controller and that there is a node with the id
    *           of #button.
    *
    * <listing version="3.0">
    * var effect:Effect = new Effect(screen_controller)
    * effect.blur([#button], { blur_x_from: 0, blur_y_from: 0, blur_x_to: 8, blur_y_to: 8, duration: .5})
    * </listing>
    **/
    public function blur(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      targets = resolveTargets(targets)

      for each (var node:Node in targets) {
        if (options.hasOwnProperty('blur_x_from')) {
          var blur_x:Tween = new Tween(node, 'blur_x', options['easing'], options['blur_x_from'], options['blur_x_to'], options['duration'], true)
          blur_x.addEventListener(TweenEvent.MOTION_CHANGE, blurTweenUpdate)
          blur_x.addEventListener(TweenEvent.MOTION_FINISH, tweenCompleteListener)
          _blur_tweens.push(blur_x)
        }
        
        if (options.hasOwnProperty('blur_y_from')) {
          var blur_y:Tween = new Tween(node, 'blur_y', options['easing'], options['blur_y_from'], options['blur_y_to'], options['duration'], true)
          blur_y.addEventListener(TweenEvent.MOTION_CHANGE, blurTweenUpdate)
          blur_y.addEventListener(TweenEvent.MOTION_FINISH, tweenCompleteListener)
          _blur_tweens.push(blur_y)
        }
      }
    }

    /**
    * Perform a timed fade on one or more objects.
    *
    * @param  targets   An array of display objects or, if a ScreenController is
    *                   present, a list of object groups and ids that will be used
    *                   to attempt to resolve display objects from the current
    *                   screen.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>fade_from -> A number from 0 to 1.</li>
    *                   <li>fade_to -> A number from 0 to 1.</li>
    *                   <li>duration -> Seconds, a number in greater than 0</li>
    *                   <li>easing -> One of the valid easing algorithms</li>
    *                   </ul>
    *
    * @example  The following code shows a half-second fade on objects found within
    *           a screen instance. It assumes that there is a ScreenController
    *           named screen_controller and that there is a node with the id
    *           of #container.
    *
    * <listing version="3.0">
    * var effect:Effect = new Effect(screen_controller)
    * effect.fade([#container], { fade_from: 1, fade_to: 0, duration: .5, easing: strong_out })
    * </listing>
    **/
    public function fade(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      targets = resolveTargets(targets)

      for each (var node:Node in targets) {
        var fade_tween:Tween = new Tween(node, 'alpha', options['easing'], options['fade_from'], options['fade_to'], options['duration'], true)
        fade_tween.addEventListener(TweenEvent.MOTION_FINISH, tweenCompleteListener)
        _fade_tweens.push(fade_tween)
      }
    }

    /**
    * Immediately make one or more objects invisible. It should be noted that
    * invisible and an alpha of 0 are not the same thing - if a hidden object has
    * its alpha set it will have no effect. To see a hidden object it must be
    * shown.
    * 
    * @param  targets An array of display objects or, if a ScreenController is
    *                 present, a list of object groups and ids that will be used
    *                 to attempt to resolve display objects from the current
    *                 screen.
    * 
    * @example  The following code shows immediately hiding a set of objects found
    *           within a screen instance. It assumes that there is a ScreenController
    *           named screen_controller and that there is a number of nodes with
    *           the group of objects.
    * 
    * <listing version="3.0">
    * var effect:Effect = new Effect(screen_controller)
    * effect.hide([.objects])
    * </listing>
    * 
    * @see show
    * @see opacity
    **/
    public function hide(targets:Array):void {
      targets = resolveTargets(targets)

      for each (var node:Node in targets) { node.visible = false }
    }

    /**
    * Like hide and show this is Not much of an effect. Move simply moves the
    * targets a specified distance immediately, with no animation. This is quite
    * usefull for ensuring that a subsequent slide effect will happen the same
    * way if run multiple times.
    * 
    * @param  targets   An array of display objects or, if a ScreenController is
    *                   present, a list of object groups and ids that will be used
    *                   to attempt to resolve display objects from the current
    *                   screen.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>x -> Any valid x coordinate. It is possible to place
    *                   the target node(s) out of view.</li>
    *                   <li>y -> Any valid y coordinate. It is possible to place
    *                   the target node(s) out of view.</li>
    *                   <li>relative -> If true x and y are translated from the
    *                   current position, if false the x and y are absolute to
    *                   the container of each object. Defaults to true.</li>
    *                   </ul>
    * 
    * @example  The following code shows a node being positioned absolutely before
    *           it will be slid. It assumes that there is a ScreenController
    *           named <code>screen_controller</code> and that there is an object
    *           named <code>#container</code> within the current screen.
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller)
    * effect.move([#container],  { x: 10, y: 10, relative: false })
    * effect.slide([#container], { start_x: 0, end_x: 500, duration: .5 })
    * </listing>
    **/
    public function move(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      targets = resolveTargets(targets)

      for each (var node:Node in targets) {
        for each (var prop:String in ['x', 'y']) {
          if (options.hasOwnProperty(prop)) {
            node[prop] = (options['relative']) ? node[prop] + int(options[prop]) : int(options[prop])
          }
        }
      }
    }

    /**
    * Like move, hide, or show this is not a timed effect. It immediately sets
    * the target object(s) opacity, or alpha, to the provided level.
    * 
    * @param  targets   An array of display objects or, if a ScreenController is
    *                   present, a list of object groups and ids that will be used
    *                   to attempt to resolve display objects from the current
    *                   screen.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>alpha -> An unsigned integer from 0 to 1, where 0 is
    *                   entirely invisible and 1 is entirely visible. Values
    *                   outside this range are possible but will look quite
    *                   distorted.</li>
    *                   </ul>
    * 
    * @example  The following code shows a node being set to completely opaque,
    *           1 (100% opacity), before it is faded out. It assumes that there
    *           is a ScreenController named <code>screen_controller</code> and
    *           that there is an object named <code>#container</code> within the
    *           current screen. Note: This code is only really useful within a
    *           queue, if executed normally the opacity would override the fade.
    *
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller)
    * effect.fade([#container],    { fade_from: 1, fade_to: 0 })
    * effect.opacity([#container], { alpha: 1 })
    * </listing>
    **/
    public function opacity(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      targets = resolveTargets(targets)

      for each (var node:Node in targets) { node.alpha = options['alpha'] }
    }

    /**
    * Pulse will fluxuate the opacity of one or more objects a set number of
    * times. Multiples of two will return the object(s) to their initial opacity.
    * 
    * @param  targets   An array of display objects or, if a ScreenController is
    *                   present, a list of object groups and ids that will be used
    *                   to attempt to resolve display objects from the current
    *                   screen.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>pulse_from -> Starting opacity, between 0 - 1.</li>
    *                   <li>pulse_to -> Ending opacity, between 0 - 1</li>
    *                   <li>times -> The number of times the object(s) will pulse.
    *                   Multiples of two will return the object(s) to initial
    *                   opacity.</li>
    *                   <li>duration -> Seconds, a number in greater than 0</li>
    *                   <li>easing -> One of the valid easing algorithms</li>
    *                   </ul>
    * 
    * @example  The following code shows a typical pulse implentation. It assumes
    *           that there is a ScreenController named <code>screen_controller</code>
    *           and that there is an object named <code>#button</code> within
    *           the current screen.
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller)
    * effect.pulse([#button], { pulse_from: 1, pulse_to: .5, times: 6, duration: .25, easing: sine_in })
    * </listing>
    **/
    public function pulse(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      targets = resolveTargets(targets)

      for each (var node:Node in targets) {
        node.pulse_count = 0
        node.pulse_total = uint(options['times'])
        
        var pulse:Tween = new Tween(node, 'alpha', options['easing'], options['pulse_from'], options['pulse_to'], options['duration'], true)
        pulse.addEventListener(TweenEvent.MOTION_FINISH, pulseTweenFinish)
        _pulse_tweens.push(pulse)
      }
    }
    
    /**
    * Like move, show, or hide this is not a timed effect. It immediately rotates
    * the specified object(s) the given rotation. For a timed version of the
    * rotate effect use spin.
    * 
    * @param  targets   An array of display objects or, if a ScreenController is
    *                   present, a list of object groups and ids that will be used
    *                   to attempt to resolve display objects from the current
    *                   screen.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>rotate -> A positiive or negative integer. Negative
    *                   values will rotate the object backward.</li>
    *                   <li>relative -> If false the current rotation will be
    *                   discarded and the new rotate value will be applied
    *                   explicitely. Default is true.</li>
    *                   </ul>
    * 
    * @example The following code shows two rotates, one absolute and one
    *          relative. It assumes that there is a ScreenController named
    *          <code>screen_controller</code> and that there is an object named
    *          <code>#icon</code> within the current screen.
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller)
    * effect.rotate([#icon], { rotate: 90, relative: false }) // Rotation is now 90
    * effect.rotate([#icon], { rotate: 180, relative: true }) // Rotation is now 270
    * </listing>
    **/
    public function rotate(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      targets = resolveTargets(targets)
      
      for each (var node:Node in targets) {
        node.rotation = (options['relative']) ? node.rotation + options['rotation'] : options['rotation']
      }
    }
    
    /**
    * Change the size of an object or objects over a period of time. Scaling is
    * locked to be uniform, meaning the x and y value remain the same.
    * 
    * @param  targets   An array of display objects or, if a ScreenController is
    *                   present, a list of object groups and ids that will be used
    *                   to attempt to resolve display objects from the current
    *                   screen.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>scale -> A numerical percentage, i.e. 1 = 100%,
    *                   1.5 = 150% etc.</li>
    *                   <li>duration -> Seconds, a number in greater than 0</li>
    *                   <li>easing -> One of the valid easing algorithms</li>
    *                   </ul>
    *
    * @example  The following code shows a typical use of the scale effect.
    * 
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller) 
    * effect.scale([.dots], { start: 1, end: 1.5, duration: .25, easing: linear_in })
    * </listing>
    **/
    public function scale(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      targets = resolveTargets(targets)

      for each (var node:Node in targets) {
        var scale_x:Tween = new Tween(node, 'scaleX', options['easing'], node.scaleX, Number(options['scale']), options['duration'], true)
        var scale_y:Tween = new Tween(node, 'scaleY', options['easing'], node.scaleY, Number(options['scale']), options['duration'], true)
        scale_y.addEventListener(TweenEvent.MOTION_FINISH, tweenCompleteListener)
        scale_x.addEventListener(TweenEvent.MOTION_FINISH, tweenCompleteListener)
        _scale_tweens.push(scale_x, scale_y)
      }
    }
    
    /**
    * Immediately make one or more objects visible. It should be noted that
    * invisible and an alpha of 0 are not the same thing - if a hidden object has
    * its alpha set it will have no effect. To see a hidden object it must be
    * shown.
    * 
    * @param  targets An array of display objects or, if a ScreenController is
    *                 present, a list of object groups and ids that will be used
    *                 to attempt to resolve display objects from the current
    *                 screen.
    * 
    * @example  The following code shows immediately showing a set of objects
    *           found within a screen instance. It assumes that there is a
    *           ScreenController named screen_controller and that there are a
    *           number of nodes in the group <code>objects</code>.
    * 
    * <listing version="3.0">
    * var effect:Effect = new Effect(screen_controller)
    * effect.show([.objects])
    * </listing>
    * 
    * @see hide
    * @see opacity
    **/
    public function show(targets:Array):void {
      targets = resolveTargets(targets)

      for each (var node:Node in targets) { node.visible = true }
    }

    /**
    * Move an object or objects from one set of x,y coordinates to another set
    * over time.
    * 
    * @param  targets   An array of display objects or, if a ScreenController is
    *                   present, a list of object groups and ids that will be used
    *                   to attempt to resolve display objects from the current
    *                   screen.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>start_x -> X coordinate to start sliding from.</li>
    *                   <li>end_x -> X coordinate to end on.</li>
    *                   <li>start_y -> Y coordinate to start sliding from.</li>
    *                   <li>end_y -> Y coordinate to end on.</li>
    *                   <li>relative -> If true the x and y start and end points
    *                   will be relative to their current position, otherwise the
    *                   values will be seen as absolute coordinates. Default is 
    *                   true.</li>
    *                   <li>duration -> Seconds, a number in greater than 0</li>
    *                   <li>easing -> One of the valid easing algorithms</li>
    *                   </ul>
    *
    * @example The following code shows one relative and one absolute slide. It
    *           assumes that there is a ScreenController named
    *           <code>screen_controller</code> and that there are a number of
    *           nodes in the group <code>container</code>.
    * 
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller)
    * // Slide a group of nodes from their current location to an x offset of 120 and a y offset of 60
    * effect.slide([.container], { start_x: 0, end_x: 120, start_y: 0, end_y: 60, relative: true, duration: 1, easing: bounce_out })
    * // Slide the same group back absolutely to the position 20,20
    * effect.slide([.container], { start_x: 140, end_x: 20, start_y: 80, end_y: 20, relative: false, duration: 1, easing: bounce_in })
    * </listing>
    **/
    public function slide(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      targets = resolveTargets(targets)

      for each (var node:Node in targets) {
        if (options.hasOwnProperty('start_x')) {
          var start_x:int   = (options['relative']) ? node.x + int(options['start_x']) : options['start_x']
          var end_x:int     = (options['relative']) ? node.x + int(options['end_x'])   : options['end_x']
          var slide_x:Tween = new Tween(node, 'x', options['easing'], start_x, end_x, options['duration'], true)
          slide_x.addEventListener(TweenEvent.MOTION_CHANGE, tweenCompleteListener)
          _slide_tweens.push(slide_x)
        }

        if (options.hasOwnProperty('start_y')) {
          var start_y:uint = (options['relative']) ? node.y + int(options['start_y']) : options['start_y']
          var end_y:uint   = (options['relative']) ? node.y + int(options['end_y'])   : options['end_y']
          var slide_y:Tween = new Tween(node, 'y', options['easing'], start_y, end_y, options['duration'], true)
          slide_y.addEventListener(TweenEvent.MOTION_CHANGE, tweenCompleteListener)
          _slide_tweens.push(slide_y)
        }
      }
    }
    
    /**
    * Rotate an object or objects over a period of time. This is the time based
    * counterpart to rotate.
    * 
    * @param  targets   An array of display objects or, if a ScreenController is
    *                   present, a list of object groups and ids that will be used
    *                   to attempt to resolve display objects from the current
    *                   screen.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>spin -> The angle of rotation. Negative values will 
    *                   rotate counter-clockwise, positive values will rotate
    *                   clockwise. Values above 360 will continue to rotate beyond
    *                   one rotation.</li>
    *                   <li>duration -> Seconds, a number in greater than 0</li>
    *                   <li>easing -> One of the valid easing algorithms</li>
    *                   </ul>
    * 
    * @example  The following code illustrates a typical use of spin. It assumes
    *           that there is a ScreenController named <code>screen_controller</code>
    *           and that there is a node with the id <code>#icon</code>.
    * 
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller)
    * effect.spin([#icon], { rotation: 720, duration: 1.25, easing: linear_in_out })
    * </listing>
    * @see  rotate
    **/
    public function spin(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      targets = resolveTargets(targets)
      
      for each (var node:Node in targets) {
        var spin:Tween = new Tween(node, 'rotation', options['easing'], node.rotation, options['spin'], options['duration'], true)
        spin.addEventListener(TweenEvent.MOTION_CHANGE, tweenCompleteListener)
        _spin_tweens.push(spin)
      }
    }

    /**
    * Terminate any in-progress effect and set it back to the start point.
    **/
    public function kill():void {
      for each (var tween_array:Array in _active_tweens) {
        for each (var tween:Tween in tween_array) {
          tween.stop()
          tween.rewind()
          // This was used to ensure that the pulse would come out at a finished
          // level. Questionable, leaving it out for the time being.
          // tween.obj.alpha = tween.finish;
        }
      }
    }

    // ---
    
    /**
    * Called by a blur tween's motion change event. Responsible for updating the
    * node's blur level.
    **/
    private function blurTweenUpdate(event:TweenEvent):void {
      var node:Node = event.target.obj as Node
      node.filters = [ new BlurFilter(node.blur_x, node.blur_y, 2) ]
    }
    
    /**
    * Called by the pulse tween's motion complete event. Will yoyo the effect
    * until the total pulse count is reached, at which point the tween will be
    * removed.
    **/
    private function pulseTweenFinish(event:TweenEvent):void {
      var node:Node   = event.target.obj as Node
      var tween:Tween = event.target as Tween
      
      node.pulse_count += 1
      
      if (node.pulse_count == node.pulse_total) {
        tweenCompleteListener(event)
      } else {
        tween.yoyo()
      }
    }
    
    /**
    * Removes completed tweens from their collections.
    **/
    private function tweenCompleteListener(event:TweenEvent):void {
      var found:Boolean = false
      for each (var tween_array:Array in _active_tweens) {
        for (var i:int = 0; i < tween_array.length; i++) {
          if (event.target === tween_array[i]) {
            tween_array.splice(i, 1)
            found = true
            break
          }
        }
        
        if (found) break
      }
    }
    
    // ---
    
    /**
    * Merge an option hash with the defaults and return the result.
    **/
    private function mergeOptions(options:Object):Object {
      var merged_options:Object = {}
      
      merged_options['alpha']       = DEFAULT_ALPHA
      merged_options['duration']    = DEFAULT_DURATION
      merged_options['easing']      = DEFAULT_EASING
      merged_options['fade_from']   = DEFAULT_FADE_FROM
      merged_options['fade_to']     = DEFAULT_FADE_TO
      merged_options['times']       = DEFAULT_PULSE_COUNT
      merged_options['pulse_from']  = DEFAULT_PULSE_FROM
      merged_options['pulse_to']    = DEFAULT_PULSE_TO
      merged_options['relative']    = DEFAULT_RELATIVE
      merged_options['rotation']    = DEFAULT_ROTATION
      merged_options['scale']       = DEFAULT_SCALE
      merged_options['spin']        = DEFAULT_SPIN

      for (var prop:String in options) { merged_options[prop] = options[prop] }

      merged_options['easing']   = resolveEasing(merged_options['easing'])
      merged_options['relative'] = (merged_options['relative'] == 'true') ? true : false
      
      return merged_options
    }

    /**
    * Takes a string representing an easing function and returns the function.
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
    * Take an array of node ids and groups and returns an array of references to
    * the actual nodes.
    **/
    private function resolveTargets(targets:Array):Array {
      if (!_screen_controller || targets.length == 0) return targets
      
      var screen:Node = _screen_controller.current
      var resolved:Array = []

      for each (var target:String in targets) {
        if (GROUP_PATTERN.test(target)) {
          resolved = resolved.concat(screen.getChildrenByGroup(target.replace(GROUP_PATTERN, "$1")))
        } else {
          resolved = resolved.concat(screen.getChildById(target))
        }
      }

      return resolved
    }
  }
}