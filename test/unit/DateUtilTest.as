package unit {

  import asunit.framework.TestCase
  import com.soren.util.DateUtil

  public class DateUtilTest extends TestCase {

    private var _instance:Object

    public function DateUtilTest(testMethod:String) {
      super(testMethod);
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
    
   	public function testModHours():void {
   	  assertEquals(0, DateUtil.modHours(0))
   	  assertEquals(1, DateUtil.modHours(3600))
   	  assertEquals(1, DateUtil.modHours(5305))
   	  assertEquals(2, DateUtil.modHours(7201))
   	}
 	
   	public function testModMinutes():void {
   	  assertEquals(0, DateUtil.modMinutes(0))
   	  assertEquals(1, DateUtil.modMinutes(60))
   	  assertEquals(0, DateUtil.modMinutes(3600))
   	  assertEquals(28, DateUtil.modMinutes(5305))
   	}
 	
   	public function testModSeconds():void {
   	  assertEquals(0, DateUtil.modSeconds(0))
   	  assertEquals(0, DateUtil.modSeconds(60))
   	  assertEquals(0, DateUtil.modSeconds(3600))
   	  assertEquals(25, DateUtil.modSeconds(5305))
   	}
   	
   	public function testDayName():void {
	 	  assertEquals('Tuesday', DateUtil.dayName(2))
	 	  assertEquals('Tuesday', DateUtil.dayName(2, false))
	 	  assertEquals('Tues',    DateUtil.dayName(2, true))
	 	}
	 	
	 	public function testMonthName():void {
	 	  assertEquals('September', DateUtil.monthName(8))
	 	  assertEquals('September', DateUtil.monthName(8, false))
	 	  assertEquals('Sep',       DateUtil.monthName(8, true))
	 	}
  }
}