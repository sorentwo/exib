/**
* Log
*
* A fairly standard logging utility. It may be used to replace any trace
* statements and to additionally tie into the debugging satelite.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.debug {
  
  import flash.net.LocalConnection

  public class Log {

    public static const DEBUG:uint = 0
    public static const WARN:uint  = 1
    public static const ERROR:uint = 2
    public static const FATAL:uint = 3
    public static const LEVELS:Array = ['DEBUG', 'WARN', 'ERROR', 'FATAL']

    private static var _instance:Log = new Log()
    private static var _connection:LocalConnection = new LocalConnection()
    
    private static var _level:uint      = DEBUG
    private static var _satelite:String = 'satelite'
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
      _level = level
    }
    
    /**
    * Retrieves the name of the logger satelite, the other half of the local
    * connection to which messages are sent.
    **/
    public function get satelite():String {
      return _satelite
    }
    
    /**
    * Change the name of the logger satelite.
    **/
    public function set satelite(satelite:String):void {
      _satelite = satelite
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
    public function debug(message:String):void {
      write(DEBUG, message)
    }
    
    /**
    * Write out a trace statement at the warning level.
    **/
    public function warn(message:String):void {
      write(WARN, message)      
    }
    
    /**
    * Write out a trace statement at the error level.
    **/
    public function error(message:String):void {
      write(ERROR, message)
      if (_throw_on_error) throw new Error('ERROR: ' + message)
    }
    
    /**
    * Write out a trace statement at the fatal level.
    **/
    public function fatal(message:String):void {
      write(FATAL, message)
      throw new Error('FATAL: ' + message)
    }
    
    /**
    * Clears the currently displayed trace statements.
    **/
    public function clear():void {
      _connection.send(_satelite, 'clear')
    }
    
    // ---
    
    /**
    * @private
    * Writes out a formatted trace statement. If a local connection is present it
    * will write to the satelite as well.
    **/
    private function write(level:uint, message:String):void {
      if (level >= _level) {
        var output:String = LEVELS[level] + ': ' + message + '\n'

        _connection.send(_satelite, 'write', output)
        
        // Fallback to Flash's trace
        trace(output)
      }
    }
  }
}
