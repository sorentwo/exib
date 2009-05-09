package unit {

  import asunit.framework.TestCase
  import flash.display.SimpleButton
  import flash.display.Stage
  import flash.events.MouseEvent
  import com.soren.exib.helper.Action
  import com.soren.exib.helper.ActionSet
  import com.soren.exib.model.ValueModel
  import com.soren.exib.view.ButtonNode
  import com.soren.exib.view.GraphicNode
  
  public class ButtonNodeTest extends TestCase {
    
    public function ButtonNodeTest(testMethod:String) {
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
    
    public function testConstructionAndAction():void {
      var model:ValueModel = new ValueModel(0, 0, 1)
      
      var act_a:Action = new Action(model, 'set', 1)
      var act_b:Action = new Action(model, 'set', 0)
      
      var press_set:ActionSet   = new ActionSet(act_a)
      var release_set:ActionSet = new ActionSet(act_b)
      
      var button:ButtonNode = new ButtonNode('up.png', 'down.png', press_set, release_set)
      
      assertEquals(1, button.numChildren)
      
      // To simulate mouse event we must extract the SimpleButton inside of the
      // button node. To use the Node base class SimpleButton couldn't be extended.
      button.getChildAt(0).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN))
      assertEquals(1, model.value)
      
      button.getChildAt(0).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP))
      assertEquals(0, model.value)
    }
  }
}