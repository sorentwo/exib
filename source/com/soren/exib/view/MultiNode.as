/**
* MultiNode
*
* Displays a different node based on a set of conditions. Only the first node
* with a condition that is true will be shown. This ensures that only one node
* will be active at a time regardless of how many conditions are true.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.events.Event
  import com.soren.exib.helper.ConditionalSet
    
  public class MultiNode extends Node implements IMultiNode {
    
    protected var _possibilities:Array = []
    protected var _default:Node
    
    /**
    * Constructs a new MultiNode instance. The node will be invisible and unused
    * until child nodes are added through +add+.
    * 
    * @see add
    **/
    public function MultiNode() {}
    
    /**
    * Add a node for the MultiNode instance to track.
    * 
    * @param  conditional_set A conditonal set that will determine whether this
    *                         node will be active or not.
    * @param  node            The node that will be tracked.
    **/
    public function add(conditional_set:ConditionalSet, node:Node):void {
      conditional_set.registerListener(changeListener)
      _possibilities.push({ conditional_set: conditional_set, node: node })
      update()
    }
    
    public function setDefault(node:Node):void {
      _default = node
      update()
    }
    
    /**
    * Update will refresh the node's children, showing the first node that has a
    * true condition.
    **/
    override public function update():void {
      unloadAll()
      var possibility_matched:Boolean = false
      for each (var possibility:Object in _possibilities) {
        if (possibility.conditional_set.evaluate()) {
          load(possibility.node)
          possibility_matched = true
          break
        }
      }
      
      if (!possibility_matched && _default) load(_default)
    }
    
    // ---
    
    /**
    **/
    protected function load(node:Node):void {
      this.addChild(node)
      node.update()
    }
  }
}
