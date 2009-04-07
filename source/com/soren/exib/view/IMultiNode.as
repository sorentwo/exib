/**
* IMultiNode
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {
  
  import com.soren.exib.helper.ConditionalSet
  
  public interface IMultiNode {
    function add(conditional_set:ConditionalSet, node:Node):void
  }
}
