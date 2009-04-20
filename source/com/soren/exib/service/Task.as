/**
* Task is a bare bones container for actions. It provides the behavior of a cron
* with no repeat, delay or conditions.<br />
* And why task? Because function is reserved.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.service {

  import com.soren.exib.core.IActionable
  import com.soren.exib.helper.ActionSet

  public class Task implements IActionable{

    private var _action_set:ActionSet
    
    /**
    * Creates a new Task object with the supplied action_set.
    *
    * @param action_set   A collection of actions to be triggered
    **/
    public function Task(action_set:ActionSet) {
      _action_set = action_set
    }
    
    /**
    * Triggers the associated actions.
    **/
    public function call():void {
      _action_set.act()
    }
  }
}
