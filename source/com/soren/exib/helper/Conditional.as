/**
* Conditional
*
* Represents a relatively self-contained condition made up of two operands and
* a relational operator. Operands can be static strings, static numbers, or a
* reference to any object that has a value accessor.
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.helper {

  import flash.events.EventDispatcher
  import flash.utils.getQualifiedClassName
  import com.soren.exib.core.IEvaluatable
  import com.soren.exib.model.Model
  
  public class Conditional {
	
    public static const VALID_OPERATORS:Array = ['!=', '==', '>', '<', '<=', '>=']
    
    private static const EVENT_TYPE:String = Model.CHANGED
    
    private var _operand_one:*
    private var _operand_two:*
    private var _operator:String
        
    /**
    * Creates a new Conditional instance. A model, operator, and condition are
    * required.
    * 
    * @param  operand_one   An object that responds to the value accessor
    * @param  operator      A valid operator (==, >=, !=, etc)
    * @param  operand_two   A string, number, or object that responds to the value
    *                       accessor
    **/
    public function Conditional(operand_one:*, operator:String, operand_two:*) {
      verifyOperand(operand_one)
      verifyOperand(operand_two)
      verifyOperator(operator)
      
      _operand_one = operand_one
      _operand_two = operand_two
      _operator    = operator
    }

    /**
    * Evaluates the conditional instance.
    * 
    * @return A boolean value indicating the evaluation
    **/
    public function evaluate():Boolean {
      var op_one_value:* = (_operand_one is IEvaluatable)
                         ? _operand_one.value
                         : _operand_one
      
      var op_two_value:* = (_operand_two is IEvaluatable)
                         ? _operand_two.value
                         : _operand_two
      
      if (op_one_value is String) op_one_value = op_one_value.toUpperCase()
      if (op_two_value is String) op_two_value = op_two_value.toUpperCase()
      
      var consequent:Boolean = false

      switch(_operator) {
        case '==' :
          consequent = (op_one_value == op_two_value)
          break
        case '!=' :
          consequent = (op_one_value != op_two_value)
          break
        case '>' :     
          consequent = (Number(op_one_value) > Number(op_two_value))
          break
        case '>=' :    
          consequent = (Number(op_one_value) >= Number(op_two_value))
          break
        case '<' :     
          consequent = (Number(op_one_value) < Number(op_two_value))
          break
        case '<=' :
          consequent = (Number(op_one_value) <= Number(op_two_value))
          break
      }
      
      return consequent
    }
    
    /**
    * Takes a function and registers it to listen for events dispatched from any
    * models linked as operands.
    * 
    * @param  listener A function that will be called when an event is dispatched
    * 
    * @see unregisterListener
    **/
    public function registerListener(listener:Function):void {
      addOrRemoveListener(listener, true)
    }
    
    /**
    * Takes a function and +unregisters+ it to listen for events dispatched.
    * 
    * @param listener A function that is currently registered 
    * 
    * @see registerListener
    **/
    public function unregisterListener(listener:Function):void {
      addOrRemoveListener(listener, false)
    }
    
    // ---
    
    /**
    * @private
    **/
    private function verifyOperand(operand:*):void {
      if (!(operand is Boolean) &&
          !(operand is Number)  &&
          !(operand is String)  &&
          !(operand is IEvaluatable)) {
        
        throw new Error(getQualifiedClassName(operand) + " is not a valid operand")
      }
    }
    
    /**
    * @private
    **/
    private function verifyOperator(operator:String):void {
      if (VALID_OPERATORS.indexOf(operator) == -1) {
        throw new Error("Operator: " + operator + " is not a valid operator")
      }
    }
    
    /**
    * @private
    **/
    private function addOrRemoveListener(listener:Function, add:Boolean = true):void {
      var operands:Array = [_operand_one, _operand_two]
      
      for each (var operand:* in operands) {
        if (!(operand is EventDispatcher)) continue
        if (add) { operand.addEventListener(EVENT_TYPE, listener)
        } else   { operand.removeEventListener(EVENT_TYPE, listener) }
      }
    }
	}
}
