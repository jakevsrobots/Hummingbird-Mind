package homeoffice {
    import org.flixel.*;

    public class PlayState extends FlxState {
        private var background:FlxSprite;
        private var gameData:Object;
        private var currentSceneName:String;
        private var gameCursor:FlxSprite;

        [Embed(source="/../data/game.xml",
                mimeType="application/octet-stream")]
        private var GameXMLFile:Class;
        
        private var titleText:FlxText;
        private var uiHintText:FlxText;        
        private var dialogText:FlxText;
        private var controls:FlxGroup;
        private var dialogOptions:FlxGroup;
        private var controlPadding:uint = 4;

        private var sprites:FlxGroup;
        
        private var dialogIndex:uint = 0;
        private var dialogCallback:Function;
        
        override public function create():void {
            var gameDataXML:XML = new XML(new GameXMLFile());

            gameData = {
                'scenes': {},
                'startingScene': gameDataXML.scenes.@firstScene
            };

            for each(var sceneNode:XML in gameDataXML.scenes.scene) {
                gameData['scenes'][sceneNode.@name] = {
                    'title': sceneNode.@title,
                    'name': sceneNode.@name,
                    'background': sceneNode.@background,
                    'dialogs': []
                };
                
                if(sceneNode.sprite.length()) {
                    gameData['scenes'][sceneNode.@name]['sprites'] = [];

                    for each(var spriteNode:Object in sceneNode.sprite) {
                        gameData['scenes'][sceneNode.@name]['sprites'].push(spriteNode.@name);
                    }
                }
                    
                
                for each(var dialogNode:XML in sceneNode.dialog) {
                    var dialogObject:Object = {};
                    
                    dialogObject['body'] = dialogNode.body.toString();

                    if(dialogNode.@goto.toString()) {
                        dialogObject['goto'] = dialogNode.@goto.toString()
                    }

                    if(dialogNode.option.length()) {
                        dialogObject['options'] = [];

                        for each (var optionNode:XML in dialogNode.option) {
                            var optionObject:Object = {
                                'text': optionNode.toString()
                            };

                            if(optionNode.@goto) {
                                optionObject['goto'] = optionNode.@goto.toString();
                            }

                            dialogObject['options'].push(optionObject);
                        }
                    }
                    
                    gameData['scenes'][sceneNode.@name]['dialogs'].push(dialogObject);
                }
            }

            background = new FlxSprite(0,0);
            gameCursor = new GameCursor(0,0);

            sprites = new FlxGroup();
            
            var controlGutterHeight:uint = 80;
            
            controls = new FlxGroup();
            
            var controlsBackground:FlxSprite = new FlxSprite(0, FlxG.height - controlGutterHeight);
            controlsBackground.createGraphic(FlxG.width, controlGutterHeight, 0xff000000);
            controls.add(controlsBackground);

            var titleBackground:FlxSprite = new FlxSprite(0, FlxG.height - controlGutterHeight - 10);
            titleBackground.createGraphic(FlxG.width, 10, 0xaa0c242b);
            controls.add(titleBackground);
            titleText = new FlxText(controlPadding, FlxG.height - controlGutterHeight - 10, FlxG.width - (controlPadding * 2), '');
            titleText.setFormat(Main.gameFont, 8, 0xffffffff, 'left', 0xff303030);
            controls.add(titleText);

            var dialogOffset:uint = (FlxG.height - controlGutterHeight) + controlPadding;// + titleText.height;
            dialogText = new FlxText(controlPadding, dialogOffset, FlxG.width - (controlPadding * 2), '');
            dialogText.setFormat(Main.gameFont);
            controls.add(dialogText)

            dialogOptions = new FlxGroup;
            controls.add(dialogOptions);
            
            var hintTextWidth:uint = 96;
            uiHintText = new FlxText(controlPadding, FlxG.height - controlPadding - 10, FlxG.width - (controlPadding * 2), '(click to continue)');
            uiHintText.setFormat(Main.gameFont, 8, 0xffffffff, 'right');
            controls.add(uiHintText);
            
            loadScene(gameData['startingScene']);

            add(background);
            add(sprites);
            add(controls);
            add(gameCursor);
            
            //FlxG.showBounds = true;
        }

        override public function update():void {
            var mousePressHandled:Boolean = false;

            if(FlxG.mouse.justPressed() && !mousePressHandled) {
                if(dialogCallback != null) {
                    dialogCallback();
                    mousePressHandled = true;
                }
            }
            
            for each(var optionText:OptionText in dialogOptions.members) {
                if(optionText.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
                    optionText.hoverOn();

                    if(FlxG.mouse.justPressed() && !mousePressHandled) {
                        loadScene(optionText.gotoName);
                        mousePressHandled = true;
                    }
                } else {
                    optionText.hoverOff();
                }
            }
            
            super.update();
        }

        private function loadScene(sceneName:String):void {
            var sceneData:Object = gameData['scenes'][sceneName];

            if(sceneData == null) {
                throw new Error("No such scene: " + sceneName);
            }
            
            currentSceneName = sceneName;
            background.loadGraphic(Main.library.getAsset(sceneData['background']));

            sprites.destroy();
            
            if(sceneData.hasOwnProperty('sprites')) {
                for each(var spriteName:String in sceneData['sprites']) {
                    sprites.add(new FlxSprite(0, 0, Main.library.getAsset(spriteName)));
                }
            }
            
            titleText.text = sceneData['title'];
            dialogIndex = 0;
            loadNextDialog();
        }

        private function loadNextDialog():void {
            var sceneData:Object = gameData['scenes'][currentSceneName];

            if(sceneData['dialogs'].length > dialogIndex) {
                var dialogObject:Object = sceneData['dialogs'][dialogIndex];

                showDialog(dialogObject);

                if(dialogObject.hasOwnProperty('options')) {
                    dialogCallback = null;
                } else if(!dialogObject.hasOwnProperty('goto')) {
                    dialogCallback = function():void {
                        dialogIndex += 1;
                        loadNextDialog();
                    };
                } else {
                    dialogCallback = function():void {
                        loadScene(dialogObject['goto']);
                    }
                }
            }
        }

        private function showDialog(dialogObject:Object):void {
            dialogText.text = dialogObject.body;

            dialogOptions.destroy();
            
            if(dialogObject.hasOwnProperty('options')) {
                uiHintText.visible = false;

                var counter:uint = 0;

                for each(var optionObject:Object in dialogObject['options']) {
                    var yOffset:uint = dialogText.y + dialogText.height + 4 + (counter * 11);
                    var optionText:OptionText = new OptionText(
                        controlPadding * 2,
                        yOffset,
                        FlxG.width - (controlPadding * 3),
                        optionObject['goto'],
                        optionObject['text']);
                    
                    optionText.hoverOff();
                    
                    counter += 1;
                    dialogOptions.add(optionText);
                }
            } else {
                uiHintText.visible = true;
            }
        }
    }
}