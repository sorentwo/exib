/**
* PresetModel
* 
* Accepts the registration of model / value pairs and watches
* the models for changes. Presets, or the combination of model / value pairs,
* can be saved and loaded to capture or modify the value of all models being
* watched.
* 
* <p>For example, by registering a Value Model respresenting the number
* of units being dispensed and a State Model representing the type of unit,
* we now have a Preset Model that can save both values, return the values to
* a view of the Preset Model, and also load the values back into the watched
* models</p>
* 
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.model {
  
  public class PresetModel extends Model {
  
    private var _value_array:Array   = []
    private var _watched:Array       = []
    private var _default_text:String = ' '
    
    public function PresetModel() {}

    /**
    * Value can not be set for the PresetModel.
    **/
    public override function set value(value:*):void { }
        
    /**
    * Accessor method for retrieving the values of all watched models, as an
    * array and sorted in the order they were registered.
    * 
    * @return   An array with the value of each watched model, in the order
    *           they were registered.
    **/
    public override function get value():* {
      if (_value_array.length < 1) {
        
        for (var i:int = 0; i < _watched.length; i++) {
          _value_array[i] = _default_text
        }
      }
      
      return _value_array
    }
    
    /**
    * 
    **/
    public function set default_text(default_text:String):void {
      _default_text = default_text
    }
    
    /**
    * Register a new model (must adhere to IModel) to be watched. This makes
    * the model part of save and load operations. Additionally,
    * the order items are registered in is important as that is how they will
    * be extracted by getting the value.
    * 
    * @param  new_model   A new model that implements the IModel interface
    **/
    public function watch(new_model:Model, value:* = null):void {
      for each (var watched:Object in _watched) {
        if (watched.model == new_model) {
          throw new Error("Model: " + new_model + " already registered")
        }
      }
      
      _watched.push({ model: new_model, value: value })
      
      if (value != null) _value_array.push(value)
    }
    
    /**
    * Request that the preset instance poll all currently watched models and
    * store the values internally. After saving the value will be updated
    * and the load method is available.
    **/
    public function save():void {
      var save_array:Array = []
      for each (var watched:Object in _watched) {
        watched.value = watched.model.value
        save_array.push(watched.value)
      }
      
      _value_array = save_array
      
      dispatch()
    }
    
    /**
    * Requests that all watched models are updated with the values currently
    * stored within the preset instance. No change is broadcast, it is up
    * to models to notify observers of any changes.
    **/
    public function load():void {
      for each (var watched:Object in _watched) {
        if (watched.value == undefined) return
        watched.model.value = watched.value
      }
    }
    
    /**
    * Reset all internally stored values to undefined, this will cause the
    * preset instance's value to return to the EMPTY_VALUE string. This has
    * no effect on any models being watched, only the values stored internally.
    **/
    public override function reset():void {
      for each (var watched:Object in _watched) {
        watched.value = undefined
      }
      
      dispatch()
    }
  }
}