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
  import flash.text.TextField
  import flash.text.TextFieldAutoSize
  
  public class Satelite extends Sprite implements ISatelite {
    
    private var _output:String = 'Wild and crazy stuff'
    private var _text_field:TextField
    private var _connection:LocalConnection
    
    /**
    * Constructor
    **/
    public function Satelite() {
      _connection = new LocalConnection()
      _connection.allowDomain('*')
      _connection.connect('satelite')
      
      _text_field = new TextField()
      
      _text_field.autoSize      = TextFieldAutoSize.LEFT
      _text_field.antiAliasType = AntiAliasType.ADVANCED
      _text_field.selectable    = true
      
      this.addChild(_text_field)
      
      update()
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
