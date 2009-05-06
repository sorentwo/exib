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
  	  assertEquals("Hello AXIB.", StringUtil.sprintf("Hello %s.", "AXIB"))
  	  assertEquals("Hello AXIB you wretch", StringUtil.sprintf("Hello %s you %s", "AXIB", "wretch"))
  	  assertEquals("Hello AXIB", StringUtil.sprintf("Hello %s", "AXIB", "blank"))
  	  var error:Error
  	  try {
  	   StringUtil.sprintf("Hello %s and %s", "AXIB")
  	  } catch (e:Error) {
  	    assertNotNull(e)
  	  }
  	}
  	
  	public function testPadding():void {
  	  assertEquals("this is 4.", StringUtil.sprintf("this is %d.", 4))
  	  assertEquals("this is 04", StringUtil.sprintf("this is %02d", 4))
  	  assertEquals("this is 004", StringUtil.sprintf("this is %03d", 4))
  	  assertEquals("this is 499", StringUtil.sprintf("this is %03d", 499))
  	  assertEquals("this is 0499", StringUtil.sprintf("this is %04d", 499))
  	}
  	
  	public function testFloatPadding():void {
  	  assertEquals("4.0", StringUtil.sprintf("%f", 4))
  	  assertEquals("4.0000", StringUtil.sprintf("%.4f", 4))
  	}

  	public function testDateFormatting():void {
  	  assertEquals("3, Wed, Wednesday",
  	               StringUtil.sprintf("%{g}t, %{a}t, %{A}t", _date, _date, _date))
  	  assertEquals("08, 2008",
  	               StringUtil.sprintf("%{y}t, %{Y}t", _date, _date))
  	  assertEquals("9, Sep, September",
  	               StringUtil.sprintf("%{m}t, %{b}t, %{B}t", _date, _date, _date))
  	  assertEquals("12:30:25 pm",
  	                StringUtil.sprintf("%{h}t:%{M}t:%{S}t %{p}t", _date, _date, _date, _date))
  	}
  	
  	public function testDateZeroPadding():void {
  	  assertEquals('03, 09',
  	               StringUtil.sprintf("%02{g}t, %02{m}t", _date, _date))
   	  assertEquals('003, 00009',
   	               StringUtil.sprintf("%03{g}t, %05{m}t", _date, _date))
  	}
  	
  	public function testConversionFormatting():void {
  	  assertEquals("0",     StringUtil.sprintf("%{c}c", 32))
  	  assertEquals("27",    StringUtil.sprintf("%{c}c", 80))
  	  assertEquals("32",    StringUtil.sprintf("%{f}c", 0))
  	  assertEquals("1",     StringUtil.sprintf("%{u}c", 8))
  	  assertEquals("1.5",   StringUtil.sprintf("%{u}c", 12))
  	  assertEquals("0.3",   StringUtil.sprintf("%{l}c", 12))
  	  assertEquals('14.5',  StringUtil.sprintf("%{k}c", 14500))
  	  assertEquals(1,       StringUtil.sprintf("%{O}c", 5305))
  	  assertEquals(28,      StringUtil.sprintf("%{I}c", 5305))
  	  assertEquals(25,      StringUtil.sprintf("%{E}c", 5305))
  	}
  	
  	public function testReplacementFormatting():void {
      assertEquals('cat',       StringUtil.sprintf("%{/b/a/}r",   'cbt'))
      assertEquals('jOE',       StringUtil.sprintf("%{/oe/OE/}r", 'joe'))
      assertEquals('cold/warm', StringUtil.sprintf("%{/_///}r",   'cold_warm'))
  	}
  	
  	public function testMultiDimensionalArgs():void {
      assertEquals("Cats and dogs living together",
                   StringUtil.sprintf("%s and %s living %s", 'Cats', ['dogs', 'together']))
   	  assertEquals("Cats and dogs living together",
   	               StringUtil.sprintf("%s and %s living %s", ['Cats', 'dogs', 'together']))
  	}
  	
  	public function testFractionTools():void {
  	  var val:Number = 1.25
  	  assertEquals('1 1/4', StringUtil.sprintf('%{F}c %{N}c/%{D}c', val, val, val))
  	}
	}
}