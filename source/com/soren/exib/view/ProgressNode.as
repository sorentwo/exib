/**
* ProgressNode
*
* A dynamic progress bar based on the value retrieved from a ValueModel.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.events.Event
  import com.soren.exib.model.Model
  import com.soren.exib.model.ValueModel
  
  public class ProgressNode extends Node {
    
    private const DEFAULT_LENGTH:uint = 100
    
    private var _value_model:ValueModel
    private var _fill_graphic:GraphicNode
    private var _bar_length:uint
    private var _progress:uint
    
    /**
    * Constructor
    **/
    public function ProgressNode(value_model:ValueModel,
                                 fill_url:String,
                                 bar_length:uint = DEFAULT_LENGTH) {
      _value_model = value_model
      _value_model.addEventListener(Model.CHANGED, changeListener)
      
      _fill_graphic = new GraphicNode(fill_url)
      _fill_graphic.addEventListener(Event.ADDED, assetLoadedListener)
      this.addChild(_fill_graphic)
      
      _bar_length = bar_length
      
      update()
    }
    
    /**
    **/
    public function get progress():uint {
      return _progress
    }
    
    /**
    **/
    override public function update():void {
      showProgressLevel()
    }
    
    // ---
    
    /**
    * @private
    **/
    private function assetLoadedListener(event:Event):void {
      _fill_graphic.removeEventListener(Event.ADDED, assetLoadedListener)
      showProgressLevel()
    }
    
    /**
    * @private
    **/
    private function showProgressLevel():void {
      _progress = (_value_model.value == 0)
                ? 0
                : _bar_length * (_value_model.value / _value_model.max)

      _fill_graphic.scaleX = _progress
    }
  }
}
