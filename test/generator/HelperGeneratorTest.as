package generator {

  import asunit.framework.TestCase
  import flash.display.Sprite
  import com.soren.exib.generator.*
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
      
      var string_a:String = "_power == on && _car == slow"
      var string_b:String = "_power == off && (_car == slow || _men == pigs)"
      var string_c:String = "(_power == on && _car == slow) || (_power == off && _car == fast)"
      var string_d:String = "_fairies == real || (_power == off && _car == slow) || (_power == on && _men == pigs)"
      
      assertTrue(_generator.genConditionalSet(string_a).evaluate())
      //assertFalse(_generator.genConditionalSet(string_b).evaluate())
      //assertTrue(_generator.genConditionalSet(string_c).evaluate())
      //assertFalse(_generator.genConditionalSet(string_d).evaluate())
    }
  }
}