package hummingbird {
    import org.flixel.*;
    
    public class EndGameState extends FlxState {
        private var titleText:FlxText;
        private var subTitleText:FlxText;
        private var thankYouText:FlxText;        
        private var startButton:FlxButton;
        private var creditsButton:FlxButton;        
        private var background:FlxSprite;
        private var gameCursor:FlxSprite;
        
        override public function create():void {
            Main.clearSave();
            
            if(Main.musicPlayer == null) {
                Main.musicPlayer = new MusicPlayer('lentEtTriste');
            }
            
            FlxG.flash.start(0xff000000, 1.5, function():void {
                    FlxG.flash.stop();
                });
            
            background = new FlxSprite(0, 0, Main.library.getAsset('endgameBackground'));
            background.alpha = 0.3;
            gameCursor = new GameCursor(0,0);
            titleText = new FlxText(0, 12, FlxG.width - 12, 'Hummingbird Mind');
            titleText.setFormat(Main.gameFont, 24, 0xffa0a0a0, 'right', 0xff303030);
            
            subTitleText = new FlxText(0, 40, FlxG.width - 12, 'by cardboard computer (2010)');
            subTitleText.setFormat(Main.gameFont, 8, 0xff808080, 'right');

            thankYouText = new FlxText(70, 60, 212,
                "\"Attention Deficit Disorder was coined by regularity chauvinists. Regularity chauvinists are people who insist that you have got to do the same thing every time, every day, which drives some of us nuts. Attention Deficit Disorder - we need a more positive term for that. Hummingbird mind, I should think.\" \n\n              -Ted Nelson, inventor of hypertext\n\n\n                               Thanks for playing!");
            thankYouText.setFormat(Main.gameFont, 8, 0xff808080, 'left');
            
            startButton = new FlxButton(186, 170, function():void {
                    FlxG.fade.start(0xff000000, 1.25, function():void {
                            FlxG.state = new MenuState();
                            FlxG.fade.stop();
                        })
                });

            var buttonText:FlxText = new FlxText(0, 0, 96, 'Menu');
            buttonText.setFormat(Main.gameFont, 16, 0xffffffff, 'center');
            var buttonHighlightText:FlxText = new FlxText(0, 0, 96, 'Menu');
            buttonHighlightText.setFormat(Main.gameFont, 16, 0xff606060, 'center', 0xff303030);
            
            startButton.loadText(buttonText, buttonHighlightText);
            
            add(background)
            add(startButton)
            add(subTitleText);
            add(titleText);
            add(thankYouText);
            add(gameCursor);
        }

    }
}