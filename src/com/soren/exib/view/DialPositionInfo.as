/**
* Typed data container for use by the DialNode class.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {
  
  import com.soren.exib.helper.ActionSet
  
  public class DialPositionInfo {
    
    public var snap:uint = 0
    public var ambiguous:ActionSet = null
    public var clockwise:ActionSet = null
    public var counter:ActionSet   = null
    
    public var preceding:uint  = 0
    public var anteceding:uint = 0
    
    /**
    * Store typed position info.
    * 
    * @param  snap      Angle to snap to
    * @param  ambiguous Actions that will be triggered regardless of direction
    * @param  clockwise Actions that will be triggered when the dial is moved
    *                   clockwise.
    * @param  counter   Actions that will be triggered when the dial is moved
    *                   counterclockwise.
    **/
    public function DialPositionInfo($snap:uint,
                                     $ambiguous:ActionSet = null,
                                     $clockwise:ActionSet = null,
                                     $counter:ActionSet = null) {
      snap = $snap
      ambiguous = $ambiguous; clockwise = $clockwise; counter = $counter
    }
  }
}
