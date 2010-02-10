/**
* Cron is an extended wrapper of the timer class and allows a user to set
* up a collection of actions that are performed every time the delay time is
* repeated (event actions), and another set of actions that take place
* when the timer is finished, (compelte actions).
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.service {

  import flash.utils.Timer
  import flash.events.Event
  import flash.events.TimerEvent
  import com.soren.exib.helper.ActionSet
  import com.soren.exib.helper.ConditionalSet

  public class Cron {
	
    private var _timer:Timer
    private var _event_set:ActionSet
    private var _complete_set:ActionSet
    private var _conditional_set:ConditionalSet
    
    /**
    * Sets up a new Cron object with the specified delay, repeat, delta, and
    * omega properties.
    * 
    * @param  delay         The delay between timer events, in milliseconds.
    * @param  repeat        Specifies the number of repetitions. If zero, the
    *                       timer repeats infinitely. If nonzero, the timer runs
    *                       the specified number of times and then stops.
    * @param  event_set     An action set that will be triggered every time the 
    *                       delay event is triggered.
    * @param  complete_set  An action set that will be triggered when the timer
    *                       stops.
    * @param  conditional   A conditional set that, when evaluating to true, will
    *                       trigger the complete action.
    **/
    public function Cron(delay:Number, repeat:uint,
                         event_set:ActionSet            = null,
                         complete_set:ActionSet         = null,
                         conditional_set:ConditionalSet = null) {
      
      validateAndSetActionSets(event_set, complete_set)
      validateAndSetConditionalSet(conditional_set)
      
      _timer = new Timer(delay, repeat)
    }

    protected function get event_set():ActionSet { 
      return _event_set
    }
    
    protected function get complete_set():ActionSet {
      return _complete_set
    }
    
    // ---
    
    /**
    * Starts the cron instance's timer and registers the cron to listen for changes
    * in any model it may be watching.
    **/
    public function start():void {
      _timer.start()
      
      _timer.addEventListener(TimerEvent.TIMER, eventHandler)
      _timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler)
      
      if (_conditional_set) {
        _conditional_set.registerListener(conditionalChangeListener)
      }
    }
    
    /**
    * Alias for reset. For a Timer-like implementation of stop for Cron objects
    * see pause()
    **/
    public function stop():void {
      reset()
    }
    
    public function pause():void {
      _timer.stop()
    }
    
    /**
    * Forces the cron to reset and triggers the complete actions simultaneously
    **/
    public function complete():void {
      reset()
      completeHandler(new TimerEvent(TimerEvent.TIMER_COMPLETE))
    }
    
    /**
    * Stops the timer, if it is running, and sets the currentCount property
    * back to 0, like the reset button of a stopwatch. Then, when start() is
    * called, the timer instance runs for the specified number of repetitions,
    * as set by the repeatCount value.
    **/
    public function reset():void {
      _timer.reset()
      
      _timer.removeEventListener(TimerEvent.TIMER, eventHandler)
      _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler)
      
      if (_conditional_set) {
        _conditional_set.unregisterListener(conditionalChangeListener)
      }
    }
    
    /**
    * Shortcut method for reset()->start(). The timer is reset to 0 and started
    * again.
    **/
    public function restart():void {
      reset()
      start()
    }
    
    protected function conditionalChangeListener(event:Event):void {
      if (Boolean(_conditional_set) && _conditional_set.evaluate()) {
        complete()
      }
    }
    
    protected function eventHandler(event:TimerEvent):void {
      if (_event_set) _event_set.act()
    }
    
    protected function completeHandler(event:TimerEvent):void {
      if (_complete_set) _complete_set.act()
      reset()
    }
    
    // ---
    
    protected function validateAndSetActionSets(event_set:ActionSet,
                                                complete_set:ActionSet):void {
      var valid_sets:uint = 0
      
      if (event_set && !event_set.isEmpty()) {
        _event_set = event_set
        valid_sets ++
      }
      
      if (complete_set && !complete_set.isEmpty()) {
        _complete_set = complete_set
        valid_sets ++
      }
      
      if (valid_sets < 1) throw new Error("Cron: Not enough actions provided.")
    }
	
	  protected function validateAndSetConditionalSet(conditional_set:ConditionalSet):void {
	    if (!conditional_set || conditional_set.isEmpty()) return

      _conditional_set = conditional_set
	  }
	}
}
