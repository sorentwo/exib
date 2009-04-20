/**
* VideoNode
*
* Node for loading and controlling SWF video clips.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.display.MovieClip
  import flash.events.Event
  import com.soren.debug.Log
  import com.soren.exib.core.IActionable

  public class VideoNode extends Node implements IActionable {

    private static const VALID_URL:RegExp = /\w+\.swf$/
    
    private static var _embed_container:*
    
    private var _loop:Boolean
    private var _persistent:Boolean
    private var _video:MovieClip

    /**
    * Constructor
    * 
    * @param  url
    * @param  loop  Determine whether the video will loop
    **/
    public function VideoNode(url:String, loop:Boolean = true, persistent:Boolean = false) {
      verifyEmbedContainer()
      validateURL(url)
      
      var class_name:String = processUrlIntoClassName(url)
      
      try {
        _video = new _embed_container[class_name] as MovieClip
      } catch (e:Error) {
        Log.getLog().error('Unable to load embedded graphic: ' + class_name + '\n' + e)
      }
      
      _loop = loop
      _persistent = persistent
      
      if (_persistent) _video.gotoAndStop(0); addChild(_video)
    }
    
    /**
    * Supply the class where embedded assets can be found.
    **/    
    public static function setEmbedContainer(embed_container:*):void {
      _embed_container = embed_container
    }
    
    /**
    * Play the video. Doing so will add it to the display list of this node.
    **/
    public function play():void {
      addChild(_video)
      _video.gotoAndPlay(0)
      Log.getLog().debug(_video.width)
      if (_loop) _video.addEventListener(Event.ENTER_FRAME, loopPlaybackListener)
    }
    
    /**
    * Stop the video. Doing so will remove it from the display list of this node.
    **/
    public function stop():void {
      _video.gotoAndStop(0)
      
      if (!_persistent) this.removeChild(_video)
      if (_loop)        _video.removeEventListener(Event.ENTER_FRAME, loopPlaybackListener)
    }
    
    // ---
    
    /**
    * @private
    **/
    private function loopPlaybackListener(event:Event):void {
      if (_video.currentFrame == _video.totalFrames) _video.gotoAndPlay(0)
    }
    
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
      if (!VALID_URL.test(url)) Log.getLog().error('Invalid URL: ' + url)
    }
  }
}
