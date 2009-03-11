/**
* MeterNode
*
* Used to create a multi part meter, or a segmented set of graphics than can be
* either full or empty. The minimum number of parts is three, with a maximum
* amount only limited by the display area available.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.view {

  import flash.events.Event
  import com.soren.exib.model.Model
  import com.soren.exib.model.ValueModel
  import com.soren.math.AdvancedMath
  
  public class MeterNode extends Node {
    
    private const MIN_SEGMENTS:uint    = 3
    private const DEFAULT_SPACING:uint = 0
    
    private var _value_model:ValueModel
    
    private var _left_empty:GraphicNode
    private var _left_full:GraphicNode
    private var _right_empty:GraphicNode
    private var _right_full:GraphicNode
    
    private var _mid_empties:Array = []
    private var _mid_fulls:Array   = []
    
    private var _units:uint         = 0
    private var _segments:uint      = 0
    private var _spacing:int        = 0
    private var _total_assets:uint  = 0
    private var _assets_loaded:uint = 0
    
    /**
    * Constructor
    **/
    public function MeterNode(value_model:ValueModel,
                              left_empty_url:String,  left_full_url:String,
                              mid_empty_url:String,   mid_full_url:String,
                              right_empty_url:String, right_full_url:String,
                              segments:uint = MIN_SEGMENTS,
                              spacing:int   = DEFAULT_SPACING) {
      
      _value_model = value_model
      _value_model.addEventListener(Model.CHANGED, changeListener)
      
      this.segments = segments
      this.spacing  = spacing
      _total_assets = 4 // One for left empty, full, right empty, full
      
      _left_empty  = new GraphicNode(left_empty_url)
      _left_full   = new GraphicNode(left_full_url)
      _right_empty = new GraphicNode(right_empty_url)
      _right_full  = new GraphicNode(right_full_url)
      
      var middle_segments:uint = this.segments - 2
      for (var i:int = 0; i < middle_segments; i++) {        
        _mid_empties.push(new GraphicNode(mid_empty_url))
        _mid_fulls.push(new GraphicNode(mid_full_url))
        
        _total_assets += 2 // One for each mid, empty and full
      }

      addRemoveListeners([_left_full, _left_empty, _right_empty, _right_full], true)
      addRemoveListeners(_mid_empties.concat(_mid_fulls), true)
    }
    
    /**
    **/
    public function set segments(segments:uint):void {
      if (segments < MIN_SEGMENTS) throw new Error("Meter Node: Minimum Segments = " + MIN_SEGMENTS)
      _segments = segments
    }
    
    /**
    **/
    public function get segments():uint {
      return _segments
    }
    
    /**
    **/
    public function set spacing(spacing:int):void {
      _spacing = spacing
    }
      
    /**
    **/
    public function get spacing():int {
      return _spacing
    }
    
    /**
    * Read Only. Set by the supplied ValueModel.
    **/
    public function get units():uint {
      return _units
    }
    
    /**
    **/
    override public function update():void {
      showMeterLevel()
    }
        
    // ---
    
    /**
    * @private
    **/
    private function addRemoveListeners(nodes:Array, add:Boolean):void {
      for each (var node:GraphicNode in nodes) {
        if (add) { node.addEventListener(Event.ADDED, assetLoadedListener)    }
        else     { node.removeEventListener(Event.ADDED, assetLoadedListener) }
      }
    }
    
    /**
    * @private
    **/
    private function assetLoadedListener(event:Event):void {
      _assets_loaded += 1
      
      if (_assets_loaded == _total_assets) {
        addRemoveListeners([_left_full, _left_empty, _right_empty, _right_full], false)
        addRemoveListeners(_mid_empties.concat(_mid_fulls), false)
        positionAssets()
      }
    }
      
    /**
    * @private
    **/
    private function positionAssets():void {
      var current_x:uint = 0
      
      _left_empty.x = _left_full.x = current_x
      
      for (var i:int = 0; i < _mid_empties.length; i++) {
        current_x = _left_empty.width
                  + (i * _mid_empties[i].width)
                  + ((i + 1) * _spacing)
                  
        _mid_empties[i].x = _mid_fulls[i].x = current_x
      }
      
      current_x = _mid_empties[_mid_empties.length - 1].x
                + _mid_empties[0].width
                + _spacing
      
      _right_empty.x = _right_full.x = current_x
      
      showMeterLevel()
    }
    
    /**
    * @private
    **/
    private function showMeterLevel():void {
      while (this.numChildren > 0) { removeChildAt(0) }
      
      var raw_val:int = _value_model.value
      var max_val:int = _value_model.max
      
      _units = uint(_segments * (raw_val / max_val))
      
      var to_add:Array = []
      if (_units == _segments) {
        to_add = [_left_full, _right_full].concat(_mid_fulls)
      } else if (_units == 0) {
        to_add = [_left_empty, _right_empty].concat(_mid_empties)
      } else {
        to_add = [_left_full, _right_empty]
        to_add = to_add.concat(_mid_fulls.slice(0, _units - 1))
        to_add = to_add.concat(_mid_empties.slice(_units - 1, _mid_empties.length))
      }
      
      for each (var node:GraphicNode in to_add) { this.addChild(node) }
    }
  }
}
