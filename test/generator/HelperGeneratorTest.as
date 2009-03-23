package generator {

  import asunit.framework.TestCase
  import flash.display.Sprite
  import com.soren.exib.core.*
  import com.soren.exib.helper.*
  import com.soren.exib.manager.*
  import com.soren.exib.model.StateModel

  public class HelperGeneratorTest extends TestCase {

    private var _supervisor:Supervisor
    private var _generator:Generator
    private var _xml:XML

    public function HelperGeneratorTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _supervisor = new Supervisor(['actionable'])
      _generator  = new Generator(_supervisor)
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _supervisor = null
      _generator  = null
    }

    // ---
    
    public function testGenConditionalSet():void {
      var _power:StateModel   = new StateModel('on', 'off')
      var _car:StateModel     = new StateModel('slow', 'fast')
      var _men:StateModel     = new StateModel('darlings', 'pigs')
      var _fairies:StateModel = new StateModel('real', 'imaginary')
      
      _supervisor.add('actionable', _power,   '_power')
      _supervisor.add('actionable', _car,     '_car')
      _supervisor.add('actionable', _men,     '_men')
      _supervisor.add('actionable', _fairies, '_fairies')
      
      var true_cons:Array =  ['_power == on && _car == slow',
                              '(_power == on) && (_car == slow)',
                              '(_power == on && _car == slow) && (_men == darlings || _power != off)',
                              '(_power == on && _car == slow) || (_power == off && _car == fast)'
                             ]
                             
      var false_cons:Array = ['_power == off && (_car == slow || _men == pigs)',
                              '_fairies == imaginary || (_power == on && _car == slow) || (_power == off && _men == pigs)'
                             ]
                      
      for each (var true_con:String in true_cons) {
        assertTrue(_generator.genConditionalSet(true_con).evaluate())
      }
      
      for each (var false_con:String in false_cons) {
        assertFalse(_generator.genConditionalSet(false_con).evaluate())
      }
    }
  }
}