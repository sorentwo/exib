package unit {

  import asunit.framework.TestCase
  import com.soren.exib.helper.*
  import com.soren.exib.model.ValueModel
  import com.soren.exib.view.Node
  import com.soren.exib.view.MultiNode

  public class MultiNodeTest extends TestCase {

    public function MultiNodeTest(testMethod:String) {
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
    
    public function testConstructionAndObservation():void {
      var mod_a:ValueModel = new ValueModel(0, 0, 2)
      
      var con_a:Conditional = new Conditional(mod_a, '==', 0)
      var con_b:Conditional = new Conditional(mod_a, '==', 1)
      
      var sub_node_a:Node = new Node()
      var sub_node_b:Node = new Node()
      sub_node_a.id = 'sub_node_a'
      sub_node_b.id = 'sub_node_b'
      
      var multi:MultiNode = new MultiNode()
      multi.add(new ConditionalSet(con_a), sub_node_a)
      multi.add(new ConditionalSet(con_b), sub_node_b)
      
      assertEquals(1, multi.numChildren)
      assertEquals('sub_node_a', (multi.getChildAt(0) as Node).id)
      
      mod_a.set(1)
      
      assertEquals(1, multi.numChildren)
      assertEquals('sub_node_b', (multi.getChildAt(0) as Node).id)
      
      mod_a.set(2)
      
      assertEquals(0, multi.numChildren)
    }
  }
}