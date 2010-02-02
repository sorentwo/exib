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

    private static const VALID_URL:RegExp     = /\w+\.swf$/
    
    public static const STANDARD_MODE:uint   = 0
    public static const LOOP_MODE:uint       = 1
    public static const HOLD_MODE:uint       = 2
    public static const HOLD_FIRST:uint      = 0
    public static const HOLD_LAST:uint       = 1
    public static const HOLD_BOTH:uint       = 2
    public static const HOLD_LOOP:uint       = 3
    
    private static var _embed_container:*

    private var _mode:uint
    private var _hold:uint
    private var _video:MovieClip

    /**
    * Create a new VideoNode instance.
    * 
    * @param  url     The url of the SWF video clip to load.
    * @param  mode    Determines the behavior for this video, see the mode constants
    * @param  hold    If <code>hold mode</code> is chosen this determines the frame
    *                 that will be held. By using one of the constants the first or
    *                 last frames can be used instead.
    **/
    public function VideoNode(url:String, mode:uint = STANDARD_MODE, hold:uint = HOLD_FIRST) {
      verifyEmbedContainer()
      validateURL(url)
      
      _mode = mode
      _hold = hold
      
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
      
      _video.addEventListener(Event.ENTER_FRAME, endPlaybackListener)
    }
    
    /**
    * Stop the video. If the clip is persistent it will remain visible, otherwise
    * it will be removed from the display list.
    **/
    public function stop():void {
      switch (_mode) {
        case STANDARD_MODE:
        case LOOP_MODE:
          if (this.contains(_video)) removeChild(_video)
          _video.gotoAndStop(0)
          break
        case HOLD_MODE:
          switch (_hold) {
            case HOLD_FIRST:
            case HOLD_BOTH:
            case HOLD_LOOP:
              _video.gotoAndStop(0)
              break
            case HOLD_LAST:
              _video.gotoAndStop(0)
              if (this.contains(_video)) removeChild(_video)
              break
          }
      }
      
      _video.removeEventListener(Event.ENTER_FRAME, endPlaybackListener)
    }
    
    /**
    * Remove the video from the stage. Overrides any mode or hold settings.
    **/
    public function remove():void {
      if (this.contains(_video)) removeChild(_video)
    }
    
    /**
    * Return the video to its original state.
    **/
    public function reset():void {
      handleLoadComplete(new Event(Event.ENTER_FRAME))
    }
    
    // ---
    
    /**
    * Handle the completed load event, crucial to actually loading and using the
    * embedded clip.
    **/
    private function handleLoadComplete(event:Event):void {
      _video = MovieClip(event.target.content.getChildAt(0))
      handleHold()
    }
    
    /**
    **/
    private function handleHold():void {
      if (_mode == HOLD_MODE) {
        switch (_hold) {
          case HOLD_FIRST:
          case HOLD_BOTH:
            _video.gotoAndStop(0)
            addChild(_video)
            break
          case HOLD_LOOP:
            _video.play()
            addChild(_video)
            break
        } 
      }
    }
    
    /**
    * Triggered on each frame and loop the video if it has reached the end.
    **/
    private function endPlaybackListener(event:Event):void {
      if (_video.currentFrame == _video.totalFrames) {
        switch (_mode) {
          case STANDARD_MODE:
            stop()
            break
          case LOOP_MODE:
            _video.gotoAndPlay(0)
            break
          case HOLD_MODE:
            switch (_hold) {
              case HOLD_FIRST:
                stop()
                break
              case HOLD_LOOP:
                _video.gotoAndPlay(0)
                break
              case HOLD_BOTH:
              case HOLD_LAST:
                _video.gotoAndStop(_video.totalFrames)
            }
        }
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
