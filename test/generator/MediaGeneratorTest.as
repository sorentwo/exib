package generator {

  import asunit.framework.TestCase
  import flash.text.TextFormat
  import com.soren.exib.core.*
  import com.soren.exib.service.Sound
  import com.soren.exib.view.VideoNode

  public class MediaGeneratorTest extends TestCase {

    private var _generator:Generator
    private var _xml:XML
    
    public function MediaGeneratorTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _generator  = new Generator()
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _generator  = null
    }
    
    // ---
    
    public function testFormatGenerator():void {
      _xml = <format id="plain" font="Helvetica" size="12" color="0xFFFFFF" />
      
      var format:TextFormat = _generator.genFormat(_xml)
    }
    
    public function testSoundGenerator():void {
      _xml = <sound id="tweet" url="assets/sounds/tone.mp3" />
      
      var sound:Sound = _generator.genSound(_xml)
    }
    
    public function testVideoGenerator():void {
      _xml = <video id="slick" url="assets/video/test_video.flv" size="640x480" />
      
      var video:VideoNode = _generator.genVideo(_xml)
    }
  }
}