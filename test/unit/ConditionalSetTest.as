package unit {

  import asunit.framework.TestCase
  import flash.events.*
  import com.soren.exib.helper.*
  import com.soren.exib.model.*

  public class ConditionalSetTest extends TestCase {
    
    private var _changed_by_event:uint = 0

    public function ConditionalSetTest(testMethod:String) {
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
      var conditional_set:ConditionalSet
      var error:Error
      try {
        conditional_set = new ConditionalSet()
      } catch (e:Error) {
        error = e
      }
            
      assertNull(error)
      
      try {
        conditional_set = new ConditionalSet(new Conditional(true, '==', false),
                                             new Conditional(true, '==', false))
      } catch (e:Error) {
        error = e
      }
            
      assertNull(error)
    }
    
    public function testPublicMethods():void {
      var sta_mod:StateModel = new StateModel('ON', 'OFF')
      
      var cond_set:ConditionalSet = new ConditionalSet()
      cond_set.push(new Conditional(sta_mod, '==', 'ON'))
      cond_set.push(new Conditional(sta_mod, '!=', 'OFF'))
      
      assertTrue(cond_set.evaluate())
      
      cond_set.push(new Conditional(sta_mod, '==', 'OFF'))
      assertFalse(cond_set.evaluate())
    }
    
    public function testIsEmpty():void {
      var cond_set:ConditionalSet = new ConditionalSet()
      assertTrue(cond_set.isEmpty())
      
      cond_set.push(new Conditional(true, '==', false))
      assertFalse(cond_set.isEmpty())
    }
    
    public function testListeners():void {
      var sta_mod_a:StateModel = new StateModel('on', 'off')
      var sta_mod_b:StateModel = new StateModel('on', 'off')
      
      var cond_set:ConditionalSet = new ConditionalSet()
      cond_set.push(new Conditional(sta_mod_a, '==', 'off'),
                    new Conditional(sta_mod_b, '==', 'off'))
      
      cond_set.registerListener(eventListener)
      
      sta_mod_a.set('off')
      assertEquals(1, _changed_by_event)
      
      sta_mod_b.set('off')
      assertEquals(2, _changed_by_event)
      
      cond_set.unregisterListener(eventListener)
      
      sta_mod_a.set('on')
      assertEquals(2, _changed_by_event)
    }
    
    // ---
    
    private function eventListener(event:Event):void {
      _changed_by_event += 1
    }
  }
}