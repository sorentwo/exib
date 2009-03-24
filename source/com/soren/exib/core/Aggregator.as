/**
* Aggregator
*
* Singleton for gathering and reporting the load status of all, or any combination,
* of assets being loaded by EXIB for any given application.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.core {
  
  import com.soren.debug.Log
  import flash.display.LoaderInfo
  import flash.events.Event
  import flash.events.EventDispatcher
  import flash.events.IEventDispatcher
  import flash.events.ProgressEvent
  import flash.media.Sound
  import flash.net.NetStream
  import flash.net.URLLoader
  import flash.utils.Dictionary
  
  public class Aggregator extends EventDispatcher {
    
    public static const AUDIO:uint    = 0
    public static const CONFIG:uint   = 1
    public static const GRAPHIC:uint  = 2
    public static const VIDEO:uint    = 3
    
    public static const AUDIO_COMPLETE:String   = 'audio_complete'
    public static const CONFIG_COMPLETE:String  = 'config_complete'
    public static const GRAPHIC_COMPLETE:String = 'graphic_complete'
    public static const VIDEO_COMPLETE:String   = 'video_complete'
    public static const COMPLETE:String         = 'complete'
    
    private static var _instance:Aggregator = new Aggregator()
    private static var _bytes_loaded:uint  = 0
    private static var _bytes_total:uint   = 0
    
    // AUDIO, CONFIG, GRAPHIC, VIDEO
    private static var _assets:Array = [ new AssetInfo(), new AssetInfo(), new AssetInfo(), new AssetInfo()]
    
    /**
    * Singleton, has no constructor
    **/
    public function Aggregator() {
      if (_instance) throw new Error('Can only be accessed through Aggregator.getAggregator()')
    }
    
    public static function getAggregator():Aggregator {
      return _instance
    }
    
    // ---
    
    public function get bytesLoaded():uint { return _bytes_loaded }
    public function get bytesTotal():uint  { return _bytes_total  }
    
    // ---
    
    /**
    * Return the bytes loaded for a particular asset by supplying its index.
    **/
    public function assetBytesLoaded(asset_index:uint):uint {
      verifyAssetIndex(asset_index)
      return _assets[asset_index].bytes_loaded
    }
    
    /**
    * Return the bytes total for a particular asset by supplying its index.
    **/
    public function assetBytesTotal(asset_index:uint):uint {
      verifyAssetIndex(asset_index)
      return _assets[asset_index].bytes_total
    }
    
    /**
    * Disable tracking of multiple assets by supplying an array of indecies.
    **/
    public function batchDisableAssets(asset_map:Array):void {
      for each (var asset_index:uint in asset_map) { disableAssetTracking(asset_index) }
    }    
    
    /**
    * Enable tracking of multiple assets by supplying an array of indecies.
    **/
    public function batchEnableAssets(asset_map:Array):void {
      for each (var asset_index:uint in asset_map) { enableAssetTracking(asset_index) }
    }
    
    /**
    * Disable tracking a particular asset by supplying its index.
    **/
    public function disableAssetTracking(asset_index:uint):void {
      verifyAssetIndex(asset_index)
      _assets[asset_index].active = false
    }
    
    /**
    * Enable tracking a particular asset by supplying its index.
    **/
    public function enableAssetTracking(asset_index:uint):void {
      verifyAssetIndex(asset_index)
      _assets[asset_index].active = true
    }
    
    /**
    * Register an asset's loader client to track progress. Valid dispatchers are
    * Loader, URLLoader, Sound, and NetStream
    **/
    public function registerDispatcher(asset_index:uint, dispatcher:IEventDispatcher):void {
      verifyAssetIndex(asset_index)
      verifyDispatcher(dispatcher)
      
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
      
      // Here 0 indicates that that dispatcher's target hasn't been totaled
      _assets[asset_index].pool[dispatcher] = 0
    }
    
    // ---
    
    /**
    * @private
    **/
    private function completeHandler(asset_index:uint, event:Event):void {
      // Duplicate code. DRYing this up introduces redundancy in itself, a little lazy
      var progress_handler:Function
      var complete_handler:Function
      var dispatch_code:String
      
      switch (asset_index) {
        case AUDIO:
          progress_handler = audioProgressHandler
          complete_handler = audioCompleteHandler
          dispatch_code    = Aggregator.AUDIO_COMPLETE
          break
        case CONFIG:
          progress_handler = configProgressHandler
          complete_handler = configCompleteHandler
          dispatch_code    = Aggregator.CONFIG_COMPLETE
          break
        case GRAPHIC:
          progress_handler = graphicProgressHandler
          complete_handler = graphicCompleteHandler
          dispatch_code    = Aggregator.GRAPHIC_COMPLETE
          break
        case VIDEO:
          progress_handler = videoProgressHandler
          complete_handler = videoCompleteHandler
          dispatch_code    = Aggregator.VIDEO_COMPLETE
          break
      }
      
      event.target.removeEventListener(ProgressEvent.PROGRESS, progress_handler)
      event.target.removeEventListener(Event.COMPLETE, complete_handler)
      
      // Asset type specific
      if (_assets[asset_index].bytes_loaded >= _assets[asset_index].bytes_total) {
        dispatchEvent(new Event(dispatch_code))
      }

      // Global
      if (_bytes_loaded >= _bytes_total) {
        dispatchEvent(new Event(Aggregator.COMPLETE))
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
        _assets[asset_index].bytes_total += event.bytesTotal * .5
        calculateGlobalBytesTotal()
      }
      
      _assets[asset_index].pool[event.target] = event.bytesLoaded
      _assets[asset_index].calculateBytesLoaded()
      
      calculateGlobalBytesLoaded()
    }
    
    private function audioProgressHandler(event:ProgressEvent):void   { progressHandler(AUDIO, event)   }
    private function configProgressHandler(event:ProgressEvent):void  { progressHandler(CONFIG, event)  }
    private function graphicProgressHandler(event:ProgressEvent):void { progressHandler(GRAPHIC, event) }
    private function videoProgressHandler(event:ProgressEvent):void   { progressHandler(VIDEO, event)   }
    
    /**
    * @private
    **/
    private function calculateGlobalBytesLoaded():void {
      _bytes_loaded = 0
      for each (var asset_info:AssetInfo in _assets) {
        if (asset_info.active) _bytes_loaded += asset_info.bytes_loaded
      }
    }
    
    /**
    * @private
    **/
    private function calculateGlobalBytesTotal():void {
      _bytes_total = 0
      for each (var asset_info:AssetInfo in _assets) {
        if (asset_info.active) _bytes_total += asset_info.bytes_total
      }
    }
    
    /**
    * @private
    **/
    private function isInitialEvent(asset_index:uint, dispatcher:Object):Boolean {
      return (_assets[asset_index].pool[dispatcher] == 0) ? true : false
    }
    
    /**
    * @private
    **/
    private function verifyAssetIndex(asset_index:uint):void {
      if (asset_index < AUDIO || asset_index > VIDEO) Log.getLog().error('Unknown asset code: ' + asset_index)
    }
    
    /**
    * @private
    **/
    private function verifyDispatcher(dispatcher:IEventDispatcher):void {
      if (!((dispatcher is URLLoader) || (dispatcher is LoaderInfo) || (dispatcher is Sound) || (dispatcher is NetStream))) {
        Log.getLog().error('Unusable dispatcher: ' + dispatcher)
      }
    }
  }
}
