package unit {

  import asunit.framework.TestCase
  import com.soren.exib.service.Task
  import com.soren.sfx.*

  public class QueueCallbackTest extends TestCase {

    public function QueueCallbackTest(testMethod:String) {
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

  }
}