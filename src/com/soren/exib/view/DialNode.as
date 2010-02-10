/**
* Creates a graphical dial that can be spinned to a limited set of positions.
* Positions are added by supplying a new ActionSet. For each new position added
* the circle of travel will be divided evenly by one more. For example, adding
* four ActionSets would yield fixed positions at 0 (north), 90 (east), 180 (south),
* and 270 (west).
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.events.Event
  import flash.events.MouseEvent
  import com.soren.exib.helper.ActionSet

  public class DialNode extends Node {

    private var _graphic:GraphicNode
    private var _container:Node
    private var _handle:VectorNode

    private var _positions:Array = []

    private var _current_snap:uint = 0
    private var _last_snap:uint    = 0

    /**
    * Create a new dial instance by providing the url of the graphic to be used
    * as the dial.
    * 
    * @param  graphic_url URL of the graphic to use for the dial
    **/
    public function DialNode(graphic_url:String) {
      _graphic = new GraphicNode(graphic_url)
      _graphic.addEventListener(Event.ADDED, positionGraphic)

      _container = new Node()
      _container.addChild(_graphic)
      this.addChildAt(_container, 0) // Placed at the back, vector on top

      this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler)
      this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler)
      this.addEventListener(MouseEvent.ROLL_OUT, mouseUpHandler)
    }

    /**
    * Add a new position by supplying a value. Each position added divides the
    * dial's travel by one more. For example, for one position added the dial
    * would point north and not travle at all, for two positions the dial would
    * travel between pointing north and south, for four positions the dial would
    * point the north, east, south, and west.
    *
    * @param  action_set Any number of action sets that will be executed when the
    *                    dial is in the corresponding position.
    **/
    public function add(snap:uint,
                        ambiguous:ActionSet = null,
                        clockwise:ActionSet = null,
                        counter:ActionSet   = null):void {
      
      verifyMinimumAction(ambiguous, clockwise, counter)
      verifySnap(snap)
      
      _positions.push(new DialPositionInfo(snap, ambiguous, clockwise, counter))
      _positions.sortOn('snap', Array.NUMERIC)
      
      calculateGrabAngles()
    }
    
    /**
    * Tells how many possible dial positons the instance has.
    * 
    * @return Number of positions
    **/
    public function get numPositions():int {
      return _positions.length
    }
    
    // ---
    
    /**
    * Calculate the grab angle before and after each snap.
    **/
    private function calculateGrabAngles():void {
      var prev_snap:int, next_snap:int
      
      for (var i:int = 0; i < _positions.length; i++) {
        if (_positions.length == 1) {
          prev_snap = _positions[i].snap
          next_snap = _positions[i].snap
        } else if (_positions.length > 1 && i == 0) {
          prev_snap = _positions[_positions.length - 1].snap - 360
          next_snap = _positions[i + 1].snap
        } else if (_positions.length > 1 && i == _positions.length - 1) {
          prev_snap = _positions[i - 1].snap
          next_snap = 360 + _positions[0].snap
        } else {
          prev_snap = _positions[i - 1].snap
          next_snap = _positions[i + 1].snap
        }
        
        _positions[i].preceding  = (_positions[i].snap - prev_snap) * .5
        _positions[i].anteceding = (next_snap - _positions[i].snap) * .5
      }
    }
    
    /**
    * Convert the supplied angle from a positive or negative 180 to a 360 scale.
    **/
    private function convertAngle(angle:int):uint {
      var converted:int = 0

      if (angle < 0) { converted = 270 + angle }
      else           { converted = angle - 90  }

      if (converted < 0) converted = 360 + converted

      return converted
    }

    private function mouseDownHandler(event:MouseEvent):void {
    	this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
    }

    private function mouseMoveHandler(event:MouseEvent):void {
    	var angle:int = convertAngle(int(Math.atan2((_graphic.height * .5) - event.localY, (_graphic.width * .5) - event.localX) * 57.2957))
    	var snap:uint = snapTo(angle)
      
      var clockwise:Boolean
      clockwise = (snap > _last_snap)
                ? (_last_snap == _positions[0].snap && snap == _positions[_positions.length - 1].snap) ? false : true
                : (snap == _positions[0].snap && _last_snap == _positions[_positions.length - 1].snap) ? true  : false
                
      _last_snap = snap
      
    	if (snap != _current_snap) {
        _container.rotation = snap
    	  _current_snap = snap
    	  
    	  for each (var position:DialPositionInfo in _positions) { if (position.snap == snap) break }
    	  
    	  position.ambiguous.act()
    	  if (clockwise  && position.clockwise) position.clockwise.act()
    	  if (!clockwise && position.counter)   position.counter.act()
    	}
    }

    private function mouseUpHandler(event:MouseEvent):void {
      this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
    }

    /**
    * Position the dial graphic and place a control handle on top of it.
    * Note: Handle node creation piggybacks off of this
    **/
    private function positionGraphic(event:Event):void {
      _graphic.x -= _graphic.width * .5
      _graphic.y -= _graphic.height * .5

      _handle       = new VectorNode('circle', { radius: _graphic.width * .5 })
      _handle.x    -= _handle.width * .5
      _handle.y    -= _handle.height * .5
      _handle.alpha = 0
      
      this.addChild(_handle)

      _handle.buttonMode    = true
      _handle.useHandCursor = true
    }

    /**
    * Pulls an angle to its closest snap point
    **/
    private function snapTo(angle:uint):uint {
      var matched_snap:uint

      for (var i:int = 0; i < _positions.length; i++) {
        var snap:uint = _positions[i].snap
        var pre:uint  = _positions[i].preceding
        var ant:uint  = _positions[i].anteceding
        
        if ((angle >= snap) && (angle < (snap + ant))) {
          matched_snap = snap
          break
        } else if ((angle < snap) && (angle >= (snap - pre))) {
          matched_snap = snap
          break
        } else if (angle > (360 - _positions[0].preceding)) {
          matched_snap = _positions[0].snap
          break
        }
      }

      return matched_snap
    }
    
    /**
    * Verify that of 3 supplied action sets at least one is not null and has at
    * least one action.
    **/
    private function verifyMinimumAction(a:ActionSet, b:ActionSet, c:ActionSet):void {
      if (!a && !b && !c) {
        throw new Error('No Valid Actions: You must supply at least one action set')
      }
      
      if ((a && a.isEmpty()) && (b && b.isEmpty()) && (c && c.isEmpty())) {
        throw new Error('Not Enough Actions: You must supply at least one action')
      }
    }
    
    /**
    * Verify that the provided snap isn't already used with this dial.
    **/
    private function verifySnap(snap:uint):void {
      if (snap > 360) throw new Error('Snap angle greater than 360: ' + snap)
      
      for each (var position:DialPositionInfo in _positions) {
        if (position.snap == snap) throw new Error('Snap already used: ' + snap)
      }
    }
  }
}
