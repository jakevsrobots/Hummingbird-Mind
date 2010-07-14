package homeoffice {
    import org.flixel.*;
    
    public class MenuState extends FlxState {
        private var titleText:FlxText;
        private var subTitleText:FlxText;
        private var startButton:FlxButton;
        private var background:FlxSprite;
        private var gameCursor:FlxSprite;
        
        override public function create():void {
            background = new FlxSprite(0, 0, Main.library.getAsset('menuBackground'));
            gameCursor = new GameCursor(0,0);
            titleText = new FlxText(0, 12, FlxG.width - 12, 'Hummingbird Mind');
            titleText.setFormat(Main.gameFont, 24, 0xff606060, 'right', 0xff303030);
            
            subTitleText = new FlxText(0, 40, FlxG.width - 12, 'by cardboard computer (2010)');
            subTitleText.setFormat(Main.gameFont, 8, 0xff303030, 'right');
            
            startButton = new FlxButton(186, 64, function():void {
                    FlxG.fade.start(0xff000000, 1.25, function():void {
                            FlxG.state = new PlayState();
                            FlxG.fade.stop();
                        })
                });

            var buttonText:FlxText = new FlxText(0, 0, 96, 'Play');
            buttonText.setFormat(Main.gameFont, 16, 0xffaaaaaa, 'center');
            var buttonHighlightText:FlxText = new FlxText(0, 0, 96, 'Play');
            buttonHighlightText.setFormat(Main.gameFont, 16, 0xff606060, 'center', 0xff303030);
            
            startButton.loadText(buttonText, buttonHighlightText);
            
            add(background)
            add(startButton)
            add(subTitleText);
            add(titleText);
            add(gameCursor);
        }
    }
}