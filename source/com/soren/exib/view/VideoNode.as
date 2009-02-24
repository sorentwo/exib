/**
* VideoNode
*
* Node for loading and controlling .flv video clips.
*
* Copyright (c) 2009 Parker Selbert
*
* See LICENSE.txt for full license information.
**/

package com.soren.exib.view {

  import flash.events.NetStatusEvent
  import flash.media.Video
  import flash.net.NetConnection
  import flash.net.NetStream
  import com.soren.exib.helper.IActionable

  public class VideoNode extends Node implements IActionable {

    private const VALID_URL:RegExp = /\.flv$/
    
    private var _video_url:String
    private var _video_height:uint
    private var _video_width:uint
    private var _loop:Boolean
    
    private var _connection:NetConnection
    private var _stream:NetStream
    private var _video:Video

    /**
    * Constructor
    **/
    public function VideoNode(url:String, video_width:uint,
                              video_height:uint, loop:Boolean = true) {
      if (VALID_URL.test(url)) { _video_url = url }
      else { throw new Error("Video: Invalid URL = " + url) }
      
      _video_width  = video_width
      _video_height = video_height
      _loop         = loop
      
      _connection = new NetConnection()
      _connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler)
      _connection.connect(null)
    }
    
    /**
    **/
    public function play():void {
      _stream.play(_video_url)
      addChild(_video)
    }
    
    /**
    **/
    public function stop():void {
      _stream.pause()
      _stream.seek(0)
      
      while (this.numChildren > 0) { this.removeChildAt(0) }
    }
    
    // ---
    
    /**
    * @private
    **/
    private function netStatusHandler(event:NetStatusEvent):void {
      switch (event.info.code) {
        case "NetConnection.Connect.Success":
          connectStream()
          break
        case "NetStream.Play.Stop":
          if (_loop) _stream.play(_video_url)
          break
        case "NetStream.Play.StreamNotFound":
          throw new Error("Unable to locate video url: " + _video_url)
          break
      }
    }
    
    /**
    * @private
    **/
    private function connectStream():void {
      _stream = new NetStream(_connection)
      _stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler)
    
      // Handle onMetaData errors silently, we have no use for them
      var net_client:Object = new Object()
      net_client.onMetaData = function(meta:Object):void { }
      _stream.client = net_client
    
      _video = new Video()
      _video.width  = _video_width
      _video.height = _video_height
    
      _video.attachNetStream(_stream)
    } 
  }
}
