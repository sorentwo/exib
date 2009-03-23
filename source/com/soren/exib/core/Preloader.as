/**
* Preloader
*
* Singleton for gathering and reporting the load status of all, or any combination,
* of assets being loaded by EXIB for any given application.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.core {
  
  import com.soren.exib.debug.Log
  import flash.events.Event
  import flash.events.IEventDispatcher
  import flash.events.ProgressEvent
  
  public class Preloader {
    
    public static const AUDIO:uint    = 0
    public static const CONFIG:uint   = 1
    public static const GRAPHIC:uint  = 2
    public static const VIDEO:uint    = 3
    private static const ASSETS:Array = [AUDIO, CONFIG, GRAPHIC, VIDEO]
    
    private static var _instance:Preloader = new Preloader()
    private static var _bytes_loaded:uint  = 0
    private static var _bytes_total:uint   = 0
    private static var _assets:Array =
      [ { name: 'audio',   active: true, bytes_total: 0, bytes_loaded: 0 },
        { name: 'config',  active: true, bytes_total: 0, bytes_loaded: 0 },
        { name: 'graphic', active: true, bytes_total: 0, bytes_loaded: 0 },
        { name: 'video',   active: true, bytes_total: 0, bytes_loaded: 0 }
      ]
    
    /**
    * Singleton, has no constructor
    **/
    public function Preloader() {
      if (_instance) throw new Error('Can only be accessed through Preloader.getPreloader()')
    }
    
    public function getPreloader():Preloader {
      return _instance
    }
    
    // ---
    
    /**
    **/
    public static function get bytesLoaded():uint {
      return _bytes_loaded
    }
    
    /**
    **/
    public static function get bytesTotal():uint {
      return _bytes_total
    }
    
    // ---
    
    /**
    * Return the bytes loaded for a particular asset by supplying its index.
    **/
    public static function assetBytesLoaded(asset_index:uint):uint {
      verifyAssetIndex(asset_index)
      return _assets[asset_index]['bytes_loaded']
    }
    
    /**
    * Return the bytes total for a particular asset by supplying its index.
    **/
    public static function assetBytesTotal(asset_index:uint):uint {
      verifyAssetIndex(asset_index)
      return _assets[asset_index]['bytes_total']
    }
    
    /**
    * Disable tracking of multiple assets by supplying an array of indecies.
    **/
    public static function batchDisableAssets(asset_map:Array):void {
      for each (var asset_index:uint in asset_map) { disableAssetTracking(asset_index) }
    }    
    
    /**
    * Enable tracking of multiple assets by supplying an array of indecies.
    **/
    public static function batchEnableAssets(asset_map:Array):void {
      for each (var asset_index:uint in asset_map) { enableAssetTracking(asset_index) }
    }
    
    /**
    * Disable tracking a particular asset by supplying its index.
    **/
    public static function disableAssetTracking(asset_index:uint):void {
      verifyAssetIndex(asset_index)
      _assets[asset_index]['active'] = false
    }
    
    /**
    * Enable tracking a particular asset by supplying its index.
    **/
    public static function enableAssetTracking(asset:String):void {
      verifyAssetIndex(asset_index)
      _assets[asset_index]['active'] = true
    }
    
    /**
    * 
    **/
    public static function registerDispatcher(asset_index:uint, dispatcher:IEventDispatcher):void {
      dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler)
      dispatcher.addEventListener(Event.COMPLETE, completeHandler)
      
      addToDispatcherPool(dispatcher)
    }
    
    // ---
    
    /**
    * @private
    **/
    private function addToDispatcherPool(dispatcher:IEventDispatcher):void {
      _dispatcher_pool.push({ dispatcher: dispatcher, included_in_total: false })
    }
    
    /**
    * @private
    **/
    private function completeHandler(event:Event):void {
      event.target.removeEventListener(ProgressEvent.PROGRESS, progressHandler)
      event.target.removeEventListener(Event.COMPLETE, completeHandler)
      
      removeFromDispatcherPool(event.target)
    }
    
    /**
    * @private
    **/
    private function progressHandler(event:ProgressEvent):void {
      if (isInitialEvent(event.target)) {
        _bytes_total += event.bytesTotal
      }
      
      _bytes_loaded += event.bytesLoaded
    }
    
    /**
    * @private
    **/
    private function verifyAssetIndex(asset_index:uint):void {
      if (!ASSETS.indexOf(asset_index)) throw new Error('Unknown asset code: ' + asset_index)
    }
  }
}
