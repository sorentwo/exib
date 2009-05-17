package unit {

  import asunit.framework.TestCase
  import com.soren.util.Abbreviate
  
  public class AbbreviateTest extends TestCase {

    public function AbbreviateTest(testMethod:String) {
      super(testMethod)
    }
    
    // ---
    
    public function testKnownAbbreviations():void {
      assertEquals('cm',    Abbreviate.abbreviate('centimeter'))
      assertEquals('deg',   Abbreviate.abbreviate('degree'))
      assertEquals('gal',   Abbreviate.abbreviate('gallon'))
      assertEquals('ltr',   Abbreviate.abbreviate('liter'))
      
      // Check normalization
      assertEquals('ltr',   Abbreviate.abbreviate('Liter'))
      assertEquals('oz',    Abbreviate.abbreviate('ounce'))
    }
    
    public function testAuxilliaryAbbreviations():void {
      assertEquals('Bachelors',   Abbreviate.abbreviate('Bachelors'))
      
      Abbreviate.addAuxilliary('Bachelors', 'b.a')
      
      assertEquals('b.a',   Abbreviate.abbreviate('Bachelors'))
    }
  }
}