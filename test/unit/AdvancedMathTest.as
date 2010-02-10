package unit {

  import asunit.framework.TestCase
  import com.soren.math.AdvancedMath

  public class AdvancedMathTest extends TestCase {

    public function AdvancedMathTest(testMethod:String) {
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
    
    public function testGCD():void {
      assertEquals(2,  AdvancedMath.gcd(0,2))
      assertEquals(2,  AdvancedMath.gcd(2,4))
      assertEquals(3,  AdvancedMath.gcd(9,12))
      assertEquals(6,  AdvancedMath.gcd(12,18))
      assertEquals(2,  AdvancedMath.gcd(-4,14))
      assertEquals(1,  AdvancedMath.gcd(9,28))
      assertEquals(7,  AdvancedMath.gcd(7,21))
      assertEquals(14, AdvancedMath.gcd(42,56))
    }
    
    public function testLCM():void {
      assertEquals(8,   AdvancedMath.lcm(4,8))
      assertEquals(16,  AdvancedMath.lcm(4,16))
      assertEquals(42,  AdvancedMath.lcm(21,6))
    }
    
    public function testFraction():void {
      assertEquals([0,0].toString(), AdvancedMath.toFraction(0).toString())
      assertEquals([0,0].toString(), AdvancedMath.toFraction(1).toString())
      
      assertEquals([1,4].toString(), AdvancedMath.toFraction(0.25).toString())
      assertEquals([1,3].toString(), AdvancedMath.toFraction(0.33).toString())
      assertEquals([1,2].toString(), AdvancedMath.toFraction(0.5).toString())
      assertEquals([2,3].toString(), AdvancedMath.toFraction(0.66).toString())
      assertEquals([3,4].toString(), AdvancedMath.toFraction(0.75).toString())
      
      assertEquals([1,2].toString(), AdvancedMath.toFraction(1.5).toString())
      assertEquals([2,3].toString(), AdvancedMath.toFraction(1.66).toString())
      
      assertEquals(1, AdvancedMath.numerator(0.25))
      assertEquals(1, AdvancedMath.numerator(0.33))
      assertEquals(3, AdvancedMath.numerator(0.75))
      assertEquals(7, AdvancedMath.numerator(0.875))
      
      assertEquals(4, AdvancedMath.denominator(0.25))
      assertEquals(3, AdvancedMath.denominator(0.33))
      assertEquals(4, AdvancedMath.denominator(0.75))
      assertEquals(8, AdvancedMath.denominator(0.875))
    }
  }
}