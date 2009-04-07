/**
* EffectTest
*
* Class Description.
*
* Copyright (c) 2009 Parker Selbert
**/

package {
  
  import flash.display.Sprite
  import com.soren.exib.effect.Effect
  import com.soren.exib.effect.Queue
  import com.soren.exib.view.VectorNode
  
  public class EffectTest extends Sprite {

    public function EffectTest() {
      //arrayOfDots()
      effectQueuing()
    }
    
    private function arrayOfDots():void {
      var dots:Array = []
      
      var num_dots:uint = 50
      var init_x:uint = 5
      var init_y:uint = 5
      
      for (var i:int = 0; i < num_dots; i++) {
        var dot:VectorNode = new VectorNode('circle', { radius: 25 })
        dot.x = init_x
        dot.y = init_y
        init_x = (init_x < 505) ? init_x + 55 : 5
        init_y = (init_x >= 455) ? init_y + 55 : init_y
        addChild(dot)
        dots.push(dot)
      }
      
      new Effect().blur(dots, { blur_x_from: 0, blur_x_to: 16, blur_y_from: 0, blur_y_to: 16, duration: .75 })
      new Effect().slide(dots.slice(0, 10), { start_y: 5, end_y: 300, easing: 'back_in', duration: 1})
      new Effect().pulse(dots.slice(11,21), { pulse_to: .25, easing: 'linear_out', duration: .75, times: 2})
      new Effect().slide(dots.slice(22,33), { start_x: 0, end_x: 500, relative: true, duration: .5, easing: 'back_in' })
    }
    
    private function effectQueuing():void {
      var row_a:Array = []
      var row_b:Array = []
      var row_c:Array = []
      var row_d:Array = []
      var row_e:Array = []
      var row_f:Array = []
      
      var num_per_row:uint = 14
      var cir_radius:uint  = 15
      var spacing:uint = Math.round((stage.stageWidth - (num_per_row * (cir_radius * 2))) / (num_per_row - 1)) + cir_radius * 2
      
      var row_y:uint = 55
      
      for each (var row:Array in [row_a, row_b, row_c, row_d, row_e, row_f]) {
        var init_x:uint = 5
        
        for (var i:int = 0; i < num_per_row; i++) {
          addChild(new VectorNode('circle', { radius: cir_radius } ))
          getChildAt(numChildren - 1).x = init_x
          getChildAt(numChildren - 1).y = row_y
          init_x += spacing - 1
          row.push(getChildAt(numChildren - 1))
        }
        
        row_y += spacing
      }

      var queue:Queue = new Queue()
      queue.enqueue('slide', row_a, { start_x: 0, end_x: 550, relative: true, duration: .25}, true)
      queue.enqueue('blur',  row_a, { blur_x_from: 0, blur_x_to: 16, duration: .15 }, true, 50)
      queue.enqueue('slide', row_b, { start_x: 0, end_x: -550, relative: true, duration: .25}, true, 200)
      queue.enqueue('blur',  row_b, { blur_x_from: 0, blur_x_to: 16, duration: .15 }, true, 250)
      queue.enqueue('slide', row_c, { start_x: 0, end_x: 550, relative: true, duration: .25}, true, 400)
      queue.enqueue('blur',  row_c, { blur_x_from: 0, blur_x_to: 16, duration: .15 }, true, 450)
      queue.enqueue('slide', row_d, { start_x: 0, end_x: -550, relative: true, duration: .25}, true, 600)
      queue.enqueue('blur',  row_d, { blur_x_from: 0, blur_x_to: 16, duration: .15 }, true, 650)
      queue.enqueue('slide', row_e, { start_x: 0, end_x: 550, relative: true, duration: .25}, true, 800)
      
      queue.enqueue('fade', row_f,  { fade_from: 1, fade_to: .5, duration: .25, easing: 'sine_out'}, false)
      queue.enqueue('slide', row_f, { start_y: 0, end_y: -150, relative: true, duration: .5, easing: 'back_in'}, false, 250)
      queue.enqueue('blur', row_f,  { blur_y_from: 0, blur_y_to: 32, duration: .4}, false, 350)
      queue.enqueue('blur', row_f,  { blur_y_from: 32, blur_y_to: 0, duration: .25}, false, 750)
      queue.enqueue('fade', row_f,  { fade_from: .5, fade_to: 1, duration: .25, easing: 'sine_out'}, false, 1000)
      
      for (var j:int = 0; j < row_f.length; j++) {
        queue.enqueue('slide', [row_f[j]], { start_x: 0, end_x: Math.random()*200, start_y: 0, end_y: Math.random()*150, relative: true, duration: .25, easing: 'back_in'}, false, 1250)
        queue.enqueue('blur', [row_f[j]],  { blur_x_from: 0, blur_x_to: 16, blur_y_from: 0, blur_y_to: 16, duration: .25}, false, 1300)
        queue.enqueue('fade', [row_f[j]],  { fade_from: 1, fade_to: 0, duration: .25}, false, 1350)
      }
      
      queue.start()
    }
  }
}
