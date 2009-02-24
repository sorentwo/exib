package unit {

  import asunit.framework.TestCase
  import flash.events.*
  import com.soren.exib.helper.*
  import com.soren.exib.model.*
  
  public class ConditionalTest extends TestCase {

    private var _changed_by_event:uint = 0

    public function ConditionalTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void { }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void { }

    // ---
    
    public function testArgumentVerification():void {
      var mod_a:StateModel = new StateModel(['ON', 'OFF'])
      
      var error:Error
      var conditional:Conditional
      
      // Try the 4 valid data types, boolean, string, number, value returning
      try {
        conditional = new Conditional(true,  '==', 'true')
        conditional = new Conditional('on',  '==', 'on')
        conditional = new Conditional(5,     '==', '5')
        conditional = new Conditional(mod_a, '==', 'on')
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
      
      // Try all valid operators
      try {
        for each (var operator:String in Conditional.VALID_OPERATORS) {
          conditional = new Conditional(mod_a, operator, 'on')
        }
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
      
      // Try an invalid operand type
      try {
        conditional = new Conditional(new Array, '==', 'ON')
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
      error = null
      
      // Try an invalid operator
      try {
        conditional = new Conditional(mod_a, '!', 'on')
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
    }
    
    public function testEvaluation():void {
      var sta_mod_a:StateModel = new StateModel('ON', 'OFF')
      var sta_mod_b:StateModel = new StateModel('OFF', 'ON')
      var val_mod_a:ValueModel = new ValueModel(0, 0, 10)
      var val_mod_b:ValueModel = new ValueModel(5, 0, 10)
      
      var passing:Array = [new Conditional(sta_mod_a, '==', 'ON'),
                           new Conditional(sta_mod_a, '!=', sta_mod_b),
                           new Conditional(val_mod_a, '<', 1),
                           new Conditional(val_mod_a, '<=', 0),
                           new Conditional(val_mod_b, '>', val_mod_a),
                           new Conditional(val_mod_b, '>=', 5)
                          ]
                          
      for each (var conditional:Conditional in passing) {
        assertTrue(conditional.evaluate())
      }
      
      var failing:Array = [new Conditional(sta_mod_a, '==', sta_mod_b),
                           new Conditional(sta_mod_a, '!=', 'ON'),
                           new Conditional(val_mod_a, '<', 0),
                           new Conditional(val_mod_b, '<=', val_mod_a),
                           new Conditional(val_mod_b, '>', 10),
                           new Conditional(val_mod_b, '>=', 10)
                          ]
      
      for each (conditional in failing) {
        assertFalse(conditional.evaluate())
      }
    }
    
    public function testListeners():void {
      var val_mod_a:ValueModel = new ValueModel(0, 0, 1)
      var val_mod_b:ValueModel = new ValueModel(1, 0, 1)
      
      var conditional:Conditional = new Conditional(val_mod_a, '==', val_mod_b)
      conditional.registerListener(eventListener)
      
      val_mod_a.set(1)
      assertEquals(1, _changed_by_event)
      
      val_mod_b.set(0)
      assertEquals(2, _changed_by_event)
      
      conditional.unregisterListener(eventListener)
      
      val_mod_a.set(0)
      assertEquals(2, _changed_by_event)
    }
    
    // ---
    
    private function eventListener(event:Event):void {
      _changed_by_event += 1
    }
  }
}