package {
	
	import flash.utils.describeType
	import asunit.framework.TestSuite
	import unit.*
	import generator.*
	import com.soren.exib.service.Sound
	import com.soren.exib.view.GraphicNode
	import com.soren.exib.view.VideoNode
	
  public class UnitTests extends TestSuite {
    
    include "./TestHelper.as"
    
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
    
    public function UnitTests () {      
      for each (var klass:Class in [Sound, GraphicNode, VideoNode]) {
        klass['setEmbedContainer'](this)
      }
      
      super()
      
      var tests:Array = [
        AbbreviateTest, ActionSetTest, ActionTest, AdvancedMathTest, ButtonNodeTest, ClockModelTest, ConditionalSetTest, ConditionalTest, ConversionUtilTest, CronTest, DaemonTest, DateUtilTest, DialNodeTest, EvaluatorTest, ExtendedArrayTest, FormulaTest, GraphicNodeTest, HistoryModelTest, HotkeyTest, KeyUtilTest, ManagerTest, MeterNodeTest, MultiNodeTest, NodeTest, PadTest, PresetModelTest, ProgressNodeTest, ScreenControllerTest, ScreenNodeTest, SoundTest, StateModelTest, StringUtilTest, TaskTest, TextNodeTest, ValueModelTest, VectorNodeTest, VideoNodeTest, ViewTest // AUTO
      ]

      iterateTestArray(tests)
    }
	}
}