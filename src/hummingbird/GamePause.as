package hummingbird {
    import org.flixel.*;
    
    public class GamePause extends FlxGroup {
		[Embed(source="/../data/key_minus.png")] private var ImgKeyMinus:Class;
		[Embed(source="/../data/key_plus.png")] private var ImgKeyPlus:Class;
		[Embed(source="/../data/key_0.png")] private var ImgKey0:Class;
		[Embed(source="/../data/key_p.png")] private var ImgKeyP:Class;
		[Embed(source="/../data/key_q.png")] private var ImgKeyQ:Class;        
        
        public function GamePause():void {
            super();

			scrollFactor.x = 0;
			scrollFactor.y = 0;
			var w:uint = 80;
			var h:uint = 106;
			x = (FlxG.width-w)/2;
			y = (FlxG.height-h)/2;
			add((new FlxSprite()).createGraphic(w,h,0xaa000000,true),true);			
			(add(new FlxText(0,0,w,"this game is"),true) as FlxText).setFormat(Main.gameFont, 8, 0xffffffff, "center");
			add((new FlxText(0,10,w,"paused")).setFormat(Main.gameFont,16,0xffffff,"center"),true);
			add(new FlxSprite(4,36,ImgKeyP),true);
			add((new FlxText(16,36,w-16,"Pause Game")).setFormat(Main.gameFont, 8, 0xffffffff, "center"),true);

			add(new FlxSprite(4,50,ImgKeyQ),true);            
			add((new FlxText(16,50,w-16,"Quit Game")).setFormat(Main.gameFont, 8, 0xffffffff, "center"),true);
            
			add(new FlxSprite(4,64,ImgKey0),true);
			add((new FlxText(16,64,w-16,"Mute Sound")).setFormat(Main.gameFont, 8, 0xffffffff, "center"),true);
			add(new FlxSprite(4,78,ImgKeyMinus),true);
			add((new FlxText(16,78,w-16,"Sound Down")).setFormat(Main.gameFont, 8, 0xffffffff, "center"),true);
			add(new FlxSprite(4,92,ImgKeyPlus),true);
			add((new FlxText(16,92,w-16,"Sound Up")).setFormat(Main.gameFont, 8, 0xffffffff, "center"),true);
        }
    }
}