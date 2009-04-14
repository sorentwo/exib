/**
* IEvaluatable
*
* Aims to be a binder for any classes that are expected to return a value,
* a property that is typically the realm of models.
*
* Copyright (c) 2009 Parker Selbert
**/

package com.soren.exib.core {

  public interface IEvaluatable {
    function get value():*
  }
}
