# EXIB (Extended Interface Builder)
### Project API

---

## Models

### State

    <state id='name' def='value-b' states='value-a, value-b' />
    
State models are the backbone of every interface. They are used to track a *fixed* set of values, or states. Note the term 'fixed' — every possible state for a state model to have must be defined before the simulation is compiled. They are static objects, not dynamic. Lets use a simple example to illustrate the primary reason for this.

    <!-- About the most basic state model possible -->
    <state id='power' states='on, off' />
    
    <!-- Modes and cycles are a primary use of a state model -->
    <state id='cycle' states='normal, heavy load, whitest whites' />
    
    <!-- State model representing a light, the default state is auto -->
    <state id='light_mode' def='auto' states='on, off, auto' />

In this example a state model representing the light mode for an appliance has three possible states: on, off and auto. During the simulation if a controller were able to set the model to 'ato' there would now be an additional incorrect state which would probably introduce a rather confusing bug as nothing referencing the light model expected an 'ato' value. Because of this situation EXIB will check every value that is going to be assigned to a model and throws an error if it doesn't match one that the model already has.

**State Attributes:**  

----------- | ------------------------------------------------------------------
id          | Unique identifier
def         | Optionally specifies a default state, first used if omitted
states      | List of all the available state values
wrap        | True or false, default is true. Cycles from the last value if true

**Available Methods:**  

add(state)
:   Add an additional state to the model

next
:   Changes to the next state in the list. If `wrap` is true and the
    current state is _last_ in the list then the state is set to the _first_ in
    the list.

previous
:   Changes to the previous state in the list. If `wrap` is true and the current
    state is the _first_ in the list then the state is set to the _last_ in the
    list.

remove(state)
:   Remove an existing state from the model

reset
:   Return the model to the default state. If no default, `def`, was specified 
    then it returns to the first state in the list.

set(state)
:   Set the model to any valid state


### Value

    <value id='name' def='value' range='min..max' />

A value model stores _numerical_ values within a specified range. Any integer or float value within the range is valid.

    <!-- Temperature -->
    <value id='temp' def='98' range='92..105' />
    
    <!-- A freezer temperature model -->
    <value id='freezer_temp' def='0' range='-4..7' />
    
    <!-- Psuedo fractions, keeping proper -->
    <value id='fraction' def='.5' range='0..1' />
    
    <!-- Floats are problematic, but may be used -->
    <value id='measurement' def='.375' range='.25..2.5' />
    
    <!-- Unbound. Possible, but there isn't usually reason for it -->
    <value id='mobius' def='1000' range='0..i' />

Note in the examples that negative numbers, floating point numbers, and infinity (shown with the letter 'i') may be used to set the value range.

**Value Attributes:**  

----------- | ------------------------------------------------------------------
id          | Unique identifier
def         | The initial value of the model. Required, unlike a state model
range       | Sets the upper and lower bounds of the model.

**Available Methods:**  

change(amount)
:     Change the model's value by the amount specified. Positive and negative
      amounts are possible

reset
:     Set the model's value back to that when it was created

set(value)
:     Sets the model to the value specified, if that value is within the valid  
      range

### Clock

    <clock id='name' start='year, month, day, hour, minute, second' />

A clock model is a simple Time and Date object. Time is stored internally as milliseconds. By default a clock object will instantiate at the current system time.
    
**Example**
    
    <!-- Just the current time -->
    <clock id='current_time' />
    
    <!-- Time: December 25th, 2008 at 8:10:30 am -->
    <clock id='system_clock' start='2008, 12, 25, 8, 10, 30' />
    
    <!-- Time: December 25th, 2008 at +current time+ -->
    <clock id='system_clock' start='2008, 12, 25' />
    
    <!-- A mixture is also possible -->
    <clock id='system_clock' start='2008, , 25, , 10' />

This example shows the default time (current) being overridden and set to fixed times. Any value not set will be left as the current system time.

**Clock Attributes:**  

----------- | ------------------------------------------------------------------
id          | Unique identifier
start       | Comma separated list of initial values

**Available Methods:**  

changeYear(amount)
:

changeMonth(amount)
:

changeDate(amount)
:

changeHours(amount)
:

changeMinutes(amount)
:

changeSeconds(amount)
:

cycleMeridian(amount)
:

reset
:

set(year, month, date, hour, minute, second)
:   Set a new clock value using the 'year, month, date, hour, minute, second' 
    format.

setYear(value)
:

setMonth(value)
:

setDate(value)
:

setHours(value)
:

setMinutes(value)
:

setSeconds(value)
:

setMeridian(meridian)
:

update
:

### Preset

    <preset id='name'>
      <model id='name' value='value-a' blacklist='value-c, value-d' />
    </preset>

Preset models are used to control the state of other models. This allows multiple models to be changed simultaneously to a specified value, or to save the current value for retrieval later. Think of a radio station preset in a car, except that rather than only storing one value (the radio station, in this example), you can store as many values as you like — volume, bass, equalizer, etc.

**Example**

    <!-- The models that will be stored / changed -->
    <state id='band'   def='fm'   states='am, fm' />
    <value id='freq'   def='91.5' range='96..107' />
    <value id='volume' def='11'   range='0..20' />
    
    <!-- Now the preset -->
    <preset id='station_01'>
      <model id='band'   value='fm' />
      <model id='freq'   value='104.5' />
      <model id='volume' value='18' />
    </preset>

In the previous example there are three models being tracked, 'band', 'freq' and 'volume.' Each is declared independently, and then referenced with a particular value within the preset. When the preset is loaded it will set each of the three models to the value it has stored. Presets can also be saved over.

**Preset Attributes:**  
----------- | ------------------------------------------------------------------
id          | Unique identifier

**Model Attributes:**

----------- | ------------------------------------------------------------------
id          | Reference to a state or value model's id
value       | The initial value to be loaded  
blacklist   | Comma-separated list of explicitly forbidden values. (State Only)
bounds      | The valid range for values (Value Only)

**Available Methods:**  

save
:   Store the current value of the model referenced

load
:   Set the value of each referenced model to that currently stored by the 
    preset

reset
:
   
watch
:

---

## Effects

This is a rather quick and dirty bit of documentation. My apologies.

**Examples**
    
    <!-- Syntax: effect.effect_name([selectors], { options }) -->
    effect.blur([id, .group], { blur_x_from: 0, blur_x_to: 16 })
    effect.fade([id, .group], { fade_from: 1, fade_to: 0, duration: 1 })
    effect.hide([id, .group])
    effect.move([id, .group], { x: 10, y: 5, relative: true })
    effect.pulse([id, .group], { pulse_from: 1, pulse_to: .5, times: 6 })
    effect.show([id, .group])
    effect.slide([id, .group], { start_x: 10, end_x: 100 })

**Blur Options:**
------------|-------------------------------------------------------------------
blur_x_from | Value from 0 to 64 (Exponents of 2 are optimized)
blur_x_to   | Value from 0 to 64 (Exponents of 2 are optimized)
blur_y_from | Value from 0 to 64 (Exponents of 2 are optimized)
blur_y_to   | Value from 0 to 64 (Exponents of 2 are optimized)
duration    | Time of the effect in seconds. (.1, .5, 1, 3, 10 etc)
easing      | One of the easing options (See Easing)

**Fade Options:**
------------|-------------------------------------------------------------------
duration    | Time of the effect in seconds. (.1, .5, 1, 3, 10 etc)
easing      | One of the easing options (See Easing)
fade_from   | Value from 0 to 1
fade_to     | Value from 0 to 1

**Move Options:**
------------|-------------------------------------------------------------------
relative    | true or false, whether the movement will be absolute or relative
x           | The x coordinate to move to
y           | The y coordinate to move to

**Pulse Options:**
------------|-------------------------------------------------------------------
duration    | Time of the effect in seconds. (.1, .5, 1, 3, 10 etc)
easing      | One of the easing options (See Easing)
pulse_from  | Value from 0 to 1
pulse_to    | Value from 0 to 1
times       | How many times it will pulse. Even numbers will return to the original value

**Slide Options:**
------------|-------------------------------------------------------------------
duration    | Time of the effect in seconds. (.1, .5, 1, 3, 10 etc)
easing      | One of the easing options (See Easing)
end_x       | The final x coordinate, offset if relative is <code>true</code>
end_y       | The final y coordinate, offset if relative is <code>true</code>
relative    | true or false, whether the movement will be absolute or relative
start_x     | The initial x coordinate, offset if relative is <code>true</code>
start_y     | The initial x coordinate, offset if relative is <code>true</code>

### Easing

The easing options available are:

Back:   back_in, back_out, back_in_out
Bounce: bounce_in, bounce_out, bounce_in_out
Linear: linear_in, linear_out, linear_in_out
Quint:  quint_in, quint_out, quint_in_out
Sine:   sine_in, sine_out, sine_in_out

---

## Text

The text node provides a variety of complex string manipulation tools, most of
which are harvested from common language paradigms like tr and sprintf.

**Character Case: lust(%s), value**
  
  * l — Lowercase
  * u — Uppercase
  * s — Sentence case
  * t — Title case

**Conversion: (%{ceEdfIklOu}c), value**

  * c — Convert from Fahrenheit to Celsisu
  * f — Convert from Celsius to Fahrenheit
  * u — Convert from Ounces to Cups   
  * l — Convert from Ounces to Liters
  * d — Convert to Dec (divide by 10)
  * e — Convert to Cent (divide by 100)
  * k — Convert to Kil (divide by 1000)
  * O — Convert seconds to hours only, no remainder
  * I — Convert seconds to minutes only, no remainder
  * E — Convert seconds to only the seconds remaining after hours and minutes are extracted

**Date: (%{AaBbDgHhMmpPSYy}t), date**

  * D — Date, 0-31
  * g — Day of the week as a number, 0 = Sunday
  * a — Short day name, Sun-Sat
  * A — Long day name, Sunday-Saturday
  * y — Two digit year, 09
  * Y — Full year, 2009
  * m — Month as a number, 0 = January
  * b — Short month name, Jan
  * B — Long month name, January
  * h — Standard time hour, 1-12
  * H — Military time hour, 0-23
  * p — The meridian, am or pm
  * M — Minutes, 0-59
  * S — Seconds, 0-59
  
**Transposition: (%{/word/replace/}r), value**

  Replaces whatever is specified as the input string with that which is specified in the output string. Replacement is global, meaning it will replace every occurrence.