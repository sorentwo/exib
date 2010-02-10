package unit {

  import asunit.framework.TestCase
  import com.soren.exib.core.Generator
  import com.soren.exib.view.Node
  import com.soren.sfx.Queue

  public class QueueGeneratorTest extends TestCase {
    
    private var _root:Node
    private var _child_a:Node
    private var _child_b:Node
    private var _gen:Generator
    
    public function QueueGeneratorTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _root = new Node()
      
      _child_a = new Node()
      _child_a.id = 'child_a'
      _child_a.groups = ['group_a']
      
      _child_b = new Node()
      _child_b.id = 'child_b'
      _child_b.groups = ['group_b']
      
      _gen = new Generator()
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _root, _child_a, _child_b = null
      _gen = null
    }
    
    public function testGenerateEmptyQueue():void {
      var xml:XML = <queue id='myqueue'></queue>

      assertTrue(_gen.genQueue(xml, _root) is Queue)
    }
    
    public function testGenerateSingleElementQueue():void {
      var xml:XML = <queue id='myqueue'><fade targets='.group_a'>from: 0, to: 1</fade></queue>
      
      var queue:Queue = _gen.genQueue(xml, _root)
      assertEquals(1, queue.length)
    }
    
    public function testGenerateMultiElementQueue():void {
      var xml:XML = <queue id='myqueue'><fade targets='.group_a'>from: 0, to: 1</fade><slide targets='.group_b'>start_x: 0, end_x: 100</slide></queue>
      
      var queue:Queue = _gen.genQueue(xml, _root)
      assertEquals(2, queue.length)
    }
    
    public function testGenerateQueueWithWait():void {
      var xml:XML = <queue id='myqueue'><fade targets='#child_a, .group_b'>from: 0, to: 1, wait: 1.5</fade></queue>
      
      var queue:Queue = _gen.genQueue(xml, _root)
      assertEquals(1, queue.length)
    }
  }
}