/**
* GraphicNode
*
* An extension of Node to simplify loading external assets.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.view {
  
  import flash.events.IOErrorEvent
  import flash.display.Loader
  import flash.net.URLRequest
  import com.soren.debug.Log
  import com.soren.exib.core.Aggregator

  public class GraphicNode extends Node {
    private const VALID_URL:RegExp = /.*\.(png|jpg|gif)$/i
    
    private var _graphic:Loader = new Loader()
    private var _url:String
    
    public function GraphicNode(url:String) {
      validateURL(url)
      
      try {
        _graphic.load(new URLRequest(url))
      } catch (e:Error) {
        Log.getLog().error('Unable to load requested graphic: ' + url)
      }
      
      _graphic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler)
      Aggregator.getAggregator().registerDispatcher(Aggregator.GRAPHIC, _graphic.contentLoaderInfo)
      
      _url = url
      addChild(_graphic)
    }
    
    /**
    * Retrieive the width of the graphic object. Entirely synonomous with width.
    **/
    public function get full_width():uint {
      return _graphic.width
    }
    
    /**
    * Retrieve the url used to load the graphic asset
    **/
    public function get url():String {
      return _url
    }
    
    // ---
    
    /**
    * @private
    **/
    private function ioErrorHandler(event:IOErrorEvent):void {
      Log.getLog().error('Asset could not be loaded at: ' + _url)
    }
    
    /**
    * @private
    **/
    private function validateURL(url:String):void {
      if (!VALID_URL.test(url)) { Log.getLog().error('Invalid url: ' + url) }
    }
  }
}
