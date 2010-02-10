package unit {

  import asunit.framework.TestCase
  import flash.events.*
  import com.soren.exib.model.Model
  import com.soren.exib.model.StateModel

  public class StateModelTest extends TestCase {

    private static var TEST_STATE_A:String = 'on'
    private static var TEST_STATE_B:String = 'off'
    private static var TEST_STATE_C:String = 'auto'

    private var _instance:StateModel
    private var _changed_by_event:uint = 0

    /**
    * Constructor
    *
    * @param  testMethod Name of the method to test
    **/
    public function StateModelTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _instance = new StateModel(TEST_STATE_A, TEST_STATE_B)
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _instance = null
    }

    // ---

    public function testInitialState():void {
      // Test that the first state added will now be returned as the state and value
      assertEquals(TEST_STATE_A, _instance.value)
    }

    public function testSet():void {
      // Test a simple change to a state we know is registered
      _instance.set(TEST_STATE_B)
      assertEquals(TEST_STATE_B, _instance.value)
      
      var error:Error
      try {
        _instance.set('INVALID')
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
    }
    
    public function testAdd():void {
      _instance.add(TEST_STATE_C)
      _instance.set(TEST_STATE_C)
      assertEquals(TEST_STATE_C, _instance.value)
      
      var error:Error
      try {
        _instance.add(TEST_STATE_C)
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
    }

    public function testCycling():void {
      var initial_state:String = _instance.value
      
      _instance.next()
      assertFalse(initial_state == _instance.value)
      
      _instance.previous()
      assertEquals(initial_state, _instance.value)
      
      // Test wrapping
      _instance.previous()
      assertEquals(TEST_STATE_B, _instance.value)
      
      _instance.wraps = false
      _instance.next()
      assertEquals(TEST_STATE_B, _instance.value)
    }

    public function testRemove():void {
      _instance.remove(TEST_STATE_B)
      
      var error:Error
      try {
        _instance.set(TEST_STATE_B)
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
    }
    
    public function testReset():void {
      // Test that reset will set us back to the first state registered
      _instance.set(TEST_STATE_B)
      _instance.reset()
      assertEquals(TEST_STATE_A, _instance.value)
    }

    public function testTotal():void {
      assertEquals(2, _instance.total)
    }
    
    public function testDispatch():void {
      _instance.addEventListener(Model.CHANGED, changeListener)
      _instance.set(TEST_STATE_A)
      
      assertEquals(1, _changed_by_event)
    }
    
    public function testToggle():void {
      _instance.add(TEST_STATE_C)
      _instance.toggle('off', 'auto')
      assertEquals('off', _instance.value)
      
      _instance.toggle('off', 'auto')
      assertEquals('auto', _instance.value)
      
      _instance.toggle('off', 'auto')
      assertEquals('off', _instance.value)
    }
    
    // ---
    
	 	private function changeListener(event:Event):void {
	 	  _changed_by_event = 1
	 	}
  }
}