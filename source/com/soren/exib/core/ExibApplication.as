/**
* EXIB
* 
* This is the core class, responsible for loading all external assets and date,
* and linking MVC components together.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.core {

  import flash.display.Sprite
  import mx.core.Application
  import com.soren.exib.effect.*
  import com.soren.exib.core.*
  import com.soren.exib.view.*
  
  public final class ExibApplication extends Application {
    
    private var _graphics_path:String = 'graphics'
    private var _sounds_path:String   = 'sounds'
    private var _media_path:String    = 'media'
    
    private var _space:Space = Space.getSpace()
    private var _generator:Generator = new Generator()
    private var _container:Sprite
    
    /**
    * Construct a new Exib instance. This will allocate the Exib object and
    * libraries and process the configuration xml.
    * 
    * @param  exml        The exml configuration file.
    * @param  asset_path  The base asset path. Graphics, Sounds, and Media
    *                     subfolders must be present.
    * @param  pools       An array of regular expressions that will used to put
    *                     and find objects from the global space.
    * @see    Space.as
    **/
    public function ExibApplication(exml:XML, asset_path:String, pools:Array) {
      for each (var path:String in [_graphics_path, _sounds_path, _media_path]) {
        path = asset_path + '/' + path
      }
      
      for each (var pool_pattern:RegExp in pools) {
        Space.getSpace().createPool(pool_pattern)
      }
      
      process(exml)
    }

    // ---
        
    private function process(config:XML):void {
      pre(config)
      
      populateOptions(config.options)
      populateModels(config.models)
      populateFormats(config.formats)
      populateMedia(config.media)
      populateQueues(config.queues)
      populateServices(config.services)
      populateHotkeys(config.hotkeys)
      populateView(config.view)
      
      post(config)
    }
    
    private function pre(config:XML):void {
      if (config.view.screens != undefined) {
        _container = _generator.genContainer(config.view.screens)
        var scr_con:ScreenController = new ScreenController(_container, 10)
        _space.add(scr_con, 'screen')
        _space.add(new Effect(scr_con), 'effect')
        
        addChild(_container)
      }
    }
    
    private function post(config:XML):void {
      _space.get('screen').load(config.view.screens.screen[0].@id)
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
            _space.add(_generator.genSound(xml_media, _sounds_path), xml_media.@id)
            break
          case 'video':
            var video:VideoNode = _generator.genVideo(xml_media, _video_path)
            _space.add(video, xml_media.@id)
        }
      }
    }
    
    private function populateQueues(queues:XMLList):void {
      for each (var xml_queue:XML in queues.*) {
        _space.add(_generator.genQueue(xml_queue), xml_queue.@id)
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
      var scr_con:ScreenController = _space.get('screen')
      for each (var xml_screen:XML in screens) {
        var screen:ScreenNode = new ScreenNode()
        if (xml_screen.@bg != undefined) screen.addChild(new GraphicNode(GRAPHICS_PATH + xml_screen.@bg))
        
        _generator.genNodes(xml_screen.*, screen, GRAPHICS_PATH)
        scr_con.add(screen, xml_screen.@id)
      }
    }
  }
}