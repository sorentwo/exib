/**
* ScreenController
*
* Manages the state of screens, their storage and retrieval, as well as providing
* an interface for handling screen changes. If an instance is constructed with
* an manager tied to effects then effects may be used.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.view {
  
  import flash.display.Sprite
  import flash.events.Event
  import flash.events.EventDispatcher
  import com.soren.exib.helper.IActionable
  import com.soren.exib.manager.Manager
  import com.soren.exib.model.Model  
  import com.soren.exib.model.HistoryModel

  public class ScreenController extends EventDispatcher implements IActionable {

    private static const EVENT_TYPE:String = Model.CHANGED
    
    private var _screen_container:Sprite
    private var _screen_manager:Manager
    private var _screen_model:HistoryModel
    
    /**
    * Constructor
    * 
    * @param  screen_container  The parent container where all child nodes will
    *                           be added
    * @param  screen_history    The length of history to keep
    **/
    public function ScreenController(screen_container:Sprite, screen_history:uint = 3) {
      _screen_container = screen_container
      instantiateHistoryAndManager(screen_history)
    }
    
    /**
    **/
    public function get current():ScreenNode {
      return _screen_manager.get(_screen_model.current)
    }
    
    /**
    **/
    public function get idOfCurrent():String {
      return _screen_model.current
    }
    
    /**
    **/
    public function get idOfPrevious():String {
      return _screen_model.previous
    }
      
    /**
    **/
    public function get value():String {
      return this.idOfCurrent
    }
    
    /**
    * Add a screen for management and control.
    **/
    public function add(screen:ScreenNode, screen_id:String):void {
      _screen_model.add(screen_id)
      _screen_manager.add(screen, screen_id)
    }
         
    /**
    * Shortcut for unloading the current screen and loading the next
    **/
    public function go(screen_id:String):void {
      unload()
      load(screen_id)
    }
    
    /**
    **/
    public function load(screen_id:String):void {
      //if (_screen_model.current == screen_id.toLowerCase()) return
      _screen_model.set(screen_id)
      _screen_container.addChild(this.current)
      
      dispatch()
    }
    
    /**
    * Shortcut for go(this.previous)
    **/
    public function previous():void {
      go(idOfPrevious)
    }
    
    /**
    **/
    public function unload():void {
      while (_screen_container.numChildren > 0) { _screen_container.removeChildAt(0) }
      dispatch()
    }
    
    // ---
    
    /**
    * @private
    **/
    private function instantiateHistoryAndManager(screen_history:uint):void {
      _screen_model     = new HistoryModel(screen_history)
      _screen_manager   = new Manager()
    }
    
    /**
    * @private
    **/
    private function dispatch():void {
      dispatchEvent(new Event(EVENT_TYPE))
    }
  }
}
