/**
* Customizable preloader class.
**/

package {

  import flash.display.DisplayObject
  import flash.display.MovieClip
  import flash.events.Event
  import flash.utils.getDefinitionByName
  
  // SWF Metadata
  [SWF(width='800', height='600', backgroundColor='#333333', frameRate='30')]
  
  public class Factory extends MovieClip {

    public function Factory() {
      stop()
      addEventListener(Event.ENTER_FRAME, onEnterFrame)
    }
    
    // ---
    
    private function onEnterFrame(event:Event):void {
      if (this.framesLoaded == this.totalFrames) {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame)
        nextFrame()
        init()
      } else {
        var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal
        graphics.beginFill(0)
        graphics.drawRect(0, (stage.stageHeight * .5) - 10, stage.stageWidth * percent, 20)
        graphics.endFill()
      }
    }
    
    private function init():void {
      var mainClass:Class = Class(getDefinitionByName("#APPLICATION_NAME#"))
      
      if (mainClass) {
        var application:Object = new mainClass()
        addChild(application as DisplayObject)
      }
    }
  }
}
