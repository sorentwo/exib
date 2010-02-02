/**
* ValueModel
* 
* Represents a single numerical value that is persistently stored and can be
* manipulated within a specified range.
* 
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.model {

  import com.soren.exib.debug.Log
  
  public class ValueModel extends Model {

    private var _value:int
    private var _initial:int
    private var _min:int
    private var _max:int

    /**
    * Constructor
    * 
    * @param  initial   Integer value which the model will start at and reset to
    * @param  min       Minimum value possible
    * @param  max       Maximum value possible
    **/
    public function ValueModel(initial:int = 0, min:int = 0, max:int = 10) {
      _min = min
      _max = max
      
      this.initial = initial
      this.value   = initial
    }

    /**
    * Setter method for modifying the model's initial value. Valid input will
    * be an integer between the minimum and maximum values set for the model.
    * 
    * @param  value   Integer within the model's constraints
    **/
    public function set initial(value:int):void {
      if ((value < _min) || (value > _max)) {
        throw new Error("Default value must be between " + _min + " and " + _max)
      }
      
      _initial = value
    }
     
    /**
    * Getter method for retrieving the model's initial value
    **/
    public function get initial():int {
      return _initial
    }
    
    /**
    * Set a new value for the model. Valid input will be an integer between
    * the minimum and maximum values set for the model.
    * 
    * @param  value Untyped number within the model's constraints
    **/
    public override function set value(value:*):void {
      value = int(value)
      
      if ((_min > value) || (_max < value)) {
        return
      }

      _value = value
      
      dispatch()
    }
    
    /**
    * Accessor method for retrieving the current value of the model
    * 
    * @return An integer representing the current value of the model
    **/
    public override function get value():* {
      return _value
    }

    /**
    * Accessor method for setting a new minimum value for the model
    **/
    public function set min(value:int):void {
      if (value > _max) {
        Log.getLog().error('Minimum value can not be greater than maximum value: ' + _max)
      } else {
        _min = value
      }
    }
    
    /**
    * Accessor method for retrieving the minimum value of the model
    **/
    public function get min():int {
      return _min
    }
    
    /**
    * Accessor method for setting a new maximum value for the model
    **/
    public function set max(value:int):void {
      if (value < _min) {
        Log.getLog().error('Maximum value can not be less than minimum value: ' + _min)
      } else {
        _max = value
      }
    }
    
    /**
    * Accessor method for retrieving the maximum value of the model
    **/
    public function get max():int { 
      return _max
    }
    
    /**
    * Change the model's value by the provided amount. Signed and unsigned integers
    * are possible.
    **/
    public function change(value:int):void {
      this.value += value
    }
      
    /**
    **/
    public function set(value:int):void {
      this.value = value
    }
     
    /**
    * Reset the model back to the default value.
    **/
    public override function reset():void {
      this.value = _initial
    }
  }
}