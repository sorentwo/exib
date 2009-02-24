package unit {

  import asunit.framework.TestCase
  import com.soren.exib.view.Node
  import com.soren.exib.view.ScreenNode
  
  public class ScreenNodeTest extends TestCase {

    public function ScreenNodeTest(testMethod:String) {
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