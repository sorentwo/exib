package unit {

  import asunit.framework.TestCase
  import com.soren.exib.view.VideoNode

  public class VideoNodeTest extends TestCase {

    private var _source:String = 'test_video.swf'
    
    public function VideoNodeTest(testMethod:String) {
      super(testMethod)
    }
    
    /*public function testInvalidURL():void {
      var error:Error
      try {
        var invalid_url:String   = 'test_video.mov'
        var video_node:VideoNode = new VideoNode(invalid_url)
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
    }*/
  }
}