package unit {

  import asunit.framework.TestCase
  import flash.events.Event
  import com.soren.debug.Log
  import com.soren.exib.core.Aggregator
  
  public class AggregatorTest extends TestCase {
    
    // Singleton, take note
    private var _aggregator:Aggregator = Aggregator.getAggregator()
    
    public function AggregatorTest(testMethod:String) {
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
        _aggregator.disableAssetTracking(Aggregator.AUDIO)
        _aggregator.disableAssetTracking(Aggregator.CONFIG)
        _aggregator.disableAssetTracking(Aggregator.GRAPHIC)
        _aggregator.disableAssetTracking(Aggregator.VIDEO)
        _aggregator.batchEnableAssets([Aggregator.AUDIO, Aggregator.CONFIG, Aggregator.GRAPHIC, Aggregator.VIDEO])
        _aggregator.batchDisableAssets([Aggregator.AUDIO, Aggregator.CONFIG, Aggregator.GRAPHIC, Aggregator.VIDEO])
        _aggregator.enableAssetTracking(Aggregator.AUDIO)
        _aggregator.enableAssetTracking(Aggregator.CONFIG)
        _aggregator.enableAssetTracking(Aggregator.GRAPHIC)
        _aggregator.enableAssetTracking(Aggregator.VIDEO)
      } catch (e:Error) {
        error = e 
      }
      
      assertNull(error)
    }
    
    public function testStatus():void {
      // It is assumed this test is running last, meaning audio, graphic, and
      // video assets have loaded.
      
      assertTrue(_aggregator.assetBytesTotal(Aggregator.AUDIO) > 0)
      assertTrue(_aggregator.assetBytesTotal(Aggregator.GRAPHIC) > 0)
      //assertTrue(_aggregator.assetBytesTotal(Aggregator.VIDEO) > 0)
      
      assertTrue(_aggregator.assetBytesLoaded(Aggregator.AUDIO) > 0)
      assertTrue(_aggregator.assetBytesLoaded(Aggregator.GRAPHIC) > 0)
      //assertTrue(_aggregator.assetBytesTotal(Aggregator.VIDEO) > 0)
      
      assertTrue(_aggregator.bytesTotal > 0)
      assertTrue(_aggregator.bytesLoaded > 0)
    }
    
    public function testEventListeners():void {
      _aggregator.addEventListener(Aggregator.AUDIO_COMPLETE, eventListener)
      _aggregator.addEventListener(Aggregator.GRAPHIC_COMPLETE, eventListener)
      _aggregator.addEventListener(Aggregator.COMPLETE, eventListener)
    }
    
    // ---
    
    private function eventListener(event:Event):void {
      Log.getLog().debug('Listener triggered: ' + event)
    }
  }
}