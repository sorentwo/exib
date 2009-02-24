package unit {

  import asunit.framework.TestCase
  import com.soren.exib.model.ValueModel
  import com.soren.exib.view.GraphicNode
  import com.soren.exib.view.MeterNode
  
  public class MeterNodeTest extends TestCase {

    private const ASSET_PATH:String = 'assets/graphics/'
    
    public function MeterNodeTest(testMethod:String) {
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
      var value_model:ValueModel = new ValueModel(0, 0, 5)
      
      var graphic_url:String = ASSET_PATH + 'up.png'
      
      var segments:uint = 5
      var spacing:int   = 0
      
      var meter_node:MeterNode = new MeterNode(value_model,
                                               graphic_url, graphic_url,
                                               graphic_url, graphic_url,
                                               graphic_url, graphic_url,
                                               segments, spacing)
      
      assertEquals(segments, meter_node.segments)
      assertEquals(spacing,  meter_node.spacing)
      
      // An asynchronous test is not worth the effort at this time
    }
  }
}