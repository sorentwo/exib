/**
* TextNode
* 
* A dynamic and updatable text field, but with all of the methods of the Node
* class.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.text.AntiAliasType
  import flash.text.TextField
  import flash.text.TextFieldAutoSize
  import flash.text.TextFormat
  import flash.text.TextFormatAlign
  import com.soren.exib.core.IEvaluatable
  import com.soren.exib.debug.Log
  import com.soren.exib.model.Model
  import com.soren.util.ExtendedArray
  import com.soren.util.StringUtil

  public class TextNode extends Node {
    
    private var _arguments:Array
    private var _align:String
    private var _charcase:uint
    private var _content:String
    private var _format:TextFormat
    private var _height:uint
    private var _text_field:TextField
    private var _width:uint
    
    /**
    * Construct a new text node. If a set of arguments is provided the node is
    * treated as dynamic, otherwise it will be static - meaning it always shows
    * the same content.
    * 
    * @param  content   A string that can either be static or use a token system
    *                   for conversion, replacement, time, etc. If arguments are
    *                   provided the node will expect to find valid replacement
    *                   tokens.
    * @param  format    A Flash text format.
    * @param  arguments An array of IEvaluatable objects that will be used for
    *                   token substitution.
    * @param  align     The text nodes alignment. LEFT, CENTER, and RIGHT are
    *                   valid.
    **/
    public function TextNode(content:String, format:TextFormat,
                             arguments:Array = null, align:String = 'LEFT') {
      
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
    * Set the text node's alignment.
    * 
    * @param  align
    **/
    public function set align(align:String):void {
      var pattern:RegExp = /^(left|center|right)$/i
      if (pattern.test(align)) { _align = align.toUpperCase() }
      else                     { throw new Error("Invalid alignment: " + align) }
    }
    
    /**
    * Set an array of arguments that will be used for token replacement. If these
    * are provided it is expected that the node has a matching number of tokens.
    * 
    * @param  arguments
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
    * A charcase token that will be used to convert all text that the node displays.
    * 
    * @param charcase
    * 
    * @see com.soren.util.StringUtil.casefix()
    **/
    public function set charcase(charcase:String):void {
      var charmap:Object = { l: StringUtil.LOWER, u: StringUtil.UPPER, s: StringUtil.SENTENCE, t: StringUtil.TITLE }
      var resolved:uint  = charmap[charcase]
      
      if (resolved) { _charcase = resolved }
      else          { throw new Error('Invalid character case: ' + charcase) }
    }
    
    /**
    * Set the content that will be displayed. To use token replacement a matching
    * number of arguments must be provided as well.
    * 
    * @param  content
    **/
    public function set content(content:String):void {
      _content = content
    }
    
    /**
    * Set a new format for the node to use. Note that the format change won't be
    * evident until update is called.
    * 
    * @param  format
    **/
    public function set format(format:TextFormat):void {
      _format = format
    }
    
    /**
    * Set the height of the internal text node.
    **/
    override public function set height(height:Number):void {
      _height = height
    }
    
    /**
    * Set the width of the internal text node. Particularly useful when centering
    * content.
    **/
    override public function set width(width:Number):void {
      _width = width
    }
    
    /**
    * Force the node to update its display.
    **/
    override public function update():void {
      applySizing()
      applyAlignment()
      applyContent()
      applyFormat()
    }
    
    // ---
    
    /**
    * Apply text field alignment.
    **/
    private function applyAlignment():void {
      switch(_align) {
        case 'LEFT':
          if (_width) { _format.align = TextFormatAlign.LEFT          }
          else        { _text_field.autoSize = TextFieldAutoSize.LEFT }
          break
        case 'CENTER':
          if (_width) { _format.align = TextFormatAlign.CENTER          }
          else        { _text_field.autoSize = TextFieldAutoSize.CENTER }
          break
        case 'RIGHT':
          if (_width) { _format.align = TextFormatAlign.RIGHT          }
          else        { _text_field.autoSize = TextFieldAutoSize.RIGHT }
          break
      }
    }

    /**
    * Updates the text. Will perform token replacement and case conversion as
    * necessary.
    **/
    private function applyContent():void {
      var new_text:String = _content
      
      if (hasTokens())   new_text = StringUtil.format(new_text, _arguments.map(extractValues))
      if (hasCharcase()) new_text = StringUtil.casefix(new_text, _charcase)
      
      _text_field.text = new_text
    }

    /**
    * Apply the stored format to this node's text field.
    **/
    private function applyFormat():void {
      _text_field.setTextFormat(_format)
    }
    
    /**
    * Apply the width and height, if present.
    **/
    private function applySizing():void {
      if (_height) _text_field.height = _height
      if (_width)  _text_field.width  = _width
    }
    
    /**
    * Determine whether this node should have character case conversion applied.
    **/
    private function hasCharcase():Boolean {
      return (_charcase != undefined) ? false : true
    }
    
    /**
    * Determine whether this node has any replacement tokens
    **/
    private function hasTokens():Boolean {
      var pattern:RegExp = /%[a-z0-9{}]+/g
      return pattern.test(_content)
    }
    
    /**
    * Map function for extracting the values from an array of IEvaluatable objects.
    **/
    private function extractValues(object:*, index:int, array:Array):* {
      return (object is IEvaluatable) ? object.value : object
    }
  }
}
