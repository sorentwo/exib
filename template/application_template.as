/**
* Project Description.
**/

package {
  
  import com.soren.exib.core.Application
  
  public class #APPLICATION_NAME# extends Application {
    
    // EXML Embed
    [Embed(source="../assets/config/config.exml", mimeType="application/octet-stream")]
    private const ConfigEXML:Class
    
    // AUTO EMBEDDING
    
    // The asset location. It isn't likely these will need to be changed.
    private const ASSET_PATH:String  = '../assets'
    
    /**
    * RegExp patterns used to place assets into pools (groups).
    * 
    * models = _model, services = *service, queues = +queue, media = $media,
    * formats = %format, screens = @screen
    **/
    private const POOLS:Array = [/^_\w+/, /^\*\w+/, /^\+\w+/, /^\$\w+/, /^%\w+/, /^@\w+/]
    
    public function #APPLICATION_NAME#() {
      start(ConfigEXML, ASSET_PATH, POOLS)
    }
  }
}
