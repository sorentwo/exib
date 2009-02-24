/**
* ActionSet
*
* A class to store numerous actions and allow all of them to be acted upon
* at once. It mimics very few Array methods for adding Actions.
*
* Copyright (c) 2008 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.helper {

  public class ActionSet implements ISet {
	
    private var _actions:Array = []
    
    /**
    * Creates a new ActionSet instance
    **/
    public function ActionSet(...args) {
      if (args.length > 0) this.push.apply(this, args)
    }

    /**
    * Returns an array of all the actions
    **/
    public function get set():Array { 
      return _actions
    }
    
    /**
    * Adds any number of action items to the set. Can be overloaded.
    * 
    * @param  *args   Any number of Action objects to add to the set
    **/
    public function push(...args):void {
      for each (var action:Action in args) {
        _actions.push(action)
      }
    }
    
    /**
    * Returns a boolean determination on whether the set contains any actions
    **/
    public function isEmpty():Boolean {
      return (_actions.length == 0) ? true : false
    }
    
    
    /**
    * Triggers +act+ for every action in the set
    **/
    public function act():void {
      for each (var action:Action in _actions) {
        action.act()
      }
    }    
	}
}
