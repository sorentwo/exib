/**
* Log
*
* A fairly standard logging utility. It may be used to replace any trace
* statements and to additionally tie into the debugging satellite.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.debug {
  
  import com.soren.exib.core.IActionable

  public class Log implements IActionable {
    
    public static const DEBUG:uint = 0
    public static const WARN:uint  = 1
    public static const ERROR:uint = 2
    public static const FATAL:uint = 3
    public static const LEVELS:Array = ['DEBUG', 'WARN', 'ERROR', 'FATAL']

    private static var _instance:Log = new Log()
    
    private static var _level:uint = DEBUG
    private static var _throw_on_error:Boolean = false
    
    public function Log() {
      if (_instance) throw new Error("Can only be accessed through Logger.getLog()")
    }
    
    /**
    * Returns *the* Logger instance.
    **/
    public static function getLog():Log {      
      return _instance
    }
    
    /**
    * Returns the warning level that will be used.
    **/
    public function get level():uint {
      return _level
    }
    
    /**
    * Set the warning level to one of the valid levels, 0-3, DEBUG through FATAL.
    **/
    public function set level(level:uint):void {
      if (level > DEBUG && level < FATAL) throw new Error('Invalid level provided: ' + level)
      _level = level
    }
    
    /**
    * Set whether logging an error will also throw an exception.
    **/
    public function get throwOnError():Boolean {
      return _throw_on_error
    }
    
    /**
    * 
    **/
    public function set throwOnError(throw_on_error:Boolean):void {
      _throw_on_error = throw_on_error
    }
    
    // ---
    
    /**
    * Write out a trace statement at the debug level. This is the default trace
    * level.
    **/
    public function debug(message:*):void {
      write(DEBUG, homogenize(message))
    }
    
    /**
    * Write out a trace statement at the warning level.
    **/
    public function warn(message:*):void {
      write(WARN, homogenize(message))
    }
    
    /**
    * Write out a trace statement at the error level.
    **/
    public function error(message:*):void {
      write(ERROR, homogenize(message))
      if (_throw_on_error) throw new Error('ERROR: ' + message)
    }
    
    /**
    * Write out a trace statement at the fatal level.
    **/
    public function fatal(message:*):void {
      write(FATAL, homogenize(message))
      throw new Error('FATAL: ' + message)
    }
    
    // ---
    
    /**
    * @private
    **/
    private function homogenize(message:*):String {
      var homogenized:String = ''
      
      if (message == null)           { homogenized = 'null'             }
      else if (message == undefined) { homogenized = 'undefined'        }
      else                           { homogenized = message.toString() }
      
      return homogenized
    }
    
    /**
    * @private
    * Writes out a formatted trace statement. If a local connection is present it
    * will write to the satellite as well.
    **/
    private function write(level:uint, message:String):void {
      if (level >= _level) {
        trace(LEVELS[level] + ': ' + message + '\n')
      }
    }
  }
}
