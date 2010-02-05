package generator {

  import asunit.framework.TestCase
  import flash.display.Sprite
  import com.soren.exib.core.*
  import com.soren.exib.debug.Log
  import com.soren.exib.helper.*
  import com.soren.exib.model.*

  public class HelperGeneratorTest extends TestCase {

    private var _space:Space = Space.getSpace()
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
      _generator  = new Generator()
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _space.reset()
      _generator  = null
    }

    // ---
    
    public function testGenConditionalSet():void {
      var _power:StateModel   = new StateModel('on', 'off')
      var _car:StateModel     = new StateModel('slow', 'fast')
      var _men:StateModel     = new StateModel('darlings', 'pigs')
      var _fairies:StateModel = new StateModel('real', 'imaginary')
      var _startup:StateModel = new StateModel('true', 'false')
      
      _space.add(_power,   '_power')
      _space.add(_car,     '_car')
      _space.add(_men,     '_men')
      _space.add(_fairies, '_fairies')
      _space.add(_startup, '_startup')
      
      var true_cons:Array =  [' _startup == true',
                              '_power == on and _car == slow',
                              '(_power == on) and (_car == slow)',
                              '(_power == on and _car == slow) and (_men == darlings or _power != off)',
                              '(_power == on and _car == slow) or (_power == off and _car == fast)'
                             ]
                             
      var false_cons:Array = ['_power == off and (_car == slow or _men == pigs)',
                              '_fairies == imaginary or (_power == on and _car == slow) or (_power == off and _men == pigs)'
                             ]
                      
      for each (var true_con:String in true_cons) {
        assertTrue(_generator.genConditionalSet(true_con).evaluate())
      }
      
      for each (var false_con:String in false_cons) {
        assertFalse(_generator.genConditionalSet(false_con).evaluate())
      }
    }
    
    public function testGenEvaluator():void {
      var _vm_a:ValueModel = new ValueModel(0,0,1)
      var _vm_b:ValueModel = new ValueModel(1,0,1)
      var _pre:PresetModel = new PresetModel()
      
      _pre.watch(_vm_a)
      _pre.watch(_vm_b)
      _pre.save()
      
      _space.add(_vm_a, '_vm_a')
      _space.add(_vm_b, '_vm_b')
      _space.add(_pre,  '_pre')
      
      var true_cons:Array = ['_vm_a.value == 0',
                             '_vm_a.max == 1',
                             '_vm_a.min == _vm_b.min',
                             '_pre.value[0] == 0',
                             '_pre.value[1] == _vm_b']

      for each (var true_con:String in true_cons) {
        assertTrue(_generator.genConditionalSet(true_con).evaluate())
      }
    }
  }
}