package unit {
  
  import asunit.framework.TestCase
  import com.soren.exib.model.PresetModel
  import com.soren.exib.model.StateModel
  import com.soren.exib.model.ValueModel
  import com.soren.util.StringUtil
  
  public class PresetModelTest extends TestCase {
  
    public static const OUNCES:String   = 'ounces'
    public static const CUPS:String     = 'cups'
    public static const BASE_VALUE:uint = 8
    public static const MIN_VALUE:uint  = 0
    public static const MAX_VALUE:uint  = 16

    private var _instance:PresetModel
    private var _watched_state:StateModel
    private var _watched_value:ValueModel
    
    /**
    * Constructor
    * 
    * @param  testMethod Name of the method to test
    **/
    public function PresetModelTest(testMethod:String) {
      super(testMethod)
    }
    
    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _watched_state = new StateModel([OUNCES, CUPS])
      _watched_value = new ValueModel(BASE_VALUE, MIN_VALUE, MAX_VALUE)
      _instance      = new PresetModel()
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _instance      = null
      _watched_value = null
      _watched_state = null
    }
    
    // ---
    
    public function testWatch():void {
      var error:Error
      try {
        _instance.watch(_watched_value)
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
    }
    
    public function testWatchWithNumericalDefault():void {
      var default_value:uint = 10
      _instance.watch(_watched_value, default_value)
      
      assertEquals(10, _instance.value[0])
    }
    
    public function testWatchWithStringDefault():void {
      var default_value:String = 'cups'
      _instance.watch(_watched_state, default_value)
      
      assertEquals('cups', _instance.value[0])
      
      _instance.load()
      
      assertEquals('cups', _watched_state.value)
    }
    
    public function testWatchWithTwoDefaults():void {
      var def_int:uint = 10
      var def_str:String = 'cups'
      
      _instance.watch(_watched_value, def_int)
      _instance.watch(_watched_state, def_str)
      
      assertEquals(def_int, _instance.value[0])
      assertEquals(def_str, _instance.value[1])
      
      _instance.load()
      
      assertEquals(def_int, _watched_value.value)
      assertEquals(def_str, _watched_state.value)
    }
    
    public function testWatchAndSaveOverDefault():void {
      var default_value:uint = 10
      
      _instance.watch(_watched_value, default_value)
      _instance.save()
      
      assertEquals(BASE_VALUE, _instance.value[0])
    }
    
    public function testSavePreset():void {
      _instance.watch(_watched_value)
      _instance.watch(_watched_state)
      
      // The default text is an empty string, ' '
      assertEquals(' ', _instance.value[0])
      assertEquals(' ', _instance.value[1])
      
      _instance.save()
            
      assertEquals(BASE_VALUE, _instance.value[0])
      assertEquals(OUNCES, _instance.value[1])
    }
    
    public function testLoadPreset():void {
      _instance.watch(_watched_state)
      _instance.save()
      
      _watched_state.value = CUPS
      
      _instance.load()
      
      assertEquals(OUNCES, _instance.value[0])
    }
    
    public function testFormatInterraction():void {
      _instance.watch(_watched_value)
      _instance.watch(_watched_state)
      
      _instance.save()
      
      assertEquals('Preset: 8 ounces', StringUtil.format('Preset: %d %s', _instance.value[0], _instance.value[1]))
    }
  }  
}