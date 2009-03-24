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
  import com.soren.debug.Log
  import com.soren.exib.core.Aggregator
  import com.soren.exib.helper.IActionable

  public class VideoNode extends Node implements IActionable {

    private const VALID_URL:RegExp = /\.flv$/
    private const DEFAULT_BUFFER_TIME:uint = 60
    
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
    public function VideoNode(url:String, video_width:uint, video_height:uint, loop:Boolean = true) {
      validateURL(url)
      
      _video_url    = url
      _video_width  = video_width
      _video_height = video_height
      _loop         = loop
      
      _connection = new NetConnection()
      _connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler)
      _connection.connect(null)
    }
    
    /**
    * Play the video. Doing so will add it to the display list of this node.
    **/
    public function play():void {
      _stream.play(_video_url)
      addChild(_video)
    }
    
    /**
    * Stop the video. Doing so will remove it from the display list of this node.
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
        case 'NetConnection.Connect.Success':
          connectStream()
          break
        case 'NetStream.Play.Stop':
          if (_loop) _stream.play(_video_url)
          break
        case 'NetStream.Play.StreamNotFound':
          Log.getLog().error('Unable to locate video url: ' + _video_url)
          break
      }
    }
    
    // ---
    
    /**
    * @private
    **/
    private function connectStream():void {
      _stream = new NetStream(_connection)
      _stream.bufferTime = DEFAULT_BUFFER_TIME
      _stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler)
      
      // The video is tracked as a 'preloaded' asset. Note that the buffer is set
      // to 60 seconds, far longer than we expect any video in EXIB to be.
      Aggregator.getAggregator().registerDispatcher(Aggregator.VIDEO, _stream)
    
      // Handle onMetaData errors silently, we have no use for them
      var net_client:Object = new Object()
      net_client.onMetaData = function(meta:Object):void { }
      _stream.client = net_client
    
      _video = new Video()
      _video.width  = _video_width
      _video.height = _video_height
      _video.attachNetStream(_stream)
    } 
  
    /**
    * @private
    **/
    private function validateURL(url:String):void {
      if (!VALID_URL.test(url)) Log.getLog().error('Invalid URL: ' + url)
    }
  }
}
