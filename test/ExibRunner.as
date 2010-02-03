package {
  import asunit.textui.TestRunner
  import com.soren.sfx.Tween
  
  public class ExibRunner extends TestRunner {
    
    public function ExibRunner() {
      
      Tween.getInstance().registerStage(this.stage)
      
      start(UnitTests, null, TestRunner.SHOW_TRACE)
    }
  }
}