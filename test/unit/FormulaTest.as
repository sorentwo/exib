package unit {

  import asunit.framework.TestCase
  import com.soren.exib.helper.Formula

  public class FormulaTest extends TestCase {

    public function FormulaTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void { }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void { }
    
    // ---
    
    public function testGenericParsing():void {
      var formula:Formula = new Formula('0 + 0')
      
      // Addition
      formula.store('0 + 0')
      assertEquals(0, formula.yield())
      
      formula.store('5 + 5')
      assertEquals(10, formula.yield())
      
      formula.store('5 + -5')
      assertEquals(0, formula.yield())
      
      formula.store('5.2 + 5.3')
      assertEquals(10.5, formula.yield())
      
      // Subtraction
      formula.store('5 - 5')
      assertEquals(0, formula.yield())
      
      formula.store('0 - 5')
      assertEquals(-5, formula.yield())
      
      formula.store('10 - 5')
      assertEquals(5, formula.yield())
      
      formula.store('5.5 - 5')
      assertEquals(.5, formula.yield())
      
      // Multiplication
      formula.store('5 * 0')
      assertEquals(0, formula.yield())
      
      formula.store('5 * 5')
      assertEquals(25, formula.yield())
      
      formula.store('5 * -1')
      assertEquals(-5, formula.yield())
      
      formula.store('5 * .5')
      assertEquals(2.5, formula.yield())
      
      // Division      
      formula.store('0 / 5')
      assertEquals(0, formula.yield())
      
      formula.store('5 / 5')
      assertEquals(1, formula.yield())
      
      formula.store('5 / 2.5')
      assertEquals(2, formula.yield())
      
      formula.store('5.5 / 2')
      assertEquals(2.75, formula.yield())
      
      // Modulo
      formula.store('5 % 5')
      assertEquals(0, formula.yield())
      
      formula.store('5 % 2')
      assertEquals(1, formula.yield())
      
      formula.store('5.5 % 2')
      assertEquals(1.5, formula.yield())
    }
    
    public function testCompoundOperations():void {
      var formula:Formula = new Formula('0 + 0')
      
      formula.store('0 + 0 + 5')
      assertEquals(5, formula.yield())
      
      formula.store('1 + 1 + 1')
      assertEquals(3, formula.yield())
      
      formula.store('.5 + .5 + .5')
      assertEquals(1.5, formula.yield())
      
      formula.store('2.5 + 2.5 - 5')
      assertEquals(0, formula.yield())
      
      formula.store('0 + 0 - 1')
      assertEquals(-1, formula.yield())
      
      formula.store('1 + 1 * 2')
      assertEquals(3, formula.yield())
      
      formula.store('1 * 1 * 2')
      assertEquals(2, formula.yield())
      
      formula.store('1 + 5 / 5')
      assertEquals(2, formula.yield())
      
      formula.store('5 % 2 + 1')
      assertEquals(2, formula.yield())
    }
    
    public function testOptionUsage():void {
      var formula:Formula = new Formula('0 + 0')
      
      formula.store('.4 + .5', { round: Formula.ROUND })
      assertEquals(1, formula.yield())
      
      // Test persistence of the option
      formula.store('.1 + .3')
      assertEquals(0, formula.yield())
      
      formula.store('0 + .1', { round: Formula.CEIL })
      assertEquals(1, formula.yield())
      
      formula.store('0 + .9', { round: Formula.FLOOR })
      assertEquals(0, formula.yield())
      
      formula.store('0 + -1', { abs: true })
      assertEquals(1, formula.yield())
      
      // Compound options
      formula.store('0 + -.1', { round: Formula.CEIL, abs: true })
      assertEquals(1, formula.yield())
      
      formula.store('2 + -.1', { round: Formula.FLOOR, abs: true })
      assertEquals(1, formula.yield())
    }
    
    public function testVariableExtraction():void {
      var formula:Formula = new Formula('0 + 0')
      var val_a:ValueModel = new ValueModel(0, 1, 10)
      var val_b:ValueModel = new ValueModel(0, 250, 500)
      var val_c:ValueModel = new ValueModel(-100, 0, 100)
      
      
      
      formula.store('val_a + 1')
      assertEquals(2, formula.yield())
    }
  }
}