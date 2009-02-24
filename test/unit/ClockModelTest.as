package unit {
  
  import asunit.framework.TestCase
  import flash.events.*
  import com.soren.exib.model.Model
  import com.soren.exib.model.ClockModel
  
  public class ClockModelTest extends TestCase {
    private const YEAR:uint    = 2008
    private const MONTH:uint   = 9
    private const DATE:uint    = 9
    private const HOURS:uint   = 10
    private const MINUTES:uint = 20
    private const SECONDS:uint = 30
    
    private var _instance:ClockModel
    private var _changed_by_event:uint = 0
    
    /**
    * Constructor
    * 
    * @param  testMethod Name of the method to test
    **/
    public function ClockModelTest(testMethod:String) {
      super(testMethod)
    }
    
    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _instance = new ClockModel(YEAR, MONTH, DATE, HOURS, MINUTES, SECONDS)
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _instance = null
    }
    
    // ---
        
    public function testChange():void {
      _instance.changeYear(1)
      _instance.changeMonth(1)
      _instance.changeDate(1)
      _instance.changeHours(1)
      _instance.changeMinutes(1)
      _instance.changeSeconds(1)
      
      var modified:Date = _instance.value as Date
      
      assertEquals(YEAR + 1,    modified.fullYear)
      assertEquals(MONTH + 1,   modified.month)
      assertEquals(DATE + 1,    modified.date)
      assertEquals(HOURS + 1,   modified.hours)
      assertEquals(MINUTES + 1, modified.minutes)
      assertEquals(SECONDS + 1, modified.seconds)
      
      _instance.changeYear(-1)
      _instance.changeMonth(-1)
      _instance.changeDate(-1)
      _instance.changeHours(-1)
      _instance.changeMinutes(-1)
      _instance.changeSeconds(-1)
      
      assertEquals(YEAR,    modified.fullYear)
      assertEquals(MONTH,   modified.month)
      assertEquals(DATE,    modified.date)
      assertEquals(HOURS,   modified.hours)
      assertEquals(MINUTES, modified.minutes)
      assertEquals(SECONDS, modified.seconds)
    }
    
    public function testSingleSet():void {
      var new_year:uint   = 2008
      var new_month:uint  = 6
      var new_date:uint   = 31
      var new_hours:uint   = 19
      var new_minutes:uint = 21
      var new_seconds:uint = 20
      
      _instance.setYear(new_year)
      _instance.setMonth(new_month)
      _instance.setDate(new_date)
      _instance.setHours(new_hours)
      _instance.setMinutes(new_minutes)
      _instance.setSeconds(new_seconds)
      
      var modified:Date = _instance.value as Date
      
      assertEquals(new_year,    modified.fullYear)
      assertEquals(new_month,   modified.month)
      assertEquals(new_date,    modified.date)
      assertEquals(new_hours,   modified.hours)
      assertEquals(new_minutes, modified.minutes)
      assertEquals(new_seconds, modified.seconds)
    }
    
    public function testReset():void {
      var original:Date = _instance.value as Date
      _instance.setYear(1997)
      _instance.reset()
      
      assertEquals(original.fullYear, (_instance.value as Date).fullYear)
    }
    
    public function testSet():void {
      var new_year:uint    = 2008
      var new_month:uint   = 6
      var new_date:uint    = 31
      var new_hours:uint   = 19
      var new_minutes:uint = 21
      var new_seconds:uint = 20
      
      _instance.set(new_year, new_month, new_date,
                    new_hours, new_minutes, new_seconds)
      
      var modified:Date = _instance.value as Date
      
      assertEquals(new_year,    modified.fullYear)
      assertEquals(new_month,   modified.month)
      assertEquals(new_date,    modified.date)
      assertEquals(new_hours,   modified.hours)
      assertEquals(new_minutes, modified.minutes)
      assertEquals(new_seconds, modified.seconds)
    }
    
    public function testDispatch():void {
      _instance.addEventListener(Model.CHANGED, changeListener)
      _instance.setYear(2001)
      
      assertEquals(1, _changed_by_event)
    }
    
    // ---
    
    private function changeListener(event:Event):void {
	 	  _changed_by_event = 1
	 	}
  }  
}