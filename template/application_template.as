/**
* Project Description.
**/

package {
  
  import com.soren.exib.core.Application
  import com.soren.exib.view.GraphicNode
  
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
      GraphicNode.setEmbedContainer(this)
      
      start(ConfigEXML, POOLS)
    }
  }
}
