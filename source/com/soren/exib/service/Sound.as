/**
* Sound
*
* A container for loading and controlling sounds. It automates the loading
* process and provides shortcuts for controlling playback.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.service {
  
  import flash.events.Event
  import flash.media.Sound
  import flash.media.SoundChannel
  import flash.net.URLRequest
  import com.soren.exib.helper.IActionable
  
  public class Sound implements IActionable {

    private var _channel:SoundChannel
    private var _sound:flash.media.Sound
    
    /**
    * Constructor
    * 
    * @param  url   Location of the sound file to load
    **/
    public function Sound(url:String) {
      var request:URLRequest = new URLRequest(url)
      
      _sound = new flash.media.Sound(request)
      _sound.addEventListener(Event.COMPLETE, loadComplete)
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
    * Replaces the incomplete _sound object with the fully loaded sound
    **/
    private function loadComplete(event:Event):void {
      _sound = event.target as flash.media.Sound
    }
  }
}
