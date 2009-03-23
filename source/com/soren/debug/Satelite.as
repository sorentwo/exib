/**
* Satelite
*
* Other half of the logger local connection. When open this will display any
* statements traced by Log.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.debug {
  
  import flash.display.Sprite
  import flash.net.LocalConnection
  import flash.text.AntiAliasType
  import flash.text.TextFormat
  import flash.text.TextField
  import flash.text.TextFieldAutoSize
  
  public class Satelite extends Sprite implements ISatelite {
    
    private var _output:String = ''
    private var _text_field:TextField
    private var _connection:LocalConnection
    
    private var _background_color:uint = 0x333333
    private var _format_color:uint     = 0xffffff
    private var _format_font:String    = 'Consolas'
    private var _format_size:uint      = 10
    private var _height:uint           = 400
    private var _width:uint            = 550
    
    /**
    * Constructor
    **/
    public function Satelite() {
      _connection = new LocalConnection()
      _connection.allowDomain('*')
      _connection.client = this

      try {
        _connection.connect('satelite')
      } catch (error:ArgumentError) {
        throw new Error("Can't connect...the connection name is already being used by another SWF")
      }
      
      _text_field = new TextField()
      
      _text_field.autoSize        = TextFieldAutoSize.LEFT
      _text_field.background      = true
      _text_field.backgroundColor = _background_color
      _text_field.antiAliasType   = AntiAliasType.ADVANCED
      _text_field.selectable      = true
      _text_field.wordWrap        = true
      _text_field.width           = _width
      _text_field.height          = _height
      
      var format:TextFormat = new TextFormat()
			format.font  = _format_font
			format.size  = _format_size
			format.color = _format_color
			
			_text_field.defaultTextFormat = format
      
      this.addChild(_text_field)
      
      write("Logger Satelite\n")
      write("------------------------\n\n")
    }
    
    /**
    * Clears the displayed trace statements.
    **/
    public function clear():void {
      _output = ''
      
      update()
    }
    
    /**
    * Writes a pre-formatted trace statement to the buffer.
    **/
    public function write(output:String):void {
      _output += output

      update()
    }
    
    // ---
    
    /**
    * Refreshes the text display
    **/
    protected function update():void {
      _text_field.text = _output
    }
  }
}
