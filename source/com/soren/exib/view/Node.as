/**
* Node
*
* This is the base class for all display components. It expands on Sprite with a
* number of properties and finder methods.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.display.Sprite
  import flash.events.Event
  
  public class Node extends Sprite implements INode {
    
    protected var _id:String
    protected var _group:String
    
    // Implemented directly because this can not be a dynamic class. Get / Set
    // methods seem overkill, but may be used in the future.
    public var blur_x:uint = 0
    public var blur_y:uint = 0
    
    public function Node() {}
    
    /**
    **/
    public function set id(node_id:String):void {
      _id = node_id
    }
    
    /**
    **/
    public function get id():String {
      return (_id) ? _id : ''
    }
    
    /**
    **/
    public function set group(group_id:String):void {
      _group = group_id
    }
    
    /**
    **/
    public function get group():String {
      return (_group) ? _group : ''
    }
      
    /**
    **/
    public function getChildrenByGroup(group:String):Array {
      return bsearch(group, 'group', true)
    }
    
    /**
    * Returns the first node it finds that matches the supplied id
    **/
    public function getChildById(id:String):* {
      return bsearch(id, 'id', false)
    }
    
    /**
    * 
    **/
    public function position(coordinates:String):void {
      var pattern:RegExp = /(?P<x>-?\d+)\s?,\s?(?P<y>-?\d+)/
      
      if (!pattern.test(coordinates)) throw new Error("Invalid coordinates")
      
      var result:Object = pattern.exec(coordinates)
      this.x = int(result.x)
      this.y = int(result.y)
    }
    
    /**
    * 
    **/
    public function update():void {}
    
    // ---
    
    /**
    * @protected
    **/
    protected function changeListener(event:Event):void {
      update()
    }
    
    // ---
    
    /**
    * Performs a bredth-first trasversal of the node tree, comparing each node to
    * the target property specified. Can be used to return one or all of the
    * matches found.
    **/
    private function bsearch(target:String, property:String, multiple:Boolean):* {
      var unsearched:Array = [this]
      var matching:Array   = []
      
      var normalized_target:String = target.toLowerCase()
      
      while (unsearched.length > 0) {
        if (!(unsearched[0] is Node)) { unsearched.shift(); continue}
        var current_node:Node = unsearched.shift()
        
        if (current_node.hasOwnProperty(property) &&
            current_node[property].toLowerCase() == normalized_target) {
          if (multiple) { matching.push(current_node) }
          else          { matching.push(current_node); break }
        }
        
        for (var i:int = 0; i < current_node.numChildren; i++) {
          unsearched.push(current_node.getChildAt(i))
        }
      }
      
      return (multiple) ? matching : (matching.length > 0) ? matching.shift() : null
    }
  }
}