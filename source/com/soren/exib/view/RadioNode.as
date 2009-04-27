/**
* RadioNode
*
* Creates a collection of radio buttons - buttons with selected and unselected
* states in which only one can be selected at a time.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.events.Event
  import com.soren.exib.debug.Log
  import com.soren.exib.model.Model
  import com.soren.exib.helper.Action
  import com.soren.exib.helper.ActionSet

  public class RadioNode extends Node {

    private var _model:Model
    private var _options:Array
    private var _selected_url:String
    private var _unselected_url:String

    /**
    * Constructs a new RadioNode set. Within a set only one model and two
    * graphics are used. Because this model and both graphics are used to
    * construct each individual radio button (created using the +add+ method)
    * they must be supplied initially.
    *
    * @param  model     The Model instance that individual radio options will be
    *                   evaluated against.
    * @param  sel_url   URL of the graphic that will be used to show selection.
    * @param  unsel_url URL of the graphic that will be used to show that an item
    *                   is unselected.
    **/
    public function RadioNode(model:Model, sel_url:String, unsel_url:String) {
      _model          = model
      _selected_url   = sel_url
      _unselected_url = unsel_url
      
      _options = []
      
      _model.addEventListener(Model.CHANGED, changeListener)
    }

    /**
    * Add a new option to the radio set. Buttons and graphics are automatically
    * generated from the set's selected and unselcted graphics (supplied at
    * construction). Each option added must have a unique value.
    *
    * @param  pos      A position string in the form of x,y
    * @param  value    Unique value that will be matched against the current value
    *                  of the model. If the values match this option will be active.
    * @param  actions  An optional set of actions that will be triggered on press.
    **/
    public function add(pos:String, value:*, actions:ActionSet = undefined):void {
      verifyUniqueValue(value)

      actions = actions || new ActionSet()
      actions.push(new Action(_model, 'set', value))

      var graphic:GraphicNode = new GraphicNode(_selected_url)
      var button:ButtonNode   = new ButtonNode(_unselected_url, _unselected_url, new ActionSet(), actions)
      
      graphic.position(pos)
      button.position(pos)
      
      _options.push( { graphic: graphic, button: button, value: value } )
      
      update()
    }

    /**
    * Displays all selected or unselected (selectable) graphics.
    **/
    override public function update():void {
      unloadAll()
      for each (var option:Object in _options) {
        if (option.value == _model.value) { addChild(option.graphic) }
        else                              { addChild(option.button)  }
      }
    }

    // ---

    /**
    * @private
    *
    * Checks the value against each existing value to ensure that they are unique.
    **/
    private function verifyUniqueValue(value:*):void {
      for each (var option:Object in _options) {
        if (option.value == value) {
          Log.getLog().error('Value supplied is not unique: ' + option)
        }
      }
    }
  }
}
