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
    
    /**
    * Returns the name of weekday based on the day number
    *
    * @param  day     An unsigned integer representing the day of the week
    *                 as a value 0..6, the default output of the Date class
    * @param  short   A boolean value specifying whether the returned day
    *                 name should be truncated to the first three letters.
    *                 The default value of short is false
    * 
    * @return A weekday name based on the day number supplied, i.e. 6 would
    *         'Sunday', or 'Sun' if short is true
    **/
    public static function dayName(day_number:uint, short:Boolean = false):String {
      var long_days:Array = ['Sunday', 'Monday', 'Tuesday', 'Wednesday',
                             'Thursday', 'Friday', 'Saturday']
      var short_days:Array = ['Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat']
      
      var days:Array = (short) ? short_days : long_days
      
      return days[day_number]
    }

    /**
    * Returns the name of the month based on the month number
    *
    * @param  month   An unsigned integer from 0..11 representing the month number
    * @param  short   A boolean value specifying whether the returned month
    *                 name should be truncated to the first three letters.
    *                 The default value of short is false
    *  
    * @return A month name based on the month number supplied, i.e. 0 would
    *         return 'January', or 'Jan' if short is true
    **/
    public static function monthName(month_number:uint, short:Boolean = false):String {
      var months:Array = ['January', 'February', 'March', 'April',
                          'May', 'June', 'July', 'August', 'September',
                          'October', 'November', 'December']
      var month:String = months[month_number]
      month = (short) ? month.substr(0, 3) : month
      
      return month
    }
  }
}
