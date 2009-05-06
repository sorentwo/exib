package unit {
	
	import asunit.framework.TestCase
	import com.soren.util.ConversionUtil
	
  public class ConversionUtilTest extends TestCase {
  	
    /**
    * Constructor
    * 
    * @param  testMethod Name of the method to test
    **/
    public function ConversionUtilTest(testMethod:String) {
      super(testMethod)
    }
		
		//---
		
    public function testConvertVolume():void {
      assertEquals(1,   ConversionUtil.convertVolume(ConversionUtil.OUNCE, ConversionUtil.CUP, 8))
    }
	}	
}