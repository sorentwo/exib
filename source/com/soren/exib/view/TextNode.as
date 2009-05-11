/**
* TextNode
* 
* A dynamic and updatable text field contained within the standard <code>Node</code> 
* class.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.text.AntiAliasType
  import flash.text.TextFieldAutoSize
  import flash.text.TextField
  import flash.text.TextFormat
  import com.soren.exib.core.IEvaluatable
  import com.soren.exib.model.Model
  import com.soren.util.StringUtil

  public class TextNode extends Node {
    
    private var _text_field:TextField = new TextField()
    
    private var _arguments:Array
    private var _charcase:String
    private var _content:String
    
    /**
    * Construct a new text node. If a set of arguments is provided the node is
    * treated as dynamic, otherwise it will be static - meaning it always shows
    * the same content.
    * 
    * @param  content   A string that can either be static or use a token system
    *                   for conversion, replacement, time, etc. If arguments are
    *                   provided the node will expect to find valid replacement
    *                   tokens.
    * @param  format    An instance of the flash.text.TextFormat class.
    * @param  arguments An array of objects that will be used for token 
    *                   substitution. If an object is IEvaluatable its returned
    *                   value will be used for substitution.
    * @param  width     The text fields width. The node itself will resize to
    *                   fit. If set to <code>null</code> the stage width is used.
    * @param  height    The text fields height. The node itself will resize to 
    *                   fit. If set to <code>null</code> the stage height is used.
    * @param  charcase  Applies universal case changing to the text. If set to
    *                   <code>null</code> no change will be made to the text.
    *                   For valid charcase values see com.soren.util.StringUtil.casefix().
    * @param  wordwrap  A Boolean value that indicates whether the text field 
    *                   has word wrap. Note that if wordwrap is set to true then
    *                   the text will automatically be made multiline. The
    *                   default value is <code>false</code>.
    **/
    public function TextNode(content:String, format:TextFormat,
                             arguments:Array = null, width:uint = 0,
                             height:uint = 0, charcase:String = null,
                             wordwrap:Boolean = false) {
      
      _text_field.antiAliasType = AntiAliasType.ADVANCED
      _text_field.embedFonts    = true
      _text_field.selectable    = false
      
      _text_field.defaultTextFormat = format
      _text_field.multiline = wordwrap
      _text_field.wordWrap  = wordwrap
      
      if (height != 0) { _text_field.height = height }
      if (width != 0)  { _text_field.width  = width  }
      else             { _text_field.autoSize = TextFieldAutoSize.LEFT }
      
      _content   = content
      _charcase  = charcase
      _arguments = arguments || []
      
      registerArguments()
      this.addChild(_text_field)
      update()
    }
    
    /**
    * Force the node to update its display.
    **/
    override public function update():void {
      applyContent()
    }
    
    // ---

    /**
    * Updates the text. Will perform token replacement and case conversion as
    * necessary.
    **/
    private function applyContent():void {
      var new_text:String = _content
      
      if (hasTokens()) {
        var _format_args:Array = _arguments.map(extractValues)
            _format_args.unshift(new_text)
            
        new_text = StringUtil.format.apply(null, _format_args)
      }
      
      if (hasCharcase()) new_text = StringUtil.casefix(new_text, _charcase)

      _text_field.text = new_text
    }
    
    /**
    * Map function for extracting the values from an array of IEvaluatable objects.
    **/
    private function extractValues(object:*, index:int, array:Array):* {
      return (object is IEvaluatable) ? object.value : object
    }
    
    /**
    * Determine whether this node should have character case conversion applied.
    **/
    private function hasCharcase():Boolean {
      return (_charcase == null) ? false : true
    }
    
    /**
    * Determine whether this node has any replacement tokens
    **/
    private function hasTokens():Boolean {
      var pattern:RegExp = /%[a-z0-9{}]+/g
      return pattern.test(_content)
    }
    
    /**
    * Ensure that each argument, if a model, is being listened to.
    **/
    private function registerArguments():void {
      for each (var argument:* in _arguments) {
        if (argument is IEvaluatable) {
          argument.addEventListener(Model.CHANGED, changeListener)
        }
      }
    }
  }
}
