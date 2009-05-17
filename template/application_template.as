/**
* Project Description.
**/

package {
  
  import com.soren.exib.core.Application
  import com.soren.exib.service.Sound
  import com.soren.exib.view.GraphicNode
  import com.soren.exib.view.VideoNode
  import com.soren.util.Abbreviate
  
  public class #APPLICATION_NAME# extends Application {
    
    // EXML Embed
    [Embed(source="../assets/config/config.exml", mimeType="application/octet-stream")]
    private const ConfigEXML:Class
    
    // BEGIN AUTO EMBED
    // END AUTO EMBED
    
    /**
    * RegExp patterns used to place assets into pools (groups).
    * 
    * models = _model, services = *service, queues = +queue, media = $media,
    * formats = %format, screens = @screen
    **/
    private const POOLS:Array = [/^_\w+/, /^\*\w+/, /^\+\w+/, /^\$\w+/, /^%\w+/, /^@\w+/]
    
    public function #APPLICATION_NAME#() {
      // Asset loading nodes must have a reference to the class where assets are
      // embedded. If assets are compiled into a class other than this change
      // the embed container here.
      for each (var klass:Class in [Sound, GraphicNode, VideoNode]) {
        klass.setEmbedContainer(this)
      }
      
      // These objects will be automatically created when the application
      // launches. Change the default name of each here.
      _default_screen_name = '_screen'
      _default_effect_name = '_effect'
      _default_log_name    = '_log'
      
      // Set any custom or atypical abbreviations here.
      // Abbreviate.addAuxilliary('cups', 'c')
      
      start(ConfigEXML, POOLS)
    }
  }
}
