package unit {

  import asunit.framework.TestCase
  import com.soren.exib.core.Generator
  import com.soren.exib.core.Space
  import com.soren.exib.model.*
  
  public class ModelGenerationTest extends TestCase {
    
    private var _generator:Generator
    private var _space:Space = Space.getSpace()
    private var _xml:XML
    
    public function ModelGenerationTest(testMethod:String) {
      super(testMethod)
    }
    
    protected override function setUp():void {
      _generator = new Generator()
    }
    
    protected override function tearDown():void {
      _space.reset()
      _generator = null
    }
    
    // ---
    
    public function testClockGenerator():void {
      _xml = <clock id='clock' start='2009, 1, 14, 14, 49, 37' />
      var clock_model:ClockModel = _generator.genClockModel(_xml)
      
      var modified:Date = clock_model.value as Date
      
      assertEquals(2009, modified.fullYear)
      assertEquals(1,    modified.month)
      assertEquals(14,   modified.date)
      assertEquals(14,   modified.hours)
      assertEquals(49,   modified.minutes)
      assertEquals(37,   modified.seconds)
    }
    
    public function testHistoryGenerator():void {
      _xml = <history id='history' length='4' states='value-a, value-b' />
      var history:HistoryModel = _generator.genHistoryModel(_xml)
      
      assertEquals('value-a', history.current)
      history.set('value-b')
      assertEquals('value-b', history.current)
      assertEquals('value-a', history.previous)
      
    }
    
    public function testPresetGenerator():void {
      _xml = <preset id='preset' default_text='--'>
               <model id='value_model' def='1' />
               <model id='state_model' def='ounce' />
             </preset>
      
      var val:ValueModel = new ValueModel(0, 0, 1)
      var sta:StateModel = new StateModel('cup','ounce')
      
      _space.add(val, 'value_model')
      _space.add(sta, 'state_model')
      
      var preset:PresetModel = _generator.genPresetModel(_xml)
      
      assertEquals(1, preset.value[0])
      assertEquals('ounce', preset.value[1])
      
      preset.load()
      
      assertEquals(1, val.value)
      assertEquals('ounce', sta.value)
    }
    
    public function testStateGenerator():void {
      _xml = <state id='state' def='value-b' states='value-a, value-b' />
      var state_model:StateModel = _generator.genStateModel(_xml)
      
      assertEquals('value-b', state_model.value)
    }
    
    public function testValueGenerator():void {
      _xml = <value id='value' def='1' range='0..10' />
      var value_model:ValueModel = _generator.genValueModel(_xml)
      
      assertEquals(1,  value_model.value)
      assertEquals(0,  value_model.min)
      assertEquals(10, value_model.max)
    }
  }
}