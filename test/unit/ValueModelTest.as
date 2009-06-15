package unit {
	
	import asunit.framework.TestCase
	import flash.events.*
	import com.soren.exib.model.Model
	import com.soren.exib.model.ValueModel
	
  public class ValueModelTest extends TestCase {
	
  	private static var INITIAL:int = 5
  	private static var MIN:int     = 1
  	private static var MAX:int     = 10

    private var _instance:ValueModel
    private var _changed_by_event:uint = 0
    
    /**
    * Constructor
    * 
    * @param  testMethod Name of the method to test
    **/
    public function ValueModelTest(testMethod:String) {
      super(testMethod)
    }
    
    /**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void {
	 		_instance = new ValueModel(INITIAL, MIN, MAX)
	 	}

		/**
	 	 * Clean up after test, delete instance of class that we were testing.
	 	 */
	 	protected override function tearDown():void {
	 		_instance = null
	 	}
    
    // ---
	 	
	 	public function testValue():void {
	 	  assertEquals(INITIAL, _instance.value)
	 	  
	 	  // In range
	 	  _instance.value = 9
	 	  assertEquals(9, _instance.value)
	 	  
	 	  // Out of range
	 	  _instance.value = 0
	 	  assertEquals(9, _instance.value)
	 	  _instance.value = 11
	 	  assertEquals(9, _instance.value)
	 	}
	 	
	 	public function testSet():void {
      _instance.set(9)
      assertEquals(9, _instance.value)
	 	}
	 	
	 	public function testChange():void {
	 	  _instance.change(1)
	 	  assertEquals(6, _instance.value)
	 	}
	 	
	 	public function testReset():void {
	 	  _instance.reset()
	 	  assertEquals(5, _instance.value)
	 	}
	 	
	 	public function testEventDispatching():void {
      _instance.addEventListener(Model.CHANGED, changeListener)
      _instance.set(9)
      
      assertEquals(1, _changed_by_event)
	 	}
	 	
	 	public function testSendAccessorMethod():void {
	 	 var vm:ValueModel = new ValueModel(0, 0, 10)
	 	 
	 	 assertEquals(0, vm['min'])
	 	 vm['min'] = 5
	 	 assertEquals(5, vm['min'])
	 	}
	 	
	 	public function testToString():void {
	 	  var vm:ValueModel = new ValueModel(0, 0, 10)
	 	  assertEquals(vm.toString(), vm.value)
	 	  vm.value = 5
	 	  assertEquals(vm.toString(), vm.value)
	 	}
	 	
	 	// ---
	 	
	 	private function changeListener(event:Event):void {
	 	  _changed_by_event = 1
	 	}
	}	
}