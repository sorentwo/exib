package unit {

  import asunit.framework.TestCase
  import com.soren.exib.view.GraphicNode
  
  public class GraphicNodeTest extends TestCase {
    
    public function GraphicNodeTest(testMethod:String) {
      super(testMethod)
    }
    
    // ---
    
    public function testGraphicLoading():void {
      var error:Error
      var path:String
      
      try {
        path = 'sample_asset.png'
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
          var graphic:GraphicNode = new GraphicNode("sample_asset" + extension)
        } catch (e:Error) {
          error = e
        }
        
        assertNull(error)
      }
      
      var invalid_extensions:Array = ['.psd', '.tif']
      for each (extension in invalid_extensions) {
        assertThrows(Error, function():void {
          new GraphicNode('sample_asset' + extension)
        })
      }
    }
  }
}