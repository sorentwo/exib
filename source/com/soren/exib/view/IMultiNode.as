/**
* IMultiNode
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information
**/

package com.soren.exib.view {
  
  import com.soren.exib.helper.ConditionalSet
  
  public interface IMultiNode {
    function add(conditional_set:ConditionalSet, node:Node):void
  }
}
