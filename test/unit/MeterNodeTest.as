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
      
      var url:String = ASSET_PATH + 'up.png'
      
      var segments:uint = 5
      var spacing:int   = 0
      
      var meter_node:MeterNode = new MeterNode(value_model, url, url, url, url,
                                               url, url, segments, spacing)
      
      assertEquals(segments, meter_node.segments)
      assertEquals(spacing,  meter_node.spacing)
    }
    
    public function testProperFullAndEmpty():void {
      var val_a:ValueModel = new ValueModel(0, 0, 5)
      var val_b:ValueModel = new ValueModel(0, 0, 10)
      var val_c:ValueModel = new ValueModel(4, 4, 10)
      var val_d:ValueModel = new ValueModel(0, 0, 100)
      
      var meter_node:MeterNode
      var url:String = ASSET_PATH + 'up.png'
      
      // ValueModel A      
      meter_node = new MeterNode(val_a, url, url, url, url, url, url, 5, 0)

      assertEquals(0, meter_node.full)
      assertEquals(5, meter_node.empty)
      
      val_a.set(3)
      assertEquals(3, meter_node.full)
      assertEquals(2, meter_node.empty)
      
      val_a.set(5)
      assertEquals(5, meter_node.full)
      assertEquals(0, meter_node.empty)
      
      // ValueModel B
      meter_node.model = val_b
      assertEquals(0, meter_node.full)
      assertEquals(5, meter_node.empty)
      
      val_b.set(5)
      assertEquals(2, meter_node.full)
      assertEquals(3, meter_node.empty)
      
      meter_node.segments = 10
      
      assertEquals(5, meter_node.full)
      assertEquals(5, meter_node.empty)
      
      // ValueModel C
      meter_node.model = val_c
      meter_node.segments = 10
      assertEquals(0, meter_node.full)
      assertEquals(10, meter_node.empty)
      
      val_c.set(7)
      assertEquals(5, meter_node.full)
      assertEquals(5, meter_node.empty)
      
      val_c.set(10)
      assertEquals(10, meter_node.full)
      assertEquals(0, meter_node.empty)
      
      val_c.set(7)
      meter_node.segments = 20
      assertEquals(10, meter_node.full)
      assertEquals(10, meter_node.empty)
      
      // ValueModel D
      meter_node.model = val_d
      meter_node.segments = 40
      assertEquals(0, meter_node.full)
      assertEquals(40, meter_node.empty)
      
      val_d.set(15)
      assertEquals(6, meter_node.full)
      assertEquals(34, meter_node.empty)
      
      val_d.set(50)
      assertEquals(20, meter_node.full)
      assertEquals(20, meter_node.empty)
      
      val_d.set(87)
      assertEquals(34, meter_node.full)
      assertEquals(6, meter_node.empty)
    }
  }
}