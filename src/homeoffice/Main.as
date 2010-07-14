package homeoffice {
    import org.flixel.*;
    import AssetLibrary;
    
    [SWF(width="600", height="400", backgroundColor="#000000")];

    public class Main extends FlxGame {
        public static var bgcolor:uint = 0xff000000;
        public static var library:AssetLibrary;        
        public static var instance:Main;

        [Embed(source='/../data/Antenna8.ttf', fontFamily='antenna8', embedAsCFF="false")]
        public static var Antenna8FontClass:String;
        [Embed(source='/../data/04B_03__.TTF', fontFamily='zerofourbee', embedAsCFF="false")]
        public static var ZeroFourFontClass:String;

        public static var gameFont:String;
        
        public function Main():void {
            gameFont = 'zerofourbee';
            
            Main.library = new AssetLibrary();
            Main.instance = this;
            
            super(300, 200, MenuState, 2);
            //super(300, 200, PlayState, 2);
            FlxState.bgColor = Main.bgcolor;
        }
    }
}