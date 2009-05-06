package unit {

  import asunit.framework.TestCase
  import com.soren.util.TimeUtil

  public class TimeUtilTest extends TestCase {

    private var _instance:Object

    public function TimeUtilTest(testMethod:String) {
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
   	  assertEquals(0, TimeUtil.modHours(0))
   	  assertEquals(1, TimeUtil.modHours(3600))
   	  assertEquals(1, TimeUtil.modHours(5305))
   	  assertEquals(2, TimeUtil.modHours(7201))
   	}
 	
   	public function testModMinutes():void {
   	  assertEquals(0, TimeUtil.modMinutes(0))
   	  assertEquals(1, TimeUtil.modMinutes(60))
   	  assertEquals(0, TimeUtil.modMinutes(3600))
   	  assertEquals(28, TimeUtil.modMinutes(5305))
   	}
 	
   	public function testModSeconds():void {
   	  assertEquals(0, TimeUtil.modSeconds(0))
   	  assertEquals(0, TimeUtil.modSeconds(60))
   	  assertEquals(0, TimeUtil.modSeconds(3600))
   	  assertEquals(25, TimeUtil.modSeconds(5305))
   	}
   	
   	public function testDayName():void {
	 	  assertEquals('Tuesday', TimeUtil.dayName(2))
	 	  assertEquals('Tuesday', TimeUtil.dayName(2, false))
	 	  assertEquals('Tues',    TimeUtil.dayName(2, true))
	 	}
	 	
	 	public function testMonthName():void {
	 	  assertEquals('September', TimeUtil.monthName(8))
	 	  assertEquals('September', TimeUtil.monthName(8, false))
	 	  assertEquals('Sep',       TimeUtil.monthName(8, true))
	 	}
  }
}