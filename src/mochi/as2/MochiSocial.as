/**
* MochiServices
* Class that provides API access to Mochi Coins Service
* @author Mochi Media
*/
import mochi.as2.MochiEventDispatcher;
import mochi.as2.MochiServices;

class mochi.as2.MochiSocial {
    public static var LOGGED_IN:String = "LoggedIn";
    public static var LOGGED_OUT:String = "LoggedOut";
    public static var LOGIN_SHOW:String = "LoginShow";
    public static var LOGIN_HIDE:String = "LoginHide";
    public static var LOGIN_SHOWN:String = "LoginShown";
    public static var PROFILE_SHOW:String = "ProfileShow";
    public static var PROFILE_HIDE:String = "ProfileHide";
    public static var PROPERTIES_SAVED:String = "PropertySaved";
    public static var WIDGET_LOADED:String = "WidgetLoaded";

    public static var FRIEND_LIST:String = "FriendsList";
    public static var PROFILE_DATA:String = "ProfileData";
    public static var GAMEPLAY_DATA:String = "GameplayData";

    public static var ACTION_CANCELED:String = "onCancel";
    public static var ACTION_COMPLETE:String = "onComplete";

    // initiated with getUserInfo() call.
    // event pass object with user info.
    // {name: "name", uid: unique_identifier, profileImgURL: url_of_player_image, hasCoins: True}
    public static var USER_INFO:String = "UserInfo";

    public static var ERROR:String = "Error";
    // error types
    public static var IO_ERROR:String = "IOError";
    public static var NO_USER:String = "NoUser";
    public static var PROPERTIES_SIZE:String = "PropertiesSize"

    private static var _dispatcher:MochiEventDispatcher = new MochiEventDispatcher();

    public static function getVersion():String
    {
        return MochiServices.getVersion();
    }

    /**
     * Method: showLoginWidget
     * Displays the MochiGames Login widget.
     * @param   options object containing variables representing the changeable parameters <see: GUI Options>
     * {x: 150, y: 10}
     */
    public static function showLoginWidget(options:Object):Void
    {
        MochiServices.setContainer();
        MochiServices.stayOnTop();
        MochiServices.send("social_showLoginWidget", { options: options });
    }

    /**
     * Method: hideLoginWidget
     * Hides the login widget
     */

    public static function hideLoginWidget():Void
    {
        MochiServices.send("social_hideLoginWidget");
    }

    /**
     * Method: requestLogin
     * Request login from user using interactive modal dialog
     */
    public static function requestLogin(properties:Object):Void
    {
        MochiServices.send("social_requestLogin",properties);
    }

    /**
     * Method: getFriendsList
     * Asyncronously request friend graph
     * Response returned in MochiSocial.FRIEND_LIST event
     */
    public static function getFriendsList(properties:Object):Void
    {
        MochiServices.send("social_getFriendsList",properties);
    }

    // <--- BEGIN MochiSocial experimental calls ---
    /**
     * Method: getProfileData
     * Asyncronously request mochigames user profile data (non-game specific)
     * @param   properties  Object containing user information
     * Response returned in MochiSocial.PROFILE_DATA event
     * { uid: 'user id' }
     */
     /*
    public static function getProfileData(properties:Object):Void
    {
        MochiServices.send("social_getProfileData", properties);
    }
    */

    /**
     * Method: getGameplayData
     * Asyncronously request mochigames user gameplay data (game specific)
     * @param   properties  Object containing user and game information
     * Response returned in MochiSocial.GAMEPLAY_DATA event
     * { uid: 'user id', gameID: 'xxx' }
     */
     /*
    public static function getGameplayData(properties:Object):Void
    {
        MochiServices.send("social_getGameplayData", properties);
    }
    */
    // --- END MochiSocial experimental calls --->

    
    /**
     * Method: postToStream
     * Post (optionally with a reward) a message to user's public stream. The stream post goes both on MochiGames as well as their other social networks.
     * Item id's must be marked as giftable in your developer account.
     * Items are given as a reward only to the current player as incentive for posting about the game.
     * @param   properties  Object containing message
     * { channel: 'xxx', item: 'xxx', title: 'xxx', message: 'xxx' }
     */
    public static function postToStream(properties:Object):Void
    {
        MochiServices.send("social_postToStream", properties);
    }

    /**
     * Method: inviteFriends
     * Post (optionally with a gift) invite to friends
     * also may include prepopulated list of friends. Item id's must be marked as giftable in your developer account.
     * Each invited player and the current player will be given the gifted item.
     * @param   properties  Object containing message
     * { friends: ['xxx'], item: 'xxx', title: 'xxx', message: 'xxx' }
     */
    public static function inviteFriends(properties:Object):Void
    {
        MochiServices.send("social_inviteFriends", properties);
    }

    /**
     * Method: requestFan
     * Ask the current player to become a fan and follow your developer updates.
     * Your messages are recieved by players both through MochiGames.com and in-game via the login widget or leaderboards.
     * You can configure your update settings on mochimedia.com
     * @param   properties  Object containing message
     * { channel: 'xxx' }
     */
    public static function requestFan(properties:Object):Void
    {
        MochiServices.send("social_requestFan", properties);
    }

    public static function saveUserProperties(properties:Object):Void
    {
        MochiServices.send("social_saveUserProperties", properties);
    }

    // --- Callback system ----------
    public static function addEventListener( eventType:String, delegate:Function ):Void
    {
        _dispatcher.addEventListener( eventType, delegate );
    }

    public static function triggerEvent( eventType:String, args:Object ):Void
    {
        _dispatcher.triggerEvent( eventType, args );
    }

    public static function removeEventListener( eventType:String, delegate:Function ):Void
    {
        _dispatcher.removeEventListener( eventType, delegate );
    }
}
