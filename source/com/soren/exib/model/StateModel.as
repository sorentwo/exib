/**
* StateModel
* 
* Represents a collection of persistent states that can be set,
* retreived, and nextd. States are simple strings and can be as basic as
* 'ON' and 'OFF'.
* 
* Copyright (c) 2008 Parker Selbert
* 
* See LICENSE.txt for full license information.
**/

package com.soren.exib.model {

  import com.soren.debug.Log
  import com.soren.util.ExtendedArray

  public class StateModel extends Model {

    protected var _states:Array         = []
    protected var _initial_pointer:uint = 0
    protected var _state_pointer:uint   = 0
    protected var _wraps:Boolean        = true

    /**
    * The StateModel constructor accepts any number of string and array
    * parameters, and will automatically add each as an initial state
    **/
    public function StateModel(...args) {
      var ea:Array = new ExtendedArray(args).flatten().flatten()
      
      for each (var state:String in ea) {
        this.add(state)
      }
      
      Log.getLog().debug('args')
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
      return _states[_state_pointer]
    }

    /**
    * Set the model's initial state to one of the registered states.
    * 
    * @param  value A string representing the name of a state
    **/
    public function set initial(value:String):void {
      value = value.toLowerCase()
      
      var index:int = _states.indexOf(value)
      
      if (index == -1) {
        throw new Error("State: " + value + " was not found")
      } else {
        _initial_pointer = index
      }
    }
    
    /**
    * Retrieves the initial, or default, state
    **/
    public function get initial():String {
      return _states[_initial_pointer]
    }
    
    /**
    * Retrieve an array of all the states contained in the model
    * 
    * @return An array of all states in the model
    **/
    public function get states():Array {
      return _states
    }
    
    /**
    * Retrieve the total number of states contained in the instance
    * 
    * @return An unsigned integer representing the total number of states
    **/
    public function get total():int {
      return _states.length
    }
    
    /**
    * Set whether this instance will wrap from the last state back to the first
    **/
    public function set wraps(wraps:Boolean):void {
      _wraps = wraps
    }
    
    /**
    * Boolean representing whether this instance will wrap or not
    **/
    public function get wraps():Boolean {
      return _wraps
    }
     
    /**
    * Add a new possible state to the model. Any string is possible so long
    * as it doesn't already exist. This is not case sensitive.
    * 
    * @param  new_state  A string representing the new state to add
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
    * Cycle through the registered states. This will move through all possible
    * states in the order they were registered, returning to the first state if
    * the last state is currently active and wrapping is enabled.
    **/
    public function next():void {
      this.pointer  = (_state_pointer == _states.length - 1)
                    ? (_wraps) ? 0 : _state_pointer
                    : _state_pointer + 1
    }
    
    /**
    * The reverse of next. This will cycle through the states in reverse order. 
    * 
    * @see next
    **/
    public function previous():void {
      this.pointer = (_state_pointer == 0)
                   ? (_wraps) ? _states.length - 1 : 0
                   : _state_pointer - 1
    }
    
    /**
    * Remove the supplied state from the instance
    * 
    * @param  state   The state to remove
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
    * Reset the model back to the initial state. If no initial was provided then
    * the first state added is the initial.
    **/
    public override function reset():void {
      this.pointer = _initial_pointer
      dispatch()
    }
    
    /**
    * Set the model's state to any of the states that have been registered
    * for the model. Attempting to set it to a state that doesn't exist will
    * throw an error.
    * 
    * @see set value
    **/
    public function set(state:String):void {
      this.value = state
    }
    
    // ---
    
    /**
    * @private
    **/
    protected function set pointer(pointer:int):void {
      _state_pointer = pointer
      dispatch()
    }
  }
}
