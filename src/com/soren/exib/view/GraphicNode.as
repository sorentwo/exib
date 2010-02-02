/**
* GraphicNode
*
* A basic graphic node to load embedded assets.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {
  
  import flash.display.Bitmap
  import com.soren.exib.debug.Log
  
  public class GraphicNode extends Node {
    
    private static const VALID_URL:RegExp = /\w+\.(png|jpg|gif)$/i
    
    private static var _embed_container:*
    
    /**
    * Constructor
    * 
    * @param  url   The asset url. It will be stripped down to the file name with
    *               no extension. 
    **/
    public function GraphicNode(url:String) {
      verifyEmbedContainer()
      validateURL(url)
      
      var class_name:String = processUrlIntoClassName(url)
      
      try {
        addChild(new _embed_container[class_name] as Bitmap)
      } catch (e:Error) {
        Log.getLog().error('Unable to load embedded graphic: ' + class_name + '\n' + e)
      }
    }

    /**
    * Supply the class where embedded assets can be found.
    **/    
    public static function setEmbedContainer(embed_container:*):void {
      _embed_container = embed_container
    }
    
    // ---
    
    /**
    * @private
    **/
    private function processUrlIntoClassName(url:String):String {
      var result:Object = /(?P<file_name>\w+)\.\w{3}/.exec(url)
      return result.file_name
    }
    
    /**
    * @private
    **/
    private function verifyEmbedContainer():void {
      if (!_embed_container) Log.getLog().fatal('No embed container set, cannot load embedded assets')
    }
    
    /**
    * @private
    **/
    private function validateURL(url:String):void {
      if (!VALID_URL.test(url)) { Log.getLog().error('Invalid url: ' + url) }
    }
  }
}
