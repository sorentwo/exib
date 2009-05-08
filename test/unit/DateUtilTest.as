package unit {

  import asunit.framework.TestCase
  import com.soren.util.DateUtil

  public class DateUtilTest extends TestCase {

    private var _instance:Object

    public function DateUtilTest(testMethod:String) {
      super(testMethod)
    }
    
    //---
   	
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