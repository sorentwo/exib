/**
* VectorNode
*
* A convenience class for easily creating circle, rectnagle, or squround (rounded
* rectangle) vector shapes. Options are optional, there is a full set of defaults
* defined in the class.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.display.Graphics
  import flash.display.Shape
  
  public class VectorNode extends Node {

    private const VALID_SHAPES:RegExp = /^(circle|rectangle|squround)$/i
    
    public const DEFAULT_COLOR:uint  = 0x000000
    public const DEFAULT_CORNER:uint = 10
    public const DEFAULT_FILL:uint   = 0xFFFFFF
    public const DEFAULT_HEIGHT:uint = 100
    public const DEFAULT_RADIUS:uint = 50
    public const DEFAULT_STROKE:uint = 0
    public const DEFAULT_WIDTH:uint  = 100
    
    private var _options:Object = new Object()
    
    /**
    * Constructor
    **/
    public function VectorNode(shape:String, options:Object = null) {
      if (VALID_SHAPES.test(shape)) { shape = shape.toLowerCase() }
      else                          { throw new Error("Invalid shape: " + shape) }
      
      options = (options) ? options : {}
      extractOptions(options)
      
      switch (shape) {
        case 'circle':
          doDrawCircle()
          break
        case 'rectangle':
          doDrawRectangle()
          break
        case 'squround':
          doDrawSquround()
      }
    }
    
    // ---
    
    /**
    * @private
    **/
    private function doDrawCircle():void {      
      var circle:Shape = new Shape()
      circle.graphics.beginFill(_options['fill'])
      circle.graphics.lineStyle(_options['stroke'], _options['color'])
      circle.graphics.drawCircle(_options['radius'], _options['radius'], _options['radius'])
      circle.graphics.endFill()
      this.addChild(circle)
    }
    
    /**
    * @private
    **/
    private function doDrawRectangle():void {
      var rectangle:Shape = new Shape()
      rectangle.graphics.beginFill(_options['fill'])
      rectangle.graphics.lineStyle(_options['stroke'], _options['color'])
      rectangle.graphics.drawRect(0, 0, _options['width'], _options['height'])
      rectangle.graphics.endFill()
      this.addChild(rectangle)
    }
    
    /**
    * @private
    **/
    private function doDrawSquround():void {
      var squround:Shape = new Shape()
      squround.graphics.beginFill(_options['fill'])
      squround.graphics.lineStyle(_options['stroke'], _options['color'])
      squround.graphics.drawRoundRect(0, 0, _options['width'], _options['height'], _options['corner'])
      squround.graphics.endFill()
      this.addChild(squround)
    }
    
    /**
    * @private
    **/
    private function extractOptions(options:Object):void {
      _options['fill']   = (options.hasOwnProperty('fill'))
                         ? uint(options['fill'])
                         : DEFAULT_FILL
      _options['stroke'] = (options.hasOwnProperty('stroke'))
                         ? uint(options['stroke'])
                         : DEFAULT_STROKE
      _options['color']  = (options.hasOwnProperty('color'))
                         ? uint(options['color'])
                         : DEFAULT_COLOR
      _options['radius'] = (options.hasOwnProperty('radius'))
                         ? uint(options['radius'])
                         : DEFAULT_RADIUS
      _options['width']  = (options.hasOwnProperty('width'))
                         ? uint(options['width'])
                         : DEFAULT_WIDTH
      _options['height'] = (options.hasOwnProperty('height'))
                         ? uint(options['height'])
                         : DEFAULT_HEIGHT
      _options['corner'] = (options.hasOwnProperty('corner'))
                         ? uint(options['corner'])
                         : DEFAULT_CORNER
    }
  }
}
