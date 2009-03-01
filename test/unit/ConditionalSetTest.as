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
    }
    
    public function testPublicMethods():void {
      var sta_mod:StateModel = new StateModel('ON', 'OFF')
      var sec_mod:StateModel = new StateModel('harvard', 'tie')
      
      var cond_set:ConditionalSet = new ConditionalSet()
      cond_set.push(new Conditional(sta_mod, '==', 'ON'),  ConditionalSet.LOGICAL_AND)
      cond_set.push(new Conditional(sec_mod, '==', 'tie'))
      
      assertFalse(cond_set.evaluate())
      
      cond_set.push(new Conditional(sec_mod, '==', 'harvard'), ConditionalSet.LOGICAL_OR)
      assertTrue(cond_set.evaluate())
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
      cond_set.push(new Conditional(sta_mod_a, '==', 'off'))
      cond_set.push(new Conditional(sta_mod_b, '==', 'off'))
      
      cond_set.registerListener(eventListener)
      
      sta_mod_a.set('off')
      assertEquals(1, _changed_by_event)
      
      sta_mod_b.set('off')
      assertEquals(2, _changed_by_event)
      
      cond_set.unregisterListener(eventListener)
      
      sta_mod_a.set('on')
      assertEquals(2, _changed_by_event)
    }
    
    public function testGroupings():void {
      var _harlan:StateModel = new StateModel('pepper', 'fleck')
      var _rufus:StateModel = new StateModel('bloodhound', 'bassethound')
      var _cookie:StateModel = new StateModel('dozens', 'hundreds')
      var _buisybee:StateModel = new StateModel('fish', 'parrot')
      
      var and:uint = ConditionalSet.LOGICAL_AND
      var or:uint  = ConditionalSet.LOGICAL_OR
      
      // (_harlan == pepper && _rufus == bloodhound) || (_cookie == hundreds)
      var subset_a:ConditionalSet = new ConditionalSet()
      var subset_b:ConditionalSet = new ConditionalSet()
      subset_a.push(new Conditional(_harlan, '==', 'pepper'),     and)
      subset_a.push(new Conditional(_rufus,  '==', 'bloodhound'), and)
      subset_b.push(new Conditional(_cookie, '==', 'hundreds'),   and)
      
      var set_a:ConditionalSet = new ConditionalSet()
      set_a.push(subset_a, and)
      set_a.push(subset_b, or)
      
      assertTrue(set_a.evaluate())
      
      // (_buisybee == fish || _cookie == hundreds) && (_rufus == bloodhound || _harlan == fleck)
      subset_a = subset_b = new ConditionalSet()
      subset_a.push(new Conditional(_buisybee, '==', 'fish'),       and)
      subset_a.push(new Conditional(_cookie,   '==', 'hundreds'),   or)
      subset_b.push(new Conditional(_rufus,    '==', 'bloodhound'), and)
      subset_b.push(new Conditional(_harlan,   '==', 'fleck'),      or)
      
      var set_b:ConditionalSet = new ConditionalSet()
      set_b.push(subset_a, and)
      set_b.push(subset_b, and)
      
      assertTrue(set_b.evaluate())
      
      // _harlan == fleck && (_rufus == bloodhound || _cookie == hundreds)
      subset_a = new ConditionalSet()
      subset_a.push(new Conditional(_rufus,  '==', 'bloodhound'), and)
      subset_a.push(new Conditional(_cookie, '==', 'hundreds'),   or)
      
      var set_c:ConditionalSet = new ConditionalSet()
      set_c.push(new Conditional(_harlan, '==', 'fleck'), and)
      set_c.push(subset_a, and)
      
      assertFalse(set_c.evaluate())
    }
    
    // ---
    
    private function eventListener(event:Event):void {
      _changed_by_event += 1
    }
  }
}