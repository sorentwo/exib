/**
* A simplified button class that holds action sets for press and release states.
* An up and a down url must be provided, though if they are the same only one
* will be used. A hit test object sits as the top most layer, allowing additional
* nodes to be added as the child of the button node.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.events.Event
  import flash.events.MouseEvent
  import com.soren.exib.helper.ActionSet
  import com.soren.exib.debug.Log
  
  public class ButtonNode extends Node {

    protected var _hit_test:VectorNode
    protected var _down_graphic:GraphicNode
    protected var _up_graphic:GraphicNode
    protected var _press_set:ActionSet
    protected var _release_set:ActionSet
    
    /**
    * Create a new button node.
    * 
    * @param  up_url      The url of a graphic that will be used as the up state.
    * @param  down_url    The url of a graphic that will be used as the down
    *                     state. If it is the same as up only one graphic will
    *                     be used.
    * @param  press_set   An action set. Between press and release there must be
    *                     at least one action.
    * @param  release_set An action set. Between press and release there must be
    *                     at least one action.
    **/
    public function ButtonNode(up_url:String, down_url:String,
                               press_set:ActionSet, release_set:ActionSet) {
      
      _hit_test = new VectorNode('rectangle', { width: 10, height: 10, alpha: 0 })
      _hit_test.buttonMode    = true
      _hit_test.useHandCursor = true
      
      _hit_test.addEventListener(MouseEvent.MOUSE_DOWN, actOnMouseDown)
      _hit_test.addEventListener(MouseEvent.MOUSE_UP,   actOnMouseUp)
      _hit_test.addEventListener(MouseEvent.MOUSE_OUT,  actOnMouseOut)
      
      this.addChild(_hit_test)
      this.addEventListener(Event.ADDED, manageHitTest)
      
      loadGraphics(up_url, down_url)
      assignActionSets(press_set, release_set)
    }
    
    // ---
    
    /**
    * Loads the up and down graphics.
    **/
    protected function loadGraphics(up_url:String, down_url:String):void {
      _up_graphic   = new GraphicNode(up_url)
      _down_graphic = new GraphicNode(down_url)
      
      _hit_test.height = (_up_graphic.height > _down_graphic.height) ? _up_graphic.height : _down_graphic.height
      _hit_test.width  = (_up_graphic.width > _down_graphic.width)   ? _up_graphic.width  : _down_graphic.width
      
      this.addChild(_up_graphic)
    }
    
    /**
    * Handles the mouse down, or press, event.
    **/
    protected function actOnMouseDown(event:MouseEvent):void {
      this.removeChild(_up_graphic)
      this.addChildAt(_down_graphic, 0)
      
      if (_press_set) _press_set.act()
    }
    
    /**
    * Handles the mouse out event. Ensures button-like behavior.
    **/
    protected function actOnMouseOut(event:MouseEvent):void {
      if (this.contains(_down_graphic)) this.removeChild(_down_graphic)
      if (!this.contains(_up_graphic))  this.addChildAt(_up_graphic, 0)
    }
    
    /**
    * Handles the mouse up, or release, event.
    **/
    protected function actOnMouseUp(event:MouseEvent):void {
      if (this.contains(_down_graphic)) this.removeChild(_down_graphic)
      if (!this.contains(_up_graphic))  this.addChildAt(_up_graphic, 0)
      
      if (_release_set) _release_set.act()
    }
    
    /**
    * Ensures that the _hit_test object remains at the top-most index.
    **/
    protected function manageHitTest(event:Event):void {
      this.setChildIndex(_hit_test, this.numChildren - 1)
    }
    
    /**
    * Examines both sets of actions to ensure there is a mimimum of one action.
    **/
    protected function assignActionSets(press_set:ActionSet, release_set:ActionSet):void {
      var valid_sets:uint = 0
      
      if (press_set && !press_set.isEmpty()) {
        _press_set = press_set
        valid_sets ++
      }
      
      if (release_set && !release_set.isEmpty()) {
        _release_set = release_set
        valid_sets ++
      }
      
      if (valid_sets < 1) throw new Error("ButtonNode: Not enough actions provided.")
    }
    
  }
}