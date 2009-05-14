package unit {
	
	import asunit.framework.TestCase
	import com.soren.util.StringUtil
	
  public class StringUtilTest extends TestCase {
 		
  	private var _date:Date = new Date(2008, 8, 24, 12, 30, 25)

    public function StringUtilTest(testMethod:String) {
      super(testMethod)
    }
  	
  	// ---
    
    public function testConvertCase():void {
      var original_string:String = 'The Time Is Now 12'
      assertEquals('the time is now 12', StringUtil.casefix(original_string, StringUtil.LOWER))
      assertEquals('The time is now 12', StringUtil.casefix(original_string, StringUtil.SENTENCE))
      assertEquals('The Time Is Now 12', StringUtil.casefix(original_string, StringUtil.TITLE))
      assertEquals('THE TIME IS NOW 12', StringUtil.casefix(original_string, StringUtil.UPPER))
    }
  	
  	public function testPositionals():void {
  	  assertEquals("Goodbye AXIB.",           StringUtil.format("Goodbye %s.", "AXIB"))
  	  assertEquals("Hello EXIB you wretch", StringUtil.format("Hello %s you %s", "EXIB", "wretch"))
  	  assertEquals("Hello EXIB",            StringUtil.format("Hello %s", "EXIB", "blank"))
  	  
  	  var error:Error
  	  try {
  	   StringUtil.format("Hello %s and %s", "AXIB")
  	  } catch (e:Error) {
  	    assertNotNull(e)
  	  }
  	}
  	
  	public function testPadding():void {
  	  assertEquals("4.",   StringUtil.format("%d.", 4))
  	  assertEquals("04",   StringUtil.format("%02d", 4))
  	  assertEquals("004",  StringUtil.format("%03d", 4))
  	  assertEquals("499",  StringUtil.format("%03d", 499))
  	  assertEquals("0499", StringUtil.format("%04d", 499))
  	}
  	
  	public function testFloatPadding():void {
  	  assertEquals('0.4',     StringUtil.format('%f', 0.4))
  	  assertEquals("4",       StringUtil.format("%f",   4))
  	  assertEquals("4.0000",  StringUtil.format("%.4f", 4))
  	}
    
  	public function testDateFormatting():void {
  	  assertEquals("3, Wed, Wednesday",
  	               StringUtil.format("%{+day}, %{+dayshort}, %{+daylong}", _date, _date, _date))
  	  assertEquals("08, 2008",
  	               StringUtil.format("%{+year}, %{+fullyear}", _date, _date))
  	  assertEquals("9, Sep, September",
  	               StringUtil.format("%{+month}, %{+monthshort}, %{+monthlong}", _date, _date, _date))
  	  assertEquals("12:30:25 pm",
  	                StringUtil.format("%{+hours}:%{+minutes}:%{+seconds} %{+ampm}", _date, _date, _date, _date))
  	  assertEquals("12:30:25 pm",
  	                StringUtil.format("%02{+hours}:%02{+minutes}:%02{+seconds} %{+ampm}", _date, _date, _date, _date))
  	}
  	
  	public function testConversionFormatting():void {
  	  assertEquals(0,  StringUtil.format('%{fahrenheit:celcius}', 32))
  	  assertEquals(30, StringUtil.format('%{fahrenheit:celcius}', 86))
  	  assertEquals(0,  StringUtil.format('%{kelvin:celcius}',     273))
  	  
  	  // Volume
  	  assertEquals(1,   StringUtil.format('%{ounce:cup}',    8))
  	  assertEquals(1.5, StringUtil.format('%{ounce:cup}',    12))
  	  assertEquals(4,   StringUtil.format('%{quart:gallon}', 16))
  	  
  	  // Post
  	  assertEquals(2, StringUtil.format('%{ounce:cup::ceil}',        12))
  	  assertEquals(2, StringUtil.format('%{ounce:cup::denominator}', 12))
  	  assertEquals(1, StringUtil.format('%{ounce:cup::floor}',       12))
  	  assertEquals(1, StringUtil.format('%{ounce:cup::numerator}',   12))
  	  assertEquals(1, StringUtil.format('%{ounce:cup::round}',       10))
  	  
  	  // Prefix
  	  assertEquals(14.5, StringUtil.format('%{kilo:one}',  14500))
  	  assertEquals(2000, StringUtil.format('%{deka:kilo}', 20))
  	  
  	  // Mod Time
  	  assertEquals(1,  StringUtil.format("%{rawsec:modhour}", 5305))
  	  assertEquals(28, StringUtil.format("%{rawsec:modmin}",  5305))
  	  assertEquals(25, StringUtil.format("%{rawsec:modsec}",  5305))
  	}
  	
  	public function testReplacementFormatting():void {
      assertEquals('cat',        StringUtil.format('%{b/a}',   'cbt'))
      assertEquals('JOE',        StringUtil.format('%{oe/OE}', 'Joe'))
      assertEquals('cold/warm',  StringUtil.format('%{_//}',   'cold_warm'))
      assertEquals('normal cyc', StringUtil.format('%{_/ }',   'normal_cyc'))
  	}
	}
}