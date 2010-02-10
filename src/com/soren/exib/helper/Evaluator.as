/**
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.helper {
  
  import com.soren.exib.core.IEvaluatable
  import com.soren.exib.core.Space
  
  public class Evaluator implements IEvaluatable {
    
    private var _evaluatable:IEvaluatable
    private var _evaluatable_id:String
    private var _method:String
    private var _index:int
    
    public function Evaluator(evaluatable:*, method:String = null, index:int = -1) {
      if (evaluatable is String)            { _evaluatable_id = evaluatable }
      else if (evaluatable is IEvaluatable) { _evaluatable = evaluatable    }
      else                                  { throw new Error('Invalid object supplied for evaluation' + evaluatable) }
      
      _method = method
      _index  = index
    }
    
    public function get value():* {
      if (_evaluatable_id != null && _evaluatable == null) {
        _evaluatable    = Space.getSpace().get(_evaluatable_id)
        _evaluatable_id = null
      }
      
      var temp_value:* = (!_method) ? _evaluatable.value : _evaluatable[_method]
      return (_index == -1) ? temp_value : temp_value[_index]
    }
    
    public function get evaluatable():IEvaluatable { return _evaluatable }
    public function get method():String            { return _method      }
    public function get index():int                { return _index       }
  }
}
