/**
* EXIB
* 
* This is the core class, responsible for loading all external assets, data, and
* linking MVC components together.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.core {

  import flash.display.Sprite
  import flash.events.Event
  import flash.utils.ByteArray
  import com.soren.exib.debug.*
  import com.soren.exib.helper.*
  import com.soren.exib.manager.*
  import com.soren.exib.model.*
  import com.soren.exib.service.*
  import com.soren.exib.view.*
  import com.soren.sfx.*
  
  public class Application extends Sprite {
    
    private var _space:Space = Space.getSpace()
    private var _generator:Generator = new Generator()
    private var _container:Node
    
    protected var _default_screen_name:String = '_screen'
    protected var _default_effect_name:String = '_effect'
    protected var _default_log_name:String    = '_log'
    
    /**
    * Construct a new Exib instance.
    **/
    public function Application() {}
    
    /**
    * Provided the necessary assets start the Exib application.
    * 
    * @param  ConfigEXML  An embedded XML class
    * @param  pools       An array of regular expressions that will used to put
    *                     and find objects from the global space.
    **/
    public function start(ConfigEXML:Class, pools:Array):void {
      for each (var pool_pattern:RegExp in pools) {
        _space.createPool(pool_pattern)
      }
      
      // Logging
      Log.getLog().level = Log.DEBUG
      Log.getLog().throwOnError = true
      
      Log.getLog().debug('Extended XML Interface Builder :: Version ' + Version.version())
      
      // Listener for presence on the stage. Necessary for tweening.
      addEventListener(Event.ADDED_TO_STAGE, registerStageForTween)
      
      // XML Processing
      process(getXMLFromEmbeddedClass(ConfigEXML))
    }

    // ---
    
    /**
    * @private
    * 
    * Register the stage to the tween class
    **/
    private function registerStageForTween(event:Event):void {
      Tween.getInstance().registerStage(stage)
    }
    
    /**
    * @private
    * 
    * Reads the embedded XML data and loads it into a usable XML object.
    **/
    private function getXMLFromEmbeddedClass(ConfigEXML:Class):XML {
      var byte_array:ByteArray = ByteArray(new ConfigEXML())
      return new XML(byte_array.readUTFBytes(byte_array.length))
    }
    
    /**
    * @private
    * 
    * Process the configuration file by section.
    **/
    private function process(config:XML):void {
      pre(config)
      
      populateModels(config.models)
      populateFormats(config.formats)
      populateMedia(config.media)
      populateServices(config.services)
      populateHotkeys(config.hotkeys)
      populateView(config.view)
      populateQueues(config.queues) // Brittle, must be run after populateView
      
      post(config)
    }
    
    private function pre(config:XML):void {
      if (config.view.screens != undefined) {
        _container = _generator.genContainer(config.view.screens)
        var scr_con:ScreenController = new ScreenController(_container, 10)
        addChild(_container)
        
        // Push the defaults to the space
        _space.add(new Effect(),  _default_effect_name)
        _space.add(Log.getLog(),  _default_log_name)
        _space.add(scr_con,       _default_screen_name)
      }
    }
    
    private function post(config:XML):void {
      _space.get(_default_screen_name).load(config.view.screens.screen[0].@id)
    }
    
    // ---
    
    private function populateModels(models:XMLList):void {
      for each (var xml_mod:XML in models.*) {
        switch (xml_mod.name().toString()) {
        case 'clock':
          _space.add(_generator.genClockModel(xml_mod), xml_mod.@id)
          break
        case 'history':                               
          _space.add(_generator.genHistoryModel(xml_mod), xml_mod.@id)
          break
        case 'preset':                                
          _space.add(_generator.genPresetModel(xml_mod), xml_mod.@id)
          break
        case 'state':                                 
          _space.add(_generator.genStateModel(xml_mod), xml_mod.@id)
          break
        case 'value':
          _space.add(_generator.genValueModel(xml_mod), xml_mod.@id)
        }
      }
    }
    
    private function populateFormats(formats:XMLList):void {
      for each (var xml_format:XML in formats.*) {
        _space.add(_generator.genFormat(xml_format), xml_format.@id)
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
            _space.add(_generator.genSound(xml_media), xml_media.@id)
        }
      }
    }
    
    private function populateQueues(queues:XMLList):void {
      // HACK to have objects resolve
      var context:Node = _space.get('context')
      for each (var xml_queue:XML in queues.*) {
        _space.add(_generator.genQueue(xml_queue, context), xml_queue.@id)
      }
    }
    
    private function populateServices(services:XMLList):void {
      for each (var xml_ser:XML in services.*) {
        switch (xml_ser.name().toString()) {
          case 'cron':
            _space.add(_generator.genCron(xml_ser), xml_ser.@id)
            break
          case 'daemon':
            _space.add(_generator.genDaemon(xml_ser), xml_ser.@id)
            break
          case 'task':
            _space.add(_generator.genTask(xml_ser), xml_ser.@id)
        }
      }
    }
    
    private function populateView(view:XMLList):void {
      populateScreens(view.screens.screen)
      
      var context:Node = _generator.genContext(view.context)
      _space.add(context, 'context')
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
      var scr_con:ScreenController = _space.get(_default_screen_name)
      for each (var xml_screen:XML in screens) {
        var screen:ScreenNode = new ScreenNode()
        if (xml_screen.@bg != undefined) screen.addChild(new GraphicNode(xml_screen.@bg))
        
        _generator.genNodes(xml_screen.*, screen)
        scr_con.add(screen, xml_screen.@id)
      }
    }
  }
}