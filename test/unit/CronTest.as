package unit {

  import asunit.framework.TestCase
  import com.soren.exib.helper.*
  import com.soren.exib.model.*
  import com.soren.exib.service.Cron
  
  public class CronTest extends TestCase {

    private var _instance:Cron
    private var _model_a:ValueModel
    private var _model_b:ValueModel
    private var _model_c:ValueModel
    
    private var _delay:uint  = 100
    private var _repeat:uint = 0
    
    public function CronTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _model_a = new ValueModel(0, 0, 5)
      _model_b = new ValueModel(5, 0, 10)
      _model_c = new ValueModel(7, 0, 10)
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _model_a = _model_b = _model_c = null
    }

    // ---
    
    public function testCreateCron():void {      
      var act_a:Action = new Action(_model_a, 'change', 1)
      var act_b:Action = new Action(_model_b, 'change', 1)
      var act_c:Action = new Action(_model_c, 'change', 1)
      
      var event_set:ActionSet    = new ActionSet(act_a, act_b)
      var complete_set:ActionSet = new ActionSet(act_c)
      
      var cron:Cron
      var error:Error
      try {
        cron = new Cron(_delay, _repeat, event_set)
        cron = new Cron(_delay, _repeat, event_set, null, new ConditionalSet())
        cron = new Cron(_delay, _repeat, event_set, complete_set, new ConditionalSet())
      } catch (e:Error) {
        error = e
      }
      
      assertNull(error)
    }
    
    // Because of the delayed nature of the Cron class it isn't possible to do a
    // straight forward test, we're forcing it by using the complete method.
    public function testForceComplete():void {      
      var act_a:Action = new Action(_model_a, 'change', 1)
      var act_b:Action = new Action(_model_a, 'set',    0)
      
      var event_set:ActionSet    = new ActionSet(act_a)
      var complete_set:ActionSet = new ActionSet(act_b)
      
      var cron:Cron = new Cron(_delay, _repeat, event_set, complete_set)
      
      act_a.act()
      assertEquals(1, _model_a.value)
      
      cron.complete()
      assertEquals(0, _model_a.value)
    }
    
    public function testMultipleActions():void {
      var act_a:Action = new Action(_model_a, 'set', 1)
      var act_b:Action = new Action(_model_a, 'set', 2)
      var act_c:Action = new Action(_model_b, 'set', 2)
      
      var event_set:ActionSet = new ActionSet(act_a)
      var complete_set:ActionSet = new ActionSet(act_b, act_c)
      
      var cron:Cron = new Cron(_delay, _repeat, event_set, complete_set)
      
      var initial_a_value:* = _model_a.value
      var initial_b_value:* = _model_b.value
      
      cron.complete()
      assertFalse(initial_a_value == _model_a.value)
      assertFalse(initial_b_value == _model_b.value)
    }
    
    public function testConditionals():void {
      var act_a:Action = new Action(_model_a, 'set', 0)
      var complete_set:ActionSet = new ActionSet(act_a)
      
      var cond:Conditional = new Conditional(_model_a, '==', 1)
      var cond_set:ConditionalSet = new ConditionalSet(cond, 0)
      
      var cron:Cron = new Cron(_delay, _repeat, null, complete_set, cond_set)
      
      // The cron must be started to register the conditional listeners
      cron.start()
      
      // Setting model_a to 1 should trigger the conditional set
      _model_a.set(1)
      assertEquals(0, _model_a.value)
    }
  }
}