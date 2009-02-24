package unit {

  import asunit.framework.TestCase
  import com.soren.exib.model.HistoryModel
  
  public class HistoryModelTest extends TestCase {

    public function HistoryModelTest(testMethod:String) {
      super(testMethod)
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
    
    // ---
    
    public function testHistory():void {
      var h_mod:HistoryModel = new HistoryModel(5, 'home', 'menu', 'settings')
      
      h_mod.set('menu')
      assertEquals('menu', h_mod.current)
      assertEquals('home', h_mod.previous)
      
      h_mod.set('settings')
      h_mod.rollback()
      assertEquals('home', h_mod.previous)
      
      h_mod.purge()
      assertEquals('settings', h_mod.current)
      assertEquals('settings', h_mod.previous)
    }
  }
}