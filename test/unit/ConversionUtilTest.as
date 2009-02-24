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

	  /**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void { }

		/**
	 	 * Clean up after test, delete instance of class that we were testing.
	 	 */
	 	protected override function tearDown():void { }
		
		//---
		
	 	public function testToCups():void {
	 	  assertEquals('1', ConversionUtil.toCups(8))
	 	  assertEquals('1.5', ConversionUtil.toCups(12))
	 	  assertEquals('2.12', ConversionUtil.toCups(17, 2))
	 	}

	 	public function testToLitres():void {
	 	  assertEquals('0.5', ConversionUtil.toLitres(20))
 	    assertEquals('0.3', ConversionUtil.toLitres(13))
 	    assertEquals('0.59', ConversionUtil.toLitres(20, 2))
	 	}
	 	
	 	public function testToFahrenheit():void {
	 	  assertEquals('212', ConversionUtil.toFahrenheit(100))
	 	  assertEquals('189', ConversionUtil.toFahrenheit(87))
	 	  assertEquals('32', ConversionUtil.toFahrenheit(0))
	 	}
	 	
	 	public function testToCelsius():void {
	 	  assertEquals('100', ConversionUtil.toCelsius(212))
	 	  assertEquals('20', ConversionUtil.toCelsius(68))
	 	  assertEquals('0', ConversionUtil.toCelsius(32))
	 	}
	 	
	 	public function testToK():void {
	 	  assertEquals('175.0', ConversionUtil.toK(175000))
	 	 assertEquals('13.7', ConversionUtil.toK(13700))
	 	 assertEquals('5.4', ConversionUtil.toK(5400))
	 	 assertEquals('0.4', ConversionUtil.toK(400))
	 	 assertEquals('0.0', ConversionUtil.toK(25))
	 	}
	 	
	 	public function testDayName():void {
	 	  assertEquals('Tuesday', ConversionUtil.dayName(2))
	 	  assertEquals('Tuesday', ConversionUtil.dayName(2, false))
	 	  assertEquals('Tues', ConversionUtil.dayName(2, true))
	 	}
	 	
	 	public function testMonthName():void {
	 	  assertEquals('September', ConversionUtil.monthName(8))
	 	  assertEquals('September', ConversionUtil.monthName(8, false))
	 	  assertEquals('Sep', ConversionUtil.monthName(8, true))
	 	}
	}	
}