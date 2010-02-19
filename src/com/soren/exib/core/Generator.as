/**
* Generator
*
* Handles processing XML into exib class instances.
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.exib.core {

  import flash.display.DisplayObject
  import flash.text.TextField
  import flash.text.TextFormat
  import com.soren.exib.helper.*
  import com.soren.exib.manager.*
  import com.soren.exib.model.*
  import com.soren.exib.service.*
  import com.soren.exib.view.*
  import com.soren.sfx.*
  import com.soren.util.*

  public class Generator {
    
    private const KNOWN_NODES:RegExp = /^button|composite|dial|graphic|mask|multi|meter|progress|radio|text|vector|video|mbutton|mcomposite|mdial|mgraphic|mmask|mmulti|mmeter|mprogress|mradio|mtext|mvector|mvideo$/
    
    private var _space:Space = Space.getSpace()
    
    /**
     * Constructor
    **/
    public function Generator() {}
    
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
      
      var value:*
      for each (var xml_model:XML in xml.model) {
        if (xml_model.@def != undefined) {
          value = xml_model.@def
        } else {
          value = null
        }
        
        model.watch(_space.get(xml_model.@id), value)
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
      var range_pattern:RegExp = /^([\d-]+)\.{2}([\d-]+)$/
      
      var min:int = int(xml.@range.toString().replace(range_pattern, "$1"))
      var max:int = int(xml.@range.toString().replace(range_pattern, "$2"))
      var def:int = int(xml.@def)
      
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
    
    public function genTask(xml:XML):Task {
      return new Task(genActionSet(xml.action))
    }
    
    // Media -->
    public function genFormat(xml:XML):TextFormat {
      var tf:TextFormat = new TextFormat(xml.@font, xml.@size, xml.@color)
      
      if (xml.@leading != undefined) tf.leading       = Number(xml.@leading)
      if (xml.@spacing != undefined) tf.letterSpacing = Number(xml.@spacing)
      
      return tf
    }
    
    public function genSound(xml:XML):Sound {
      return new Sound(xml.@url)
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
    public function genQueue(xml:XML, root:Node):Queue {
      var queue:Queue          = new Queue()
      var group_pattern:RegExp = /\.(.+)/
      var id_pattern:RegExp    = /#(.+)/
      
      for each (var member:XML in xml.*) {
        var effect:String  = member.name().toString()
        var targets:Array  = member.@targets.split(/\s*,\s*/)
        var options:Object = convertType('{' + member + '}') || {}
        var wait:Number    = options.wait || NaN
        
        var all_resolved:Array = []
        for each (var target:String in targets) {
          var resolved:Array
          if (group_pattern.test(target)) {
            resolved = root.getChildrenByGroup(target.replace(/\.(.+)/, "$1"))
          } else if (id_pattern.test(target)) {
            resolved = [root.getChildById(target.replace(/#(.+)/, "$1"))]
          } else {
            throw new Error("Target didn't match as a group or an id")
          }
          
          if (resolved != null && resolved.length > 0) {
            all_resolved = all_resolved.concat(resolved)
          } else {
            throw new Error('No targets were resolved with the pattern: ' + target)
          }
        }
        
        queue.enqueue(effect, all_resolved, options, wait)
      }
      
      return queue
    }
    
    // View -->
    public function genContext(xml_list:XMLList):Node {
      var context:Node = new Node()
      
      if (xml_list.@bg != undefined) context.addChild(new GraphicNode(xml_list.@bg))
      
      genNodes(xml_list.*, context)
      
      return context
    }
    
    public function genContainer(xml_list:XMLList):Node {
      var container:Node = new Node()
      container.position(xml_list.@pos)
      
      return container
    }
    
    public function genNodes(xml_list:XMLList, container:Node, multi:Boolean = false):void {
      for each (var xml:XML in xml_list) {
        
        var new_node:Node
        
        switch (xml.name().toString()) {
          case 'button':
          case 'mbutton':
            new_node = genButtonNode(xml)
            break
          case 'composite':
          case 'mcomposite':
            new_node = genCompositeNode(xml)
            break
          case 'dial':
          case 'mdial':
            new_node = genDialNode(xml)
            break
          case 'graphic':
          case 'mgraphic':
            new_node = genGraphicNode(xml)
            break
          case 'mask':
          case 'mmask':
            new_node = genVectorNode(xml)
            break
          case 'meter':
          case 'mmeter':
            new_node = genMeterNode(xml)
            break
          case 'multi':
          case 'mmulti':
            new_node = new MultiNode()
            break
          case 'progress':
          case 'mprogress':
            new_node = genProgressNode(xml)
            break
          case 'radio':
          case 'mradio':
            new_node = genRadioNode(xml)
            break
          case 'text':
          case 'mtext':
            new_node = genTextNode(xml)
            break
          case 'vector':
          case 'mvector':
            new_node = genVectorNode(xml)
            break
          case 'video':
          case 'mvideo':
            new_node = genVideoNode(xml)
            break
        }
        
        if (new_node) {
          if (multi) {
            if (xml.@when.toString() == 'default') { (container as MultiNode).setDefault(new_node) }
            else { (container as MultiNode).add(genConditionalSet(xml.@when.toString()), new_node) }
          } else {
            container.addChild(new_node)
          }
        }
        
        if (xml.@pos   != undefined) new_node.position(xml.@pos)
        if (xml.@id    != undefined) new_node.id = xml.@id
        if (xml.@group != undefined) new_node.groups = xml.@group.toString().split(/\s+/)
        
        // Mask applied after it has been positioned or it won't move.
        if (xml.name().toString() == 'mask') container.mask = new_node
        
        if (hasChildNode(xml)) genNodes(xml.*, new_node, (new_node is MultiNode))
      }
    }
    
    public function genButtonNode(xml:XML):ButtonNode {
      var press_set:ActionSet   = null
      var release_set:ActionSet = null
        
      if (Boolean(xml.press))   press_set   = genActionSet(xml.press)
      if (Boolean(xml.release)) release_set = genActionSet(xml.release)
      
      if (xml.@down == undefined) xml.@down = xml.@up
      
      return new ButtonNode(xml.@up, xml.@down, press_set, release_set)
    }
    
    public function genCompositeNode(xml:XML):CompositeNode {
      var composite_node:CompositeNode = new CompositeNode()

      if (xml.@bg != undefined) composite_node.addChild(new GraphicNode(xml.@bg))

      return composite_node
    }
    
    public function genDialNode(xml:XML):DialNode {
      var dial_node:DialNode = new DialNode(xml.@url)
            
      for each (var xml_pos:XML in xml.position) {
        var xml_inj:XML
        for each (xml_inj in xml.action)    { xml_pos.appendChild(<action>{xml_inj.toString()}</action>)       }
        for each (xml_inj in xml.inject)    { xml_pos.appendChild(<action>{xml_inj.toString()}</action>)       } // Kept for backwards compatibility
        for each (xml_inj in xml.clockwise) { xml_pos.appendChild(<clockwise>{xml_inj.toString()}</clockwise>) }
        for each (xml_inj in xml.counter)   { xml_pos.appendChild(<counter>{xml_inj.toString()}</counter>)     }
        
        var ambiguous:ActionSet = genActionSet(xml_pos.action)    || null
        var clockwise:ActionSet = genActionSet(xml_pos.clockwise) || null
        var counter:ActionSet   = genActionSet(xml_pos.counter)   || null
        dial_node.add(uint(xml_pos.@snap), ambiguous, clockwise, counter)
      }
      
      return dial_node
    }
    
    public function genGraphicNode(xml:XML):GraphicNode {
      return new GraphicNode(xml.@url)
    }
    
    public function genMeterNode(xml:XML):MeterNode {
      var model:ValueModel = _space.get(xml.@model) as ValueModel
      
      return new MeterNode(model,
                           xml.@left_empty,  xml.@left_full,
                           xml.@mid_empty,   xml.@mid_full,
                           xml.@right_empty, xml.@right_full,
                           xml.@segments, xml.@spacing)
    }
        
    public function genProgressNode(xml:XML):ProgressNode {
      var model:ValueModel = retrieveActionable(xml.@model) as ValueModel
      var length:uint = uint(xml.@length)
      
      return new ProgressNode(model, xml.@url, length)
    }
    
    public function genRadioNode(xml:XML):RadioNode {
      var model:Model = retrieveActionable(xml.@model) as Model
      var selected_url:String   = xml.@selected
      var unselected_url:String = xml.@unselected
      
      var radio:RadioNode = new RadioNode(model, selected_url, unselected_url)

      for each (var option:XML in xml.option) {
        for each (var xml_inj:XML in xml.inject) { option.appendChild(<action>{xml_inj.toString()}</action>) }
        radio.add(option.@pos, option.@value, genActionSet(option.action))
      }
      
      return radio
    }
    
    public function genTextNode(xml:XML):TextNode {
      var format:TextFormat = _space.get(xml.@format)
          format.align = (xml.@align != undefined) ? xml.@align : 'left'
      
      var arguments:Array = []
      var content:String  = xml
      
      var charcase:String, wordwrap:Boolean
      var height:uint, width:uint = 0
      
      if (xml.@height   != undefined) height   = xml.@height
      if (xml.@width    != undefined) width    = xml.@width
      if (xml.@wordwrap != undefined) wordwrap = (xml.@wordwrap == 'true') ? true : false
      
      if (/\(.*/.test(xml)) {
        var parsed:Object = /(?P<charcase>[ulst])?\((?P<content>.*)\)\s?,\s?(?P<arguments>.*)/.exec(xml)  
        content  = parsed.content
        charcase = parsed.charcase || null
        var to_replace:Array = parsed.arguments.toString().split(/[\s\t]?,[\s\t]?/)
        for each (var arg:String in to_replace) { arguments.push(retrieveActionable(arg))}
      }
      
      return new TextNode(content, format, arguments, width, height, charcase, wordwrap)
    }
    
    public function genVectorNode(xml:XML):VectorNode {
      var options:Object = {}
      var known:RegExp   = /^(alpha|color|corner|fill|height|radius|stroke|width|)$/

      var attr_list:XMLList = xml.@*
      for (var i:int = 0; i < attr_list.length(); i++) {
        if (known.test(attr_list[i].name())) options[attr_list[i].name().toString()] = attr_list[i]
      }
      
      return new VectorNode(xml.@shape, options)
    }
    
    public function genVideoNode(xml:XML):VideoNode {
      var mode:uint
      var hold:uint
      switch (xml.@mode.toString()) {
        case 'standard': mode = VideoNode.STANDARD_MODE; break
        case 'loop':     mode = VideoNode.LOOP_MODE;     break
        case 'hold':     mode = VideoNode.HOLD_MODE;     break
        default:         mode = VideoNode.STANDARD_MODE
      }
      
      switch (xml.@hold.toString()) {
        case 'first': hold = VideoNode.HOLD_FIRST; break
        case 'both':  hold = VideoNode.HOLD_BOTH;  break
        case 'last':  hold = VideoNode.HOLD_LAST;  break
        case 'loop':  hold = VideoNode.HOLD_LOOP;  break
        default:      hold = VideoNode.HOLD_FIRST
      }
      
      // Video is the only node that requires explicite control, because of this
      // it must be added to the global space.
      var video:VideoNode = new VideoNode(xml.@url, mode, hold)
      _space.add(video, xml.@id)
      
      return video
    }
    
    // ---

    /**
    * Process an array of strings into an object with key / value pairs.
    **/
    private function arrToObject(arr:Array):Object {
      var object:Object = {}
      
      for each (var element:String in arr) {
        var key_value:Object = /^(?P<key>[a-z_]+):[\s\t]*(?P<value>.*)/.exec(element)
        try {
          object[key_value.key] = convertType(key_value.value.replace(/\s/, ''))
        } catch (e:Error) {
          throw new Error('Object parse failed: ' + element + '\n' + key_value + '\n' + e)
        }
      }
      
      return object
    }
    
    private function convertType(element:*):* {
      var int_pattern:RegExp    = /^\d+$/
      var float_pattern:RegExp  = /^[\d\.]+$/
      var array_pattern:RegExp  = /\[(.*)\]/
      var object_pattern:RegExp = /\{\s?(.*)\s?\}/
      
      if (int_pattern.test(element)) {
        return int(element)
      } else if (float_pattern.test(element)) {
        return Number(element)
      } else if (array_pattern.test(element)) {
        var arr:Array = element.replace(array_pattern, "$1").split(/[\s\t]?,[\s\t]?/)
        var conv:Array = []
        for each (var elem:* in arr) { conv.push(convertType(elem)) }
        return conv
      } else if (object_pattern.test(element)) {
        return arrToObject(element.replace(object_pattern, "$1").split(/[\s\t]*,[\s\t]*/))
      } else {
        return String(element)
      }
    }
    
    private function parseAction(action_string:String):Object {
      var parsed:Object
      var return_pattern:RegExp = /^(return|break)(\s+if\s+(?P<conditional>.*))?$/
      if (return_pattern.test(action_string)) {
        parsed = return_pattern.exec(action_string)
        
        return { actionable: 'return', method: '', arguments: [], conditional: parsed.conditional }
      }
      
      var action_pattern:RegExp = /^(?P<actionable>[\w_@#$+*]+)\.(?P<method>[\w_]+)\((?P<arguments>.*?)\)(\s+if\s+(?P<conditional>.*))?$/
      if (!action_pattern.test(action_string)) {
        throw new Error(action_string)
      }
      
      parsed = action_pattern.exec(action_string)

      var args:Array = parsed.arguments.toString().split(/[\s\t]?(,|\[.*\]|\{.*\})[\s\t]?/)
      var conv:Array = []
      for each (var element:* in args) {
        if (/(^[\s,]?$|^$)/.test(element)) continue
        
        var processed:* = convertType(element)
        if (processed is String && _space.has(processed)) processed = _space.get(processed)
        
        conv.push(processed)
      }
      
      parsed.arguments = conv
      if (_space.has(parsed.actionable)) parsed.actionable = retrieveActionable(parsed.actionable)

      return parsed
    }
    
    private function genSubset(statement:String):ConditionalSet {
      var set:ConditionalSet = new ConditionalSet()

      var group_pattern:RegExp = /(^|\s+(?P<operator>and|or)\s+)\((?P<group>[^\)]+)\)/g
      var group:Object = group_pattern.exec(statement)
      
      while (group) {
        set.push(genSubset(group.group), resolveOperator(group.operator))
        group = group_pattern.exec(statement)
      }
      
      // Matching doesn't actually remove the strings, this will.
      statement = statement.replace(group_pattern, '')
      
      var ungrouped_pattern:RegExp = /(?P<operator>^|and|or)\s*(?P<condition>[\w_@#$+*.\[\]]+\s+[!<>=]{1,2}\s+[\w_@#$+*.\[\]]+)/g
      var ungrouped:Object = ungrouped_pattern.exec(statement)

      while (ungrouped) {
        set.push(genCondition(ungrouped.condition), resolveOperator(ungrouped.operator))
        ungrouped = ungrouped_pattern.exec(statement)
      }

      return set
    }
        
    private function genCondition(statement:String):Conditional {
      var cond_pattern:RegExp = /^(?P<operand_one>.+?)[\s\t]?(?P<operator>[!<>=]{1,2})[\s\t]?(?P<operand_two>.+)$/
      var eval_pattern:RegExp = /^(?P<model>.+?)(\.(?P<method>\w+))?(\[(?P<index>\d+)\])?$/
      
      var parsed:Object     = cond_pattern.exec(statement)
      var broken_one:Object = eval_pattern.exec(parsed.operand_one)
      var broken_two:Object = eval_pattern.exec(parsed.operand_two)
      
      var operand_one:Object, operand_two:Object
      
      broken_one.index = (broken_one.index) ? int(broken_one.index) : -1
      broken_two.index = (broken_two.index) ? int(broken_two.index) : -1
      
      if (_space.has(broken_one.model)) {
        operand_one = new Evaluator(_space.get(broken_one.model), broken_one.method, broken_one.index)
      } else {
        operand_one = broken_one.model
      }

      if (_space.has(broken_two.model)) {
        operand_two = new Evaluator(_space.get(broken_two.model), broken_two.method, broken_two.index)
      } else {
        operand_two = broken_two.model
      }

      return new Conditional(operand_one, parsed.operator, operand_two)
    }
    
    private function resolveOperator(operator:*):uint {
      operator = operator || 'and'
      return (operator == 'and') ? ConditionalSet.LOGICAL_AND : ConditionalSet.LOGICAL_OR
    }
    
    private function retrieveActionable(actionable_id:String):* {
      return _space.get(actionable_id)
    }
  
    /**
    * Determine whether the supplied xml has one or more sub-nodes
    **/
    private function hasChildNode(xml:XML):Boolean {
      for each (var child:XML in xml.*) {
        if (KNOWN_NODES.test(child.name())) return true
      }
      
      return false
    }
  }
}