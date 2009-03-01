/**
* Generator
*
* Handles processing XML into exib class instances.
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.generator {

  import flash.display.DisplayObject
  import flash.text.TextField
  import flash.text.TextFormat
  import com.soren.exib.effect.*
  import com.soren.exib.helper.*
  import com.soren.exib.manager.*
  import com.soren.exib.model.*
  import com.soren.exib.service.*
  import com.soren.exib.view.*
  import com.soren.util.*

  public class Generator {
    
    private var _supervisor:Supervisor
    
    /**
     * Constructor
    **/
    public function Generator(supervisor:Supervisor) {
      _supervisor = supervisor
    }
    
    // Models -->
    public function genClockModel(xml:XML):ClockModel {
      if (Boolean(xml.@start)) var values:Array = xml.@start.toString().split(/[\s\t]?,[\s\t]?/)
      
      var year:uint    = int(values.shift()) || undefined
      var month:uint   = int(values.shift()) || undefined
      var date:uint    = int(values.shift()) || undefined
      var hours:uint   = int(values.shift()) || undefined
      var minutes:uint = int(values.shift()) || undefined
      var seconds:uint = int(values.shift()) || undefined

      return new ClockModel(year, month, date, hours, minutes, seconds)
    }
    
    public function genHistoryModel(xml:XML):HistoryModel {
      var model:HistoryModel = new HistoryModel(xml.@length)
      
      var states:Array = xml.@states.toString().split(/[\s\t]?,[\s\t]?/)
      for each (var state:String in states) { model.add(state) }
      
      return model
    }
    
    public function genPresetModel(xml:XML):PresetModel {
      var model:PresetModel = new PresetModel()
      
      if (xml.@default_text != undefined) model.default_text = xml.@default_text
      
      for each (var xml_model:XML in xml.model) {
        model.watch(_supervisor.get('actionable', xml_model.@id))
      }
      
      return model
    }
    
    public function genStateModel(xml:XML):StateModel {
      var model:StateModel = new StateModel()
      
      var states:Array = xml.@states.toString().split(/[\s\t]?,[\s\t]?/)
      for each (var state:String in states) { model.add(state) }
      
      if (xml.@def != undefined) model.initial = xml.@def
      
      model.reset()
      
      return model
    }
    
    public function genValueModel(xml:XML):ValueModel {
      var range_pattern:RegExp = /^(\d+)\.{2}(\d+)$/
      
      var min:uint = uint(xml.@range.toString().replace(range_pattern, "$1"))
      var max:uint = uint(xml.@range.toString().replace(range_pattern, "$2"))
      var def:uint = uint(xml.@def)
      
      return new ValueModel(def, min, max)
    }
    
    // Services -->
    public function genCron(xml:XML):Cron {
      var event_set:ActionSet    = null
      var complete_set:ActionSet = null
      var conditionals:ConditionalSet = null
      
      if (Boolean(xml.event_action))    event_set    = genActionSet(xml.event_action)
      if (Boolean(xml.complete_action)) complete_set = genActionSet(xml.complete_action)
      if (Boolean(xml.complete_when))   conditionals = genConditionalSet(xml.complete_when)
      
      return new Cron(uint(xml.@delay), uint(xml.@repeat), event_set, complete_set, conditionals)
    }
    
    public function genDaemon(xml:XML):Daemon {
      var event_set:ActionSet    = null
      var complete_set:ActionSet = null
      var conditionals:ConditionalSet = null
      
      if (Boolean(xml.event_action))    event_set    = genActionSet(xml.event_action)
      if (Boolean(xml.complete_action)) complete_set = genActionSet(xml.complete_action)
      if (Boolean(xml.complete_when))   conditionals = genConditionalSet(xml.complete_when)
      
      return new Daemon(uint(xml.@delay), event_set, complete_set, conditionals)
    }
    
    public function genHotkey(xml:XML, stage:DisplayObject):Hotkey {
      var toggle:Boolean = (xml.@toggle == undefined || xml.@toggle == 'false') ? false : true
      return new Hotkey(xml.@key, genActionSet(xml.action), stage, toggle)
    }
    
    // Media -->
    public function genFormat(xml:XML):TextFormat {
      return new TextFormat(xml.@font, xml.@size, xml.@color)
    }
    
    public function genSound(xml:XML, path:String = ''):Sound {
      return new Sound(path + xml.@url)
    }
    
    public function genVideo(xml:XML, path:String = ''):VideoNode {
      var parsed:Object = /^(?P<width>\d+)x(?P<height>\d+)$/.exec(xml.@size)
      return new VideoNode(path + xml.@url, parsed.width, parsed.height)
    }
    
    // Helpers -->
    public function genActionSet(xml_list:XMLList):ActionSet {
      var action_set:ActionSet = new ActionSet()
      for each (var xml_action:XML in xml_list) {
        var parsed:Object = parseAction(xml_action)
        var action:Action = new Action(parsed.actionable, parsed.method, parsed.arguments)
        
        if (parsed.conditional) {
          action.conditional_set = genConditionalSet(parsed.conditional.toString())
        }
        
        action_set.push(action)
      }
      
      return action_set
    }
    
    public function genConditionalSet(statement:String):ConditionalSet {
      var superset:ConditionalSet

      if (statement != '') { superset = genSubset(statement) }
      else {                 superset = new ConditionalSet() }

      return superset
    }
    
    // Queue -->
    public function genQueue(xml:XML):Queue {
      var queue:Queue = new Queue(_supervisor)
      
      for each (var xml_member:XML in xml.*) {
        var before:Boolean = (xml_member.name() == 'before') ? true : false
        var parsed:Object  = parseQueueMember(xml_member)
        queue.enqueue(parsed.effect, parsed.targets, parsed.options, before, parsed.wait)
      }
      
      return queue
    }
    
    // View -->
    public function genContext(xml_list:XMLList, path:String = ''):CompositeNode {
      var context:CompositeNode = new CompositeNode()
      
      if (xml_list.@bg != undefined) context.addChild(new GraphicNode(path + xml_list.@bg))
      
      genNodes(xml_list.*, context, path)
      
      return context
    }
    
    public function genContainer(xml_list:XMLList):CompositeNode {
      var container:CompositeNode = new CompositeNode()
      container.position(xml_list.@pos)
      
      return container
    }
    
    public function genNodes(xml_list:XMLList, container:Node, path:String = ''):void {
      for each (var xml:XML in xml_list) {
        
        switch (xml.name().toString()) {
          case 'button':
            container.addChild(genButtonNode(xml, path))
            break
          case 'composite':
            container.addChild(genCompositeNode(xml, path))
            break
          case 'dial':
            container.addChild(genDialNode(xml, path))
            break
          case 'graphic':
            container.addChild(genGraphicNode(xml, path))
            break
          case 'mask':
            container.addChild(genVectorNode(xml))
            break
          case 'meter':
            container.addChild(genMeterNode(xml, path))
            break
          case 'multi':
            container.addChild(genMultiNode(xml, path))
            break
          case 'progress':
            container.addChild(genProgressNode(xml, path))
            break
          case 'text':
            container.addChild(genTextNode(xml))
            break
          case 'vector':
            container.addChild(genVectorNode(xml))
            break
          case 'video':
            container.addChild(retrieveVideoReference(xml))
            break
        }
        
        // Position
        var last_node:Node = (container.getChildAt(container.numChildren - 1) as Node)
        
        if (xml.@pos != undefined)   last_node.position(xml.@pos)
        if (xml.@id != undefined)    last_node.id = xml.@id
        if (xml.@group != undefined) last_node.group = xml.@group
        
        if (xml.name().toString() == 'mask') { container.mask = last_node }

        // Check the children of this node
        var known:RegExp = /^(button|composite|dial|graphic|mask|multi|meter|progress|text|vector|video)$/
        var has_valid_child:Boolean = false
        
        for each (var child:XML in xml.*) {
          if (known.test(child.name())) has_valid_child = true; break
        }
        
        if (has_valid_child) genNodes(xml.*, last_node, path)
      }
    }
    
    public function genButtonNode(xml:XML, path:String):ButtonNode {
      var press_set:ActionSet   = null
      var release_set:ActionSet = null
        
      if (Boolean(xml.press))   press_set   = genActionSet(xml.press)
      if (Boolean(xml.release)) release_set = genActionSet(xml.release)
      
      if (xml.@down == undefined) xml.@down = xml.@up
      
      return new ButtonNode(path + xml.@up, path + xml.@down, press_set, release_set)
    }
    
    public function genCompositeNode(xml:XML, path:String):CompositeNode {
      var composite_node:CompositeNode = new CompositeNode()

      if (xml.@bg != undefined) composite_node.addChild(new GraphicNode(path + xml.@bg))

      return composite_node
    }
    
    public function genDialNode(xml:XML, path:String):DialNode {
      var dial_node:DialNode = new DialNode(path + xml.@url)
            
      for each (var xml_pos:XML in xml.position) {
        for each (var xml_inj:XML in xml.inject) { xml_pos.appendChild(<action>{xml_inj.toString()}</action>) }
        dial_node.add(genActionSet(xml_pos.action))
      }
      
      return dial_node
    }
    
    public function genGraphicNode(xml:XML, path:String):GraphicNode {
      return new GraphicNode(path + xml.@url)
    }
    
    public function genMeterNode(xml:XML, path:String):MeterNode {
      var model:ValueModel = _supervisor.get('actionable', xml.@model) as ValueModel
      
      return new MeterNode(model,
                           path + xml.@left_empty,  path + xml.@left_full,
                           path + xml.@mid_empty,   path + xml.@mid_full,
                           path + xml.@right_empty, path + xml.@right_full,
                           xml.@segments, xml.@spacing)
    }
    
    public function genMultiNode(xml:XML, path:String):MultiNode {
      var multi_node:MultiNode = new MultiNode()
      for each (var xml_child:XML in xml.*) {
        var child_node:Node
        
        switch (xml_child.name().toString()) {
          case 'mbutton':
            child_node = genButtonNode(xml_child, path)
            break
          case 'mgraphic':
            child_node = genGraphicNode(xml_child, path)
            break
          case 'mtext':
            child_node = genTextNode(xml_child)
            break
        }
        
        if (xml_child.@pos != undefined)   child_node.position(xml_child.@pos)
        if (xml_child.@id != undefined)    child_node.id = xml_child.@id
        if (xml_child.@group != undefined) child_node.group = xml_child.@group
        
        multi_node.add(genConditionalSet(xml_child.@when.toString()), child_node)
      }
      
      return multi_node
    }
    
    public function genProgressNode(xml:XML, path:String):ProgressNode {
      var model:ValueModel = retrieveActionable(xml.@model) as ValueModel
      var length:uint = uint(xml.@length)
      
      return new ProgressNode(model, path + xml.@url, length)
    }
    
    public function genTextNode(xml:XML):TextNode {
      var format:TextFormat = _supervisor.get('format', xml.@format)
      var align:String      = (xml.@align != undefined) ? xml.@align : 'left'
      
      var charcase:String
      var content:String  = xml
      var arguments:Array = []
      
      if (/\(.*/.test(xml)) {
        var parsed:Object = /(?P<charcase>[ulst])?\((?P<content>.*)\)\s?,\s?(?P<arguments>.*)/.exec(xml)  
        content  = parsed.content
        charcase = parsed.charcase || null
        var to_replace:Array = parsed.arguments.toString().split(/[\s\t]?,[\s\t]?/)
        for each (var arg:String in to_replace) { arguments.push(retrieveActionable(arg))}
      }
      
      var text_node:TextNode = new TextNode(content, format, arguments, align)
      if (charcase) text_node.charcase = charcase
      
      text_node.update()
      return text_node
    }
    
    public function genVectorNode(xml:XML):VectorNode {
      var options:Object = {}
      var known:RegExp   = /^(color|corner|fill|height|radius|stroke|width|)$/

      var attr_list:XMLList = xml.@*
      for (var i:int = 0; i < attr_list.length(); i++) {
        if (known.test(attr_list[i].name())) options[attr_list[i].name().toString()] = attr_list[i]
      }
      
      return new VectorNode(xml.@shape, options)
    }
    
    // ---

    /**
    * @private
    **/
    private function arrToObject(arr:Array):Object {
      var object:Object = {}
      
      for each (var element:String in arr) {
        var key_value:Object = /^(?P<key>[a-z_]+):\s?(?P<value>.*)/.exec(element)
        object[key_value.key] = convertType(key_value.value)
      }
      
      return object
    }
    
    /**
    * @private
    **/
    private function convertType(element:*):* {
      if (/^\d+$/.test(element))           return int(element)
      if (/^[\d\.]+$/.test(element))       return Number(element)
      
      var array_pattern:RegExp = /\[(.*)\]/
      if (array_pattern.test(element)) {
        var arr:Array = element.replace(array_pattern, "$1").split(/[\s\t]?,[\s\t]?/)
        var conv:Array = []
        for each (var elem:* in arr) { conv.push(convertType(elem)) }
        return conv
      }
      
      var object_pattern:RegExp = /\{\s?(.*)\s?\}/
      if (object_pattern.test(element))    return arrToObject(element.replace(object_pattern, "$1").split(/[\s\t]?,[\s\t]/))
      
      // None of the above, just return the contents as string
      return String(element)
    }
    
    /**
    * @private
    **/
    private function parseAction(action_string:String):Object {
      var action_pattern:RegExp = /^(?P<actionable>[\w_]+)\.(?P<method>[\w_]+)\((?P<arguments>.*)\)(\s+if\s+(?P<conditional>.*))?$/
      if (!action_pattern.test(action_string)) throw new Error(action_string)
      var parsed:Object = action_pattern.exec(action_string)

      var args:Array = parsed.arguments.toString().split(/[\s\t]?(,|\[.*\]|\{.*\})[\s\t]?/)
      var conv:Array = []
      for each (var element:* in args) { if (!(/^[\s,]?$/.test(element))) conv.push(convertType(element)) }
      
      parsed.actionable = retrieveActionable(parsed.actionable)
      parsed.arguments  = conv

      return parsed
    }
    
    /**
    * @private
    **/
    private function genSubset(statement:String):ConditionalSet {
      var set:ConditionalSet = new ConditionalSet()

      var group_pattern:RegExp = /(^|\s+(?P<operator>[&|\|]{2})\s+)\((?P<group>[^\)]+)\)/g
      var group:Object = group_pattern.exec(statement)

      while (group) {
        set.push(genSubset(group.group), resolveOperator(group.operator))        
        group = group_pattern.exec(statement)
      }

      // Matching doesn't actually remove the strings, this will.
      statement = statement.replace(group_pattern, '')
      
      var ungrouped_pattern:RegExp = /(^|\s+(?P<operator>[&|\|]{2})\s+)(?P<condition>\w+\s+[<>=]{1,2}\s+\w+)/g
      var ungrouped:Object = ungrouped_pattern.exec(statement)
      
      while (ungrouped) {
        set.push(genCondition(ungrouped.condition), resolveOperator(ungrouped.operator))
        ungrouped = ungrouped_pattern.exec(statement)
      }

      return set
    }
    
    /**
    * @private
    **/
    private function resolveOperator(operator:*):uint {
      operator = operator || '&&'
      return (operator == '&&') ? ConditionalSet.LOGICAL_AND : ConditionalSet.LOGICAL_OR
    }
    
    /**
    * @private
    **/
    private function genCondition(statement:String):Conditional {
      var pattern:RegExp = /^(?P<operand_one>[\w\d_]+)[\s\t]?(?P<operator>[!<>=]{1,2})[\s\t]?(?P<operand_two>[\w\d_]+)$/
      var parsed:Object = pattern.exec(statement)

      parsed.operand_one = (_supervisor.has('actionable', parsed.operand_one))
                         ? _supervisor.get('actionable', parsed.operand_one)
                         : parsed.operand_one
      parsed.operand_two = (_supervisor.has('actionable', parsed.operand_two))
                         ? _supervisor.get('actionable', parsed.operand_two)
                         : parsed.operand_two

      return new Conditional(parsed.operand_one, parsed.operator, parsed.operand_two)
    }
    
    /**
    * @private
    **/
    private function parseQueueMember(member_string:String):Object {
      var member_pattern:RegExp = /^(?P<effect>[a-z]+)\s*?\(\s*?(?P<targets>\[.*\])(\s*?,\s*?)?(?P<options>\{.*\})?(,\s*?)?(?P<wait>\.?\d+)?\)/
      var parsed:Object = member_pattern.exec(member_string)

      parsed.targets = convertType(parsed.targets)
      parsed.options = convertType(parsed.options.toString())
      parsed.wait    = convertType(parsed.wait) || NaN
      
      return parsed
    }
    
    /**
    * @private
    **/
    private function retrieveActionable(actionable_id:String):IActionable {
      return _supervisor.get('actionable', actionable_id)
    }
    
    /**
    * @private
    **/
    private function retrieveVideoReference(xml:XML):Node {
      var video_node:VideoNode = _supervisor.get('video', xml.@id)
          video_node.position(xml.@pos)

      return video_node
    }
  }
}