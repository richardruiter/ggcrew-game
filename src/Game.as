package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.ui.Mouse;
    import flash.geom.Point;

    import starling.display.Sprite;
    import starling.display.Quad;
    import starling.utils.Color;
    import starling.text.TextField;
    
    import starling.display.Image;
    import starling.textures.Texture;
    
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    import com.util.BMPFunctions;

    public class Game extends Sprite
    {
		[Embed(source = "../assets/opened_door.png")]
		private static var sketch1:Class;
		
		[Embed(source = "../assets/spraycan.png")]
		private static var spraycan:Class;
		
		private var data:BitmapData;
		private var mousecan:Image;
		private var image:Image;
		
		public var currentColor:uint = 0xFF04000E;
		private var colorArray:Array = new Array(
		    // Los Angeles
		    0xFF04000E,
		    0xFFAB1119,
		    0xFFDA505F,
		    0xFFE5E37C,
		    0xFF4EA24A,
		    // California
		    0xFF003931,
		    0xFF127561,
		    0xFF94D9E0,
		    0xFFF3C354,
		    0xFFE5B0AA
		);
		
		private var debug:TextField;
    
        public function Game()
        {
            // initial data
            data = new sketch1().bitmapData;
            
            // create image
            image = new Image(makeTexture(data));
            image.y = 30;
            image.readjustSize();
            image.addEventListener(TouchEvent.TOUCH, onImageTouch);
            addChild(image);
            
            // add color buttons
            colorButtons();
            
            // add spraycan
            //Mouse.hide();
            //mousecan = new Image(makeTexture(new spraycan().bitmapData));
            //addChild(mousecan);
            
            // debug info
            debug = new TextField(600, 40, "", "Arial", 12, Color.BLACK);
            debug.hAlign = 'left';
            debug.x = 0;
            debug.y = 560;
            addChild(debug);
            
        }

        private function setImageTexture(texture):void
        {
        
        }
        
        private function colorButtons():void
        {
            for (var i:int = 0; i < colorArray.length; i++) 
            {
                var quad:Quad = new Quad(30, 30, colorArray[i]);
                quad.x = 0+i*30;
                quad.y = 0;
                quad.addEventListener(TouchEvent.TOUCH, onColorTouch);
                addChild(quad);
            }
        }
        
        private function makeTexture(data:BitmapData):Texture
        {
            return Texture.fromBitmapData(data);
        }
        
        private function debugInfo(str:String):void
        {
             debug.text = str;    
        }
        
        private function onImageTouch(event:TouchEvent):void
        {
            // change color when clicked on white pixel
            var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
            if (touch)
            {
                var localPos:Point = touch.getLocation(this);
                var targetColor:uint = data.getPixel32(localPos.x, localPos.y);
                var tolerance:int = 127;
                if (colorArray.indexOf(targetColor) > 0)
                {
                    tolerance = 0;
                }
                if(colorArray.indexOf(targetColor) > 0 || targetColor === 0xFFFFFFFF)
                {
                    var map:Array = BMPFunctions.floodFill(data, localPos.x, localPos.y, currentColor, tolerance);
                    data = map[0];
                    image.texture = makeTexture(data);
                    image.readjustSize();
                }
            }    
            
            // move spray can on hover
            var hover:Touch = event.getTouch(this, TouchPhase.HOVER);
            if (hover)
            {
                //var hoverPos:Point = hover.getLocation(this);
                //mousecan.x = hoverPos.x;
                //mousecan.y = hoverPos.y;
            }
        }
        
        private function onColorTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
            if (touch)
            {
                var quad:Quad = event.target as Quad;
                var rgb:uint = quad.color;
                var a:int = 0xFF;
                currentColor = (a << 24) + rgb;
            }
        }
    }
}