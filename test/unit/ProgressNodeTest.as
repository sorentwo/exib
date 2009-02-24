package unit {

  import asunit.framework.TestCase
  import com.soren.exib.model.ValueModel
  import com.soren.exib.view.ProgressNode
  
  public class ProgressNodeTest extends TestCase {
    
    private const ASSET_PATH:String = 'assets/graphics/'
    
    public function ProgressNodeTest(testMethod:String) {
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
    
    public function testConstructionAndChanges():void {
      var value_model:ValueModel = new ValueModel(0, 0, 20)
      var bar_length:uint = 100
      
      var pnode:ProgressNode = new ProgressNode(value_model,
                                                ASSET_PATH + 'fill.png',
                                                bar_length)
      
      assertEquals(1, pnode.numChildren)
      assertEquals(0, pnode.progress)
      
      value_model.set(10)
      assertEquals(50, pnode.progress)
    }
  }
}