package unit {

  import asunit.framework.TestCase
  import com.soren.exib.view.*
  public class ViewTest extends TestCase {

    // CONSTANTS ----------------------------------------------------------- //

    // PRIVATE VARIABLES --------------------------------------------------- //

    // CONSTRUCTOR --------------------------------------------------------- //
    public function ViewTest(testMethod:String) {
      super(testMethod)
    }

    // SET UP AND TEAR DOWN ------------------------------------------------ //

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {}

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {}

    // TESTS --------------------------------------------------------------- //
    public function testViewCompile():void {
    }
  }
}