package {
	
	import flash.utils.describeType
	import asunit.framework.TestSuite
	import unit.*
	import generator.*
	
  public class AllTests extends TestSuite {
    
    public function AllTests () {
      super()
      
      var helper_tests:Array    = [ConditionalTest, ConditionalSetTest, ActionTest, ActionSetTest]
      var manager_tests:Array   = [ManagerTest, SupervisorTest]
      var model_tests:Array     = [ValueModelTest, StateModelTest, HistoryModelTest, ClockModelTest, PresetModelTest]
      var service_tests:Array   = [CronTest, DaemonTest, HotkeyTest, SoundTest]
      var util_tests:Array      = [TimeUtilTest, ExtendedArrayTest, ConversionUtilTest, KeyUtilTest, PadTest, StringUtilTest]
      var view_tests:Array      = [NodeTest, GraphicNodeTest, ButtonNodeTest, DialNodeTest, MeterNodeTest, MultiNodeTest, ProgressNodeTest, TextNodeTest, VectorNodeTest, VideoNodeTest, ScreenNodeTest, ScreenControllerTest]

      iterateTestArray(helper_tests)
      iterateTestArray(manager_tests)
      iterateTestArray(model_tests)
      iterateTestArray(service_tests)
      iterateTestArray(util_tests)
      iterateTestArray(view_tests)
      
      // Generator Tests last
      
      var model_gen_tests:Array = [ModelGenerationTest, ServiceGeneratorTest, MediaGeneratorTest]
      
      iterateTestArray(model_gen_tests)
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