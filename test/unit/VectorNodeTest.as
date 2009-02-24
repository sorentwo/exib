package unit {

  import asunit.framework.TestCase
  import com.soren.exib.view.VectorNode

  public class VectorNodeTest extends TestCase {

    public function VectorNodeTest(testMethod:String) {
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
      var vc:VectorNode = new VectorNode('circle')
      assertEquals(1, vc.numChildren)
    }
    
    public function testValidShapes():void {
      var valid_shapes:Array = ['circle', 'rectangle', 'squround']
      
      for each (var shape:String in valid_shapes) {
        var error:Error
        try {
          var vector:VectorNode = new VectorNode(shape)
        } catch (e:Error) {
          error = e
        }
        
        assertNull(error)
      }
      
      var invalid_shapes:Array = ['cir', 'rect', 'hexagon', 'dodecahedron']
      
      for each (var invalid_shape:String in invalid_shapes) {
        try {
          vector = new VectorNode(invalid_shape)
        } catch (e:Error) {
          error = e
        }
        
        assertNotNull(error)
      }
    }
  }
}