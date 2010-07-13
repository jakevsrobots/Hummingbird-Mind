package homeoffice {
    import org.flixel.*;
    import AssetLibrary;
    
    [SWF(width="600", height="400", backgroundColor="#000000")];

    public class Main extends FlxGame {
        public static var bgcolor:uint = 0xff000000;
        public static var library:AssetLibrary;        
        public static var instance:Main;
        
        public function Main():void {
            Main.library = new AssetLibrary();

            Main.instance = this;
            
            super(300, 200, PlayState, 2);
            FlxState.bgColor = Main.bgcolor;
        }
    }
}