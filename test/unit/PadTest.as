package unit {

  import asunit.framework.TestCase
  import com.soren.util.Pad

  public class PadTest extends TestCase {

    public function PadTest(testMethod:String) {
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

    public function testPad():void {
      assertEquals(' 1', Pad.pad(1))
      assertEquals('_1', Pad.pad(1, 2, '_'))
      assertEquals('_K_', Pad.pad('K_', 3, '_'))
      assertEquals('ff1', Pad.pad(1, 3, 'f'))
    }
    
    public function testZeroPad():void {
      assertEquals('01', Pad.zeroPad(1))
      assertEquals('1', Pad.zeroPad(1, 1))
      assertEquals('01', Pad.zeroPad(1, 2))
      assertEquals('10', Pad.zeroPad(10, 2))
      assertEquals('010', Pad.zeroPad(10, 3))
      assertEquals('100', Pad.zeroPad(100, 2))
      assertEquals('100', Pad.zeroPad(100, 3))
      assertEquals('00100', Pad.zeroPad(100, 5))
    }
    
    public function testDecPad():void {
      assertEquals('1.00', Pad.decPad(1))
      assertEquals('1.0', Pad.decPad(1, 1))
      assertEquals('1.00', Pad.decPad(1, 2))
      assertEquals('10.0', Pad.decPad(10, 1))
    }
  }
}