package unit {

  import asunit.framework.TestCase
  import flash.events.Event
  import com.soren.debug.Log
  import com.soren.exib.core.Preloader
  
  public class PreloaderTest extends TestCase {
    
    // Singleton, take note
    private var _preloader:Preloader = Preloader.getPreloader()
    
    public function PreloaderTest(testMethod:String) {
      super(testMethod)
    }

    /**
    * Prepare for test, create instance of class that we are testing.
    * Invoked by TestCase.runMethod function.
    **/
    protected override function setUp():void { }

    /**
    * Clean up after test, delete instance of class that we were testing.
    **/
    protected override function tearDown():void { }
    
    // ---
    
    public function testConfigurate():void {
      var error:Error
      
      // Just tossing the disable/enable methods around, no real outcome
      try {
        _preloader.disableAssetTracking(Preloader.AUDIO)
        _preloader.disableAssetTracking(Preloader.CONFIG)
        _preloader.disableAssetTracking(Preloader.GRAPHIC)
        _preloader.disableAssetTracking(Preloader.VIDEO)
        _preloader.batchEnableAssets([Preloader.AUDIO, Preloader.CONFIG, Preloader.GRAPHIC, Preloader.VIDEO])
        _preloader.batchDisableAssets([Preloader.AUDIO, Preloader.CONFIG, Preloader.GRAPHIC, Preloader.VIDEO])
        _preloader.enableAssetTracking(Preloader.AUDIO)
        _preloader.enableAssetTracking(Preloader.CONFIG)
        _preloader.enableAssetTracking(Preloader.GRAPHIC)
        _preloader.enableAssetTracking(Preloader.VIDEO)
      } catch (e:Error) {
        error = e 
      }
      
      assertNull(error)
    }
    
    public function testStatus():void {
      // It is assumed this test is running last, meaning audio, graphic, and
      // video assets have loaded.
      
      assertTrue(_preloader.assetBytesTotal(Preloader.AUDIO) > 0)
      assertTrue(_preloader.assetBytesTotal(Preloader.GRAPHIC) > 0)
      //assertTrue(_preloader.assetBytesTotal(Preloader.VIDEO) > 0)
      
      assertTrue(_preloader.assetBytesLoaded(Preloader.AUDIO) > 0)
      assertTrue(_preloader.assetBytesLoaded(Preloader.GRAPHIC) > 0)
      //assertTrue(_preloader.assetBytesTotal(Preloader.VIDEO) > 0)
      
      assertTrue(_preloader.bytesTotal > 0)
      assertTrue(_preloader.bytesLoaded > 0)
    }
    
    public function testEventListeners():void {
      _preloader.addEventListener(Preloader.AUDIO_COMPLETE, eventListener)
      _preloader.addEventListener(Preloader.GRAPHIC_COMPLETE, eventListener)
      _preloader.addEventListener(Preloader.COMPLETE, eventListener)
    }
    
    // ---
    
    private function eventListener(event:Event):void {
      Log.getLog().debug('Listener triggered: ' + event)
    }
  }
}