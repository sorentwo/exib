package unit {

  import asunit.framework.TestCase
  import flash.text.TextField
  import flash.text.TextFormat
  import com.soren.exib.model.StateModel
  import com.soren.exib.model.ValueModel
  import com.soren.exib.view.TextNode
  
  public class TextNodeTest extends TestCase {

    public function TextNodeTest(testMethod:String) {
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
    
    public function testStaticText():void {
      var text_node:TextNode
      
      text_node = new TextNode("Lorem Ipsum", new TextFormat())
      assertEquals(1, text_node.numChildren)
      assertEquals('Lorem Ipsum', (text_node.getChildAt(0) as TextField).text)
      
      text_node = new TextNode('Lorem Ipsum', new TextFormat(), null, 0, 0, 'l')
      assertEquals('lorem ipsum', (text_node.getChildAt(0) as TextField).text)
    }
    
    public function testDynamicText():void {
      var mod_a:StateModel = new StateModel('chicago', 'salt lake city')
      var mod_b:ValueModel = new ValueModel(1, 1, 2)
      
      var dynamic_text:String = 'We live in %s for the next %d year'
      
      var text_node:TextNode = new TextNode(dynamic_text, new TextFormat(), [mod_a, mod_b])
      
      assertEquals('We live in chicago for the next 1 year',
                   (text_node.getChildAt(0) as TextField).text)
      
      mod_b.set(2)
      assertEquals('We live in chicago for the next 2 year',
                   (text_node.getChildAt(0) as TextField).text)
    }
  }
}