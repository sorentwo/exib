/**
* DialNode
*
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
    private var _snaps:Array     = []

    private var _delta:uint        = 0
    private var _current_snap:uint = 0

    /**
    * Constructor
    **/
    public function DialNode(graphic_url:String) {
      _graphic = new GraphicNode(graphic_url)
      _graphic.addEventListener(Event.ADDED, positionGraphic)

      _container = new Node()
      _container.addChild(_graphic)
      this.addChild(_container)

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
    * @param  position_action Any number of action sets that will be executed
    *                         when the dial is in the corresponding position.
    **/
    public function add(...action_sets):void {
      for each (var action_set:ActionSet in action_sets) {
        _positions.push(action_set)
      }

      var snap:uint = Math.ceil(360 / _positions.length)
      var x:int = 0
      _snaps = [x]

      while (x < (360 - snap)) { _snaps.push(x += snap) }

      snap *= .5
      _delta = snap == int(snap) ? snap : int(snap) + 1
    }

    // ---

    /**
    * @private
    **/
    private function convertAngle(angle:int):uint {
      var converted:int = 0

      if (angle < 0) { converted = 270 + angle }
      else           { converted = angle - 90  }

      if (converted < 0) converted = 360 + converted

      return converted
    }

    /**
    * @private
    **/
    private function mouseDownHandler(event:MouseEvent):void {
    	this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
    }

    /**
    * @private
    **/
    private function mouseMoveHandler(event:MouseEvent):void {
    	var angle:int = convertAngle(int(Math.atan2((_graphic.height * .5) - event.localY, (_graphic.width * .5) - event.localX) * 57.2957))
    	var snap:uint = snapTo(angle)

    	if (snap != _current_snap) {
        _container.rotation = snap
    	  _current_snap = snap
    	  _positions[_snaps.indexOf(snap)].act()
    	}
    }

    /**
    * @private
    **/
    private function mouseUpHandler(event:MouseEvent):void {
      this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
    }

    /**
    * @private
    *
    * Handle node creation piggybacks off of this
    **/
    private function positionGraphic(event:Event):void {
      _graphic.x -= _graphic.width * .5
      _graphic.y -= _graphic.height * .5

      _handle       = new VectorNode('circle', { radius: _graphic.width * .5 })
      _handle.x    -= _handle.width * .5
      _handle.y    -= _handle.height * .5
      _handle.alpha = .1

      this.addChild(_handle)

      _handle.buttonMode    = true
      _handle.useHandCursor = true
    }

    /**
    * @private
    **/
    private function snapTo(angle:uint):uint {
      var matched_snap:uint = NaN

      for (var i:int = 0; i < _snaps.length; i++) {
        var snap:uint = _snaps[i]

        if ((angle >= snap) && (angle < (snap + _delta))) {
          matched_snap = snap
          break
        } else if ((angle < snap) && (angle >= (snap - _delta))) {
          matched_snap = snap
          break
        } else if (angle > (360 - _delta)) {
          matched_snap = 0
          break
        }
      }

      return matched_snap
    }
  }
}
