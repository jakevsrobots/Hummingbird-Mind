package hummingbird {
    import org.flixel.*;
    import mochi.as3.*;
    
    public class PlayState extends FlxState {
        private var currentBackgroundName:String;
        private var background:FlxSprite;
        private var gameData:Object;
        private var currentSceneName:String;
        private var gameCursor:GameCursor;

        [Embed(source="/../data/game.xml",
                mimeType="application/octet-stream")]
        private var GameXMLFile:Class;
        
        private var titleText:FlxText;
        private var uiHintText:FlxText;        
        private var dialogText:RollingText;
        private var controls:FlxGroup;
        private var dialogOptions:FlxGroup;
        private var controlPadding:uint = 4;

        private var sprites:FlxGroup;
        
        private var dialogIndex:uint = 0;
        private var dialogCallback:Function;

        private var gameFlags:Object;

        private var suspendControl:Boolean = false;

        private var muteButton:MuteButton;

        private var currentSoundscape:String;

        private var playerDelay:Number;
        private var playerDelayAccum:Number;        
        private var playerDelayActive:Boolean = false;
        private var delayedSoundFile:Class;
        
        override public function create():void {
            if(Main.musicPlayer == null) {
                Main.musicPlayer = new MusicPlayer('lentEtTriste');
            }

            if(Main.saveGame.data['flags']) {
                MochiEvents.startPlay('continue');                
                gameFlags = Main.saveGame.data['flags'];
            } else {
                MochiEvents.startPlay('play');
                gameFlags = {};
            }
            
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
                    'soundscape': sceneNode.@soundscape,
                    'dialogs': []
                };
                
                if(sceneNode.sprite.length()) {
                    gameData['scenes'][sceneNode.@name]['sprites'] = [];

                    for each(var spriteNode:XML in sceneNode.sprite) {
                        gameData['scenes'][sceneNode.@name]['sprites'].push(spriteNode.@name);
                    }
                }

                if(sceneNode.setFlag.length()) {
                    gameData['scenes'][sceneNode.@name]['flags'] = {};

                    for each(var flagNode:XML in sceneNode.setFlag) {
                        gameData['scenes'][sceneNode.@name]['flags'][flagNode.@name] = flagNode.@value;
                    }
                }
                
                for each(var dialogNode:XML in sceneNode.dialog) {
                    var dialogObject:Object = {};
                    
                    dialogObject['body'] = dialogNode.body.toString();

                    if(dialogNode.@conditionFlag.toString()) {
                        dialogObject['conditionFlag'] = dialogNode.@conditionFlag.toString();
                    }
                    
                    if(dialogNode.@goto.toString()) {
                        dialogObject['goto'] = dialogNode.@goto.toString();
                    }

                    if(dialogNode.option.length()) {
                        dialogObject['options'] = [];

                        for each (var optionNode:XML in dialogNode.option) {
                            var optionObject:Object = {
                                'text': optionNode.toString()
                            };

                            if(optionNode.@goto.toString()) {
                                optionObject['goto'] = optionNode.@goto.toString();
                            }

                            if(optionNode.@conditionFlag.toString()) {
                                optionObject['conditionFlag'] = optionNode.@conditionFlag.toString();
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
            dialogText = new RollingText(controlPadding, dialogOffset, FlxG.width - (controlPadding * 2), '');
            dialogText.setFormat(Main.gameFont);
            controls.add(dialogText)

            dialogOptions = new FlxGroup;
            controls.add(dialogOptions);
            
            var hintTextWidth:uint = 96;
            uiHintText = new FlxText(controlPadding, FlxG.height - controlPadding - 10, FlxG.width - (controlPadding * 2), '(click to continue)');
            uiHintText.setFormat(Main.gameFont, 8, 0xffffffff, 'right');
            controls.add(uiHintText);

            FlxG.flash.start(0xff000000, 0.5, function():void {
                    FlxG.flash.stop();
                });

            if(Main.saveGame.data['currentScene']) {
                currentBackgroundName = gameData['scenes'][Main.saveGame.data['currentScene']]['background'];
                background.loadGraphic(Main.library.getAsset(currentBackgroundName));
                
                loadScene(Main.saveGame.data['currentScene']);
            } else {
                currentBackgroundName = gameData['scenes'][gameData['startingScene']]['background'];
                background.loadGraphic(Main.library.getAsset(currentBackgroundName));
                
                loadScene(gameData['startingScene']);
            }

            //muteButton = new MuteButton(FlxG.width - 16 - 2, 2);            
            
            add(background);
            add(sprites);
            add(controls);
            add(gameCursor);
            //add(muteButton);
            
            //FlxG.showBounds = true;
        }

        override public function update():void {
            if(suspendControl) {
                super.update();
                return;
            }
            
            var mousePressHandled:Boolean = false;

            if(FlxG.mouse.justPressed() && !mousePressHandled) {
                if(dialogText.rolling) {
                    dialogText.forceComplete();
                    mousePressHandled = true;
                }
            }
            
            if(FlxG.mouse.justPressed() && !mousePressHandled) {
                if(dialogCallback != null) {
                    dialogCallback();
                    mousePressHandled = true;
                }
            }
            
            for each(var optionText:OptionText in dialogOptions.members) {
                if(optionText.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
                    optionText.hoverOn();

                    if(FlxG.mouse.justPressed() && !optionText.hidden && !mousePressHandled) {
                        loadScene(optionText.gotoName);
                        mousePressHandled = true;
                        //FlxG.play(Main.library.getAsset('choose'));
                    }
                } else {
                    optionText.hoverOff();
                }
            }

            if(FlxG.keys.justPressed("ESCAPE")) {
                FlxG.pause = !FlxG.pause;
            }
            
            if(FlxG.keys.justPressed("Q")) {
                FlxG.fade.start(0xff000000, 1.0, function():void {
                        FlxG.fade.stop();
                        FlxG.state = new MenuState();
                    });
                suspendControl = true;                
            }

            // update soundscape delay
            if(playerDelayActive) {
                playerDelayAccum += FlxG.elapsed;

                if(playerDelayAccum > playerDelay) {
                    FlxG.play(delayedSoundFile, 1.0, true);
                    playerDelayActive = false;
                }
            }
            
            super.update();
        }

        private function loadScene(sceneName:String):void {
            if(sceneName == 'endgame') {
                FlxG.fade.start(0xff000000, 1.0, function():void {
                        FlxG.fade.stop();
                        FlxG.state = new EndGameState;
                    });
                suspendControl = true;
                return;
            }
            
            var sceneData:Object = gameData['scenes'][sceneName];

            if(sceneData == null) {
                throw new Error("No such scene: " + sceneName);
            }
            
            currentSceneName = sceneName;

            Main.save(gameFlags, currentSceneName);

            if(sceneData['soundscape'] != currentSoundscape) {
                for each(var sound:FlxSound in FlxG.sounds) {
                    if(sound.active) {
                        sound.fadeOut(0.5);
                    }
                }
                
                FlxG.play(Main.library.getAsset(sceneData['soundscape']), 1.0, true);
                playWithDelay(Main.library.getAsset(sceneData['soundscape']));
                currentSoundscape = sceneData['soundscape'];
            }
            
            /*
            //throw new Error(Main.soundscapePlayers.hasOwnProperty(sceneData['soundscape']));
                
            if(!Main.soundscapePlayers.hasOwnProperty(sceneData['soundscape'])) {
                Main.soundscapePlayers[sceneData['soundscape']] = new MusicPlayer(sceneData['soundscape'], 1.0);
            }
            
            if(Main.currentSoundscape != sceneData['soundscape']) {
                if(Main.soundscapePlayers.hasOwnProperty(Main.currentSoundscape)) {
                    Main.soundscapePlayers[Main.currentSoundscape].fadeOut(0.5);
                } else {
                    FlxG.log('cannot fade out ' + Main.currentSoundscape + ' because it does not exist');
                }
                
                Main.soundscapePlayers[sceneData['soundscape']].fadeIn(0.5);
                Main.currentSoundscape = sceneData['soundscape'];
            }
            */
            
            
            if(sceneData['background'] != currentBackgroundName) {
                currentBackgroundName = sceneData['background'];
                
                // Hide the quick background switch with a short fade.
                FlxG.fade.start(0xff000000, 0.125, function():void {
                        FlxG.fade.stop();
                        
                        background.loadGraphic(Main.library.getAsset(currentBackgroundName));
                        
                        FlxG.flash.start(0xff000000, 0.125, function():void {
                                FlxG.flash.stop();
                            });
                    });
            }

            sprites.destroy();
            
            if(sceneData.hasOwnProperty('sprites')) {
                for each(var spriteName:String in sceneData['sprites']) {
                    sprites.add(new FlxSprite(0, 0, Main.library.getAsset(spriteName)));
                }
            }

            if(sceneData.hasOwnProperty('flags')) {
                for(var flagName:String in sceneData['flags']) {
                    setFlag(flagName, sceneData['flags'][flagName]);
                }
            }
            
            titleText.text = sceneData['title'];
            dialogIndex = 0;
            loadNextDialog();
        }

        private function loadNextDialog():void {
            var sceneData:Object = gameData['scenes'][currentSceneName];

            var dialogObject:Object = null;
            
            while(dialogObject == null && dialogIndex < sceneData['dialogs'].length) {
                dialogObject = sceneData['dialogs'][dialogIndex];

                // Check flags and just silently skip over dialog objects
                // that have flags for which the conditions are not met.
                if(dialogObject.hasOwnProperty('conditionFlag')) {
                    if(!getFlag(dialogObject['conditionFlag'])) {
                        dialogObject = null;
                        dialogIndex += 1;
                        continue;
                    }
                }
                
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
            var callback:Function = function():void {
                if(dialogObject.hasOwnProperty('options')) {

                    var counter:uint = 0;

                    var yOffsetAccum:uint = dialogText.y + dialogText.height + 4;;
                    
                    for each(var optionObject:Object in dialogObject['options']) {
                        var optionText:OptionText = new OptionText(
                            controlPadding,
                            yOffsetAccum,
                            FlxG.width - (controlPadding * 2),
                            optionObject['goto'],
                            optionObject['text'],
                            counter + 1
                        );

                        yOffsetAccum += optionText.height + 2;

                        if(optionObject.hasOwnProperty('conditionFlag')) {
                            if(!getFlag(optionObject['conditionFlag'])) {
                                optionText.makeHidden();
                            }
                        }
                        
                        optionText.hoverOff();
                        
                        counter += 1;
                        dialogOptions.add(optionText);
                    }
                } else {
                    uiHintText.visible = true;
                }
            };

            dialogText.displayText(dialogObject.body, callback);
            uiHintText.visible = false;
            dialogOptions.destroy();
        }

        private function setFlag(flagName:String, flagValue:String):void {
            if(flagValue == "1") {
                gameFlags[flagName] = true;
            } else {
                gameFlags[flagName] = false;
            }
        }

        private function getFlag(flagName:String):Boolean {
            // Use '+' to check many flags at once. Returns 'true' only if *all* flags
            // are true.
            if(flagName.indexOf('+') != -1) {
                var subFlagNameList:Array = flagName.split('+');
                
                for each(var subFlagName:String in subFlagNameList) {
                    if(!getFlag(subFlagName)) {
                        return false;
                    }
                }

                return true;
            }
            
            if(gameFlags.hasOwnProperty(flagName) && gameFlags[flagName]) {
                return true;
            } else {
                return false;
            }
        }

        public function playWithDelay(soundFile:Class):void {
            var sound:ExpandedSound = new ExpandedSound();
            sound.loadEmbedded(soundFile);

            delayedSoundFile = soundFile;
            playerDelay = (sound.length / 1000) / 2;
            playerDelayAccum = 0;
            playerDelayActive = true;
            
            sound.destroy();
        }
    }
}