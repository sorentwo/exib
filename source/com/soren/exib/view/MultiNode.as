/**
* MultiNode
*
* Displays a different node based on a set of conditions.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.view {

  import flash.events.Event
  import com.soren.exib.helper.ConditionalSet
    
  public class MultiNode extends Node implements IMultiNode {
    
    protected var _possibilities:Array = []
    
    /**
    * Constructor
    **/
    public function MultiNode() {}
    
    /**
    **/
    public function add(conditional_set:ConditionalSet, node:Node):void {
      conditional_set.registerListener(changeListener)
      _possibilities.push({ conditional_set: conditional_set, node: node })
      update()
    }
    
    /**
    **/
    override public function update():void {
      unloadAll()
      for each (var possibility:Object in _possibilities) {
        if (possibility.conditional_set.evaluate()) {
          load(possibility.node)
          break
        }
      }
    }
    
    // ---
    
    /**
    **/
    protected function load(node:Node):void {
      this.addChild(node)
      node.update()
    }
    
    /**
    **/
    protected function unloadAll():void {
      while (this.numChildren > 0) { removeChildAt(0) }
    }
  }
}
