/**
* ButtonNode
*
* Utilizes both the SimpleButton class and GraphicNodes to create a more
* convenient button class.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.display.SimpleButton
  import flash.events.MouseEvent
  import com.soren.exib.helper.ActionSet
  
  public class ButtonNode extends Node {

    protected var _button:SimpleButton
    protected var _up_graphic:GraphicNode
    protected var _down_graphic:GraphicNode
    protected var _press_set:ActionSet
    protected var _release_set:ActionSet
    
    /**
    * Constructor
    **/
    public function ButtonNode(up_url:String, down_url:String,
                               press_set:ActionSet, release_set:ActionSet) {
      _button = new SimpleButton()
      _button.useHandCursor = true
      
      _button.addEventListener(MouseEvent.MOUSE_DOWN, actOnPress)
      _button.addEventListener(MouseEvent.MOUSE_UP, actOnRelease)
      
      this.addChild(_button)
      
      loadGraphics(up_url, down_url)
      assignActionSets(press_set, release_set)
    }
    
    // ---
    
    /**
    **/
    protected function loadGraphics(up_url:String, down_url:String):void {
      _up_graphic   = new GraphicNode(up_url)
      
      if (up_url != down_url) _down_graphic = new GraphicNode(down_url)

      _button.upState   = _button.overState = _button.hitTestState = _up_graphic
      _button.downState = _down_graphic || _up_graphic
    }
    
    /**
    **/
    protected function actOnPress(event:MouseEvent):void {
      if (_press_set) _press_set.act()
    }
    
    /**
    **/
    protected function actOnRelease(event:MouseEvent):void {
      if (_release_set) _release_set.act()
    }
    
    /**
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
