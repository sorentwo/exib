/**
* SimpleManager
*
* An intensely stripped down, and non-singleton, Manager class
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.manager {

  import com.soren.debug.Log
  
  public class SimpleManager implements IManager {
    
    protected var _managed:Object = {}
    
    public function SimpleManager() {}
    
    /**
    * Add a new object to be managaged. Objects are stored and retrieved by id
    * and are case insensitive.
    * 
    * @param object     An object, may be of any type – though typically only one
    *                   class of object is kept in a single manager
    * @param object_id  An id used to reference the object
    **/
    public function add(object:*, object_id:String):void {
      if (this.has(object_id)) {
        Log.getLog().error('Adding ' + object_id + ' failed, id already exists.')
      }

      _managed[object_id.toLowerCase()] = object
    }
    
    /**
    * Retrieve a managed object by its +id+
    * 
    * @param  object_id   The id used to register the object
    * @return Object      The found object
    **/
    public function get(object_id:String):* {
      var found:Object = _managed[object_id.toLowerCase()]
      
      if (found) { return found }
      else       { Log.getLog().error('Object with id: ' + object_id + ' not found') }
    }
    
    /**
    * Determine if the manager has an object stored under the provided id
    * 
    * @param  object_id   The id used to register the object
    * @return Boolean     True if the object is managed, false otherwise
    **/
    public function has(object_id:String):Boolean {
      return _managed.hasOwnProperty(object_id.toLowerCase())
    }
  }
}
