package unit {

  import asunit.framework.TestCase
  import com.soren.exib.helper.Action
  import com.soren.exib.helper.ActionSet
  import com.soren.exib.model.StateModel
  import com.soren.exib.view.DialNode

  public class DialNodeTest extends TestCase {
    
    private var _graphic_url:String = 'assets/graphics/dial.png'
    
    public function DialNodeTest(testMethod:String) {
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
      var model:StateModel = new StateModel('normal', 'heavy', 'whites', 'rinse')
      
      var act_a:Action = new Action(model, 'set', 'normal')
      var act_b:Action = new Action(model, 'set', 'heavy')
      var act_c:Action = new Action(model, 'set', 'whites')
      var act_d:Action = new Action(model, 'set', 'rinse')
      
      var act_set_a:ActionSet = new ActionSet(act_a)
      var act_set_b:ActionSet = new ActionSet(act_b)
      var act_set_c:ActionSet = new ActionSet(act_c)
      var act_set_d:ActionSet = new ActionSet(act_d)      
      
      var dial_node:DialNode = new DialNode(_graphic_url)
      
      assertEquals(0, dial_node.numPositions)
      
      dial_node.add(0, act_set_a)
      assertEquals(1, dial_node.numPositions)
      
      dial_node.add(180, act_set_c)
      assertEquals(2, dial_node.numPositions)
    }
  }
}