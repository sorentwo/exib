/**
* ClockModel
* 
* Model wrapper for a date object. The only value returned is the Date.time.
* This is set at the time the instance is instantiated, or when the update method
* is called.
* 
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.model {
  
  public class ClockModel extends Model {

    private const YEAR:uint    = 0
    private const MONTH:uint   = 1
    private const DATE:uint    = 2
    private const HOURS:uint   = 3
    private const MINUTES:uint = 4
    private const SECONDS:uint = 5

    private var _date:Date
    private var _value:uint
    private var _initial_value:uint
    
    /**
    * @constructor
    * 
    * @param year    uint Value to initialize the date to, optional
    * @param month   uint Value to initialize the date to, optional
    * @param date    uint Value to initialize the date to, optional
    * @param hours   uint Value to initialize the date to, optional
    * @param minutes uint Value to initialize the date to, optional
    * @param seconds uint Value to initialize the date to, optional
    **/
    public function ClockModel(year:uint = undefined, month:uint = undefined,
                               date:uint = undefined, hours:uint = undefined,
                               minutes:uint = undefined, seconds:uint = undefined) {
      _date = new Date()
      
      this.set(year, month, date, hours, minutes, seconds)
      
      _initial_value = _date.valueOf()
    }

    /**
    * Update the instance's value. The new value must be validly formatted
    * UTC milliseconds. This makes manipulation a bit convoluted as some
    * conversion is involved, but results in a more direct use of the getter.
    * 
    * @param  value The new time in UTC milliseconds
    **/
    public override function set value(value:*):void {
      if (!(value is uint)) throw new Error("Value must be a Number in Milliseconds")
      
      _date.time = value
      
      dispatch()
    }
    
    /**
    * Retrieve the instance's value as a date object. Because the return value
    * is untyped, any method needing a typed date object (sprintf) will have to
    * cast it.
    * 
    * @return The clock model's date
    **/
    public override function get value():* {
      return _date
    }
          
    /**
    * Change the year by the supplied value
    **/
    public function changeYear(value:int):void {
      changeValue(YEAR, value)
    }
    
    /**
    * Set the year to a new value
    **/
    public function setYear(value:int):void {
      setValue(YEAR, value)
    }

    /**
    * Change the month by the supplied value
    **/
    public function changeMonth(value:int):void {
      changeValue(MONTH, value)
    }
    
    /**
    * Set the month to a new value
    **/
    public function setMonth(value:int):void {
      setValue(MONTH, value)
    }

    /**
    * Change the date by the supplied value
    **/
    public function changeDate(value:int):void {
      changeValue(DATE, value)
    }
    
    /**
    * Set the date to a new value
    **/
    public function setDate(value:int):void {
      setValue(DATE, value)
    }

    /**
    * Change the hour by the supplied value
    **/
    public function changeHours(value:int):void {
      changeValue(HOURS, value)
    }
    
    /**
    * Set the hour to a new value
    **/
    public function setHours(value:int):void {
      setValue(HOURS, value)
    }

    /**
    * Change the minute by the supplied value
    **/
    public function changeMinutes(value:int):void {
      changeValue(MINUTES, value)
    }
    
    /**
    * Set the minute to a new value
    **/
    public function setMinutes(value:int):void {
      setValue(MINUTES, value)
    }

    /**
    * Change the second by the supplied value
    **/
    public function changeSeconds(value:int):void {
      changeValue(SECONDS, value)
    }
    
    /**
    * Set the second to a new value
    **/
    public function setSeconds(value:int):void {
      setValue(SECONDS, value)
    }
    
    /**
    * Set the meridian to a new value
    **/
    public function setMeridian(meridian:String):void {
      var offset:int = 0
      
      switch (meridian.toUpperCase()) {
        case 'AM':
          offset = (_date.hours >= 12) ? -12 : 0
          break
        case 'PM':
           offset = (_date.hours >= 12) ? 0 : 12
          break
        default :
          throw new Error("Invalid meridian: " + meridian)
      }

      _date.setHours(_date.hours + offset)
    }
    
    /**
    * Cycles the meridian between 'am' and 'pm'
    **/
    public function cycleMeridian():void {
      var offset:int = (_date.hours >= 12) ? -12 : 12
      _date.setHours(_date.hours + offset)
    }
      
    /**
    * Sets date back to the exact time the model was instantiated
    **/
    public override function reset():void {
      this.value = _initial_value
    }
    
    /**
    *  Set a new clock value using the 'year, month, day, hour, minute, second' 
    *  format.
    **/
    public function set(year:uint = undefined, month:uint = undefined,
                        date:uint = undefined, hours:uint = undefined,
                        minutes:uint = undefined, seconds:uint = undefined):void {
      if (Boolean(year))    this.setYear(year)
      if (Boolean(month))   this.setMonth(month)
      if (Boolean(date))    this.setDate(date)
      if (Boolean(hours))   this.setHours(hours)
      if (Boolean(minutes)) this.setMinutes(minutes)
      if (Boolean(seconds)) this.setSeconds(seconds)
    }
    
    /**
    * Force the value to update to the current UTC time
    **/
    public function update():void {
      this.value = new Date().valueOf
    }
  
    // ---
    
    /**
    * @private
    **/
    private function changeValue(kase:uint, value:int):void {
      switch (kase) {
        case YEAR:
          _date.setFullYear(_date.fullYear + value)
          break
        case MONTH:
          _date.setMonth(_date.month + value)
          break
        case DATE:
          _date.setDate(_date.date + value)
          break
        case HOURS:
          _date.setHours(_date.hours + value)
          break
        case MINUTES:
          _date.setMinutes(_date.minutes + value)
          break
        case SECONDS:
          _date.setSeconds(_date.seconds + value)
          break
        default :
          throw new Error("Invalid case for changeValue")
      }
      
      dispatch()
    }
    
    /**
    * @private
    **/
    private function setValue(kase:uint, value:int):void {
      switch (kase) {
        case YEAR:
          _date.setFullYear(value)
          break
        case MONTH:
          _date.setMonth(value)
          break
        case DATE:
          _date.setDate(value)
          break
        case HOURS:
          _date.setHours(value)
          break
        case MINUTES:
          _date.setMinutes(value)
          break
        case SECONDS:
          _date.setSeconds(value)
          break
        default :
          throw new Error("Invalid case for setValue")
      }
      
      dispatch()
    }
  }
}