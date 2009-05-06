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

    public static const TOKEN_VARIABLE_MISMATCH:String    = "Number of variables and tokens don't match"
    public static const NO_VALID_FORMAT_TOKENS:String     = "No valid format tokens were found"
    public static const NO_VALID_DATE_TOKENS:String       = "No valid date tokens were found"
    public static const NO_VALID_CONVERSION_TOKENS:String = "No valid conversion tokens were found"
    public static const INVALID_DATE_OBJECT:String        = "Supplied is not a valid Date object"
    
    // Case Constants
    private static const LOWER:uint    = 0
    private static const UPPER:uint    = 1
    private static const SENTENCE:uint = 2
    private static const TITLE:uint    = 3
    
    // sprintf base tokens
    private static const FORMAT_TOKENS:String      = 'acdfrst'
    private static const CONVERSION_TOKEN:String   = 'c'
    private static const DATE_TOKEN:String         = 't'
    private static const FLOAT_TOKEN:String        = 'f'
    private static const INTEGER_TOKEN:String      = 'd'
    private static const REPLACEMENT_TOKEN:String  = 'r'
    private static const STRING_TOKEN:String       = 's'

    // sprintf date formatting tokens
    // Valid date formats must be contained in the master "DATE_TOKENS" string
    private static const DATE_TOKENS:String            = 'AaBbDgHhMmpPSYy'
    private static const DATE_DATE_TOKEN:String        = 'D'
    private static const DATE_DAY_TOKEN:String         = 'g'
    private static const DATE_DAY_SHORT_TOKEN:String   = 'a'
    private static const DATE_DAY_LONG_TOKEN:String    = 'A'
    private static const DATE_YEAR_TOKEN:String        = 'y'
    private static const DATE_FULLYEAR_TOKEN:String    = 'Y'
    private static const DATE_MONTH_TOKEN:String       = 'm'
    private static const DATE_MONTH_SHORT_TOKEN:String = 'b'
    private static const DATE_MONTH_LONG_TOKEN:String  = 'B'
    private static const DATE_HOUR_TOKEN:String        = 'h'
    private static const DATE_HOUR24_TOKEN:String      = 'H'
    private static const DATE_AMPM_TOKEN:String        = 'p'
    private static const DATE_MINUTES_TOKEN:String     = 'M'
    private static const DATE_SECONDS_TOKEN:String     = 'S'

    // convs formatting tokens
    private static const CONVERSION_TOKENS:String        = 'CceEdfFIklNORu'
    private static const CONVERT_CELSIUS_TOKEN:String    = 'c'
    private static const CONVERT_FAHRENHEIT_TOKEN:String = 'f'
    private static const CONVERT_CUPS_TOKEN:String       = 'u'
    private static const CONVERT_LITRES_TOKEN:String     = 'l'
    private static const CONVERT_TO_D:String             = 'd'
    private static const CONVERT_TO_C:String             = 'e'
    private static const CONVERT_TO_K:String             = 'k'
    private static const CONVERT_MOD_HOURS:String        = 'O'
    private static const CONVERT_MOD_MINUTES:String      = 'I'
    private static const CONVERT_MOD_SECONDS:String      = 'E'
    
    // temporary conv formatting for fractions
    private static const CONVERT_DENOMINATOR:String = 'C'
    private static const CONVERT_NUMERATOR:String   = 'N'
    private static const CONVERT_ROUND:String       = 'R'
    private static const CONVERT_FLOOR:String       = 'F'
    
    // Sprintf regex and sections.
    private static const CONVERSION_RE:String = "(\\{(?P<conversion_token>[" + CONVERSION_TOKENS + "]{1})\\})?"
    private static const DATE_RE:String       = "(\\{(?P<date_token>[" + DATE_TOKENS +"]{1})\\})?"
    private static const TRANSPOSE_RE:String  = "(\\{(?P<tr_token>\\/.*\\/.*\\/)\\})?"
    private static const PADDING_RE:String    = "(?P<padding>0[0-9])?"
    private static const PRECISION_RE:String  = "(\\.(?P<precision>[0-9]))?"
    private static const FORMAT_RE:String     = "(?P<format_token>[" + FORMAT_TOKENS + "])"
    
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
    * @return The replaced string.
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
    * Flexibile and powerful token replacement system based largely on traditional
    * sprintf tools (Perl, Ruby, C), but expanded to allow for conversions as well.
    * @param    raw   The input string containing content to be formatted
    * @param    args  Overloadable argument set. Pass in a comma-delimited set of
    *                 strings of model references to be interpreted and replaced.
    * @return   The formatted string containing all replaced values
    **/
    public static function sprintf(raw:String, ...args):String {
      args = new ExtendedArray(args).flatten()

      var matches:Array = []
      var sprintf:RegExp = new RegExp('%' + PADDING_RE + CONVERSION_RE + DATE_RE +
                                      TRANSPOSE_RE + PRECISION_RE + FORMAT_RE, 'g')
                                      
      var result:Object = sprintf.exec(raw)

      while (result) {
        var conversion_token:String = result.conversion_token.replace(/\{|\}/, '')
        var date_token:String       = result.date_token.replace(/\{|\}/, '')
        var tr_token:String         = result.tr_token.replace(/\{|\}/, '')
        var format_token:String     = result.format_token

        if (result.padding)   var padding:uint   = uint(result.padding)
        if (result.precision) var precision:uint = uint(result.precision)

        var match:Object = { start:   result.index,
                             length:  String(result[0]).length,
                             end:     result.index + String(result[0]).length,
                             content: result[0]
                            }

        var replacement:*
        try {
          replacement = args[matches.length]
        } catch (e:Error) {
          throw new Error(TOKEN_VARIABLE_MISMATCH)
        }

        // Replacement Switches
        switch (format_token) {
          case STRING_TOKEN:
            match.replacement = replacement.toString()
            break
          case FLOAT_TOKEN:
            match.replacement = Pad.padFloat(replacement, precision)
            break
          case INTEGER_TOKEN:
            match.replacement = int(replacement)
            break
          case REPLACEMENT_TOKEN:
            match.replacement = tr(tr_token, replacement)
            break
          case DATE_TOKEN:
            if (!(replacement is Date)) {
              throw new Error(INVALID_DATE_OBJECT)
            }

            switch (date_token) {
              case DATE_DATE_TOKEN:
                match.replacement = replacement.date
                break
              case DATE_DAY_TOKEN:
                match.replacement = replacement.day
                break
              case DATE_DAY_SHORT_TOKEN:
                match.replacement = ConversionUtil.dayName(replacement.day, true)
                break
              case DATE_DAY_LONG_TOKEN:
                match.replacement = ConversionUtil.dayName(replacement.day, false)
                break
              case DATE_FULLYEAR_TOKEN:
                match.replacement = replacement.fullYear
                break
              case DATE_YEAR_TOKEN:
                match.replacement = replacement.fullYear.toString().substr(2,2)
                break
              case DATE_MONTH_TOKEN:
                match.replacement = replacement.month + 1
                break
              case DATE_MONTH_SHORT_TOKEN:
                match.replacement = ConversionUtil.monthName(replacement.month, true)
                break
              case DATE_MONTH_LONG_TOKEN:
                match.replacement = ConversionUtil.monthName(replacement.month, false)
                break
              case DATE_HOUR24_TOKEN:
                match.replacement = replacement.hours
                break
              case DATE_HOUR_TOKEN:
                var mil:uint      = replacement.hours
                var standard:uint = (mil <= 12) ? mil : (mil - 12)
                if (standard == 0) { standard = 12 }
                match.replacement = standard.toString()
                break
              case DATE_AMPM_TOKEN:
                match.replacement = (replacement.hours >= 12) ? "pm" : "am"
                break
              case DATE_MINUTES_TOKEN:
                match.replacement = replacement.minutes
                break
              case DATE_SECONDS_TOKEN:
                match.replacement = replacement.seconds
                break
              default:
                throw new Error(NO_VALID_DATE_TOKENS)
            }

            break
          case CONVERSION_TOKEN:
            switch (conversion_token) {
              case CONVERT_CELSIUS_TOKEN:
                match.replacement = ConversionUtil.toCelsius(replacement)
                break
              case CONVERT_FAHRENHEIT_TOKEN:
                match.replacement = ConversionUtil.toFahrenheit(replacement)
                break
              case CONVERT_CUPS_TOKEN:
                match.replacement = ConversionUtil.toCups(replacement)
                break
              case CONVERT_LITRES_TOKEN:
                match.replacement = ConversionUtil.toLitres(replacement)
                break
              case CONVERT_TO_D:
                match.replacement = ConversionUtil.toD(replacement)
                break
              case CONVERT_TO_C:
                match.replacement = ConversionUtil.toC(replacement)
                break
              case CONVERT_TO_K:
                match.replacement = ConversionUtil.toK(replacement)
                break
              case CONVERT_MOD_HOURS:
                match.replacement = TimeUtil.modHours(replacement)
                break
              case CONVERT_MOD_MINUTES:
                match.replacement = TimeUtil.modMinutes(replacement)
                break
              case CONVERT_MOD_SECONDS:
                match.replacement = TimeUtil.modSeconds(replacement)
                break
              case CONVERT_DENOMINATOR:
                match.replacement = AdvancedMath.denominator(Number(ConversionUtil.toCups(replacement)))
                break
              case CONVERT_NUMERATOR:
                match.replacement = AdvancedMath.numerator(Number(ConversionUtil.toCups(replacement)))
                break
              case CONVERT_ROUND:
                match.replacement = Math.round(replacement)
                break
              case CONVERT_FLOOR:
                match.replacement = Math.floor(Number(ConversionUtil.toCups(replacement)))
                break
              default:
                throw new Error(NO_VALID_CONVERSION_TOKENS)
            }

            break
          default:
            throw new Error(NO_VALID_FORMAT_TOKENS)
        }
        
        if (Boolean(padding)) match.replacement = Pad.zeroPad(match.replacement, padding)
        
        matches.push(match)
        result = sprintf.exec(raw)
      }

      // Return either the initial unsubstituted string, or our replacement
      if (matches.length == 0) return raw

      var output:String = raw
      for each (match in matches) {
        output = output.replace(match.content, match.replacement)
      }

      return output
    }
  }
}
