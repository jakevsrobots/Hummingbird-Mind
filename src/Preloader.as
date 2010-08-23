package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;    
	import org.flixel.FlxPreloader;
    import org.flixel.FlxG;
    import org.flixel.FlxU;
    
	public class Preloader extends FlxPreloader {
        [Embed(source="/../data/preloader-bg.png")] protected var BackgroundImage:Class;
		public function Preloader():void {
			super();
			className = "hummingbird.Main";
            //minDisplayTime = 10;
		}

        override protected function create():void {
			_min = 0;
			if(!FlxG.debug)
				_min = minDisplayTime*1000;
			_buffer = new Sprite();
			_buffer.scaleX = 1;
			_buffer.scaleY = 1;
			addChild(_buffer);
			_width = stage.stageWidth/_buffer.scaleX;
			_height = stage.stageHeight/_buffer.scaleY;
			_buffer.addChild(new Bitmap(new BitmapData(_width,_height,false,0xffffff)));
			var b:Bitmap = new ImgLogoLight();
			b.smoothing = true;
			b.width = b.height = _height;
			b.x = (_width-b.width)/2;
			//_buffer.addChild(b);
			_bmpBar = new Bitmap(new BitmapData(1,7,false,0x14151c));
			_bmpBar.x = 4;
			_bmpBar.y = _height-11;
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat("system",8,0xffffff);
			_text.embedFonts = true;
			_text.selectable = false;
			_text.multiline = false;
			_text.x = 2;
			_text.y = _bmpBar.y - 11;
			_text.width = _width;
			_logo = new BackgroundImage();
			_logo.scaleX = _logo.scaleY = 2; //_height/8;
			_logo.x = (_width-_logo.width)/2;
			_logo.y = (_height-_logo.height)/2;
            
			_logoGlow = new ImgLogo();
			_logoGlow.smoothing = true;
			_logoGlow.blendMode = "screen";
			_logoGlow.scaleX = _logoGlow.scaleY = _height/8;
			_logoGlow.x = (_width-_logoGlow.width)/2;
			_logoGlow.y = (_height-_logoGlow.height)/2;
            
			_buffer.addChild(_logo);
			_buffer.addChild(_bmpBar);
			_buffer.addChild(_text);
			//_buffer.addChild(_logoGlow);
            
			b = new ImgLogoCorners();
			b.smoothing = true;
			b.width = _width;
			b.height = _height;
			//_buffer.addChild(b);
			b = new Bitmap(new BitmapData(_width,_height,false,0xffffff));
			var i:uint = 0;
			var j:uint = 0;
			while(i < _height)
			{
				j = 0;
				while(j < _width)
					b.bitmapData.setPixel(j++,i,0);
				i+=2;
			}
			b.blendMode = "overlay";
			b.alpha = 0.25;
			//_buffer.addChild(b);
        }

		override protected function update(Percent:Number):void {
			_bmpBar.scaleX = Percent*(_width-8);
			_text.text = "LOADING: "+FlxU.floor(Percent*100)+"%";
			_text.setTextFormat(_text.defaultTextFormat);
		}
	}
}