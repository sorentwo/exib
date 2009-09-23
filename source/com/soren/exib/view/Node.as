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
    
    protected var _id:String    = ''
    protected var _groups:Array = []
    
    // Implemented directly because this can not be a dynamic class. Get / Set
    // methods seem overkill, but may be used in the future.
    public var blur_x:uint       = 0
    public var blur_y:uint       = 0
    public var glow_alpha:Number = 0
    public var glow_blur:uint    = 0
    public var glow_color:Number = 0xFF0000
    
    /**
    * Lets you create an empty Node container.
    **/
    public function Node() {}
    
    /**
    * @param  node_id A unique identifier for the node. Uniqueness is implicite,
    *                 and is not checked.
    **/
    public function set id(node_id:String):void {
      _id = node_id
    }
    
    /**
    * The unique id of this node. If no id is set an empty string is returned.
    **/
    public function get id():String {
      return _id
    }
    
    /**
    * Set one or more groups.
    * 
    * @param  groups  An array of group names.
    **/
    public function set groups(groups:Array):void {
      if (groups.length < 1) throw new Error('Not enough groups, at least one is required')
      
      for each (var group:* in groups) {
        if (!group is String) throw new Error('String required, invalid object: ' + group)
      }
      
      _groups = groups
    }
    
    /**
    * Get the groups that this node belongs to as an array of strings.
    * 
    * @return An array of group names.
    **/
    public function get groups():Array {
      return _groups
    }
    
    /**
    * Add a new group to the list of groups this node belongs to. Groups are not
    * case sensitive and are normalized.
    * 
    * @param  group Name of the group to add.
    **/
    public function addGroup(group:String):void {
      if (_groups.indexOf(group) != -1) throw new Error('Node already belongs to group: ' + group)
      
      _groups.push(group.toLowerCase())
    }
    
    /**
    * Check whether this node instance belongs to the provided group. Groups are
    * not case sensitive.
    **/
    public function hasGroup(group:String):Boolean {
      return (_groups.indexOf(group.toLowerCase()) == -1) ? false : true
    }
    
    /**
    * Returns zero or more child nodes that match the supplied group.
    * 
    * @param group  A group to match.
    * @return       An array of zero or more nodes.
    **/
    public function getChildrenByGroup(group:String):Array {
      return bsearch(group, 'group', true)
    }
    
    /**
    * Returns the first node it finds that matches the supplied id.
    * 
    * @param  id  A unique id to match against this node's children.
    * @return     A node if one was found, otherwise <code>null</code>.
    **/
    public function getChildById(id:String):* {
      return bsearch(id, 'id', false)
    }
    
    /**
    * A shortcut method for placing a node by x,y coordinates.
    * 
    * @param  coordinates A x and y coordinate pair in the form "x,y"
    **/
    public function position(coordinates:String):void {
      var pattern:RegExp = /(?P<x>-?\d+)\s*,\s*(?P<y>-?\d+)/
      
      if (!pattern.test(coordinates)) throw new Error("Invalid coordinates: " + coordinates)
      
      var result:Object = pattern.exec(coordinates)
      this.x = int(result.x)
      this.y = int(result.y)
    }
    
    /**
    * Abstract method to be overridden by sub-classes. Intended to trigger a
    * display update for the instance.
    **/
    public function update():void {}
    
    // ---
    
    /**
    * Event handler for model changes. Simply triggers the update method.
    **/
    protected function changeListener(event:Event):void {
      update()
    }
    
    /**
    * Remove every child from this node's display list.
    **/
    protected function unloadAll():void {
      while (this.numChildren > 0) { removeChildAt(0) }
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

        if ((property == 'id'    && current_node[property].toLowerCase() == normalized_target) ||
            (property == 'group' && current_node.hasGroup(normalized_target))) {
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