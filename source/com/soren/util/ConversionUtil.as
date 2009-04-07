/**
* ConversionUtil
* 
* The convert class is a collection of simple methods to convert between
* units and from machine style notation to human readable notation, days
* of the week, months, military time to standard time, etc.
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.util {

  public class ConversionUtil {

    public static const DEFAULT_ACCURACY:uint = 1

    public function ConversionUtil() {
      throw new Error("ConversionUtil class is a static container only")
    }

    /**
    * Calculate the equivalent number of cups from a base unit of ounces
    *
    * @param  ounces      Number of ounces to convert
    * @param  accuracy    Optional, number of trailing decimals. The default
    *                     accuracy is 1 trailing digit
    * 
    * @return The number of cups as a string with trailing digits to the
    *         amount specified in accuracy
    **/
    public static function toCups(ounces:Number,
                           accuracy:uint = DEFAULT_ACCURACY):String {
      var cups:String = (ounces / 8).toString()
      return cups.substring(0, accuracy + 2)
    }

    /**
    * Calculate the equivalent number of litres from a base unit of ounces
    *
    * @param  ounces      Number of ounces to convert
    * @param  accuracy    Optional, number of trailing decimals. The default
    *                     accuracy is 1 trailing digit
    *  
    * @return The number of litres, as a string, with trailing digits to the
    *         amount specified in accuracy
    **/
    public static function toLitres(ounces:Number,
                             accuracy:uint = DEFAULT_ACCURACY):String {
      var litres:String = (ounces * 0.0295735297).toString()
      return litres.substring(0, accuracy + 2)
    }

    /**
    * Temperature conversion from celsius to fahrenheit
    *
    * @param  celsius   The base temperature in celsius to convert
    * @param  round     A boolean value indicating whether the output
    *                   should be rounded or not
    * @param  accuracy  Optional, number of trailing decimals. The default
    *                   accuracy is 1 trailing digit
    * 
    * @return The temperature in fahrenheit, rounded and truncated as
    *         specified by round and accuracy
    **/
    public static function toFahrenheit(celsius:Number,
                                 round:Boolean = true,
                                 accuracy:uint = DEFAULT_ACCURACY):String {
      var fahrenheit:Number = ((celsius * 9) / 5 ) + 32
      fahrenheit = (round) ? Math.round(fahrenheit) : fahrenheit
      return fahrenheit.toString().substring(0, accuracy + 2)
    }

    /**
    * Temperature conversion from fahrenheit to celsius
    *
    * @param  fahrenheit  The base temperature in fahrenheit to convert
    * @param  round       A boolean value indicating whether the output
    *                     should be rounded or not
    * @param  accuracy    Optional, number of trailing decimals. The default
    *                     accuracy is 1 trailing digit
    * 
    * @return The temperature in celsius, rounded and truncated as
    *         specified by round and accuracy
    **/
    public static function toCelsius(fahrenheit:Number,
                              round:Boolean = true,
                              accuracy:uint = DEFAULT_ACCURACY):String {
      var celsius:Number = ((fahrenheit - 32) * 5) / 9
      celsius = (round) ? Math.round(celsius) : celsius
      return celsius.toString().substring(0, accuracy + 2)
    }

    /**
    **/
    public static function toD(input:Number):String {
      return Pad.padFloat(input / 10, 1)
    }
    
    /**
    **/
    public static function toC(input:Number):String {
      return Pad.padFloat(input / 100, 1)
    }
    
    /**
    **/
    public static function toK(input:Number):String {
      return Pad.padFloat(input / 1000, 1)
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
