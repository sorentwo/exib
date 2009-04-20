package unit {

  import asunit.framework.TestCase
  import com.soren.exib.helper.*
  import com.soren.exib.model.ValueModel
  import com.soren.exib.service.Task
  
  public class TaskTest extends TestCase {

    public function TaskTest(testMethod:String) {
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

    public function testTaskSetup():void {
      var act:Action = new Action(new ValueModel(0, 0, 10), 'change', 1)
      
      var act_set:ActionSet = new ActionSet(act)
      
      var task:Task
      var error:Error
      try {
        task = new Task(act_set)
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
    }
    
    public function testTaskCall():void {
      var model:ValueModel = new ValueModel(0,0,10)
      var act:Action = new Action(model, 'change', 5)
      var act_set:ActionSet = new ActionSet(act)
      
      var task:Task = new Task(act_set)
      task.call()
      
      assertEquals(model.value, 5)
    }
  }
}