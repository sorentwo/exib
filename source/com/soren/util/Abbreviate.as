/**
* A utility for abbreviating words using a set of common and optional additional
* abbreviations.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.util {

  final public class Abbreviate {
    
    private static const KNOWN:Object = {
      acre:        'ac',
      barrel:      'bar',
      bushel:      'bus',
      cent:        'c',
      centimeter:  'cm',
      cup:         'c',
      degree:      'deg',
      dram:        'dr',
      franc:       'f',
      foot:        'ft',
      gallon:      'gal',
      grain:       'gr',
      hour:        'h',
      inch:        'in',
      kilogram:    'kg',
      kilometer:   'km',
      pound:       'lb',
      liter:       'ltr',
      minute:      'm',
      mile:        'mi',
      month:       'mo',
      ounce:       'oz',
      pint:        'pt',
      quarter:     'qr',
      quart:       'qt',
      second:      's',
      square:      'sq',
      yard:        'yd'
    }

    private static var AUXILLIARY:Object = {}

    /**
    * Singleton, non-used constructor.
    **/
    public function Abbreviate() {
      throw new Error('Abbreviate class is a static container only')
    }

    /**
    * Substitute a word for its abbreviation. Abbreviations are assumed to be singular,
    * and no closing punctuation is typically included.
    * 
    * @param  word  The word to abbreviate.
    * @return       If the word has a known abbreviation the abbreviation is returned,
    *               otherwise the original word.
    * 
    * @example  The following code illustrates normal usage.
    * 
    * <lsiting version='3.0'>
    * var my_words:Array = ['ounces', 'cups', 'liters']
    * 
    * // Traces out 'oz', 'c', 'ltr'
    * for each (var word:String in my_words) {
    *   trace(Abbreviate.abbreviate(word))
    * }
    * </lsiting>
    **/
    public static function abbreviate(word:String):String {
      var norm:String = word.toLowerCase()
      var abbr:String

           if (AUXILLIARY.hasOwnProperty(norm)) abbr = AUXILLIARY[norm]
      else if (KNOWN.hasOwnProperty(norm))      abbr = KNOWN[norm]

      return (abbr) ? abbr : word
    }

    /**
    * In addition to the known set of abbreviatons, additional abbreviations may be
    * added on a per-application basis.
    * 
    * @param  word  The word that will be abbreviated.
    * @param  abbr  The abbreviation to be used. Periods should not be included.
    **/
    public static function addAuxilliary(word:String, abbr:String):void {
      AUXILLIARY[word.toLowerCase()] = abbr
    }
  }
}
