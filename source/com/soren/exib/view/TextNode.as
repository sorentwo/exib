/**
* TextNode
* 
* A dynamic and updatable text field, but with all of the methods of the Node
* class.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.view {

  import flash.text.AntiAliasType
  import flash.text.TextField
  import flash.text.TextFieldAutoSize
  import flash.text.TextFormat
  import com.soren.exib.helper.IEvaluatable
  import com.soren.exib.model.Model
  import com.soren.util.ExtendedArray
  import com.soren.util.StringUtil

  public class TextNode extends Node {
    
    private var _text_field:TextField
    private var _content:String
    private var _format:TextFormat
    private var _arguments:Array
    private var _align:String
    private var _charcase:String
    
    public function TextNode(content:String,
                             format:TextFormat,
                             arguments:Array = null,
                             align:String = 'LEFT') {
      
      _text_field = new TextField()
      
      _text_field.antiAliasType = AntiAliasType.ADVANCED
      _text_field.embedFonts    = true
      _text_field.selectable    = false
      
      this.align     = align
      this.format    = format
      this.content   = content
      this.arguments = (arguments) ? arguments : []
      
      this.addChild(_text_field)
      
      update()
    }
    
    /**
    **/
    public function set align(align:String):void {
      var pattern:RegExp = /^(left|center|right)$/i
      if (pattern.test(align)) { _align = align.toUpperCase() }
      else                     { throw new Error("Invalid alignment: " + align) }
    }
    
    /**
    **/
    public function set arguments(arguments:Array):void {
      _arguments = arguments
      
      for each (var argument:* in _arguments) {
        if (argument is IEvaluatable) {
          argument.addEventListener(Model.CHANGED, changeListener)
        }
      }
    }
    
    /**
    * @param  A charcase token that will be used to convert all text that the
    *         node displays. Valid tokens are: l -> lower case, s -> Sentence case,
    *         t -> Title Case, u -> UPPER CASE
    **/
    public function set charcase(charcase:String):void {
      _charcase = charcase
    }
    
    /**
    **/
    public function set content(content:String):void {
      _content = content
    }
    
    /**
    **/
    public function set format(format:TextFormat):void {
      _format = format
    }
  
    /**
    **/
    override public function update():void {
      applyAlignment()
      applyContent()
      applyFormat()
    }
    
    // ---
    
    /**
    * @private
    **/
    private function applyAlignment():void {
      switch(_align) {
        case 'LEFT':
          _text_field.autoSize = TextFieldAutoSize.LEFT
          break
        case 'CENTER':
          _text_field.autoSize = TextFieldAutoSize.CENTER
          break
        case 'RIGHT':
          _text_field.autoSize = TextFieldAutoSize.RIGHT
          break
      }
    }

    /**
    * @private
    **/
    private function applyContent():void {
      var new_text:String = _content
      
      if (hasTokens())   new_text = StringUtil.sprintf(new_text, _arguments.map(extractValues))
      if (hasCharcase()) new_text = StringUtil.convertCase(new_text, _charcase)
      
      _text_field.text = new_text
    }

    /**
    * @private
    **/
    private function applyFormat():void {
      _text_field.setTextFormat(_format)
    }
  
    /**
    * @private
    **/
    private function hasCharcase():Boolean {
      return (_charcase == null) ? false : true
    }
    
    /**
    * @private
    **/
    private function hasTokens():Boolean {
      var pattern:RegExp = /%[a-z0-9{}]+/g
      return pattern.test(_content)
    }
  
    /**
    * @private
    **/
    private function extractValues(object:*, index:int, array:Array):* {
      return (object is IEvaluatable) ? object.value : object
    }
  }
}
