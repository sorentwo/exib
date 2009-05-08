/**
* StringUtil
* 
* A collection of string formatting tools.
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.util {

  import com.soren.math.AdvancedMath
  
  public class StringUtil {
    
    // Case Constants
    public static const LOWER:uint    = 0
    public static const UPPER:uint    = 1
    public static const SENTENCE:uint = 2
    public static const TITLE:uint    = 3
    
    // Format Tokens
    private static const STRING:String     = 's'
    private static const CONVERSION:String = 'c'
    private static const FLOAT:String      = 'f'
    private static const INTEGER:String    = 'd'
    private static const UNSIGNED:String   = 'u'
    
    private static const CONVERT:String    = 'o'
    private static const DATE:String       = 't'
    private static const REPLACE:String    = 'r'
    
    /**
    * Singleton, non-used constructor.
    **/
    public function StringUtil() {
      throw new Error('StringUtil class is a static container only')
    }
    
    /**
    * Performs case conversion on the string provided. Supports conversion to
    * lower, upper, sentence, and title cases.
    * 
    * @param  string    String to be converted.
    * @param  charcase  Token representing the character case to convert to.
    *                   <ul>
    *                   <li>0 or LOWER -> Lower case. Sample: <q>this is lower 
    *                   case.</q></li>
    *                   <li>1 or UPPER -> Upper case. Sample: <q>THIS IS UPPER 
    *                   CASE.</q></li>
    *                   <li>2 or SENTENCE -> Sentence case. Sample: <q>This is
    *                   sentence case.</q></li>
    *                   <li>3 or TITLE -> Title case. Sample: <q>This Is Title
    *                   Case.</q></li>
    *                   </ul>
    * 
    * @return   The case changed string.
    * 
    * @example  The following code shows typical usage of the casefix function.
    * <listing version='3.0'>
    * var input:String = 'The QuICK brOWn FOX JuMPed ovER the LazY DOg.'
    * var lower:String = StringUtil.casefix(input, StringUtil.LOWER)
    * var title:String = StringUtil.casefix(input, StringUtil.TITLE)
    * 
    * // lower = 'the quick brown fox jumped over the lazy dog.'
    * // title = 'The Quick Brown Fox Jumped Over The Lazy Dog.'
    * </listing>
    **/
    public static function casefix(string:String, charcase:uint):String {
      var downcased:String = string.toLowerCase()
      
      switch (charcase) {
        case LOWER:
          return downcased
        case UPPER:
          return string.toUpperCase()
        case SENTENCE:
          return downcased.substr(0, 1).toUpperCase() + downcased.substr(1, downcased.length)
        case TITLE:
          var word_pattern:RegExp = /(?:\b|\s|\t)(\w)(\w+)?/
          var title_cased:String  = ''
          var results:Object      = word_pattern.exec(downcased)

          while (results) {
            title_cased += results[1].toUpperCase() + results[2]
            results = word_pattern.exec(downcased)
          }

          return title_cased
        default:
          throw new Error('Invalid charcase code: ' + charcase)
      }
    }
    
    /**
    * Transpose (Substitute) method. Replaces the first value with the second
    * value. Use the syntax /val-a/val-b/, so /a/b/ on 'cbt' would yield 'cat'.
    * See examples below.
    * 
    * @param  format  A replacement string in the form of /pattern/replacement/.
    * @param  input   The string that will be searched and have replacements
    *                 performed on it.
    *
    * @return The replaced string.
    *
    * @example  The following code shows a typical tr implementation.
    * 
    * <listing version='3.0'>
    * var string:String   = 'The quick brown cat'
    * var replaced:String = StringUtil.tr('/brown/orange/', string)
    * 
    * // Yields 'The quick orange cat'
    * trace(replaced)
    * 
    * // Replacement is global, so it will replace a value multiple times when found
    * string   = 'black leather shoes, black leather jacket'
    * replaced = StringUtil.tr('/black/brown/', string)
    * 
    * // Yields 'brown leather shoes, brown leather jacket'
    * trace(replaced)
    * </listing>
    **/
    public static function tr(format:String, input:String):String {
      var pattern:RegExp = new RegExp("\/(?P<match>[a-zA-Z0-9_\/ ]+)\/(?P<substitute>[a-zA-Z0-9_\/ ]+)\/")
      
      if (!pattern.test(format)) throw new Error('Invalid format: ' + format)
      
      var result:Object = pattern.exec(format)
      return input.replace(result.match, result.substitute)
    }
    
    /**
    * The <code>format</code> function mimics the functionality of the C
    * standard sprintf. It produces output according to a format as described 
    * below.
    * 
    * <p>This implementation of sprintf is quite specialized </p>
    * 
    * <p>The format string is composed of zero or more directives: ordinary
    * characters, except for <code>%</code> or <code>%{}</code> sequences, which
    * are copied unchanged into the output. Each conversion token is introduced
    * by the <code>%</code> character or within the <code>%{}</code> conversion 
    * block. The number of conversion tokens and arguments must correspond and 
    * will be correlated in the sequence they are given.</p>
    * 
    * <p>After the opening <code>%</code> the following tokens or block 
    * instructions appear in sequence:</p>
    * 
    * <ul>
    *   <li>Zero or one of the following flags:
    *     <ul>
    *       <li>'d' -> Decimal conversion</li>
    *       <li>'i' -> Integer conversion</li>
    *       <li>'u' -> Unsigned integer conversion</li>
    *       <li>'s' -> String conversion, implicite with all output.</li>
    *     </ul>
    *   </li>
    *   <li>An optional decimal digit string specifying a minimum field width. If 
    *   the value has fewer characters than the field width it will be padded 
    *   with zeros on the left.<br />Example: <code>%03d -> '001', '002'</code>
    *   </li>
    *   <li>An optional precision in the form of a period '.', followed by an
    *   optional digit string. If the string is omitted the precision is taken
    *   as zero.</li>
    * </ul>
    * 
    * <p>When a conversion block, <code>%{}</code> is given, the associated 
    * argument will be converted or processed accordingly. The conversion 
    * specifiers and processors are:</p>
    *
    * <ul>
    *   <li><code>%{orig_unit:new_unit::post}</code><br />
    *     Convert between two units within the same realm of measurement (volume,
    *     prefix, weight, etc.) An error will be thrown if units don't correspond.
    *     <p>Available Units:</p>
    *     <ul>
    *       <li>Prefix: mega, kilo, hecto, deka, one, deci, centi, milli, micro</li>
    *       <li>Temperature: kelvin, celcius, fahrenheit</li>
    *       <li>Time: hours, minutes, seconds</li>
    *       <li>Volume: cubic_feet, cubic_meter, cup, gallon, liter, ounce, pint, 
    *       quart, tablespoon, teaspoon</li>
    *     </ul>
    *     <p>Available Post Processing:</p>
    *     <ul>
    *       <li>Ceil: Round the converte value up.</li>
    *       <li>Denominator: Turn the converted value into a fraction and return 
    *       only the denominator.</li>
    *       <li>Floor: Round the converted value down.</li>
    *       <li>Numerator: Turn the converted value into a fraction and return 
    *       only the numerator.</li>
    *       <li>Round: Round the converted value.</li>
    *     </ul>
    *   </li>
    *   <li><code>%{+date}</code><br />
    *     A block with a leading '+' sign signals a date format string in which to 
    *     display date and time. The available format strings are: date, day,
    *     dayshort, daylong, year, fullyear, month, monthshort, monthlong, hour, 
    *     hour24, ampm, minutes, seconds.
    *   </li>
    *   <li><code>%{pattern/replace}</code><br />
    *     A block separated by a forward slash, '/', will be interpreted as a 
    *     replacement directive where the string on the left of the slash is the 
    *     pattern to match and the string on the right is the replacement.
    *   </li>
    * </ul>
    * 
    * @param  input Formated string with zero or more tokens.
    * @param  args  Overloadable argument set. Each argument provided will be
    *               matched against a conversion token.
    *
    * @return   The formatted string containing all replaced values
    * 
    * @example  The following code shows a variety of sprintf usage.
    *
    * <listing version='3.0'>
    * 
    * </listing>
    **/
    public static function format(input:String, ...args):String {
      var padding_re:String    = "(?P<padding>0[1-9])?"
      var precision_re:String  = "(\\.(?P<precision>[0-9]))?"
      var convert_re:String    = "((\\{(?P<conversion>[\\w\\/+\\[\\]:]+)\\})|(?P<token>[a-zA-Z]{1}))"
      
      var pattern:RegExp = new RegExp('%', padding_re + precision_re + convert_re, 'g')
      
      var conversion_re:RegExp = (?P<first>\w+):(?P<second>\w+)(::(?P<post>\w+))?
      var date_re:RegExp       = \+(?P<date>\w+)
      var replace_re:RegExp    = (?P<substitution>\w+\/\w+)
      
      var output:String  = input
      var arg_index:uint = 0
      var result:Object
      var replacement:*
      
      do {
        result = pattern.exec(input)
        
        var conversion:String = result.conversion
        var token:String      = (result.conversion) ? CONVERSION : result.token
        var padding:uint      = uint(result.padding)   || NaN
        var precision:uint    = uint(result.precision) || NaN
        
        try             { replacement = args[arg_index]; arg_index ++ }
        catch (e:Error) { throw new Error('Number of variables and tokens do not match') }
        
        switch (token) {
          case STRING:
            replacement = replacement.toString()
            break
          case FLOAT:
            replacement = Number(replacement)
            break
          case INTEGER:
            replacement = int(replacement)
            break
          case UNSIGNED:
            replacement = uint(replacement)
            break
          case CONVERSION:
            var conv_token:String, conv_result:Object
            
                 if (conversion_re.test(conversion)) { conv_token = CONVERT; conv_result = conversion_re.exec(conversion) }
            else if (date_re.test(conversion))       { conv_token = DATE; conv_result = date_re.exec(conversion)          }
            else if (replace_re.test(conversion))    { conv_token = REPLACE; conv_result = replace_re.exec(conversion)    }
            
            switch (conv_token) {
              case CONVERT:
                var params:Array = ConversionUtil.getTypesAndFunction(conv_result.first, conv_result.second)
                var a:uint, b:uint, func:Function = params[0], params[1], params[2]
                replacement = ConversionUtil[func].call(null, a, b, replacement)
                
                if (conv_result.post) replacement = postFormat(conv_result.post, replacement)
                break
              case DATE:
                replacement = dateFormat(conv_result.date, replacement)
                break
              case REPLACE:
                replacement = tr(conv_result.substitution, replacement)
                break
              default:
                throw new Error('Invalid conversion pattern: ' + conversion)
            }
            
            break
          default:
            throw new Error('Invalid format token: ' + token)
        }
        
        if (!isNaN(padding))   { replacement = Pad.zeroPad(replacement, padding)    }
        if (!isNaN(precision)) { replacement = Pad.padFloat(replacement, precision) }
        
        output = output.replace(result[0], replacement)
      } while (result)
      
      return output
    }
    
    /**
    * @private
    * 
    * For internal use only. Public because of static method limitations.
    **/
    public function dateFormat(key:String, date:Date):String {
      var output:String
      
      switch (key) {
        case 'date':
          output = date.date
          break
        case 'day':
          output = date.day
          break
        case 'dayshort':
          output = DateUtil.dayName(date.day, true)
          break
        case 'daylong':
          output = DateUtil.dayName(date.day, false)
          break
        case 'fullyear':
          output = date.fullYear
          break
        case 'year':
          output = date.fullYear.toString().substr(2,2)
          break
        case 'month':
          output = date.month + 1
          break
        case 'monthshort':
          output = DateUtil.monthName(date.month, true)
          break
        case 'monthlong':
          output = DateUtil.monthName(date.month, false)
          break
        case 'hour24':
          output = date.hours
          break
        case 'hour':
          var mil:uint      = date.hours
          var standard:uint = (mil <= 12) ? mil : (mil - 12)
          if (standard == 0) standard = 12
          output = standard.toString()
          break
        case 'ampm':
          output = (date.hours >= 12) ? "pm" : "am"
          break
        case 'minutes':
          output = date.minutes
          break
        case 'seconds':
          output = date.seconds
          break
        default:
          throw new Error('Invalid date string: ' + key)
      }
      
      return output
    }
    
    /**
    * @private
    * 
    * For internal use only. Public because of static method limitations.
    **/
    public function postFormat(key:String, value:Number):Number {
      var output:Number
      
      switch (key) {
        case 'ceil':
          output = Math.ceil(value)
          break
        case 'denominator':
          output = AdvancedMath.denominator(value)
          break
        case 'floor':
          output = Math.floor(value)
          break
        case 'numerator':
          output = AdvancedMath.numerator(value)
          break
        case 'round':
          output = Math.round(value)
          break
        default:
          throw new Error('Invalid post directive: ' + key)
      }
      
      return output
    }
  }
}
