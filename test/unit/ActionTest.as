package unit {

  import asunit.framework.TestCase
  import com.soren.exib.core.Space
  import com.soren.exib.helper.*
  import com.soren.exib.model.*
  
  public class ActionTest extends TestCase {

    public function ActionTest(testMethod:String) {
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
    
    public function testVerifyAction():void {
      var val_mod:ValueModel = new ValueModel(1, 0, 2)
      var alt_mod:ValueModel = new ValueModel(0, 0, 2)
      
      var action:Action
      var error:Error
      try {
        action = new Action(val_mod, 'change', 2)
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
    }
    
    public function testAct():void {
      var val_mod_a:ValueModel = new ValueModel(0,0,2)
      var val_mod_b:ValueModel = new ValueModel(1,0,2)
      var sta_mod_a:StateModel = new StateModel('on', 'off')
      var sta_mod_b:StateModel = new StateModel('on', 'off')
      
      var val_act_a:Action = new Action(val_mod_a, 'set', 2)
      var val_act_b:Action = new Action(val_mod_a, 'set', val_mod_b)
      var sta_act_a:Action = new Action(sta_mod_a, 'set', 'off')
      var sta_act_b:Action = new Action(sta_mod_a, 'set', sta_mod_b)
      
      val_act_a.act()
      assertEquals(2, val_mod_a.value)
      
      val_act_b.act()
      assertEquals(val_mod_b.value, val_mod_a.value)
      
      sta_act_a.act()
      assertEquals('off', sta_mod_a.value)
      
      sta_act_b.act()
      assertEquals(sta_mod_a.value, sta_mod_b.value)
    }
    
    public function testActWithCondition():void {
      var val_mod_a:ValueModel = new ValueModel(0,0,1)
      var val_mod_b:ValueModel = new ValueModel(0,0,1)
      
      var val_act_a:Action = new Action(val_mod_a, 'set', 1)
      var val_act_b:Action = new Action(val_mod_a, 'set', 0)
      
      val_act_a.act()
      assertEquals(1, val_mod_a.value)
      
      var conditional:Conditional = new Conditional(val_mod_b, '==', 1)
      var conditional_set:ConditionalSet = new ConditionalSet(conditional, 0)
      
      val_act_b.conditional_set = conditional_set
      val_act_b.act()
      
      assertFalse(conditional.evaluate())
      assertEquals(1, val_mod_a.value)
      
      val_mod_b.set(1)
      val_act_b.act()
      assertTrue(conditional.evaluate())
      assertEquals(0, val_mod_a.value)
    }
    
    public function testActWithFormula():void {
      var val_mod_a:ValueModel = new ValueModel(0,0,10)
      
      // Some vanilla examples
      new Action(val_mod_a, 'set', '2 + 2').act()
      assertEquals(4, val_mod_a.value)
      
      new Action(val_mod_a, 'set', '2 - 2').act()
      assertEquals(0, val_mod_a.value)
      
      new Action(val_mod_a, 'set', '2 * 2').act()
      assertEquals(4, val_mod_a.value)
      
      new Action(val_mod_a, 'set', '2 / 2').act()
      assertEquals(1, val_mod_a.value)
    }
    
    public function testActWithFormulaVariableRetrieval():void {
      var val_mod_a:ValueModel = new ValueModel(0,0,10)
      var val_mod_b:ValueModel = new ValueModel(2,0,10)
      
      var space:Space = Space.getSpace()
      
      space.reset()
      space.add(val_mod_b, 'val_mod_b')
      
      new Action(val_mod_a, 'set', '2 * val_mod_b').act()
      assertEquals(4, val_mod_a.value)
      
      new Action(val_mod_a, 'set', 'val_mod_b % 2').act()
      assertEquals(0, val_mod_a.value)
    }
  }
}