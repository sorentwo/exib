/**
* Hotkey
*
* Provides a simple interface to tie keyboard presses to actions. Behaves like a
* button, simply switching the interraction point to the keyboard rather than a
* mouse click.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.service {

  import flash.display.DisplayObject
  import flash.events.KeyboardEvent
  import com.soren.exib.helper.ActionSet
  import com.soren.util.KeyUtil
  
  public class Hotkey {
    
    private var _action_set:ActionSet
    private var _key_code:uint
    private var _toggle:Boolean
    
    /**
    * Constructor
    * 
    * @param character    A keyboard character
    * @param action_set   An action set. It will be called when the character is
    *                     pressed
    * @param stage        A referenced to the root object that will track keyboard
    *                     events
    * @param toggle       Set whether the action is performed for 
    **/
    public function Hotkey(character:String, action_set:ActionSet,
                           stage:DisplayObject, toggle:Boolean = false) {
      _action_set = action_set
      _key_code   = KeyUtil.getKeyCode(character)
      _toggle     = toggle
      
      stage.addEventListener(KeyboardEvent.KEY_DOWN, hotkeyDownListener)
      stage.addEventListener(KeyboardEvent.KEY_UP, hotkeyUpListener)
    }
    
    // ---
    
    /**
    * Triggered when a key is pressed. Performs the registered actions if the
    * key matches the key registered.
    * 
    * @param  event   A KeyboardEvent
    **/
    protected function hotkeyDownListener(event:KeyboardEvent):void {
      if (event.keyCode == _key_code) _action_set.act()
    }
    
    /**
    * Triggered when a key is released. If toggle is enabled for this hotkey and
    * the key matches then it will trigger the registered actions.
    * 
    * @param  event   A KeyboardEvent
    **/
    protected function hotkeyUpListener(event:KeyboardEvent) : void {
      if (_toggle) hotkeyDownListener(event)
    }
  }
}
