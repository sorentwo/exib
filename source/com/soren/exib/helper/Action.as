/**
* Action
*
* A container class for 'actions,' or the pairing of a actionable object, a method,
* and any number of arguments that will be called on that actionable. Arguments may 
* overloaded and any type. When the method is finally called arguments will be
* sent unpacked.
*
* Copyright (c) 2008 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.helper {

  public class Action {
	
    private var _actionable:IActionable
    private var _method:String
    private var _arguments:Array
    
    private var _conditional_set:ConditionalSet
    
    /**
    * Constructor
    * 
    * Create a new Action instance. A actionable and a method are required,
    * and an optional set of arguments can also be supplied. Arguments
    * may be of any data type that a actionable will accept, however, because
    * of the limited dynamic ability that XML provides arguments are tested for
    * a return value (essentially to see if it is a actionable).
    * 
    * @param  actionable   The actionable that the method will be called on
    * @param  method  The method to be called
    * @param  *args   Any number of arguments that will be passed
    **/
    public function Action(actionable:IActionable, method:String, ...args) {
      if ((args.length != 0) && (args[0] is Array)) args = args[0]
      
      _actionable = actionable
      _method     = method
      _arguments  = args
    }

    /**
    **/
    public function set conditional_set(conditional_set:ConditionalSet):void {
      _conditional_set = conditional_set
    }
    
    /**
    * Applies the action to the actionable. If the action refers to an object
    * with a value accessor the value is used as the action.
    **/
    public function act():void {
      if (_conditional_set && !_conditional_set.evaluate()) return

      var values:Array = _arguments.map(toValue)
     
      try {
        _actionable[_method].apply(_actionable, values)
      } catch (e:Error) {
        try {
          _actionable[_method]()
        } catch (e:Error) {
          throw new Error("Invalid method signature: "       +
                          "actionable: " + _actionable       + ", " +
                          "method: "     + _method           + ", " +
                          "arguments: "  + values.toString() + "\n" +
                          "caught: "     + e)
        }
      }
    }
    
    // ---
    
    /**
    * @private
    * 
    * Returns either the element itself, or, if the element returns a value 
    * (i.e. a actionable), the value that is returned.
    **/
    private function toValue(element:*, index:int, arr:Array):* {
      return (element is IEvaluatable) ? element.value : element
    }
	}
}