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

  public class GraphicNode extends Node {
    private const VALID_URL:RegExp = /.*\.(png|jpg|gif)$/i
    
    private var _graphic:Loader
    private var _url:String
    
    public function GraphicNode(url:String) {
      if (VALID_URL.test(url)) { _url = url }
      else                     { throw new Error("Invalid url: " + url) }
      
      _graphic = new Loader()
      _graphic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler)
      _graphic.load(new URLRequest(_url))
      
      addChild(_graphic)
    }
    
    /**
    * 
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
      throw new Error('Asset could not be loaded at: ' + _url)
    }
  }
}
