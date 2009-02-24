package unit {

  import asunit.framework.TestCase
  import com.soren.util.KeyUtil

  public class KeyUtilTest extends TestCase {

    public function KeyUtilTest(testMethod:String) {
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
    
    //---
    
    public function testGetKeyCode():void {
	 	  assertEquals(65, KeyUtil.getKeyCode('a'))
	 	  assertEquals(78, KeyUtil.getKeyCode('n'))
	 	  assertEquals(90, KeyUtil.getKeyCode('z'))
	 	}
  }
}