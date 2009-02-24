package unit {

  import asunit.framework.TestCase
  import com.soren.exib.view.GraphicNode
  
  public class GraphicNodeTest extends TestCase {
    
    private const ASSET_PATH:String = 'assets/graphics/'
    
    public function GraphicNodeTest(testMethod:String) {
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
    
    public function testGraphicLoading():void {
      var error:Error
      var path:String
      
      try {
        path = ASSET_PATH + 'sample_asset.png'
        var graphic_a:GraphicNode = new GraphicNode(path)
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
      assertEquals(1, graphic_a.numChildren)
    }
    
    public function testValidExtensions():void {
      var error:Error
      
      var valid_extensions:Array = ['.png', '.jpg', '.gif']
      for each (var extension:String in valid_extensions) {
        try {
          var graphic:GraphicNode = new GraphicNode(ASSET_PATH + "sample_asset" + extension)
        } catch (e:Error) {
          error = e
        }
        
        assertNull(error)
      }
      
      var invalid_extensions:Array = ['.psd', '.tif']
      for each (extension in invalid_extensions) {
        try {
          var invalid:GraphicNode = new GraphicNode(ASSET_PATH + 'sample_asset' + extension)
        } catch (e:Error) {
          error = e
        }
        
        assertNotNull(error)
      }
    }
  }
}