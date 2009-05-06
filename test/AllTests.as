package {
	
	import flash.utils.describeType
	import asunit.framework.TestSuite
	import unit.*
	import generator.*
	import com.soren.exib.debug.Log
	
  public class AllTests extends TestSuite {
    
    public function AllTests () {
      Log.getLog().level = Log.DEBUG
      Log.getLog().throwOnError = true
      Log.getLog().clear()
      
      super()
      
      var helper_tests:Array    = [ConditionalTest, ConditionalSetTest, ActionTest, ActionSetTest, FormulaTest]
      var manager_tests:Array   = [ManagerTest]
      var model_tests:Array     = [ValueModelTest, StateModelTest, HistoryModelTest, ClockModelTest, PresetModelTest]
      var service_tests:Array   = [CronTest, DaemonTest, TaskTest, HotkeyTest] //, SoundTest
      var util_tests:Array      = [AdvancedMathTest, TimeUtilTest, ExtendedArrayTest, ConversionUtilTest, KeyUtilTest, PadTest, StringUtilTest]
      //var view_tests:Array      = [NodeTest, GraphicNodeTest, ButtonNodeTest, DialNodeTest, MeterNodeTest, MultiNodeTest, ProgressNodeTest, TextNodeTest, VectorNodeTest, VideoNodeTest, ScreenNodeTest, ScreenControllerTest]

      for each (var test_array:Array in [helper_tests, manager_tests, model_tests, service_tests, util_tests]) { //view_tests
        iterateTestArray(test_array)
      }
      
      // Generator Tests last
      //var generator_tests:Array = [ModelGenerationTest, ServiceGeneratorTest, MediaGeneratorTest, HelperGeneratorTest]
      
      //iterateTestArray(generator_tests)
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