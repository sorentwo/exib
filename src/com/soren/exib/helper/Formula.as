/**
* Formula
*
* Formula provides the lowly EXIB runtime with the ability to perform maths on
* numbers and IEvaluatable. A formula is stored using the +store+ command and
* then executed by calling yield.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.helper {

  import com.soren.exib.core.Space

  public class Formula {
    public static const NO_ROUND:uint = 0
    public static const ROUND:uint    = 1
    public static const CEIL:uint     = 2
    public static const FLOOR:uint    = 3
    
    // This is made public to DRY up potential formula detection by other classes
    public static const FORMULA_PATTERN:RegExp = /-?[\w\.]+\s*[-\+\/\*%]{1}\s*-?[\w\.]+/
    
    private static const DEFAULT_ROUND:uint  = 0
    private static const DEFAULT_ABS:Boolean = false
    
    private var _space:Space = Space.getSpace()
    private var _formula:String
    private var _options:Object
    
    /**
    * Constructs a new formula object. An initial formula must be provided, but
    * it may be overridden through the +store+ method at any point after.
    * 
    * @param  formula   A string containing a mathematical formula. May contain
    *                   numbers or IEvaluatable objects. <br />
    *                   The +store()+ method may be used after construction to
    *                   update the formula.
    * @param  options   An object hash of options that modify the output of the
    *                   formula.
    **/
    public function Formula(formula:String, options:Object = null) {
      defineDefaultOptions()
      this.store(formula, options)
    }
    
    /**
    * Takes a mathematical formula in the form of a string and stores it for
    * evaluation later.
    * 
    * @param  formula   A string containing a mathematical formula. May contain
    *                   numbers or IEvaluatable objects. <br />
    *                   The +store()+ method may be used after construction to
    *                   update the formula.
    * @param  options   An object hash of options that modify the output of the
    *                   formula.
    **/
    public function store(formula:String, options:Object = null):void {
      validateFormula(formula)
      if (options) mergeOptions(options)
      
      _formula = formula
    }
    
    /**
    * Evaluates the stored formula and returns the calculated value. Any IEvaluatable
    * 'variables' within the formula are re-evaluated every time yield is called.
    **/
    public function yield():Number {
      var formula:String     = _formula
      var operand_one:String = "((?P<op_one>-?[\\w\\.]+)\\s*(?P<op>"
      var operand_two:String = ")\\s*(?P<op_two>-?[\\w\\.]+))"
      var operators:Array    = ['\\*', '\\/', '%', '-', '\\+']
      var op_index:uint      = 0

      var pattern:RegExp = new RegExp(operand_one + operators[op_index] + operand_two)
      
      while (op_index < operators.length) {

        var result:Object = pattern.exec(formula)

        while (result != null) {  
          var op_one:Number = resolveVariable(result.op_one)
          var op_two:Number = resolveVariable(result.op_two)
          var value:Number  = 0

          switch (result.op) { // Cases in order of perceived usage
            case '+': value = op_one + op_two; break
            case '-': value = op_one - op_two; break
            case '*': value = op_one * op_two; break
            case '%': value = op_one % op_two; break
            case '/': value = (op_two == 0) ? 0 : op_one / op_two; break
          }

          formula = formula.replace(result[0], value)
          result  = pattern.exec(formula)
        }
        
        op_index ++
        pattern = new RegExp(operand_one + operators[op_index] + operand_two)
      }
      
      var final_value:Number = Number(formula)

      if (_options['abs']) final_value = Math.abs(final_value)
      
      switch (_options['round']) { // 0 is no round, it can be skipped
        case 1: final_value = Math.round(final_value); break
        case 2: final_value = int(final_value) + 1; break
        case 3: final_value = int(final_value); break
      }
      
      return final_value
    }
    
    // ---
    
    /**
    * @protected
    **/
    protected function defineDefaultOptions():void {
      _options = {}
      
      _options['round'] = DEFAULT_ROUND
      _options['abs']   = DEFAULT_ABS
    }
        
    /**
    * @private
    * 
    * Merges any supplied options with the default options.
    **/
    private function mergeOptions(options:Object):void {
      for (var prop:String in options) {
        _options[prop] = options[prop]
        if (_options[prop] == 'false') { _options[prop] = false }
        if (_options[prop] == 'true')  { _options[prop] = true }
      }
    }
    
    /**
    * @private
    **/
    private function resolveVariable(value:String):Number {
      var return_value:Number = 0
      if (/[\d\.]+/.test(value)) {
        return_value = Number(value)
      } else {
        if (_space.has(value)) {
          return_value = Number(_space.get(value).value)
        } else {
          throw new Error('Unknown or unmanaged variable: ' + value)
        }
      }
      
      return return_value
    }
    
    /**
    * @private
    * 
    * Determine if a given formula is valid. To be valid it must contain at least
    * two operands and one operator.
    **/
    private function validateFormula(formula:String):void {
      if (!FORMULA_PATTERN.test(formula)) {
        throw new Error('Attempt to store invalid formula: ' + formula)
      }
    }
  }
}
