package unit {

  import asunit.framework.TestCase
  import com.soren.exib.manager.*
  
  public class ManagerTest extends TestCase {
    
    private var _instance:Manager = Manager.getManager()

    public function ManagerTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _instance.reset()
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void { }

    // ---
    
    public function testPut():void {
      var error:Error
      try {
        _instance.add(new Object(), 'generic')
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
    }
    
    public function testPutDuplicate():void {
      var unique_id:String = 'test_id'
      _instance.add(new Object(), unique_id)
      
      var error:Error
      try {
        _instance.add(new Object(), unique_id)
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
    }
    
    public function testGet():void {
      _instance.add({ id: 'unique' }, 'generic')
      assertNotNull(_instance.get('generic'))
      assertEquals('unique', _instance.get('generic')['id'])
    }
    
    public function testGetMissing():void {
      var error:Error
      try {
        _instance.get('missing')
      } catch (e:Error) {
        error = e
      }

      assertNotNull(error)
    }
    
    public function testHas():void {
      var unique_id:String = 'test_id'
      _instance.add(new Object(), unique_id)
      assertTrue(_instance.has(unique_id))
    }
    
    public function testGlob():void {
      var first_obj:Object  = new Object()
      var second_obj:Object = new Object()

      _instance.add(first_obj, 'first_obj')
      _instance.add(second_obj, 'second_obj')

      // Test proper * match
      var obj_set:Array = _instance.glob('*_obj')
      assertEquals(2, obj_set.length)

      // Test improper * match
      obj_set = []
      obj_set = _instance.glob('no_*_obj')
      assertEquals(0, obj_set.length)

      var third_obj:Object  = new Object()
      var fourth_obj:Object = new Object()

      _instance.add(third_obj, 'cat_obj')
      _instance.add(fourth_obj, 'cut_obj')

      // Test proper ? match
      obj_set = []
      obj_set = _instance.glob('c?t_obj')
      assertEquals(2, obj_set.length)

      // Test ? unmatched
      obj_set = []
      obj_set = _instance.glob('z?t_obj')
      assertEquals(0, obj_set.length)

      // Test global match
      obj_set = []
      obj_set = _instance.glob('*')
      assertEquals(4, obj_set.length)
    }
    
    public function testGrep():void {    
      _instance.add(new Object(), 'btn_01')
      _instance.add(new Object(), 'btn02')
      _instance.add(new Object(), 'btn_03')
      _instance.add(new Object(), 'new_1_menu')
      _instance.add(new Object(), 'new_alpha_menu')
      
      assertEquals(3, _instance.grep('btn.*').length)
      assertEquals(2, _instance.grep('b.{2}_.*').length)
      assertEquals(5, _instance.grep('.*').length)
      assertEquals(2, _instance.grep('new_.*_menu').length)
    }

    public function testRemove():void {
      _instance.add(new Object(), 'unique_id')
      _instance.remove('unique_id')
      assertFalse(_instance.has('unique_id'))
    }
  }
}