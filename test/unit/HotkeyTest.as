package unit {

  import asunit.framework.TestCase
  import flash.display.Sprite
  import flash.events.KeyboardEvent
  import com.soren.exib.helper.*
  import com.soren.exib.model.*
  import com.soren.exib.service.Hotkey
  import com.soren.util.KeyUtil

  public class HotkeyTest extends TestCase {

    private var _stage:Sprite
    
    public function HotkeyTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _stage = new Sprite()
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _stage = null
    }
    
    // ---
    
    public function testHotkey():void {
      var model:ValueModel = new ValueModel(0, 0, 2)
      var action:Action = new Action(model, 'change', 1)
      var action_set:ActionSet = new ActionSet(action)
      
      var single_hotkey:Hotkey = new Hotkey('a', action_set, _stage)
      var key_code:uint = KeyUtil.getKeyCode('a')
      
      _stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, key_code, key_code))
      assertEquals(1, model.value)
      
      var alt_key_code:uint = KeyUtil.getKeyCode('s')
      _stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, alt_key_code, alt_key_code))
      assertEquals(1, model.value)
    }
    
    public function testHotkeyWithToggle():void {
      var model:StateModel = new StateModel('true', 'false')
      var action:Action = new Action(model, 'next')
      var action_set:ActionSet = new ActionSet(action)
      
      var toggle:Boolean = true
      var single_hotkey:Hotkey = new Hotkey('a', action_set, _stage, toggle)
      var key_code:uint = KeyUtil.getKeyCode('a')
      
      _stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, key_code, key_code))
      _stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, key_code, key_code))
      assertEquals('true', model.value)
    }
  }
}