/**
* TimeUtil
*
* A collection of simple methods for manipulating time values.
*
* Copyright (c) 2008 Parker Selbert
**/
package com.soren.util {

  public class TimeUtil {

    public function TimeUtil() {
      throw new Error("TimeUtil class is a static container only")
    }
    
    /**
    * Convert raw seconds to whole hours. For example, 3600 seconds would return
    * 1 hour. 5400 seconds would also return 1 hour. This method does not return
    * a remainder.
    * 
    * @param  seconds   Number of seconds to convert to whole hours. Any value
    *                   less than 3600 will return 0 hours.
    * @return Whole hours
    **/
    public static function modHours(seconds:uint):uint {
      return Math.floor(seconds / 3600)
    }
    
    /**
    * Convert raw seconds to whole minutes. For example, 5400 seconds would return
    * 30 minutes. 5450 seconds would also return 30 minutes.
    * 
    * @param  seconds   Number of seconds to convert to whole minutes. Any value
    *                   less than 60 will return 0 minutes.
    * @param  Whole minutes
    **/
    public static function modMinutes(seconds:uint):uint {
      return Math.floor((seconds - (modHours(seconds) * 3600)) / 60)
    }
    
    /**
    * Convert raw seconds to seconds remaining after hours and minutes have been
    * removed. For example, 5305 seconds would return 25 seconds.
    * 
    * @param  seconds   Number of seconds to convert to remaining seconds.
    * @return Remaining seconds
    **/
    public static function modSeconds(seconds:uint):uint {
      return seconds - (modHours(seconds) * 3600) - (modMinutes(seconds) * 60)
    }
  }
}
