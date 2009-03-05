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

    public static var DEBUG:uint = 0
    public static var WARN:uint  = 1
    public static var ERROR:uint = 2
    public static var FATAL:uint = 3
    public static var LEVELS:Array = ['DEBUG', 'WARN', 'ERROR', 'FATAL']

    private static var _instance:Logger = new Log()
    private static var _level:uint      = DEBUG
    private static var _connection:LocalConnection = new LocalConnection()
    
    public function Log() {
      if (_instance) throw new Error("Can only be accessed through Logger.getLogger()")
    }
    
    /**
    * Returns *the* Logger instance.
    **/
    public static function getLogger():Logger {
      return _instance
    }
    
    /**
    * Returns the warning level that will be used.
    **/
    public static function get level():uint {
      return _level
    }
    
    /**
    * Set the warning level to one of the valid levels, 0-3, DEBUG through FATAL.
    **/
    public static function set level(level:uint):void {
      _level = level
    }
    
    // ---
    
    public function debug(message:String):void {
      write(DEBUG, message)
    }
    
    public function warn(message:String):void {
      write(WARN, message)      
    }
    
    public function error(message:String):void {
      write(ERROR, message)
    }
    
    public function fatal(message:String):void {
      write(FATAL, message)
    }
    
    // ---
    
    /**
    * @private
    * Writes out a formatted trace statement. If a local connection is present it
    * will write to the satelite as well.
    * 
    **/
    private function write(level:uint, message:String):void {
      if (level >= _level) {
        var output:String = LEVELS[level] + ': ' + message + '\n'
        
        _connection.send('_logger', 'write', output)
        trace(output)
      }
    }
  }
}
