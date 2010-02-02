/**
* Retrieve day and month names based on their numerical value.
*
* Copyright (c) 2008 Parker Selbert
**/
package com.soren.util {

  public class DateUtil {
    
    public static const LONG_DAYS:Array = [
      'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
    ]
    
    public static const SHORT_DAYS:Array = [
      'Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'
    ]
    
    public static const LONG_MONTHS:Array = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ]
    
    public static const SHORT_MONTHS:Array = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
      'Nov', 'Dec'
    ]
    
    public function DateUtil() {
      throw new Error("DateUtil class is a static container only")
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
    public static function dayName(day:uint, short:Boolean = false):String {
      return (short) ? SHORT_DAYS[day] : LONG_DAYS[day]
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
    public static function monthName(month:uint, short:Boolean = false):String {
      return short ? SHORT_MONTHS[month] : LONG_MONTHS[month]
    }
  }
}
