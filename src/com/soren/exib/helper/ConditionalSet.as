/**
* ConditionalSet
*
* A class to store multiple conditional objects and allow them to be evaluated
* as a single condition. The set works according to standard boolean logic, using
* chanined 'and' and 'or' statements.
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.helper {

  public class ConditionalSet {
	  
	  public static var LOGICAL_AND:uint = 0
	  public static var LOGICAL_OR:uint  = 1
	  
    private var _conditionals:Array = []
    
    /**
    * Constructor
    **/
    public function ConditionalSet(element:* = undefined, operator:uint = 0) {
      if (element != undefined) this.push(element, operator)
    }

    /**
    * Returns an array of all the conditionals and their operator
    **/
    public function get set():Array { 
      return _conditionals
    }

    /**
    * Adds an action item to the set.
    **/
    public function push(element:*, operator:uint = 0):void {
      if (!((element is Conditional) || (element is ConditionalSet))) {
        throw new Error('ConditionalSet: Invalid conditional class -> ' + element)
      }
      
      if (operator > 1) {
        throw new Error('ConditionalSet: Invalid operator -> ' + operator)
      }
      
      _conditionals.push( {element: element, operator: operator} )
    }
    
    /**
    * Returns a boolean determination on whether the set contains any conditonals
    **/
    public function isEmpty():Boolean {
      return (_conditionals.length == 0) ? true : false
    }
    
    /**
    * Sets chain together sub-elements and sub-sets and evaluate them based on the
    * operator supplied, recursively.
    **/
    public function evaluate():Boolean {
      if (this.isEmpty()) return false
      
      var set_result:Boolean = true
      for each (var object:Object in _conditionals) {
        var result:Boolean = object.element.evaluate()
        switch (object.operator) {
          case 0: set_result = set_result && result; break
          case 1: set_result = set_result || result; break
        }
      }
      
      return set_result
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
      for each (var object:Object in _conditionals) {
        var element:* = object.element
        if (element is Conditional) element.registerListener(listener)
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
      for each (var object:Object in _conditionals) {
        var element:* = object.element
        if (element is Conditional) element.unregisterListener(listener)
      }
    }
	}
}