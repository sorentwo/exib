/**
* VideoNode
*
* Load and control a SWF video clip. Clip behavior is determined at construction
* time.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.view {

  import flash.display.Loader
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
      
      _loop = loop
      _persistent = persistent
      
      var class_name:String = processUrlIntoClassName(url)
      
      try {
        var swf:MovieClip = new _embed_container[class_name]
        var loader:Loader = swf.getChildAt(0) as Loader
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete)
      } catch (e:Error) {
        Log.getLog().error('Unable to load embedded graphic: ' + class_name + '\n' + e)
      }
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
      _video.gotoAndPlay(0)
      
      _video.addEventListener(Event.ENTER_FRAME, loopPlaybackListener)
    }
    
    /**
    * Stop the video. If the clip is persistent it will remain visible, otherwise
    * it will be removed from the display list.
    **/
    public function stop():void {
      if (!_persistent && this.contains(_video)) removeChild(_video)
      _video.gotoAndStop(0)
      
      _video.removeEventListener(Event.ENTER_FRAME, loopPlaybackListener)
    }
    
    // ---
    
    /**
    * Handle the completed load event, crucial to actually loading and using the
    * embedded clip.
    **/
    private function handleLoadComplete(event:Event):void {
      _video = MovieClip(event.target.content.getChildAt(0))
      _video.stop()

      if (_persistent) addChild(_video)
    }
    
    /**
    * Triggered on each frame and loop the video if it has reached the end.
    **/
    private function loopPlaybackListener(event:Event):void {
      if (_video.currentFrame == _video.totalFrames) {    
        (_loop) ? _video.gotoAndPlay(0) : this.stop()
      }
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
