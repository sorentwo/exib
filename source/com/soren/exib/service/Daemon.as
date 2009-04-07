/**
* The Daemon class identical to the Cron class in that it performs two
* distinct sets of actions, event actions and complete actions. Where it
* differs is that it can not be acted upon, and is started immediately
* upon creation.
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.service {
  
  import com.soren.exib.helper.*

  public class Daemon extends Cron {

    /**
    * Creates a new Daemon instance with the specified delay, event, and complete
    * actions.
    * 
    * @param  delay     The delay between timer events, in milliseconds.
    * @param  event     An array of controller:action objects that will be
    *                   triggered every time the delay event is triggered.
    * @param  complete  An array of controller:action objects that will be
    *                   triggered when the conditional set is true.
    * @param  condition A single conditional object or an array of conditional
    *                   objects.
    **/
    public function Daemon(delay:uint,
                           event_set:ActionSet            = null,
                           complete_set:ActionSet         = null,
                           conditional_set:ConditionalSet = null) {
      
      super(delay, 0, event_set, complete_set, conditional_set)
      start()
    }

    public override function stop():void          { invalidMethod('stop')          }
    
    private function invalidMethod(method:String):void {
      throw new Error(method + ": is not available for instances of the Daemon class")
    }
	}
}
