package {
	
	import flash.utils.describeType
	import asunit.framework.TestSuite
	import unit.*
	import generator.*
	import com.soren.exib.service.Sound
	import com.soren.exib.view.GraphicNode
	import com.soren.exib.view.VideoNode
	import com.soren.exib.debug.Log
	
  public class AllTests extends TestSuite {
    
    // BEGIN EMBED (Embedded files for testing)
    [Embed(source='assets/graphics/dial.png')]
    public var dial:Class
    
    [Embed(source='assets/graphics/down.png')]
    public var down:Class
    
    [Embed(source='assets/graphics/fill.png')]
    public var fill:Class
    
    [Embed(source='assets/graphics/up.png')]
    public var up:Class
    
    [Embed(source='assets/graphics/sample_asset.png')]
    public var sample_asset:Class
    
    [Embed(source='assets/sounds/tone.mp3', mimeType='audio/mpeg')]
    public var tone:Class
    
    [Embed(source='assets/videos/test_video.swf')]
    public var test_video:Class
    // END EMBED
    
    public function AllTests () {
      for each (var klass:Class in [Sound, GraphicNode, VideoNode]) {
        klass['setEmbedContainer'](this)
      }
      
      Log.getLog().level = Log.DEBUG
      Log.getLog().throwOnError = true
      Log.getLog().clear()
      
      super()
      
      var helper_tests:Array    = [ConditionalTest, ConditionalSetTest, ActionTest, ActionSetTest, FormulaTest]
      var manager_tests:Array   = [ManagerTest]
      var model_tests:Array     = [ValueModelTest, StateModelTest, HistoryModelTest, ClockModelTest, PresetModelTest]
      var service_tests:Array   = [CronTest, DaemonTest, TaskTest, HotkeyTest, SoundTest]
      var util_tests:Array      = [AdvancedMathTest, DateUtilTest, ExtendedArrayTest, KeyUtilTest, PadTest, ConversionUtilTest, StringUtilTest]
      var view_tests:Array      = [NodeTest, GraphicNodeTest, ButtonNodeTest, DialNodeTest, MeterNodeTest, MultiNodeTest, ProgressNodeTest, TextNodeTest, VectorNodeTest, VideoNodeTest, ScreenNodeTest, ScreenControllerTest]
      var generator_tests:Array = [ModelGenerationTest, ServiceGeneratorTest, MediaGeneratorTest, HelperGeneratorTest]
      
      var all_tests:Array = [helper_tests, manager_tests, model_tests, service_tests, util_tests, view_tests, generator_tests]
      
      for each (var test_array:Array in all_tests) {
        iterateTestArray(test_array)
      }
    }
    
	  // ---
	  
	  private function iterateTestArray(array:Array):void {
      for each (var test_class:Class in array) {
        runTests(test_class)
      }	    
	  }
	  
	  private function runTests(test_class:Class):void {
      var description:XML = describeType(test_class)
      var pattern:RegExp  = /test.*/
      
      for each (var method:XML in description..method) {
        if (pattern.test(method.@name)) {
          addTest(new test_class(method.@name))
        }
      }
	  }
	}
}