package unit {

  import asunit.framework.TestCase
  import com.soren.exib.service.Sound

  public class SoundTest extends TestCase {
    
    public function SoundTest(testMethod:String) {
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
    
    public function testLoadSound():void {
      var error:Error
      try {
        var sound:Sound = new Sound('tone.mp3')
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
    }
    
    public function testPlaySound():void {
      var sound:Sound = new Sound('tone.mp3')
      sound.play(3)
    }
  }
}