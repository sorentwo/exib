/**
* VideoNode
*
* Load and control a SWF video clip. Clip behavior is determined at construction
* time.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.display.MovieClip
  import flash.events.Event
  import com.soren.exib.debug.Log
  import com.soren.exib.core.IActionable

  public class VideoNode extends Node implements IActionable {

    private static const VALID_URL:RegExp = /\w+\.swf$/
    
    private static var _embed_container:*
    
    private var _loop:Boolean
    private var _persistent:Boolean
    private var _video:MovieClip

    /**
    * Create a new VideoNode instance.
    * 
    * @param  url         The url of the SWF video clip to load.
    * @param  loop        If true the video will play infinitely. If false the
    *                     video will only play once.
    * @param  persistent  If true the clip will be visible at all times. If false
    *                     the clip will be visible when playing and invisible
    *                     otherwise.
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
      
      if (_persistent) { _video.gotoAndStop(0); addChild(_video) }
    }
    
    /**
    * Supply the class where embedded assets can be found. A container must be
    * provided before any VideoNode instances are created, otherwise the asset
    * can not be located and an error will be thrown.
    * 
    * @param  embed_container Any class that has embedded video assets.
    **/    
    public static function setEmbedContainer(embed_container:*):void {
      _embed_container = embed_container
    }
    
    /**
    * Play the video. If the clip is not persistent then this will also add the
    * clip to the display list.
    **/
    public function play():void {
      if (!this.contains(_video)) addChild(_video)
      _video.play()

      //if (_loop) {
      //  _video.removeEventListener(Event.ENTER_FRAME, loopPlaybackListener)
      //  _video.addEventListener(Event.ENTER_FRAME, loopPlaybackListener)
      //}
    }
    
    /**
    * Stop the video. If the clip is persistent it will remain visible, otherwise
    * it will be removed from the display list.
    **/
    public function stop():void {
      _video.gotoAndStop(0)
      
      if (!_persistent && this.contains(_video)) this.removeChild(_video)
      //if (_loop) _video.removeEventListener(Event.ENTER_FRAME, loopPlaybackListener)
    }
    
    // ---
    
    /**
    * Triggered on each frame and loop the video if it has reached the end.
    **/
    private function loopPlaybackListener(event:Event):void {
      if (_video.currentFrame == _video.totalFrames) _video.gotoAndPlay(0)
    }
    
    /**
    * Utility to strip the extension from the url.
    **/
    private function processUrlIntoClassName(url:String):String {
      var result:Object = /(?P<file_name>\w+)\.\w{3}/.exec(url)
      return result.file_name
    }
    
    /**
    * Verify the supplied container of embedded assets.
    **/
    private function verifyEmbedContainer():void {
      if (!_embed_container) Log.getLog().fatal('No embed container set, cannot load embedded assets')
    }
  
    /**
    * Ensure the url provided is a valid video.
    **/
    private function validateURL(url:String):void {
      if (!VALID_URL.test(url)) Log.getLog().error('Invalid URL: ' + url)
    }
  }
}
