package unit {

  import asunit.framework.TestCase
  import com.soren.exib.manager.*
  
  public class SupervisorTest extends TestCase {
    
    private var _instance:Supervisor
    private var manager_list:Array = ['format', 'graphic', 'model', 'periodic',
                                      'screen', 'sound', 'video']
    
    public function SupervisorTest(testMethod:String) {
      super(testMethod);
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _instance = new Supervisor(manager_list)
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _instance = null
    }
    
    // ---
    
    public function testPutAndGet():void {
      var test_object:Object = { id: 'unique'}
      _instance.add('model', test_object, 'test_object')
      
      var retrieved:Object = _instance.get('model', 'test_object')
      assertNotNull(retrieved)
      assertEquals(test_object.id, retrieved.id)
    }
    
    public function testHas():void {
      assertFalse(_instance.has('format', 'unique'))
      _instance.add('format', new Object(), 'unique')
      assertTrue(_instance.has('format', 'unique'))
    }
    
    public function testPopAndRemove():void {
      var first:Object  = { id: 'ein' }
      var second:Object = { id: 'zwei' }
      
      _instance.add('model', first, 'ein')
      _instance.add('model', second, 'zwei')
      
      _instance.remove('model', 'ein')
      assertFalse(_instance.has('model', 'ein'))
      
      var retrieved:Object = _instance.pop('model', 'zwei')
      assertEquals(second.id, retrieved.id)
      assertFalse(_instance.has('model', 'zwei'))
    }
    
    public function testGlobAndGrep():void {    
      _instance.add('format',   new Object(), 'btn_01')
      _instance.add('format',   new Object(), 'btn02')
      _instance.add('graphic',  new Object(), 'btn_03')
      _instance.add('model',    new Object(), 'new_1_menu')
      _instance.add('periodic', new Object(), 'new_alpha_menu')
      
      assertEquals(2, _instance.glob('format', 'btn*').length)
      assertEquals(3, _instance.glob('all', 'btn*').length)
      assertEquals(5, _instance.glob('all', '*').length)
      assertEquals(1, _instance.glob('model', 'new_?_menu').length)
      assertEquals(2, _instance.glob('all', 'new_*_menu').length)
      
      assertEquals(2, _instance.grep('format', 'btn.*').length)
      assertEquals(2, _instance.grep('all', 'b.{2}_.*').length)
      assertEquals(5, _instance.grep('all', '.*').length)
      assertEquals(2, _instance.grep('all', 'new_.*_menu').length)
    }
  }
}