package unit {

  import asunit.framework.TestCase
  import com.soren.exib.view.VideoNode

  public class VideoNodeTest extends TestCase {

    private var _source:String = 'test_video.swf'
    
    public function VideoNodeTest(testMethod:String) {
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
      var video_node:VideoNode = new VideoNode(_source, true)
      
      assertEquals(0, video_node.numChildren)
      
      video_node.play()
      assertEquals(1, video_node.numChildren)
    }
    
    public function testInvalidURL():void {
      var error:Error
      try {
        var invalid_url:String   = 'test_video.mov'
        var video_node:VideoNode = new VideoNode(invalid_url)
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
    }
  }
}