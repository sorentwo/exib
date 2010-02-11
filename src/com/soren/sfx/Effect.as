/**
* The Effect class provides simple shortcuts for animating one or more objects.
*
* @copyright Copyright (c) 2009 Soren LLC
* @author    Parker Selbert — parker@sorentwo.com
**/

package com.soren.sfx {
  
  import flash.display.DisplayObject
  import flash.display.DisplayObjectContainer
  import com.soren.sfx.easing.*

  public class Effect {
    
    public static const EFFECT_COMPLETE:String = 'effect_complete'
    
    public static const DEFAULT_ALPHA:uint           = 1
    public static const DEFAULT_DURATION:uint        = 1
    public static const DEFAULT_EASING:String        = 'linear_in'
    public static const DEFAULT_FADE_FROM:uint       = 1
    public static const DEFAULT_FADE_TO:uint         = 0
    public static const DEFAULT_GLOW_ALPHA_FROM:uint = 0
    public static const DEFAULT_GLOW_ALPHA_TO:uint   = 1
    public static const DEFAULT_GLOW_BLUR_FROM:uint  = 0
    public static const DEFAULT_GLOW_BLUR_TO:uint    = 6
    public static const DEFAULT_TIMES:uint           = 3
    public static const DEFAULT_PULSE_FROM:uint      = 1
    public static const DEFAULT_PULSE_TO:uint        = 0
    public static const DEFAULT_RELATIVE:Boolean     = true
    public static const DEFAULT_REGISTRATION:String  = 'center'
    public static const DEFAULT_ROTATION:uint        = 180
    public static const DEFAULT_SCALE:uint           = 2
    public static const DEFAULT_SPIN:uint            = 360
    
    private static const GROUP_PATTERN:RegExp = /^\.(\w+)$/
    private static const MODEL_PATTERN:RegExp = /^(_\w+)$/

    private var _tween:Tween = Tween.getInstance()

    /**
    * Create an instance of the Effect class.
    **/
    public function Effect() { }
    
    /**
    * Perform a timed blur on one or more objects.
    *
    * @param  targets   An array of display objects.
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
    *           named screen_controller and that there is a object with the id
    *           of #button.
    *
    * <listing version="3.0">
    * var effect:Effect = new Effect(screen_controller)
    * effect.blur([#button], { color: 0xFF0000, blur_x_from: 0, blur_y_from: 0, blur_x_to: 8, blur_y_to: 8, duration: .5})
    * </listing>
    **/
    /*public function blur(targets:Array, options:Object = null):void {
      options = mergeOptions(options)

      for each (var object:DisplayObject in targets) {
        if (options.hasOwnProperty('blur_x_from')) {
          _tween.add(object, 'blur_x', options['easing'], options['blur_x_from'], options['blur_x_to'], options['duration'])
        }
        
        if (options.hasOwnProperty('blur_y_from')) {
          _tween.add(object, 'blur_y', options['easing'], options['blur_y_from'], options['blur_y_to'], options['duration'])
        }
      }
    }*/

    /**
    * Perform a timed fade on one or more objects.
    *
    * @param  targets   An array of display objects.
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
    *           named screen_controller and that there is a object with the id
    *           of #container.
    *
    * <listing version="3.0">
    * var effect:Effect = new Effect(screen_controller)
    * effect.fade([#container], { fade_from: 1, fade_to: 0, duration: .5, easing: strong_out })
    * </listing>
    **/
    public function fade(targets:Array, options:Object = null):void {
      options = mergeOptions(options)

      for each (var object:DisplayObject in targets) {
        if (!object.visible) object.visible = true
        _tween.add(object, 'alpha', options['easing'], options['fade_from'], options['fade_to'], options['duration'])
      }
    }
    
    /**
    * Performed a timed glow on one or more objects.
    * 
    * @param  targets   An array of display objects.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>blur_from -> An integer between 0 and 32, where
    *                   blurring will begin. Multiples of two are optimized.
    *                   </li>
    *                   <li>blur_to -> An integer between 0 and 32, where
    *                   blurring will end. Multiples of two are optimized.
    *                   </li>
    *                   <li>alpha_from -> A number between 0 and 1.</li>
    *                   <li>alpha_to -> A number between 0 and 1</li>
    *                   <li>duration -> Seconds, a number in greater than 0</li>
    *                   <li>easing -> One of the valid easing algorithms</li>
    *                   </ul>
    *
    * @example  The following code shows a typical glow on objects found within
    *           a screen instance. It assumes that there is a ScreenController
    *           named screen_controller and that there is an object with the id
    *           of #button.
    *
    * <listing version="3.0">
    * var effect:Effect = new Effect(screen_controller)
    * effect.glow([#button], { blur_from: 0, blur_to: 6, alpha_from: 0, alpha_to: 1, duration: .5})
    * </listing>
    **/
    /*public function glow(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      
      for each (var object:DisplayObject in targets) {
        object.glow_color = uint(options['glow_color'])
        _tween.add(object, 'glow_blur', options['easing'], options['blur_from'], options['blur_to'], options['duration'])
        _tween.add(object, 'glow_alpha', options['easing'], options['alpha_from'], options['alpha_to'], options['duration'])
      }
    }*/
    
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
    *           named screen_controller and that there is a number of objects with
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
    public function hide(targets:Array, options:Object = null):void {
      for each (var object:DisplayObject in targets) { object.visible = false }
    }

    /**
    * Like hide and show this is Not much of an effect. Move simply moves the
    * targets a specified distance immediately, with no animation. This is quite
    * usefull for ensuring that a subsequent slide effect will happen the same
    * way if run multiple times.
    * 
    * @param  targets   An array of display objects.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>x -> Any valid x coordinate. It is possible to place
    *                   the target object(s) out of view.</li>
    *                   <li>y -> Any valid y coordinate. It is possible to place
    *                   the target object(s) out of view.</li>
    *                   <li>relative -> If true x and y are translated from the
    *                   current position, if false the x and y are absolute to
    *                   the container of each object. Defaults to true.</li>
    *                   </ul>
    * 
    * @example  The following code shows a object being positioned absolutely
    *           before it will be slid. It assumes that there is a ScreenController
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

      for each (var object:DisplayObject in targets) {
        for each (var prop:String in ['x', 'y']) {
          if (options.hasOwnProperty(prop)) {
            object[prop] = (options['relative']) ? object[prop] + int(options[prop]) : int(options[prop])
          }
        }
      }
    }

    /**
    * Like move, hide, or show this is not a timed effect. It immediately sets
    * the target object(s) opacity, or alpha, to the provided level.
    * 
    * @param  targets   An array of display objects.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>alpha -> An unsigned integer from 0 to 1, where 0 is
    *                   entirely invisible and 1 is entirely visible. Values
    *                   outside this range are possible but will look quite
    *                   distorted.</li>
    *                   </ul>
    * 
    * @example  The following code shows a object being set to completely opaque,
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

      for each (var object:DisplayObject in targets) { object.alpha = options['alpha'] }
    }

    /**
    * Pulse will fluxuate the opacity of one or more objects a set number of
    * times. Multiples of two will return the object(s) to their initial opacity.
    * 
    * @param  targets   An array of display objects.
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

      for each (var object:DisplayObject in targets) {
        _tween.add(object, 'alpha', options['easing'], options['pulse_from'], options['pulse_to'], options['duration'], options['times'])
      }
    }
    
    /**
    * Change the registration point of an object to any of its corners or the
    * center point. Future implementation may accept a set of coordinates, this
    * does not. This is not a timed effect.
    * <p>Multiple objects will be registered individually according to their own
    * relative sizes. After the registration has been changed any new effects
    * applied to the object(s), namely scale, will be applied from the new
    * registration point.</p>
    * <p>This effect is really only intended for graphic and text objects 
    * that only have one child which is visible all the time. The nature of
    * registration points in flash makes changing the registration of more 
    * complex nodes too difficult at this time.</p>
    * 
    * @param  targets   An array of display objects.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>registration -> Any of the following registration
    *                   strings: 'center, top_left, top_mid, top_right, right_mid,
    *                   bottom_right, bottom_mid, bottom_left, left_mid'</li>
    *                   </ul>
    * @example  The following code shows a typical register usage. It assumes
    *           that there is a ScreenController named <code>screen_controller</code>
    *           and that there is a TextNode named <code>#texty</code> within
    *           the current screen.
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller)
    * effect.register([#texty], { registration: center })
    * </listing>
    **/
    public function register(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      
      var reg_x:int, reg_y:int
      
      for each (var object:DisplayObjectContainer in targets) {
        
        switch (options['registration'].replace(' ', '')) {
          case 'center':       reg_x = object.width / 2; reg_y = object.height / 2; break
          case 'top_left':     reg_x = 0;                reg_y = 0; break
          case 'top_mid':      reg_x = object.width / 2; reg_y = 0; break
          case 'top_right':    reg_x = object.width;     reg_y = 0; break
          case 'right_mid':    reg_x = object.width;     reg_y = object.height / 2; break
          case 'left_mid' :    reg_x = 0;                reg_y = object.height / 2; break
          case 'bottom_left':  reg_x = 0;                reg_y = object.height; break
          case 'bottom_mid':   reg_x = object.width / 2; reg_y = object.height; break
          case 'bottom_right': reg_x = object.width;     reg_y = object.height; break
          default: throw new Error('Invalid registration string: ' + options['registration'])
        }

        object.getChildAt(0).x -= reg_x
        object.getChildAt(0).y -= reg_y
        object.x += reg_x
        object.y += reg_y
      }
    }
    
    /**
    * Like move, show, or hide this is not a timed effect. It immediately rotates
    * the specified object(s) the given rotation. For a timed version of the
    * rotate effect use spin.
    * 
    * @param  targets   An array of display objects.
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
      
      var axis:String
      switch (options['axis']) {
        case 'x': axis = 'rotationX'; break
        case 'y': axis = 'rotationY'; break
        case 'z': axis = 'rotationZ'; break
        default:  axis = 'rotation'
      }
      
      for each (var object:DisplayObject in targets) {
        object[axis] = (options['relative']) ? object[axis] + options['rotate'] : options['rotate']
      }
    }
    
    /**
    * Change the size of an object or objects over a period of time. Scaling is
    * locked to be uniform, meaning the x and y value remain the same.
    * 
    * @param  targets   An array of display objects.
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
    * effect.scale([.dots], { size: .45, duration: .25, easing: quint_out })
    * </listing>
    **/
    public function scale(targets:Array, options:Object = null):void {
      options = mergeOptions(options)

      for each (var object:DisplayObject in targets) {
        _tween.add(object, 'scaleX', options['easing'], object.scaleX, Number(options['scale']), options['duration'])
        _tween.add(object, 'scaleY', options['easing'], object.scaleY, Number(options['scale']), options['duration'])
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
    *           number of objects in the group <code>objects</code>.
    * 
    * <listing version="3.0">
    * var effect:Effect = new Effect(screen_controller)
    * effect.show([.objects])
    * </listing>
    * 
    * @see hide
    * @see opacity
    **/
    public function show(targets:Array, options:Object = null):void {
      for each (var object:DisplayObject in targets) { object.visible = true }
    }
    
    /**
    * Change the size of an object or objects immediately. Sizing, like scaling
    * is locked to be uniform, meaning the x and y value remain the same.
    * 
    * @param  targets   An array of display objects.
    * @param  options   An option hash with any of the following key/value pairs:
    *                   <ul>
    *                   <li>scale -> A numerical percentage, i.e. 1 = 100%,
    *                   1.5 = 150% etc.</li>
    *                   </ul>
    *
    * @example  The following code shows a typical use of size.
    * 
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller) 
    * effect.size([.dots], { size: .45 })
    * </listing>
    **/
    public function size(targets:Array, options:Object = null):void {
      options = mergeOptions(options)

      for each (var object:DisplayObject in targets) {
        if (options.hasOwnProperty('start_w')) {
          var start_w:int = (options['relative']) ? object.width + int(options['start_w']) : options['start_w']
          var end_w:int   = (options['relative']) ? object.width + int(options['end_w'])   : options['end_w']
          
          _tween.add(object, 'width', options['easing'], start_w, end_w, options['duration'])
        }

        if (options.hasOwnProperty('start_h')) {
          var start_h:uint = (options['relative']) ? object.height + int(options['start_h']) : options['start_h']
          var end_h:uint   = (options['relative']) ? object.height + int(options['end_h'])   : options['end_h']

          _tween.add(object, 'height', options['easing'], start_h, end_h, options['duration'])
        }
      }
    }

    /**
    * Move an object or objects from one set of x,y coordinates to another set
    * over time.
    * 
    * @param  targets   An array of display objects.
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
    *           objects in the group <code>container</code>.
    * 
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller)
    * // Slide a group of objects from their current location to an x offset of 120 and a y offset of 60
    * effect.slide([.container], { start_x: 0, end_x: 120, start_y: 0, end_y: 60, relative: true, duration: 1, easing: bounce_out })
    * // Slide the same group back absolutely to the position 20,20
    * effect.slide([.container], { start_x: 140, end_x: 20, start_y: 80, end_y: 20, relative: false, duration: 1, easing: bounce_in })
    * </listing>
    **/
    public function slide(targets:Array, options:Object = null):void {
      options = mergeOptions(options)

      for each (var object:DisplayObject in targets) {
        if (options.hasOwnProperty('start_x')) {
          var start_x:int = (options['relative']) ? object.x + int(options['start_x']) : options['start_x']
          var end_x:int   = (options['relative']) ? object.x + int(options['end_x'])   : options['end_x']
          
          _tween.add(object, 'x', options['easing'], start_x, end_x, options['duration'])
        }

        if (options.hasOwnProperty('start_y')) {
          var start_y:int = (options['relative']) ? object.y + int(options['start_y']) : options['start_y']
          var end_y:int   = (options['relative']) ? object.y + int(options['end_y'])   : options['end_y']

          _tween.add(object, 'y', options['easing'], start_y, end_y, options['duration'])
        }
        
        if (options.hasOwnProperty('start_z')) {
          var start_z:int = (options['relative']) ? object.z + int(options['start_z']) : options['start_z']
          var end_z:int   = (options['relative']) ? object.z + int(options['end_z'])   : options['end_z']

          _tween.add(object, 'z', options['easing'], start_z, end_z, options['duration'])
        }
      }
    }
    
    /**
    * Rotate an object or objects over a period of time. This is the time based
    * counterpart to rotate.
    * 
    * @param  targets   An array of display objects.
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
    *           and that there is a object with the id <code>#icon</code>.
    * 
    * <listing version='3.0'>
    * var effect:Effect = new Effect(screen_controller)
    * effect.spin([#icon], { axis: x, rotate: 180, duration: 1.25, easing: linear_in_out })
    * </listing>
    * @see  rotate
    **/
    public function spin(targets:Array, options:Object = null):void {
      options = mergeOptions(options)
      
      var axis:String
      switch (options['axis']) {
        case 'x': axis = 'rotationX'; break
        case 'y': axis = 'rotationY'; break
        case 'z': axis = 'rotationZ'; break
        default:  axis = 'rotation'
      }
      
      for each (var object:DisplayObject in targets) {
        _tween.add(object, axis, options['easing'], object[axis], options['rotate'], options['duration'])
      }
    }

    /**
    * Terminate any in-progress effects, or a collection of effects for specified
    * targets and set them back to the start point.
    **/
    public function stop(targets:Array = null):void {
      if (targets) {
        for each (var object:DisplayObject in targets) { _tween.stop(object) }
      } else {
        _tween.stop()
      }
    }
    
    // PRIVATE -----------------------------------------------------------------
    
    /**
    * Merge an option hash with the defaults and return the result.
    **/
    private function mergeOptions(options:Object):Object {
      var merged_options:Object = {}
      
      merged_options['alpha']        = DEFAULT_ALPHA
      merged_options['alpha_from']   = DEFAULT_GLOW_ALPHA_FROM
      merged_options['alpha_to']     = DEFAULT_GLOW_ALPHA_TO
      merged_options['blur_from']    = DEFAULT_GLOW_BLUR_FROM
      merged_options['blur_to']      = DEFAULT_GLOW_BLUR_TO
      merged_options['duration']     = DEFAULT_DURATION
      merged_options['easing']       = DEFAULT_EASING
      merged_options['fade_from']    = DEFAULT_FADE_FROM
      merged_options['fade_to']      = DEFAULT_FADE_TO
      merged_options['times']        = DEFAULT_TIMES
      merged_options['pulse_from']   = DEFAULT_PULSE_FROM
      merged_options['pulse_to']     = DEFAULT_PULSE_TO
      merged_options['relative']     = DEFAULT_RELATIVE
      merged_options['registration'] = DEFAULT_REGISTRATION
      merged_options['rotation']     = DEFAULT_ROTATION
      merged_options['scale']        = DEFAULT_SCALE
      merged_options['spin']         = DEFAULT_SPIN

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
        case 'cubic_in':
          easing_method = Cubic.easeIn
          break
        case 'cubic_out':
          easing_method = Cubic.easeOut
          break
        case 'cubic_in_out':
          easing_method = Cubic.easeInOut
          break
        case 'exponential_in':
          easing_method = Exponential.easeIn
          break
        case 'exponential_out':
          easing_method = Exponential.easeOut
          break
        case 'exponential_in_out':
          easing_method = Exponential.easeInOut
          break
        case 'linear_in':
          easing_method = Linear.easeIn
          break
        case 'linear_in_out':
          easing_method = Linear.easeInOut
          break
        case 'linear_out':
          easing_method = Linear.easeOut
          break
        case 'quad_in':
          easing_method = Quad.easeIn
          break
        case 'quad_in_out':
          easing_method = Quad.easeInOut
          break
        case 'quad_out':
          easing_method = Quad.easeOut
          break
        case 'quart_in':
          easing_method = Quart.easeIn
          break
        case 'quart_in_out':
          easing_method = Quart.easeInOut
          break
        case 'quart_out':
          easing_method = Quart.easeOut
          break
        case 'quint_in':
          easing_method = Quint.easeIn
          break
        case 'quint_in_out':
          easing_method = Quint.easeInOut
          break
        case 'quint_out':
          easing_method = Quint.easeOut
          break
        case 'sine_in':
          easing_method = Sine.easeIn
          break
        case 'sine_in_out':
          easing_method = Sine.easeInOut
          break
        case 'sine_out':
          easing_method = Sine.easeOut
          break
        case 'strong_in':
          easing_method = Strong.easeIn
          break
        case 'strong_in_out':
          easing_method = Strong.easeInOut
          break
        case 'strong_out':
          easing_method = Strong.easeOut
          break
      }

      if (easing_method == null) throw new Error('No easing method found for: ' + easing_id)
      
      return easing_method
    }
    
  }
}