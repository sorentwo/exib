package unit {

  import asunit.framework.TestCase
  import flash.display.Sprite
  import com.soren.exib.manager.Manager
  import com.soren.exib.view.ScreenController
  import com.soren.exib.view.ScreenNode

  public class ScreenControllerTest extends TestCase {
    
    private var _container:Sprite
    
    public function ScreenControllerTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void {
      _container = new Sprite()
    }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void {
      _container = null
    }
    
    // ---
    
    public function testBasicConstruction():void {
      var scon:ScreenController = new ScreenController(_container)
      
      assertEquals(scon.idOfCurrent, scon.value)
      assertEquals('', scon.value)
      
      scon.add(new ScreenNode(), 'home')
      scon.add(new ScreenNode(), 'menu')
      
      scon.load('home')
      assertEquals('home', scon.idOfCurrent)
      assertTrue(_container.contains(scon.current))
      
      scon.go('menu')
      assertEquals('menu', scon.idOfCurrent)
      assertEquals('home', scon.idOfPrevious)
      assertTrue(_container.contains(scon.current))
      
      scon.previous()
      assertEquals('home', scon.idOfCurrent)
    }
  }
}