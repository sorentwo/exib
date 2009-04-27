/**
* Sound
*
* A container for loading and controlling embedded sounds. It automates the
* loading process and provides shortcuts for controlling playback.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.service {
  
  import flash.media.Sound
  import flash.media.SoundChannel
  import com.soren.exib.debug.Log
  import com.soren.exib.core.IActionable
  
  public class Sound implements IActionable {

    private static const VALID_URL:RegExp = /\w+\.mp3/i
    private static var _embed_container:*
    
    private var _channel:SoundChannel
    private var _sound:flash.media.Sound
    
    /**
    * Constructor
    * 
    * @param  url   Name of the embedded sound file. It will be stripped to its
    *               base name.
    **/
    public function Sound(url:String) {
      verifyEmbedContainer()
      validateURL(url)
      
      var class_name:String = processUrlIntoClassName(url)
      
      try {
        _sound = new _embed_container[class_name] as flash.media.Sound
      } catch (e:Error) {
        Log.getLog().error('Unable to load requested sound: ' + url + '\n' + e)
      }
    }
    
    /**
    * Supply the class where embedded assets can be found.
    **/
    public static function setEmbedContainer(embed_container:*):void {
      _embed_container = embed_container
    }
    
    /**
    * Play the sound
    * 
    * @param times  The number of times to play the sound. Default is one.
    **/
    public function play(times:uint = 1):void {
      _channel = _sound.play(0, times)
    }
    
    /**
    * Stop a sound that is currently playing
    **/
    public function stop():void {
      _channel.stop()
    }
    
    // ---
    
    /**
    * @private
    **/
    private function processUrlIntoClassName(url:String):String {
      var result:Object = /(?P<class_name>\w+)\.\w{3}/.exec(url)
      return result.class_name
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
