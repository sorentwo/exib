/**
* ConditionalSet
*
* A class to store multiple conditional objects and allow them to be evaluated
* as a single condition, in which any conditional returning <code>false</code>
* causes the entire set to return <code>false</code>
*
* Copyright (c) 2008 Parker Selbert
* 
* See LICENSE.txt for full license information.
**/

package com.soren.exib.helper {

  public class ConditionalSet implements ISet {
	
    private var _conditionals:Array = []
    
    /**
    * Constructor
    **/
    public function ConditionalSet(...args) {
      if (args.length > 0) this.push.apply(this, args)
    }

    /**
    * Returns an array of all the actions
    **/
    public function get set():Array { 
      return _conditionals
    }

    /**
    * Adds any number of action items to the set. Can be overloaded.
    **/
    public function push(...args):void {
      for each (var conditional:Conditional in args) {
        _conditionals.push(conditional)
      }
    }
    
    /**
    * Returns a boolean determination on whether the set contains any conditonals
    **/
    public function isEmpty():Boolean {
      return (_conditionals.length == 0) ? true : false
    }
    
    /**
    * Atomically evaluates every condition in the set, returning false if any one
    * element is false, and true if all elements return as true. Additionally, if
    * the set is empty it will also return false.
    **/
    public function evaluate():Boolean {
      if (this.isEmpty()) return false

      for each (var conditional:Conditional in _conditionals) {
        if (!conditional.evaluate()) return false
      }
      
      return true
    }
    
    /**
    * Takes a function and calls registerListener on every conditional object
    * in this set.
    * 
    * @param  listener A function that will be called when an event is dispatched
    * 
    * @see unregisterListener
    **/
    public function registerListener(listener:Function):void {      
      for each (var condition:Conditional in _conditionals) {
        condition.registerListener(listener)
      }
    }
    
    /**
    * Takes a function and calls unregisterListener on every conditional object
    * in this set.
    * 
    * @param listener A function that is currently registered 
    * 
    * @see registerListener
    **/
    public function unregisterListener(listener:Function):void {
      for each (var condition:Conditional in _conditionals) {
        condition.unregisterListener(listener)
      }
    }
	}
}