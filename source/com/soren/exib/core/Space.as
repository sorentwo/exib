/**
* Space
*
* Space acts as a global storage space for objects. It uses multiple Managers
* to break stored objects into pools. Pools are established by registering a
* pattern and an identifier. Objects added or requested are then matched against
* each pool pattern and directed to that pool.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.core {

  import com.soren.debug.Log
  import com.soren.exib.manager.IManager
  import com.soren.exib.manager.Manager
  
  public class Space implements IManager {
    
    private static var _instance:Space = new Space()
    private var _pools:Array = []
    
    /**
    * Space is a singleton, construction can not be used
    **/
    public function Space() {
      if (_instance) {
        Log.getLog().debug('Can only be accessed through Space.getSpace()')
      } else {
        createDefaultPool()
      }
    }
    
    /**
    * Returns the singleton instance
    **/
    public static function getSpace():Space {
      return _instance
    }
    
    // ---
    
    /**
    * Add a new object to be managaged. Objects are stored and retrieved by id
    * and are case insensitive.
    * 
    * @param object     An object, may be of any type – though typically only one
    *                   class of object is kept in a single manager
    * @param object_id  An id used to reference the object
    **/
    public function add(object:*, object_id:String):void {
      findPool(object_id).add(object, object_id)
    }
    
    /**
    * Retrieve a managed object by its +id+
    * 
    * @param  object_id   The id used to register the object
    * @return Object      The found object
    **/
    public function get(object_id:String):* {
      return findPool(object_id).get(object_id)
    }
    
    /**
    * Determine if the manager has an object stored under the provided id
    * 
    * @param  object_id   The id used to register the object
    * @return Boolean     True if the object is managed, false otherwise
    **/
    public function has(object_id:String):Boolean {
      return findPool(object_id).has(object_id)
    }
    
    /**
    * Add a new pool to Space. Pools are managed sections used to route add and
    * get requests.
    **/
    public function createPool(pool_pattern:RegExp):void {
      _pools.push({ pattern: pool_pattern, manager: new Manager() })
    }
    
    /**
    * Reset the Space to its initial state. This will remove all stored objects,
    * but not all pools.<br />
    * To reset pools back to the default use +resetPools()+
    **/
    public function reset():void {
      for each (var pool:Object in _pools) { pool.manager.reset() }
    }
    
    /**
    * Reset the Space's pools back to only the default. This will remove all
    * object references stored within those pools as well.
    **/
    public function resetPools():void {
      _pools = []
      createDefaultPool()
    }
    
    // ---
    
    /**
    * @private
    *
    **/
    private function createDefaultPool():void {
      createPool(/.*/) // Default pool won't be matched, regex doesn't matter
    }
    
    /**
    * @private
    * 
    * Searches the pool patterns for a match. Returns the default manager if no
    * match is found.
    **/
    private function findPool(object_id:String):Manager {
      var manager:Manager = _pools[0].manager
          
      // Initialize i to 1, thereby skipping the default pool altogether
      for (var i:int = 1; i < _pools.length; i++) {
        var pool:Object = _pools[i]
        if (pool.pattern.test(object_id)) manager = pool.manager; break
      }
      
      return manager
    }
  }
}
