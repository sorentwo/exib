/**
* Static utility class for converting between units of weight, volume, prefixes,
* temperature etc.
*
* Copyright (c) 2008 Parker Selbert
**/

package com.soren.util {

  public class ConversionUtil {

    public static const DEFAULT_ACCURACY:uint = 1
    
    // Volume keys and table
    public static const CUBIC_FEET:uint  = 0
    public static const CUBIC_METER:uint = 1
    public static const CUP:uint         = 2
    public static const GALLON:uint      = 3
    public static const LITER:uint       = 4
    public static const OUNCE:uint       = 5
    public static const PINT:uint        = 6
    public static const QUART:uint       = 7
    public static const TABLESPOON:uint  = 8
    public static const TEASPOON:uint    = 9
    
    public static const VOLUME:Array = [
      [1,       0.02832,  19.6883,    7.4805,   28.3168,  957.5065,   59.8442,    29.9221,    1915.013,   5745.039  ],
      [35.3147, 1,        4226.7528,  264.1721, 1000,     33814.023,  2113.3764,  1056.6882,  67628.045,  202884.14 ],
      [0.00836, 0.00024,  1,          0.0625,   0.2365,   8,          0.5,        0.25,       16,         48        ],
      [0.1337,  0.0038,   16,         1,        3.7854,   128,        8,          4,          256,        768       ],
      [0.0353,  0.001,    4.2268,     0.2642,   1,        33.8140,    2.1134,     1.0567,     67.6280,    202.8841  ],
      [0.00104, 2.9574,   0.125,      0.0078,   0.0296,   1,          0.0625,     0.0313,     2,          6         ],
      [0.0167,  0.0005,   2,          0.125,    0.4732,   16,         1,          0.5,        32,         96        ],
      [0.0334,  0.0009,   4,          0.25,     0.9464,   32,         2,          1,          64,         192       ],
      [0.0005,  1.4787,   0.0625,     0.0039,   0.0148,   0.5,        0.0314,     0.0156,     1,          3         ],
      [0.0002,  4.9289,   0.0208,     0.0013,   0.0049,   0.1667,     0.0104,     0.0052,     0.3333,     1         ]
    ]
    
    // Prefix keys and table
    public static const MEGA:uint  = 0
    public static const KILO:uint  = 1
    public static const HECTO:uint = 2
    public static const DEKA:uint  = 3
    public static const ONE:uint   = 4
    public static const DECI:uint  = 5
    public static const CENTI:uint = 6
    public static const MILLI:uint = 7
    public static const MICRO:uint = 8

    public static const PREFIX:Array = [
      [1,           1000,     10000,      100000,    10000,   10000000, 100000000,  1e+9,    1e+12     ],
      [0.001,       1,        10,         100,       1000,    10000,    100000,     1000000, 1000000000],
      [0.0001,      0.1,      1,          10,        100,     1000,     10000,      100000,  100000000 ],
      [0.00001,     0.01,     0.1,        1,         10,      100,      1000,       10000,   10000000  ],
      [0.000001,    0.001,    0.01,       0.1,       1,       10,       100,        1000,    1000000   ],
      [0.0000001,   0.0001,   0.001,      0.01,      0.1,     1,        10,         100,     100000    ],
      [0.00000001,  0.00001,  0.0001,     0.001,     0.01,    0.1,      1,          10,      10000     ],
      [1e-9,        0.000001, 0.00001,    0.0001,    0.001,   0.01,     0.1,        1,       1000      ],
      [1e-12,       1e-9,     0.00000001, 0.0000001, 0.00001, 0.00001,  0.0001,     0.001,   1]
    ]
    
    // Temperature keys
    public static const KELVIN:uint     = 0
    public static const CELCIUS:uint    = 1
    public static const FAHRENHEIT:uint = 2
    
    /**
    * This is a static container class only, it can not be constructed.
    **/
    public function ConversionUtil() {
      throw new Error('ConversionUtil class is a static container only')
    }
    
    /**
    * Convert a unit of volume to another unit of volume.
    * 
    * @param  a     The unit to convert from. It must be an unsigned integer
    *               from the volume constants.
    * @param  b     The volume to convert to.  It must be an unsigned integer
    *               from the volume constants.
    * @param  v     The value to convert.
    *               
    * @throws Error If <code>a</code> or <code>b</code> is not a valid unit key.
    * 
    * @return   The converted volume.
    * 
    * @example  The following code illustrates several volume conversions.
    *
    * <listing version="3.0">
    * var ounces:Number  = 16
    * var gallons:Number = ConversionUtil.convertVolume(ConversionUtil.OUNCE, ConversionUtil.GALLON, ounces)
    * trace(gallons) // Yields 0.125
    * 
    * var liters:Number = ConversionUtil.convertVolume(ConversionUtil.OUNCE, ConversionUtil.LITER, ounces)
    * trace(liters)  // Yields 0.47317647
    * </listing>
    **/
    public static function convertVolume(a:uint, b:uint, v:Number):Number {
      for each (var unit:uint in [a, b]) {
        if (unit < 0 || unit > VOLUME.length) {
          throw new Error('Unit key: ' + unit + ' is out of range.')
        }
      }
      
      return v * VOLUME[a][b]
    }
    
    /**
    * Convert a metric prefix to another metric prefix.
    * 
    * @param  a The prefix to convert from. Value should be one of the prefix
    *           constants.
    * @param  b The prefix to convert from. Value should be one of the prefix
    *           constants.
    * @param  v The value to convert.
    * 
    * @throws Error If <code>a</code> or <code>b</code> is not a valid prefix key.
    * 
    * @return   The converted value.
    * 
    * @example  The following code illustrates a prefix conversion.
    * 
    * <listing version="3.0">
    * // Yields 1000000000000
    * trace(ConversionUtil.convertPrefix(ConversionUtil.KILO, ConversionUtil.MICRO, 1000))
    *
    * // Yields 0.72
    * trace(ConversionUtil.convertPrefix(ConversionUtil.ONE, ConversionUtil.HECTO, 72))
    * </listing>
    **/
    public static function convertPrefix(a:uint, b:uint, v:Number):Number {
      for each (var prefix:Object in [a, b]) {
        if (prefix < 0 || prefix > PREFIX.length) {
          throw new Error('Prefix key: ' + prefix + ' is out of range.')
        }
      }
      
      return v * PREFIX[a][b]
    }
    
    /**
    * Convert between temperature scales. Can convert between Fahrenheit, Celcius,
    * and Kelvin.
    * 
    * @param  a The scale to convert from. Value should be one of the temperature
    *           constants.
    * @param  b The scale to convert from. Value should be one of the temperature
    *           constants.
    * @param  v The value to convert.
    * 
    * @throws Error If <code>a</code> or <code>b</code> is not a valid temperature key.
    * 
    * @example  The following code illustrates several temperature conversions.
    * 
    * <listing version='3.0'>
    * // Yields 37
    * var body_temperature_kelvin:uint = 310
    * trace(ConversionUtil.convertTemperature(ConversionUtil.KELVIN, ConversionUtil.CELCIUS, body_temperature_kelvin))
    * 
    * // Yields 32
    * var water_freezes_celcius:uint = 0
    * trace(ConversionUtil.convertTemperature(ConversionUtil.CELCIUS, ConversionUtil.FAHRENHEIT, water_freezes_celcius))
    * </listing>
    **/
    public static function convertTemperature(a:uint, b:uint, v:Number):Number {
      for each (var scale:uint in [a, b]) {
        if (scale < 0 || scale > 2) {
          throw new Error('Scale key: ' + scale + ' is out of range.')
        }
      }
      
      var converted:Number
      
      if (a == KELVIN) {
             if (b == KELVIN)     { converted = v                        }
        else if (b == CELCIUS)    { converted = v - 273                  }
        else if (b == FAHRENHEIT) { converted = ((v - 273) * 9 / 5) + 32 }
      }
      
      if (a == CELCIUS) {
             if (b == KELVIN)     { converted = v + 273          }
        else if (b == CELCIUS)    { converted = v                }
        else if (b == FAHRENHEIT) { converted = (v * 9 / 5) + 32 }
      }
      
      if (a == FAHRENHEIT) {
             if (b == KELVIN)     { converted = ((v - 273) * 9 / 5) + 32 }
        else if (b == CELCIUS)    { converted = (v - 32) * 5 / 9         }
        else if (b == FAHRENHEIT) { converted = v                        }
      }
      
      return converted
    }
  }
}
