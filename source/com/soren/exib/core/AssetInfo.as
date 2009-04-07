/**
* AssetInfo
*
* Ad Hoc container class to assist Aggregator
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.core {

  import flash.utils.Dictionary
  
  public class AssetInfo {
    
    private var _active:Boolean     = true
    private var _bytes_total:uint   = 0
    private var _bytes_loaded:uint  = 0
    private var _pool:Dictionary    = new Dictionary(true)
    
    public function AssetInfo() {}
    
    public function get active():Boolean {
      return _active
    }
    
    public function set active(active:Boolean):void {
      _active = active
    }
    
    public function get bytes_loaded():uint {
      return _bytes_loaded
    }
    
    public function set bytes_loaded(bytes_loaded:uint):void {
      _bytes_loaded = bytes_loaded
    }
    
    public function get bytes_total():uint {
      return _bytes_total
    }
    
    public function set bytes_total(bytes_total:uint):void {
      _bytes_total = bytes_total
    }
    
    public function get pool():Dictionary {
      return _pool
    }
    
    // ---

    public function calculateBytesLoaded():void {
      _bytes_loaded = 0
      for (var key:Object in _pool) { _bytes_loaded += uint(_pool[key]) }
    }
  }
}
