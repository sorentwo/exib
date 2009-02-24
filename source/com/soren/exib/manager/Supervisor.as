/**
* Supervisor
* 
* The supervisor class collects and acts on a group of managers. All methods
* provided by managers are possible, with the addition that the type used to
* register the manager must be provided to retrieve objects from that manager.
* Meaning, to retrieve an object with the id 'mode' from the manager labeled
* 'model' you would use <code>supervisor.get('model', 'mode')</code>.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.manager {
  
  public class Supervisor {
    
    private var _managers:Object = {}
    
    /**
    * Constructor
    **/
    public function Supervisor(manager_list:Array) {
      for each (var type:String in manager_list) {
        _managers[type] = new Manager()
      }
    }
    
    /**
    * 
    **/
    public function add(object_type:String, object:*, object_id:String):void {
      _managers[object_type.toLowerCase()].add(object, object_id)
    }
    
    /**
    * 
    **/
    public function get(object_type:String, object_id:String):* {
      return _managers[object_type.toLowerCase()].get(object_id)
    }
    
    /**
    * 
    **/
    public function glob(object_type:String, pattern:String):Array {
      return getWithPattern(object_type, pattern, false)
    }
    
    /**
    * 
    **/
    public function grep(object_type:String, pattern:String):Array {
      return getWithPattern(object_type, pattern, true)
    }
    
    /**
    * 
    **/
    public function has(object_type:String, object_id:String):Boolean {
      return _managers[object_type.toLowerCase()].has(object_id)
    }
    
    /**
    * 
    **/
    public function pop(object_type:String, object_id:String):* {
      return _managers[object_type.toLowerCase()].pop(object_id)
    }
        
    /**
    * 
    **/
    public function remove(object_type:String, object_id:String):void {
      _managers[object_type.toLowerCase()].remove(object_id)
    }
    
    // ---
    
    /**
    * @private
    **/
    private function getWithPattern(object_type:String, pattern:String, use_grep:Boolean):Array {
      var found:Array   = []
      var method:String = (use_grep) ? 'grep' : 'glob'
      
      if (object_type == 'all') {
        for (var key:String in _managers) {
          found = found.concat(_managers[key][method](pattern))
        }
      } else {
        found = _managers[object_type.toLowerCase()][method](pattern)
      }      
      
      return found
    }
  }
}