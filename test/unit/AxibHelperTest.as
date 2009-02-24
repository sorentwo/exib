package unit {
  
  import asunit.framework.TestCase
  import flash.events.*
  import com.soren.exib.controller.*
  import com.soren.exib.helper.AxibHelper
  import com.soren.exib.manager.*
  import com.soren.exib.model.*
  public class AxibHelperTest extends TestCase {
  
    // CONSTANTS --------------------------------------------------------- //

    // PRIVATE VARIABLES ------------------------------------------------- //
    private var _instance:AxibHelper

    /**
    * Constructor
    * 
    * @param  testMethod Name of the method to test
    **/
    public function AxibHelperTest(testMethod:String) {
      super(testMethod)
    }
    
    // SET UP AND TEAR DOWN ---------------------------------------------- //
    
    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _instance = new AxibHelper()
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _instance = null
    }
    
    
    // TESTS ------------------------------------------------------------- //
    public function testApplyActions():void {
      var val_mod_a:ValueModel      = new ValueModel(0, 0, 1)
      var val_mod_b:ValueModel      = new ValueModel(1, 0, 1)
      var val_con_a:ValueController = new ValueController(val_mod_a, 1)
      var val_con_b:ValueController = new ValueController(val_mod_b, 1)
      
      var straight:Array = [{controller: val_con_a, action: '1'},
                            {controller: val_con_b, action: '0'}]
      
      _instance.applyActions(straight)
      assertEquals(1, val_mod_a.value)
      assertEquals(0, val_mod_b.value)
      
      var to_model:Array = [{controller: val_con_a, action: val_mod_b}]
      
      _instance.applyActions(to_model)
      assertEquals(val_mod_b.value, val_mod_a.value)
    }
    
    public function testParseCoordinatePairs():void {
      var pair:Object = _instance.parseCoordinates('5, 10')
      assertEquals(5, pair.x)
      assertEquals(10, pair.y)
      
      pair = _instance.parseCoordinates('5,10')
      assertEquals(5, pair.x)
      assertEquals(10, pair.y)
      
      pair = _instance.parseCoordinates('5 , 10')
      assertEquals(5, pair.x)
      assertEquals(10, pair.y)
      
      var invalidPairs:Array = ['x y', 'x, y', '5 10', '5:10']
      for each (var invalidPair:String in invalidPairs) {
        var error:Error
        try {
          _instance.parseCoordinates(invalidPair)
        } catch (e:Error) {
          error = e
        }
        assertNotNull(error)
      }
    }
    
    public function testparseActionPairs():void {
      var validPairs:Array = [
          ['controller:action', [{controller: 'controller', action: 'action'}]],
          ['cont roller:act ion', [{controller: 'cont roller', action: 'act ion'}]],
          ['con_a:act, con_b:act', [{controller: 'con_a', action: 'act'},
                                    {controller: 'con_b', action: 'act'}]],
          ['con a:act, con b:act, con c:act', [{controller: 'con a', action: 'act'},
                                               {controller: 'con b', action: 'act'},
                                               {controller: 'con c', action: 'act'}]]
          ]
                              
      for each (var validPair:Array in validPairs) {
        assertEquals(validPair[1].toString(),
                     _instance.parseActionPairs(validPair[0]).toString())
      }
      
      var returnPairs:Array = [
          ["controller:action, \n controller:action", [{controller: 'controller', action: 'action'},
                                 {controller: 'controller', action: 'action'}]]
          ]
      
      for each (var returnPair:Array in returnPairs) {
        assertEquals(validPair[1].toString(),
                     _instance.parseActionPairs(validPair[0]).toString())
      }
      
      var invalidPairs:Array = ['controller:',
                                'controller-action',
                                'controller action',
                                ':action',
                                'controller:'
                               ]
      
      for each (var invalidPair:String in invalidPairs) {
        var error:Error
        try {
          _instance.parseActionPairs(invalidPair)
        } catch (e:Error) {
          error = e
        }
        assertNotNull(error)
      }
    }
    
    public function testModelAsActionParsing():void {
      var model_a:StateModel = new StateModel(['true', 'false'])
      var model_b:StateModel = new StateModel(['false', 'true'])
      var contr_a:StateController = new StateController(model_a)
      var contr_b:StateController = new StateController(model_b)
      
      var mod_manager:Manager = new Manager()
      var con_manager:Manager = new Manager()
      
      mod_manager.add('model_a', model_a)
      mod_manager.add('model_b', model_b)
      con_manager.add('contr_a', contr_a)
      con_manager.add('contr_b', contr_b)
      
      var valid_pairs:String = "contr_a:model_b, contr_b:model_a"
      
      var pairs:Array = _instance.parseActionPairs(valid_pairs,
                                                   con_manager, mod_manager)

      assertEquals('[object StateController]', pairs[0].controller.toString())
      assertEquals('[object StateModel]', pairs[0].action.toString())
      assertEquals('FALSE', pairs[0].action.value)
    }
    
    public function testParseContentModelGroup():void {
      var content_string:String = 'This is the content'
      var model_string:String   = 'modela,modelb'
      var combined:String       = "(" + content_string + "), " + model_string
      
      var group:Object = _instance.parseReplacementGroup(combined)
      assertEquals(content_string, group.content)
      assertEquals(model_string,   group.models.toString())
      
      var valid_tokens:Array = ['u', 'l', 's', 't']
      for each (var valid_token:String in valid_tokens) {
        var combined_with_case:String = valid_token + combined
        group = _instance.parseReplacementGroup(combined_with_case)
        assertEquals(valid_token, group.charcase)
      }
      
      var invalid_token:String = 'k'
      group = _instance.parseReplacementGroup(invalid_token + combined)
      assertFalse(Boolean(group.charcase))
    }
    
    public function testParseConditionalGroups():void {
      var group:Object = _instance.parseConditionalGroups("model > condition").shift()
      assertEquals("model", group.model)
      assertEquals(">", group.operator)
      assertEquals("condition", group.condition)
      
      group = _instance.parseConditionalGroups("model >= condition").shift()
      assertEquals(">=", group.operator)
      
      group = _instance.parseConditionalGroups("model <= condition").shift()
      assertEquals("<=", group.operator)
      
      group = _instance.parseConditionalGroups("model == condition").shift()
      assertEquals("==", group.operator)
      
      group = _instance.parseConditionalGroups("model != condition").shift()
      assertEquals("!=", group.operator)
      
      var multi_group_string:String = "model_a == condition_a, " +
                                      "model_b > 10, " +
                                      "model_c == condition_c, " +
                                      "model_d != condition_d"
      var groups:Array = _instance.parseConditionalGroups(multi_group_string)
      assertEquals('model_a', groups[0].model)
      assertEquals('model_b', groups[1].model)
      assertEquals('model_c', groups[2].model)
      assertEquals('model_d', groups[3].model)
    }
 
    public function testNamesToManagedForControllers():void {
      var val_mod_a:ValueModel = new ValueModel(1, 0, 5)
      var val_mod_b:ValueModel = new ValueModel(1, 0, 5)
      var val_con_a:ValueController = new ValueController(val_mod_a, 1)
      var val_con_b:ValueController = new ValueController(val_mod_b, 1)
      
      var manager:Manager = new Manager()
      manager.add('con_a', val_con_a)
      manager.add('con_b', val_con_b)
      
      var pairs:Array = [{controller: 'con_a', action: 'INCREASE'},
                         {controller: 'con_b', action: 'INCREASE'}]
      
      pairs = _instance.namesToManaged(pairs, 'controller', manager)
      
      assertTrue(pairs[0].controller is ValueController)
      assertTrue(pairs[1].controller is ValueController)
      
      assertSame(val_con_a, pairs[0].controller)
      assertSame(val_con_b, pairs[1].controller)
    }
       
    public function testNamesToManagedForModels():void {
      var val_mod:ValueModel = new ValueModel(1, 0, 5)
      var sta_mod:StateModel = new StateModel(['on', 'off'])
      
      var manager:Manager = new Manager()
      manager.add('val_mod', val_mod)
      manager.add('sta_mod', sta_mod)
      
      var conditional:Object = {model: 'val_mod', operator: '>', condition: 5}
      conditional = _instance.namesToManaged(conditional, 'model', manager)[0]
      
      assertSame(val_mod, conditional.model)
      
      var conditionals:Array = [{model: 'val_mod', operator: '>', condition: 5},
                                {model: 'sta_mod', operator: '==', condition: 'on'}
                               ]
      conditionals = _instance.namesToManaged(conditionals, 'model', manager)
      
      assertSame(val_mod, conditionals[0].model)
      assertSame(sta_mod, conditionals[1].model)
    }
    
    public function testEvaluateConditional():void {
      var val_mod_a:ValueModel = new ValueModel(1, 0, 5)
      var sta_mod_a:StateModel = new StateModel(['on', 'off'])
      
      var passing:Array = [{model: val_mod_a, operator: '>', condition: 0},
                           {model: val_mod_a, operator: '>=', condition: 1},
                           {model: val_mod_a, operator: '<', condition: 2},
                           {model: val_mod_a, operator: '<=', condition: 1},
                           {model: sta_mod_a, operator: '==', condition: 'on'}]
      
      for each (var pass:Object in passing) {
        assertTrue(_instance.evaluateConditionals(pass))
      }
      
      var failing:Array = [{model: val_mod_a, operator: '>', condition: 2},
                           {model: val_mod_a, operator: '>=', condition: 2},
                           {model: val_mod_a, operator: '<', condition: 1},
                           {model: val_mod_a, operator: '<=', condition: 0},
                           {model: sta_mod_a, operator: '==', condition: 'off'}]
      
      for each (var fail:Object in failing) {
        assertFalse(_instance.evaluateConditionals(fail))
      }
    }
    
    public function testEvaluateConditionalArray():void {
      var sta_mod_a:StateModel = new StateModel(['on', 'off'])
      var sta_mod_b:StateModel = new StateModel(['high', 'low'])
      var val_mod_a:ValueModel = new ValueModel(1, 0, 5)
      
      var single_true:Array = [{model: sta_mod_a, operator: '==', condition: 'on'}]
      assertTrue(_instance.evaluateConditionals(single_true))
      
      var double_true:Array = [{model: sta_mod_a, operator: '==', condition: 'on'},
                               {model: val_mod_a, operator: '<', condition: 3}
                              ]
      assertTrue(_instance.evaluateConditionals(double_true))
      
      var one_and_one:Array = [{model: sta_mod_b, operator: '==', condition: 'high'},
                               {model: sta_mod_a, operator: '==', condition: 'off'}
                              ]
      assertFalse(_instance.evaluateConditionals(one_and_one))
      
      var multiple_set:Array = [{model: sta_mod_a, operator: '!=', condition: 'off'},
                                {model: sta_mod_b, operator: '==', condition: 'high'},
                                {model: val_mod_a, operator: '>', condition: 4}
                               ]
      assertFalse(_instance.evaluateConditionals(multiple_set))
    }
  
    public function testDoubleModelConditionals():void {
      var val_mod_a:ValueModel = new ValueModel(1, 0, 5)
      var val_mod_b:ValueModel = new ValueModel(2, 0, 5)
      var sta_mod_a:StateModel = new StateModel(['ON', 'OFF'])
      var sta_mod_b:StateModel = new StateModel(['OFF', 'ON'])
      
      var passing:Array = [{model: val_mod_a, operator: '<=', condition: val_mod_b},
                           {model: val_mod_b, operator: '>=', condition: val_mod_a},
                           {model: sta_mod_a, operator: '!=', condition: sta_mod_b},]
      
      assertTrue(_instance.evaluateConditionals(passing))
      
      var failing:Array = [{model: val_mod_a, operator: '>', condition: val_mod_b},
                           {model: val_mod_b, operator: '<', condition: val_mod_a},
                           {model: sta_mod_a, operator: '==', condition: sta_mod_b},]
      
      assertFalse(_instance.evaluateConditionals(failing))
    }
    
    public function testRegisterConditionals():void {
      var model_a:StateModel  = new StateModel(['on', 'off'])
      var model_b:ValueModel  = new ValueModel(1,0,2)
      
      var objects:Array = [{model: model_a},
                           {model: model_b}]
      
      var call_count:uint = 0
      var test_object:Object = new Object()
      test_object.conditionalListener = function(event:Event) { call_count += 1 }
      
      var error:Error
      try {
        _instance.registerConditionals(objects, test_object.conditionalListener)
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
      
      model_a.value = 'off'
      model_b.value = 2
      
      assertEquals(2, call_count)
    }
    
    public function testUnregisterConditionals():void {
      var model_a:StateModel = new StateModel(['on', 'off'])
      
      var objects:Array = [{model: model_a}]
      
      var call_count:uint = 0
      var test_object:Object = new Object()
      test_object.conditionalListener = function(event:Event) { call_count += 1 }
      
      var error:Error
      try {
        _instance.registerConditionals(objects, test_object.conditionalListener)
        _instance.unregisterConditionals(objects, test_object.conditionalListener)
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
      
      model_a.value = 'off'
      
      assertEquals(0, call_count)
    }
  }
}