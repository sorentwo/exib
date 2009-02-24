package generator {

  import asunit.framework.TestCase
  import flash.display.Sprite
  import com.soren.exib.generator.*
  import com.soren.exib.manager.*
  import com.soren.exib.model.ValueModel
  import com.soren.exib.service.*

  public class ServiceGeneratorTest extends TestCase {

    private var _supervisor:Supervisor
    private var _generator:Generator
    private var _xml:XML

    public function ServiceGeneratorTest(testMethod:String) {
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
    
    public function testCronGenerator():void {
      _xml = <cron id="cron" delay="1000" repeat="0">
               <event_action>value_a.change(1)</event_action>
               <complete_action>value_a.set(0)</complete_action>
               <complete_when>value_a == 2</complete_when>
             </cron>
      
      _supervisor.add('actionable', new ValueModel(0, 0, 2), 'value_a')
      
      var cron:Cron = _generator.genCron(_xml)
    }
    
    public function testDaemonGenerator():void {
      _xml = <daemon id="daemon" delay="1000">
               <event_action>value_a.change(1)</event_action>
               <complete_action>value_a.set(0)</complete_action>
               <complete_when>value_a == 2</complete_when>
             </daemon>
      
      _supervisor.add('actionable', new ValueModel(0, 0, 2), 'value_a')
      
      var daemon:Daemon = _generator.genDaemon(_xml)
    }
    
    public function testHotkeyGenerator():void {
      _xml = <hotkey key="s" toggle="true">
               <action>value_a.set(2)</action>
             </hotkey>
      
      _supervisor.add('actionable', new ValueModel(0, 0, 2), 'value_a')
      
      var sprite:Sprite = new Sprite()
      var hotkey:Hotkey = _generator.genHotkey(_xml, sprite)
    }
  }
}