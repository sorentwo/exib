package unit {
  
  import asunit.framework.TestCase
  import com.soren.util.ExtendedArray
  
  public class ExtendedArrayTest extends TestCase {

    public function ExtendedArrayTest(testMethod:String) {
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
    
    //---
    
    public function testContainsArray():void {
      assertFalse(new ExtendedArray('cat', 'dog', 'frog').containsArray())      
      assertTrue(new ExtendedArray('cat', ['dog'], 'frog').containsArray())
      assertTrue(new ExtendedArray('cat', ['lion', 'tiger'], 'frog').containsArray())
    }
    
    public function testFlatten():void {
      assertFalse(new ExtendedArray('cat', 'dog').flatten().containsArray())
      assertFalse(new ExtendedArray('cat', ['dog', 'frog']).flatten().containsArray())
      assertFalse(new ExtendedArray('cat', ['lion', 'tiger'], 'frog').flatten().containsArray())
      assertFalse(new ExtendedArray(['cat', 'dog']).flatten().containsArray())
      assertFalse(new ExtendedArray([[[[[['cat']]]]]]).flatten().containsArray())
      assertFalse(new ExtendedArray([['cat', 'dog'], ['frog', 'liger']]).flatten().containsArray())
    }
  }  
}