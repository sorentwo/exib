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
    
    public function testMod():void {
      // Hour
      assertEquals(0, ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_HOUR, 0))
      assertEquals(1, ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_HOUR, 3600))
      assertEquals(1, ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_HOUR, 5305))
      assertEquals(2, ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_HOUR, 7201))
      
      // Minute
      assertEquals(0,  ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_MINUTE, 0))
      assertEquals(1,  ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_MINUTE, 60))
      assertEquals(0,  ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_MINUTE, 3600))
      assertEquals(28, ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_MINUTE, 5305))

      // Second
      assertEquals(0,  ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_SECOND, 0))
      assertEquals(0,  ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_SECOND, 60))
      assertEquals(0,  ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_SECOND, 3600))
      assertEquals(25, ConversionUtil.convertModTime(ConversionUtil.RAW_SECOND, ConversionUtil.MOD_SECOND, 5305))
    }
    
    // This test is just a stub
    public function testGetKeysAndMethod():void {
      var params:Array = ConversionUtil.getTypesAndFunction('rawsec', 'modmin')
      assertEquals(28, params[2].call(null, params[0], params[1], 5305))
    }
	}	
}