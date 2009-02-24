package unit {

  import asunit.framework.TestCase
  import com.soren.exib.helper.*
  import com.soren.exib.model.*
  import com.soren.exib.service.Daemon
  
  public class DaemonTest extends TestCase {

    public function DaemonTest(testMethod:String) {
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
    
    // Not much that can be tested for something periodic and unactionable. Because
    // Daemon extends the Cron class most of the functionality is proven, this test
    // is a syntax validator essentially.
    public function testCreateDaemon():void {
      var model:ValueModel = new ValueModel(0, 0, 1)
      var action:Action = new Action(model, 'set', 1)
      
      var event_set:ActionSet    = new ActionSet(action)
      var complete_set:ActionSet = new ActionSet(action)
      
      var error:Error
      try {
        var daemon:Daemon = new Daemon(1000, event_set, complete_set)
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
    }
  }
}