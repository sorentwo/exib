/**
* MeterNode
*
* Used to create a multi part meter, or a segmented set of graphics than can be
* either full or empty. The minimum number of parts is three, with a maximum
* amount only limited by the display area available.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.events.Event
  import com.soren.exib.debug.Log
  import com.soren.exib.model.Model
  import com.soren.exib.model.ValueModel
  
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
    
    private var _spacing:int        = 0
    private var _full_segments:uint = 0
    private var _segments:uint      = 0
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
      
      _segments = segments
      _spacing  = spacing
      
      // One for left empty, full, right empty, full
      _total_assets = 4
      
      _left_empty  = new GraphicNode(left_empty_url)
      _left_full   = new GraphicNode(left_full_url)
      _right_empty = new GraphicNode(right_empty_url)
      _right_full  = new GraphicNode(right_full_url)
      
      var middle_segments:uint = this.segments - 2
      for (var i:int = 0; i < middle_segments; i++) {        
        _mid_empties.push(new GraphicNode(mid_empty_url))
        _mid_fulls.push(new GraphicNode(mid_full_url))
        
        // One for each mid, empty and full
        _total_assets += 2
      }

      addRemoveListeners([_left_full, _left_empty, _right_empty, _right_full], true)
      addRemoveListeners(_mid_empties.concat(_mid_fulls), true)
    }
    
    /**
    * Set a new Value Model to track.
    **/
    public function set model(model:ValueModel):void {
      _value_model.removeEventListener(Model.CHANGED, changeListener)
      _value_model = model
      _value_model.addEventListener(Model.CHANGED, changeListener)
      
      // Die silently if assets aren't finished loading.
      try {
        update()
      } catch (e:Error) {}
    }
    
    /**
    * Returns the current Value Model.
    **/
    public function get model():ValueModel {
      return _value_model
    }
    
    /**
    * Set the total number of segments that will be used. This number includes
    * the left, right, and middle segments.
    **/
    public function set segments(segments:uint):void {
      if (segments < MIN_SEGMENTS) throw new Error('Meter Node: Minimum Segments = ' + MIN_SEGMENTS)
      _segments = segments
      
      // Die silently, update isn't possible if assets aren't loaded.
      try {
        update()
      } catch (e:Error) {}
    }
    
    /**
    * Returns the currently set number of segments.
    **/
    public function get segments():uint {
      return _segments
    }
    
    /**
    * Set the spacing between segments. This can be a negative value to pack
    * segments closer together.
    **/
    public function set spacing(spacing:int):void {
      _spacing = spacing
      
      // Die silently on a position / update if this is triggered before assets
      // are loaded.
      try {
        positionAssets()
        update()
      } catch (e:Error) {}
    }
      
    /**
    * Returns the current spacing.
    **/
    public function get spacing():int {
      return _spacing
    }
    
    /**
    * Read Only. Returns the calculated number of full segments. For example,
    * with a supplied value model with a maximum of 10, a current value of 5,
    * and 6 segments total—the +full+ value returned would be 3.
    **/
    public function get full():uint {
      return _full_segments
    }
    
    /**
    * Read Only. Returns the number of segments that will appear empty. This is
    * the number of total segments minus the number of full segments.
    **/
    public function get empty():uint {
      return _segments - _full_segments
    }

    override public function update():void {
      calculateFullSegments()
      showMeterLevel()
    }
      
    // ---
    
    /**
    * @private
    * 
    * Places all empty and full segments according to the number of segments and
    * spacing. Assets remain hidden after placement.
    **/
    protected function positionAssets():void {
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
    }
    
    /**
    * @private
    **/
    protected function showMeterLevel():void {
      while (this.numChildren > 0) { removeChildAt(0) }
      
      var to_add:Array = []
      if (_full_segments == _segments) {
        to_add = [_left_full, _right_full].concat(_mid_fulls)
      } else if (_full_segments == 0) {
        to_add = [_left_empty, _right_empty].concat(_mid_empties)
      } else {
        to_add = [_left_full, _right_empty]
        to_add = to_add.concat(_mid_fulls.slice(0, _full_segments - 1))
        to_add = to_add.concat(_mid_empties.slice(_full_segments - 1, _mid_empties.length))
      }
      
      for each (var node:GraphicNode in to_add) { this.addChild(node) }
    }
  
    /**
    * @private
    **/
    protected function calculateFullSegments():void {
      _full_segments = uint(_segments * ((_value_model.value - _value_model.min) / (_value_model.max - _value_model.min)))
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
        update()
      }
    }
  }
}
