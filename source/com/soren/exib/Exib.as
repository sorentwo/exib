/**
* EXIB
* 
* This is the core class, responsible for loading all external assets and date,
* and linking MVC components together.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib {

  import flash.display.Sprite
  import flash.display.Stage
  import flash.display.StageDisplayState
  import flash.display.StageScaleMode
  import flash.events.Event
  import flash.net.URLLoader
  import flash.net.URLRequest
  import flash.text.TextFormat
  import com.soren.exib.effect.*
  import com.soren.exib.core.*
  import com.soren.exib.helper.*
  import com.soren.exib.manager.*
  import com.soren.exib.model.*
  import com.soren.exib.service.*
  import com.soren.exib.view.*
  import com.soren.util.*
  
  public class Exib extends Sprite {
        
    private const CONFIG_URL:String    = '../assets/config/config.exml'
    private const GRAPHICS_PATH:String = '../assets/graphics/'
    private const SOUNDS_PATH:String   = '../assets/sounds/'
    private const VIDEO_PATH:String    = '../assets/videos/'
    
    private const MANAGER_LIST:Array = ['actionable', 'format', 'video']
    
    private var _config:XML
    private var _urlLoader:URLLoader
    
    private var _options:Object        = new Object()
    private var _preloader:Preloader   = new Preloader()
    private var _supervisor:Supervisor = new Supervisor(MANAGER_LIST)
    private var _generator:Generator   = new Generator(_supervisor)
    private var _container:Sprite
    
    /**
    * Constructor
    **/
    public function Exib() {
      XMLLoader()
    }
    
    // ---
    
    private function XMLLoader():void {
      var urlRequest:URLRequest = new URLRequest(CONFIG_URL)
      _urlLoader = new URLLoader()
      _urlLoader.addEventListener(Event.COMPLETE, XMLLoadCompleteListener)
      _urlLoader.load(urlRequest)
    }
    
    private function XMLLoadCompleteListener(event:Event):void {
      _config = new XML(_urlLoader.data)      
      processXML(_config) 
    }

    // ---
        
    private function processXML(config:XML):void {
      pre()
      
      populateOptions(config.options)
      populateModels(config.models)
      populateFormats(config.formats)
      populateMedia(config.media)
      populateQueues(config.queues)
      populateServices(config.services)
      populateHotkeys(config.hotkeys)
      populateView(config.view)
      
      post()
    }
    
    private function pre():void {
      if (_config.view.screens != undefined) {
        _container = _generator.genContainer(_config.view.screens)
        var scr_con:ScreenController = new ScreenController(_container, _options['history'])
        _supervisor.add('actionable', scr_con, 'screen')
        _supervisor.add('actionable', new Effect(scr_con), 'effect')
        
        addChild(_container)
      }
    }
    
    private function post():void {
      _supervisor.get('actionable', 'screen').load(_config.view.screens.screen[0].@id)
      
      stage.frameRate    = _options['frame_rate']   || 30
      stage.stageHeight  = _options['stage_height'] || 350
      stage.stageWidth   = _options['stage_width']  || 550
      
      if (_options['scale_stage'] == 'no')  stage.scaleMode    = StageScaleMode.NO_SCALE
      if (_options['fullscreen']  == 'yes') stage.displayState = StageDisplayState.FULL_SCREEN
    }
    // ---
    
    private function populateOptions(options:XMLList):void {
      for each (var xml_option:XML in options.*) {
        _options[xml_option.name().toString()] = xml_option
      }
    }
    
    private function populateModels(models:XMLList):void {
      for each (var xml_mod:XML in models.*) {
        switch (xml_mod.name().toString()) {
        case 'clock':
          _supervisor.add('actionable', _generator.genClockModel(xml_mod), xml_mod.@id)
          break
        case 'history':                               
          _supervisor.add('actionable', _generator.genHistoryModel(xml_mod), xml_mod.@id)
          break
        case 'preset':                                
          _supervisor.add('actionable', _generator.genPresetModel(xml_mod), xml_mod.@id)
          break
        case 'state':                                 
          _supervisor.add('actionable', _generator.genStateModel(xml_mod), xml_mod.@id)
          break
        case 'value':
          _supervisor.add('actionable', _generator.genValueModel(xml_mod), xml_mod.@id)
        }
      }
    }
    
    private function populateFormats(formats:XMLList):void {
      for each (var xml_format:XML in formats.*) {
        _supervisor.add('format', _generator.genFormat(xml_format), xml_format.@id)
      }
    }
    
    private function populateHotkeys(hotkeys:XMLList):void {
      for each (var xml_hotkey:XML in hotkeys.*) {
        _generator.genHotkey(xml_hotkey, this)
      }
    }
    
    private function populateMedia(media:XMLList):void {
      for each (var xml_media:XML in media.*) {
        switch (xml_media.name().toString()) {
          case 'sound':
            _supervisor.add('actionable', _generator.genSound(xml_media, SOUNDS_PATH), xml_media.@id)
            break
          case 'video':
            var video:VideoNode = _generator.genVideo(xml_media, VIDEO_PATH)
            _supervisor.add('actionable', video, xml_media.@id)
            _supervisor.add('video', video, xml_media.@id)
        }
      }
    }
    
    private function populateQueues(queues:XMLList):void {
      for each (var xml_queue:XML in queues.*) {
        _supervisor.add('actionable', _generator.genQueue(xml_queue), xml_queue.@id)
      }
    }
    
    private function populateServices(services:XMLList):void {
      for each (var xml_ser:XML in services.*) {
        switch (xml_ser.name().toString()) {
          case 'cron':
            _supervisor.add('actionable', _generator.genCron(xml_ser), xml_ser.@id)
            break
          case 'daemon':
            _supervisor.add('actionable', _generator.genDaemon(xml_ser), xml_ser.@id)
        }
      }
    }
    
    private function populateView(view:XMLList):void {      
      populateScreens(view.screens.screen)
      
      var context:Sprite = _generator.genContext(view.context, GRAPHICS_PATH)
      addChildAt(context, 0)
      
      // Mask?
      if (view.screens.mask[0]) {
        var xml_mask:XML = view.screens.mask[0]
        var mask_node:VectorNode = _generator.genVectorNode(xml_mask)
        mask_node.position(xml_mask.@pos)
        _container.mask = mask_node
      }
    }
    
    private function populateScreens(screens:XMLList):void {
      var scr_con:ScreenController = _supervisor.get('actionable', 'screen')
      for each (var xml_screen:XML in screens) {
        var screen:ScreenNode = new ScreenNode()
        if (xml_screen.@bg != undefined) screen.addChild(new GraphicNode(GRAPHICS_PATH + xml_screen.@bg))
        
        _generator.genNodes(xml_screen.*, screen, GRAPHICS_PATH)
        scr_con.add(screen, xml_screen.@id)
      }
    }
  }
}