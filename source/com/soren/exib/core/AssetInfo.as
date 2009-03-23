/**
* AssetInfo
*
* Ad Hoc container class to assist Preloader
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.core {

  import flash.utils.Dictionary
  
  public class AssetInfo {
    
    private var _active:Boolean     = false
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
    
    public function get bytes_loaded():Object {
      return _bytes_loaded
    }
    
    public function get bytes_total():uint {
      return _bytes_total
    }
    
    public function get pool():Dictionary {
      return _pool
    }
  }
}
