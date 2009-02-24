package unit {

  import asunit.framework.TestCase
  import com.soren.exib.helper.*
  import com.soren.exib.model.*
  
  public class ActionSetTest extends TestCase {

    public function ActionSetTest(testMethod:String) {
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
    
    public function testConstructor():void {
      var action_set:ActionSet
      var error:Error
      try {
        action_set = new ActionSet()
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
    }
    
    public function testPublicMethods():void {
      var mod_a:StateModel = new StateModel('on', 'off')
      var mod_b:StateModel = new StateModel('on', 'off')
      var act_a:Action = new Action(mod_a, 'set', 'OFF')
      var act_b:Action = new Action(mod_b, 'set', 'OFF')
      var act_c:Action = new Action(mod_b, 'set', 'ON')
      
      var act_set:ActionSet = new ActionSet()
      
      // Push a single
      act_set.push(act_a)
      assertEquals(act_set.set.length, 1)
      
      // Push multiple
      act_set.push(act_b, act_c)
      assertEquals(act_set.set.length, 3)
      
      // Push an incorrect object
      var error:Error
      try {
        act_set.push(new Object)
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
      
      // Test isEmpty
      assertFalse(act_set.isEmpty())
      
      // Test act
      act_set.act()
      assertEquals('off', mod_a.value)
      assertEquals('on', mod_b.value)
    }
  }
}