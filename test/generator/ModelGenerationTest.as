package generator {

  import asunit.framework.TestCase
  import com.soren.exib.core.Generator
  import com.soren.exib.manager.Manager
  import com.soren.exib.model.*
  
  public class ModelGenerationTest extends TestCase {
    
    private var _generator:Generator
    private var _manager:Manager = Manager.getManager()
    private var _xml:XML
    
    public function ModelGenerationTest(testMethod:String) {
      super(testMethod)
    }
    
    protected override function setUp():void {
      _generator = new Generator()
    }
    
    protected override function tearDown():void {
      _manager.reset()
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
               <model id='value_model' value='1' />
             </preset>
      
      _manager.add(new ValueModel(0, 0, 1), 'value_model')
      var preset:PresetModel = _generator.genPresetModel(_xml)
      
      assertEquals('--', preset.value.toString())
      preset.save()
      assertEquals('0', preset.value.toString())
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