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
  import flash.events.EventDispatcher
  import flash.events.IEventDispatcher
  import flash.events.ProgressEvent
  import flash.utils.Dictionary
  
  public class Preloader extends EventDispatcher {
    
    public static const AUDIO:uint    = 0
    public static const CONFIG:uint   = 1
    public static const GRAPHIC:uint  = 2
    public static const VIDEO:uint    = 3
    
    public static const AUDIO_COMPLETE:uint   = 0
    public static const CONFIG_COMPLETE:uint  = 1
    public static const GRAPHIC_COMPLETE:uint = 2
    public static const VIDEO_COMPLETE:uint   = 3
    public static const COMPLETE:uint         = 4
    
    private static var _instance:Preloader = new Preloader()
    private static var _bytes_loaded:uint  = 0
    private static var _bytes_total:uint   = 0
    
    // AUDIO, CONFIG, GRAPHIC, VIDEO
    private static var _assets:Array = [ new AssetInfo(), new AssetInfo(), new AssetInfo(), new AssetInfo()]
    
    /**
    * Singleton, has no constructor
    **/
    public function Preloader() {
      if (_instance) throw new Error('Can only be accessed through Preloader.getPreloader()')
    }
    
    public static function getPreloader():Preloader {
      return _instance
    }
    
    // ---
    
    public static function get bytesLoaded():uint        { return _bytes_loaded }
    public static function get audioBytesLoaded():uint   { return _assets[AUDIO].bytes_loaded   }
    public static function get configBytesLoaded():uint  { return _assets[CONFIG].bytes_loaded  }
    public static function get graphicBytesLoaded():uint { return _assets[GRAPHIC].bytes_loaded }
    public static function get videoBytesLoaded():uint   { return _assets[VIDEO].bytes_loaded   }

    public static function get bytesTotal():uint        { return _bytes_total }    
    public static function get audioBytesTotal():uint   { return _assets[AUDIO].bytes_total   }
    public static function get configBytesTotal():uint  { return _assets[CONFIG].bytes_total  }
    public static function get graphicBytesTotal():uint { return _assets[GRAPHIC].bytes_total }
    public static function get videoBytesTotal():uint   { return _assets[VIDEO].bytes_total   }
    
    // ---
    
    /**
    * Return the bytes loaded for a particular asset by supplying its index.
    **/
    public static function assetBytesLoaded(asset_index:uint):uint {
      verifyAssetIndex(asset_index)
      return _assets[asset_index].bytes_loaded
    }
    
    /**
    * Return the bytes total for a particular asset by supplying its index.
    **/
    public static function assetBytesTotal(asset_index:uint):uint {
      verifyAssetIndex(asset_index)
      return _assets[asset_index].bytes_total
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
      _assets[asset_index].active = false
    }
    
    /**
    * Enable tracking a particular asset by supplying its index.
    **/
    public static function enableAssetTracking(asset:String):void {
      verifyAssetIndex(asset_index)
      _assets[asset_index].active = true
    }
    
    /**
    **/
    public static function registerDispatcher(asset_index:uint, dispatcher:IEventDispatcher):void {
      verifyAssetIndex(asset_index)
      
      var progress_handler:Function
      var complete_handler:Function
      
      switch (asset_index) {
        case AUDIO:
          progress_handler = audioProgressHandler
          complete_handler = audioCompleteHandler
          break
        case CONFIG:
          progress_handler = configProgressHandler
          complete_handler = configCompleteHandler
          break
        case GRAPHIC:
          progress_handler = graphicProgressHandler
          complete_handler = graphicCompleteHandler
          break
        case VIDEO:
          progress_handler = videoProgressHandler
          complete_handler = videoCompleteHandler
          break
      }
      
      dispatcher.addEventListener(ProgressEvent.PROGRESS, progress_handler)
      dispatcher.addEventListener(Event.COMPLETE, complete_handler)
      
      // Here 'false' indicates that that dispatcher's target hasn't been totaled
      _assets[asset_index].pool[dispatcher] = false
    }
    
    // ---
    
    /**
    * @private
    **/
    private function completeHandler(asset_index:uint, event:Event):void {
      // Duplicate code. DRYing this up introduces redundancy in itself, a little lazy
      var progress_handler:Function
      var complete_handler:Function
      var dispatch_code:uint
      
      switch (asset_index) {
        case AUDIO:
          progress_handler = audioProgressHandler
          complete_handler = audioCompleteHandler
          dispatch_code    = Preloader.AUDIO_COMPLETE
          break
        case CONFIG:
          progress_handler = configProgressHandler
          complete_handler = configCompleteHandler
          dispatch_code    = Preloader.CONFIG_COMPLETE
          break
        case GRAPHIC:
          progress_handler = graphicProgressHandler
          complete_handler = graphicCompleteHandler
          dispatch_code    = Preloader.GRAPHIC_COMPLETE
          break
        case VIDEO:
          progress_handler = videoProgressHandler
          complete_handler = videoCompleteHandler
          dispatch_code    = Preloader.VIDEO_COMPLETE
          break
      }
      
      event.target.removeEventListener(ProgressEvent.PROGRESS, progress_handler)
      event.target.removeEventListener(Event.COMPLETE, complete_handler)
      
      // Asset type specific
      if (_assets[asset_index].bytes_loaded == _assets[asset_index].bytes_total) {
        dispatchEvent(new Event(dispatch_code))
      }
      
      // Global
      if (_bytes_loaded == _bytes_total) {
        dispatchEvent(new Event(Preloader.COMPLETE))
      }
    }
    
    private function audioCompleteHandler(event:Event):void   { completeHandler(AUDIO, event)   }
    private function configCompleteHandler(event:Event):void  { completeHandler(CONFIG, event)  }
    private function graphicCompleteHandler(event:Event):void { completeHandler(GRAPHIC, event) }
    private function videoCompleteHandler(event:Event):void   { completeHandler(VIDEO, event)   }
    
    /**
    * @private
    **/
    private function progressHandler(asset_index:uint, event:ProgressEvent):void {
      if (_assets[asset_index].active == false) return
      
      if (isInitialEvent(asset_index, event.target)) {
        _assets[asset_index].pool[event.target] = true // Tracked, toggle the boolean
        _assets[asset_index].bytes_total += event.bytesTotal
        
        calculateGlobalBytesTotal()
      }
      
      _assets[asset_index].bytes_loaded += event.bytesLoaded
      calculateGlobalBytesLoaded()
    }
    
    private function audioProgressHandler(event:ProgressEvent):void   { progressHandler(AUDIO, event) }
    private function configProgressHandler(event:ProgressEvent):void  { progressHandler(CONFIG, event) }
    private function graphicProgressHandler(event:ProgressEvent):void { progressHandler(GRAPHIC, event) }
    private function videoProgressHandler(event:ProgressEvent):void   { progressHandler(VIDEO, event) }
    
    /**
    * @private
    **/
    private function calculateGlobalBytesLoaded():void {
      for each (var asset_info:Object in assets) {
        if (asset_info.active) _bytes_loaded += asset_info.bytes_loaded
      }
    }
    
    /**
    * @private
    **/
    private function calculateGlobalBytesTotal():void {
      _bytes_total = 0
      for each (var asset_info:Object in assets) {
        if (asset_info.active) _bytes_total += asset_info.bytes_total
      }
    }
    
    /**
    * @private
    **/
    private function isInitialEvent(asset_index:uint, dispatcher:IEventDispatcher):Boolean {
      var initial_event:Boolean
      var pool:Dictionary = _assets[asset_index].pool
      
      if (pool[dispatcher] == false) { initial_event = true }
      else                           { initial_event = false  }
      
      return initial_event
    }
    
    /**
    * @private
    **/
    private function verifyAssetIndex(asset_index:uint):void {
      if (asset_index < AUDIO || asset_index > VIDEO) throw new Error('Unknown asset code: ' + asset_index)
    }
    
    /**
    * @private
    **/
    private function verifyDispatcher(dispatcher:IEventDispatcher):void {
      if (!(dispatcher is URLLoader) || !(dispatcher is LoaderInfo)) {
        throw new Error('Unusable dispatcher: ' + dispatcher + ', URLLoader or LoaderInfo required')
      }
    }
  }
}
