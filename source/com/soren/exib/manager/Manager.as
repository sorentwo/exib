/**
* Manager
* 
* Manager instances are used to store and retrieve a specific class of objects
* by unique id.
* 
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.manager {

  import com.soren.debug.Log

  public class Manager implements IManager {
    
    private var _managed:Object = {}
    
    /**
    * Constructor
    **/
    public function Manager() {}
    
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
    * Retrieve a collection of managed objects by supplying a basic glob pattern.
    * 
    * <p>Standard glob syntax of <code>*</code> for any number of any character
    * and <code>?</code> for one of any character is used.</p>
    * 
    * @param  pattern   A string to match against registered id's. Some simple
    *                   examples, <code>*btn</code> would match any object ending
    *                   in 'btn'.
    **/
    public function glob(pattern:String):Array {
      var translated_to_regex:String = ''
      translated_to_regex = pattern.replace(/\*/g, '.*')
      translated_to_regex = translated_to_regex.replace(/\?/g, '.{1}')
      
      var regex_pattern:RegExp = new RegExp(translated_to_regex, 'i')
      
      var found:Array = []
      for (var key:String in _managed) {
        if (regex_pattern.test(key)) found.push(_managed[key])
      }
      
      return found
    }
    
    /**
    * Retrieve a collection of managed objects by supplying a regular expression.
    * 
    * @param  pattern   A string to match against registered id's. Uses the full
    *                   supported regex syntax. Because this is a string to be
    *                   converted it should <b>not</b> be in the form of /pattern/
    **/
    public function grep(pattern:String):Array {
      var regex_pattern:RegExp = new RegExp(pattern, 'i')
      
      var found:Array = []
      for (var key:String in _managed) {
        if (regex_pattern.test(key)) found.push(_managed[key])
      }

      return found
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
    
    /**
    * Retrieves an object by +id+ and then removes it from the manager
    * 
    * @param  object_id   The id used to register the object
    * @return Object      The removed object
    **/
    public function pop(object_id:String):* {
      var found:* = this.get(object_id)
      this.remove(object_id)
      return found
    }
        
    /**
    * Remove the object from the manager
    * 
    * @param  object_id   The id used to register the object
    **/
    public function remove(object_id:String):void {
      delete _managed[object_id.toLowerCase()]
    }
	
	  /**
	  * Return the manager to an empty state.
	  **/
	  public function reset():void {
	    _managed = {}
	  }
	}
}
