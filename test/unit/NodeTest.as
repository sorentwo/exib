package unit {

  import asunit.framework.TestCase
  import com.soren.exib.view.Node
  
  public class NodeTest extends TestCase {

    public function NodeTest(testMethod:String) {
      super(testMethod)
    }
    
    // ---
    
    public function testAccessors():void {
      var node:Node = new Node()
      node.id = 'unique'
      node.groups = ['meta', 'omega']
      assertEquals('unique', node.id)
      assertEquals('meta,omega', node.groups.toString())
    }
    
    public function testPlacement():void {
      var node:Node = new Node()
      var xpos:uint = 10
      var ypos:uint = 10
      node.position(xpos + ',' + ypos)
      assertEquals(10, node.x)
      assertEquals(10, node.y)
      
      var error:Error
      try {
        node.position('5 5')
      } catch (e:Error) {
        error = e
      }
      
      assertNotNull(error)
    }
    
    /**
    * Tree 
    * 
    *        a
    *       / \
    *      b   c
    *     /   / \
    *    d   e   f
    **/
    public function testGetNodes():void {
      var screen:Node = new Node()
      var a:Node = new Node()
      var b:Node = new Node()
      var c:Node = new Node()
      var d:Node = new Node()
      var e:Node = new Node()
      var f:Node = new Node()
      
      a.id = 'container'
      b.id = 'header'
      e.id = 'footer'
      
      b.groups = c.groups = ['slidable']
      d.groups = e.groups = ['fadable', 'blurable']
      f.groups = ['fadable', 'blurable']
      
      screen.addChild(a)
      a.addChild(b); a.addChild(c)
      b.addChild(d)
      c.addChild(e); c.addChild(f)
      
      var found_node:Node
      assertNotNull(screen.getChildById('container'))
      assertNotNull(screen.getChildById('header'))
      assertNotNull(screen.getChildById('footer'))
      
      assertNull(screen.getChildById('bibliography'))
      
      var found_nodes:Array
      found_nodes = screen.getChildrenByGroup('slidable')
      assertEquals(2, found_nodes.length)
      
      found_nodes = screen.getChildrenByGroup('fadable')
      assertEquals(3, found_nodes.length)
      
      found_nodes = screen.getChildrenByGroup('blurable')
      assertEquals(3, found_nodes.length)
      
      found_nodes = screen.getChildrenByGroup('nonexistent')
      assertEquals(0, found_nodes.length)
      
      a.addGroup('scalable'); f.addGroup('scalable')
      found_nodes = screen.getChildrenByGroup('scalable')
      assertEquals(2, found_nodes.length)
      
      assertTrue(a.hasGroup('scalable'))
      assertFalse(a.hasGroup('fadable'))
    }
  }
}