package unit {
	
	import asunit.framework.TestCase
	import com.soren.util.StringUtil
	
  public class StringUtilTest extends TestCase {
 		
  	private var _date:Date

    public function StringUtilTest(testMethod:String) {
      super(testMethod)
    }
    
    /**
	 	 * Prepare for test, create instance of class that we are testing.
	 	 * Invoked by TestCase.runMethod function.
	 	 */
		protected override function setUp():void {
		  _date = new Date(2008, 8, 24, 12, 30, 25)
	 	}

		/**
	 	 * Clean up after test, delete instance of class that we were testing.
	 	 */
	 	protected override function tearDown():void { }
  	
  	// ---
  	
    public function testAbbr():void {
      assertEquals('oz', StringUtil.abbr('ounces'))
      assertEquals('oz', StringUtil.abbr('OUNCES'))
      assertEquals('foobar', StringUtil.abbr('foobar'))
    }
    
    public function testConvertCase():void {
      var original_string:String = 'The Time Is Now 12'
      assertEquals(original_string, StringUtil.convertCase(original_string))
      assertEquals('the time is now 12', StringUtil.convertCase(original_string, StringUtil.LOWER))
      assertEquals('The time is now 12', StringUtil.convertCase(original_string, StringUtil.SENTENCE))
      assertEquals('The Time Is Now 12', StringUtil.convertCase(original_string, StringUtil.TITLE))
      assertEquals('THE TIME IS NOW 12', StringUtil.convertCase(original_string, StringUtil.UPPER))
    }
  	
  	public function testPositionals():void {
  	  assertEquals("Hello AXIB.", StringUtil.format("Hello %s.", "AXIB"))
  	  assertEquals("Hello AXIB you wretch", StringUtil.format("Hello %s you %s", "AXIB", "wretch"))
  	  assertEquals("Hello AXIB", StringUtil.format("Hello %s", "AXIB", "blank"))
  	  var error:Error
  	  try {
  	   StringUtil.format("Hello %s and %s", "AXIB")
  	  } catch (e:Error) {
  	    assertNotNull(e)
  	  }
  	}
  	
  	public function testPadding():void {
  	  assertEquals("this is 4.", StringUtil.format("this is %d.", 4))
  	  assertEquals("this is 04", StringUtil.format("this is %02d", 4))
  	  assertEquals("this is 004", StringUtil.format("this is %03d", 4))
  	  assertEquals("this is 499", StringUtil.format("this is %03d", 499))
  	  assertEquals("this is 0499", StringUtil.format("this is %04d", 499))
  	}
  	
  	public function testFloatPadding():void {
  	  assertEquals("4.0", StringUtil.format("%f", 4))
  	  assertEquals("4.0000", StringUtil.format("%.4f", 4))
  	}

  	public function testDateFormatting():void {
  	  assertEquals("3, Wed, Wednesday",
  	               StringUtil.format("%{g}t, %{a}t, %{A}t", _date, _date, _date))
  	  assertEquals("08, 2008",
  	               StringUtil.format("%{y}t, %{Y}t", _date, _date))
  	  assertEquals("9, Sep, September",
  	               StringUtil.format("%{m}t, %{b}t, %{B}t", _date, _date, _date))
  	  assertEquals("12:30:25 pm",
  	                StringUtil.format("%{h}t:%{M}t:%{S}t %{p}t", _date, _date, _date, _date))
  	}
  	
  	public function testDateZeroPadding():void {
  	  assertEquals('03, 09',
  	               StringUtil.format("%02{g}t, %02{m}t", _date, _date))
   	  assertEquals('003, 00009',
   	               StringUtil.format("%03{g}t, %05{m}t", _date, _date))
  	}
  	
  	public function testConversionFormatting():void {
  	  assertEquals("0",     StringUtil.format("%{c}c", 32))
  	  assertEquals("27",    StringUtil.format("%{c}c", 80))
  	  assertEquals("32",    StringUtil.format("%{f}c", 0))
  	  assertEquals("1",     StringUtil.format("%{u}c", 8))
  	  assertEquals("1.5",   StringUtil.format("%{u}c", 12))
  	  assertEquals("0.3",   StringUtil.format("%{l}c", 12))
  	  assertEquals('14.5',  StringUtil.format("%{k}c", 14500))
  	  assertEquals(1,       StringUtil.format("%{O}c", 5305))
  	  assertEquals(28,      StringUtil.format("%{I}c", 5305))
  	  assertEquals(25,      StringUtil.format("%{E}c", 5305))
  	}
  	
  	public function testReplacementFormatting():void {
      assertEquals('cat',       StringUtil.format("%{/b/a/}r",   'cbt'))
      assertEquals('jOE',       StringUtil.format("%{/oe/OE/}r", 'joe'))
      assertEquals('cold/warm', StringUtil.format("%{/_///}r",   'cold_warm'))
  	}
  	
  	public function testMultiDimensionalArgs():void {
      assertEquals("Cats and dogs living together",
                   StringUtil.format("%s and %s living %s", 'Cats', ['dogs', 'together']))
   	  assertEquals("Cats and dogs living together",
   	               StringUtil.format("%s and %s living %s", ['Cats', 'dogs', 'together']))
  	}
  	
  	public function testFractionTools():void {
  	  var val:Number = 1.25
  	  assertEquals('1 1/4', StringUtil.format('%{F}c %{N}c/%{D}c', val, val, val))
  	}
	}
}