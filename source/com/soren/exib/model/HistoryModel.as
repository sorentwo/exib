/**
* HistoryModel
*
* The HistoryModel class is largely identical to StateModel, though because it is
* only utilizing some core features of StateModel it does *not* extend it, and as
* such has a more limited interface.
* 
* <p>Like StateModel, HistoryModel keeps track of a set of states (strings). The
* HistoryModel keeps track of all <b>previous</b> states as well.</p>
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.model {
  
  import com.soren.exib.core.IActionable
  
  public class HistoryModel extends Model {
    
    private var _states:Array          = []
    private var _state_pointer:uint    = 0
    private var _pointer_history:Array = []
    private var _history_length:uint   = 3

    /**
    * Constructor
    * 
    * @param  history_length  The number of previous states to remember, greater
    *                         than 0
    * @param  args            Any number of initial states
    **/
    public function HistoryModel(history_length:uint, ...args) {
      if (history_length > 0) _history_length = history_length
      
      for each (var state:String in args) {
        this.add(state)
      }
      
      _pointer_history.unshift(0) // Ensure there is at least one item
    }
    
    /**
    * Set the model's state to any of the states that have been registered
    * for the model. Attempting to set it to a state that doesn't exist will
    * throw an error.
    * 
    * @param  value A string representing the name of a state
    **/
    public override function set value(value:*):void {
      value = value.toLowerCase()
      
      var index:int = _states.indexOf(value)
      
      if (index == -1) {
        throw new Error("State: " + value + " was not found")
      } else {
        this.pointer = index
      }
    }
    
    /**
    * Returns the currently active state of the model.
    **/
    public override function get value():* {
      return (_states[_state_pointer]) ? _states[_state_pointer] : ''
    }
    
    /**
    * 
    **/
    public function get current():String {
      return this.value
    }
    
    /**
    * 
    **/
    public function get previous():String {
      return (_pointer_history.length > 0) ? _states[_pointer_history[1]] : this.value
    }
     
    /**
    * 
    **/
    public function add(state:String):void {
      state = state.toLowerCase()
      
      if (_states.indexOf(state) != -1) {
        throw new Error("State name: " + state + " already exists")
      } else {
        _states.push(state)
      }
    }
    
    /**
    * 
    **/
    public function purge():void {
      _pointer_history = []
    }
        
    /**
    * 
    **/
    public function remove(state:String):void {
      var index:int = _states.indexOf(state)
      
      if (index != -1) {
        _states.splice(index, 1)
      } else {
        throw new Error("State requested for removal: " + state + " was not found")
      }
    }
    
    /**
    * Removes the most recent state change from history
    **/
    public function rollback():void {
      _pointer_history.shift()
    }
    
    /**
    * 
    **/
    public function set(state:String):void {
      this.value = state
    }
      
    // ---
    
    /**
    * @protected
    **/
    protected function set pointer(pointer:int):void {
      _state_pointer = pointer
      _pointer_history.unshift(pointer)
      _pointer_history = _pointer_history.slice(0, _history_length)
      dispatch()
    }
  }
}
