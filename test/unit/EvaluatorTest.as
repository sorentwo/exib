package unit {

  import asunit.framework.TestCase
  import com.soren.exib.core.Space
  import com.soren.exib.helper.Evaluator
  import com.soren.exib.model.ValueModel
  import com.soren.exib.model.PresetModel
  
  public class EvaluatorTest extends TestCase {

    public function EvaluatorTest(testMethod:String) {
      super(testMethod)
    }
    
    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      Space.getSpace().reset()
    }
    
    // ---
    
    public function testMethodUsage():void {
      var vm:ValueModel = new ValueModel(4,2,10)
      var evaluator_a:Evaluator = new Evaluator(vm)
      var evaluator_b:Evaluator = new Evaluator(vm, 'value')
      
      assertEquals(4, evaluator_a.value)
      assertEquals(4, evaluator_b.value)
      
      var evaluator_c:Evaluator = new Evaluator(vm, 'min')
      var evaluator_d:Evaluator = new Evaluator(vm, 'max')
      
      assertEquals(2, evaluator_c.value)
      assertEquals(10, evaluator_d.value)
    }
    
    public function testIndexUsage():void {
      var pre:PresetModel = new PresetModel()
      pre.watch(new ValueModel(0,0,1))
      pre.watch(new ValueModel(1,0,2))
      pre.save()
      
      var evaluator_a:Evaluator = new Evaluator(pre, 'value', 0)
      var evaluator_b:Evaluator = new Evaluator(pre, 'value', 1)
      
      assertEquals(0, evaluator_a.value)
      assertEquals(1, evaluator_b.value)
    }
    
    public function testSpaceUsage():void {
      var vm:ValueModel = new ValueModel(1,0,1)
      Space.getSpace().add(vm, 'the_vm')
      
      var evaluator:Evaluator = new Evaluator('the_vm', 'min')
      
      assertEquals(0, evaluator.value)
    }
  }
}