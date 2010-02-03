/**
* A simple Z-Sorter for better 3D transformations. Adapted from Ralph Hauwert's
* SimpleZSort.
*
* @copyright Copyright (c) 2009 Soren LLC
* @author    Parker Selbert — parker@sorentwo.com
**/

package com.soren.sfx {
  
  import flash.display.DisplayObject
  import flash.display.DisplayObjectContainer
  import flash.geom.Matrix3D
  
  public class ZSort {
    
    /**
    * Sort display objects based on Z depth.
    * 
    * @param  container The DisplayObjectContiner containing the objects to be
    *                   sorted.
    **/
    public static function sortZ(container:DisplayObjectContainer):void {
      if (container != null && container.numChildren > 1) {
        
        var mainParent:DisplayObject = getMainParent(container)
        var sortArray:Array = []
        
        for (var i:int = 0; i < container.numChildren; i++) {
          var object:DisplayObject = container.getChildAt(i)
          var matrix:Matrix3D = object.transform.getRelativeMatrix3D(mainParent)
          
          if (matrix.position != undefined) {
            sortArray.push( { object: object, z: matrix.position.z } )
          }
        }
        
        var index:int = 0
        sortArray.sortOn('z', Array.NUMERIC | Array.ASCENDING)
        for each (var vo:Object in sortArray) {
          container.setChildIndex(vo.object, index ++)
        }
      }
    }
    
    /**
    * Find and return the root display object
    **/
    public static function getMainParent(container:DisplayObject):DisplayObject {
			var parent:DisplayObject = (container.parent == null) ? container : container.parent

			while(parent.parent != null) {
				parent = parent.parent
			}
			
			return parent
		}
  }
}
