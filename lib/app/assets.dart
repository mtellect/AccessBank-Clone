import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'basemodel.dart';

const int PAY_TYPE_SEND = 0;
const int PAY_TYPE_FUND = 1;
const int PAY_TYPE_WITHDRAW = 2;
const int PAY_TYPE_SCAN = 3;
const int PAY_TYPE_RECEIVE = 4;

const int HOME_TYPE_AIRTIME = 0;
const int HOME_TYPE_DSTV = 1;
const int HOME_TYPE_BUNDLES = 2;
const int HOME_TYPE_SHOP = 3;
const int HOME_TYPE_REMITA = 4;

const String WALLET_BALANCE = "walletBalance";
const String MY_CARDS = "myCards";
const String MY_WALLETS = "myWallets";
const String MY_ADDRESSES = "myAddresses";
const String MY_BANKS = "myBanks";
const String RAVE_TOKEN = "raveToken";
const String MY_CARD_NAME = "cardName";
const String MY_CARD_CVV = "cardCvv";
const String MY_CARD_EXP_MONTH = "cardExpMonth";
const String MY_CARD_EXP_YEAR = "cardExpYear";
const String MY_CARD_EXP_PIN = "cardPin";
const String MY_CARD_EXP_DATE = "cardExpDate";
const String MY_CARD_NUMBER = "cardNumber";
const String ACTIVE_CARD = "activeCard";
const String ACTIVE_WALLET = "activeWallet";
const String ACTIVE_BANK = "activeBank";
const String ACTIVE_ADDRESS = "activeAddress";
const String PEER_SIGN_UP = "peerSignUp";
const String ACCOUNT_UPDATED = "accountUpdated";
const String IS_MY_ACCOUNT = "isMyAccount";

const String IMAGES = "images";
const String CLOSED = "closed";
const String TYPING = "typing";
const String TYPING_ID = "typingId";
const String FANS_ONLINE = "fansOnline";

const String APP_NAME = "Moon+Stars";
const double HEADER_SIZE = 20;

final MaterialColor materialTextColor = createMaterialColor(Color(0xFF888888));
final MaterialColor materialButtonColor =
    createMaterialColor(Color(0xFFFAAB19));
final MaterialColor materialHeaderColor =
    createMaterialColor(Color(0xFF354856));
final MaterialColor materialButtonSelectedColor =
    createMaterialColor(Color(0xFF94B5B3));
final MaterialColor materialBorderColor =
    createMaterialColor(Color(0xFFDBDBDB));

const Color textColor = Color(0xFF888888);
const Color buttonColor = Color(0xFF1C68EC);
const Color headerColor = Color(0xFF112d61);
const Color subHeaderColor = Color(0xFF112D68);
const Color backgroundColor = Color.fromRGBO(235, 245, 255, 0.6117647059);
const Color buttonSelectedColor = Color(0xFF94B5B3);
const Color borderColor = Color(0xFFDBDBDB);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

const Color APP_COLOR = const Color(0xFF1f2c62);
const Color APP_COLOR2 = const Color(0xFFf08e33);
const Color primaryColor = const Color(0xFFEE1C24);
const Color primaryActiveColor = const Color(0xFFBA161C);

const Color primaryButtonColor = primaryColor;
const Color primaryButtonActiveColor = primaryActiveColor;
final Color textBoxColor = const Color(0xFF5466AE).withOpacity(0.1);

BaseModel userModel = new BaseModel();
BaseModel appSettingsModel;
bool isLoggedIn = false;
bool isAdmin = true;
String currentProgress = "";

bool showProgressLayout = false;
List<Map> dataToUpload = List();
bool uploadRunning = false;
bool showBroadcast = false;
StreamSubscription<DocumentSnapshot> userListenerController;
StreamSubscription<DocumentSnapshot> appListenerController;
StreamSubscription requestListenerController;
StreamSubscription messagesListenerController;

//<<<MAIN APP STRINGS>>>
const String BACKEND_URL = "http://dev-api.moonsandstars.app";
const String APP_PASSWORD = "moon+stars+20+20";
const String APP_DATA = "appData";
const String AUTH_TOKEN = "authToken";
const String CONFIRMATION_TOKEN = "confirmationToken";
const String MOON_ID = "moonId";
const String USER_ID = "userId";
const String OBJECT_ID = "objectId";
const String CONFIRMED = "confirmed";

const String FIRST_NAME = "firstName";
const String LAST_NAME = "lastName";
const String FULL_NAME = "fullName";
const String GENDER = "gender";
const String DOB = "dateOfBirth";
const String EDUCATION = "education";
const String EMPLOYMENT = "employment";
const String SECT = "sect";
const String SCHOOL_NAME = "schoolName";
const String KEY = "key";

const String JOB_TITLE = "jobTitle";
const String JOB_ROLE = "jobRole";

const String MARITAL_STATUS = "maritalStatus";
const String HEIGHT = "height";
const String HAS_CHILDREN = "hasChildren";
const String WANTS_CHILDREN = "wantsChildren";
const String YOU_SMOKE = "smoke";
const String SEX = "sex";

const String DENOMINATION = "denomination";
const String RELIGIOSITY = "religiosity";
const String PRAYER_HABIT = "prayerHabit";

const String PROFILE_QUESTIONS_ANSWERS = "profileQuestionAnswers";
const String USER_PHOTOS = "userPhotos";

const String LOOKING_FOR_HAS_CHILDREN = "lookingForHasChildren";
const String LOOKING_FOR_HEIGHT_MAX = "lookingForHeightMax";
const String LOOKING_FOR_HEIGHT_MIN = "lookingForHeightMin";
const String LOOKING_FOR_LOWER_AGE = "lookingForLowerAge";
const String LOOKING_FOR_UPPER_AGE = "lookingForUpperAge";
const String LOOKING_FOR_MARITAL_STATUS = "lookingForMaritalStatus";
const String LOOKING_FOR_PRAYER_HABITS = "lookingForPrayerHabits";
const String LOOKING_FOR_RADIUS = "lookingForRadius";
const String LOOKING_FOR_RELIGIOSITY = "lookingForReligiosity";
const String LOOKING_FOR_SECT = "lookingForSect";
const String LOOKING_FOR_SEX = "lookingForSex";
const String LOOKING_FOR_SMOKING = "lookingForSmoking";
const String LOOKING_FOR_WANTS_CHILDREN = "lookingForWantsChildren";

//Local bases
const String USER_BASE = "userBase";
const String MATCHED_BASE = "matchedBase";
const String PREFERENCE_BASE = "preferenceBase";

const String FavoriteAnimation = "assets/flare/Favorite.flr";

//FOR ICONS
/*const*/ String ic_launcher = "assets/images/ic_launcher.png";

const String maugostImage = "https://tinyurl.com/vfcpohq";

const String notification_icon = "assets/images/notification_icon.png";
const String post_icon = "assets/images/post_icon.png";
const String thankyou = "assets/images/thankyou.png";
const String gifIcon = "assets/images/gifIcon.png";
const String world = "assets/images/world.png";
const String like_icon = "assets/images/like_icon.png";
const String ic_chat = "assets/images/ic_chat.png";
const String ic_chat2 = "assets/images/ic_chat2.png";
const String ic_chat1 = "assets/images/ic_chat1.png";
const String church_icon = "assets/images/church_icon.png";
const String married_icon = "assets/images/married_icon.png";
const String single_icon = "assets/images/single_icon.png";
const String dating_icon = "assets/images/dating_icon.png";

//APP DATABASE COLLECTIONS
const String REQUEST_BASE = "requestBase";
const String ADMIN_BASE = "adminBase";
const String ADMIN_PATH = "maugost@yourTreeApp.com";
const String REFERENCE_BASE = "referenceBase";
const String POST_BASE = "postBase";
const String ACTIVITY_BASE = "activityBase";
const String STYLE_BASE = "styleBase";
const String DESIGN_BASE = "designBase";
const String LIKES_BASE = "likesBase";
const String COMMENTS_BASE = "commentsBase";
const String REPLIES_BASE = "repliesBase";
const String REPORT_BASE = "reportBase";
const String SUSPEND_BASE = "suspendBase";
const String SHARES_BASE = "shareBase";
const String CONNECTION_BASE = "connectionBase";
const String EVENT_BASE = "eventBase";
const String CHAT_BASE = "chatBase";
const String GROUP_BASE = "groupBase";
const String CHAT_HISTORY_BASE = "chatHistoryBase";
const String PAYMENT_BASE = "paymentBase";
const String NOTIFICATION_BASE = "notificationBase";
const String MUTED = "muted";
const String COMMENT_MUTED = "commentMuted";
const String HAS_RATED = "hasRated1";
const String SILENCED = "slienced";
const String KICKED_OUT = "kickedOut";
const String MY_SENT_CHAT = "mySentChat";
const String BY_ADMIN = "byAdmin";
const String VISIBILITY = "visibility";
const String SESSION_BASE = "sessionBase";

const String NOTIFY_BASE = "notifyBase";

const int PUBLIC = 0;
const int PRIVATE = 1;
const int REMOVED = 2;

const int NOT_MEMBER = 0;
const int MEMBER = 1;
const int ADMIN_MEMBER = 2;

//APP CONSTANTS
const String TYPE = "type";
const String CAN_POST_EVENT = "canPostEvent";
const String PEOPLE = "people";
const String PERSON_ID = "personId";
const String REQUEST_ID = "requestId";
const String APP_SETTINGS_BASE = "appSettingsBase";
const String APP_SETTINGS = "appSettings";
const String DOCUMENT_ID = "docId";
const String POST_ID = "postId";
const String OWNER_ID = "ownerId";
const String POST_MESSAGE = "postMessage";
const String LOCATION = "location";
const String TXT_BG_COLOR = "txtBgColor";
const String SHARE_TYPE = "shareType";
const String POST_TYPE = "postType";
const String FEED_TYPE = "feedType";
const String IS_COMMENT = "isComment";
const String IS_GIF = "isGIF";
const String IS_REPORTED = "isReported";
const String IS_HIDDEN = "isHidden";
const String IS_POST_PRIVATE = "isPostPrivate";
const String FILE_TO_UPLOAD = "fileToUpload";
const String FILE_UPLOADED = "fileUploaded";
const String FILE_UPLOADING = "fileUploading";
//const String IS_HIDDEN = "isVisible";
const String IS_POLL = "isPoll";
const String IS_QUIZ = "isQuiz";
const String IS_FULLTEXT = "isFullText";
const String POST_OWNER = "owner";
const String LAST_COMMENT = "lastComment";
const String LAST_REPLY = "lastReply";
const String POST_DATA = "postData";
const String POLL_DATA = "pollData";
const String POLL_DURATION = "pollDuration";
const String LIKES = "likes";
const String COMMENTS = "comments";
const String REPLIES = "replies";
const String SHARES = "shares";
const String VIDEO_VIEWS = "videoViews";
const String REPORTS = "reports";
const String TAGS = "tags";
const String IS_SHARED = "isShared";
const String SHARED_POST = "sharedPost";

const String READ_BY = "readBy";
const String THE_MODEL = "theModel";
const String PARTIES = "parties";
const String LOGIN_TOKEN = "loginToken";
const String TOKEN_ID = "tokenID";
const String TITLE = "title";
const String FOOTER = "footer";
const String CONNECTED = "connected";
const String DESCRIPTION = "description";
const String BUSINESS_ADDRESS = "businessAddress";
const String OWNER_NAME = "ownerName";
const String EMAIL = "email";
const String PASSWORD = "password";
const String CHURCH_ID = "shopID";
const String SHOP_NAME = "shopName";
const String CHURCH_INFO = "churchInfo";
const String HAS_CHURCH = "hasChurch";
const String CHURCH_NOT_FOUND = "churchNotFound";
const String CHURCH_DENOMINATION = "churchDenomination";
const String MINISTRY_NAME = "ministryName";
const String CHURCH_WEBSITE = "churchWebsite";
const String PARENT_CHURCH = "parentChurch";
const String ACCOUNT_TYPE = "accountType";
const String PHONE_NO = "phoneNo";
const String ABOUT_ME = "aboutMe";
const String IMAGE = "image";
const String PROFILE_IMAGE = "profileImage";
const String ADDRESS = "address";
const String FREE_SPACE = "freeSpace";
const String CITY = "city";
const String STATE = "state";
const String COUNTRY_COUNT = "countryCount";
const String COUNTRY = "country";
const String COUNTRY_FLAG = "countryFlag";
const String RELATIONSHIP_STATUS = "relationStatus";
const String PHONE_CODE = "phoneCode";
const String PHONE_COUNTRY = "phoneCountry";
const String STAR_RATING = "starRating";

const String AGE = "age";
const String BIRTHDAY = "birthday";
const String EMAIL_VERIFIED = "emailVerified";
const String PHONE_VERIFIED = "phoneVerified";
const String SIGN_UP_COMPLETE = "signUpComplete";
const String IS_SUBSCRIBED = "isSubscribe";

const String GROUP_ID = "groupId";
const String GROUP_NAME = "groupName";
const String GROUP_IMAGE = "groupImage";
const String GROUP_DESCRIPTION = "groupDescription";
const String GROUP_PRIVACY = "groupPrivacy";
const String GROUP_ADMIN = "groupAdmin";
const String GROUP_MEMBERS = "groupMembers";
const String IS_MEMBER = "isMembers";

const String STYLE_TITLE = "styleTitle";
const String STYLE_DESCRIPTION = "styleDescription";
const String STYLE_GENDER = "styleGender";
const String STYLE_POSITION = "stylePosition";
const String STYLE = "style";

const String DESIGN_STYLE = "designStyle";
const String DESIGN_GENDER = "designGender";
const String DESIGN_TITLE = "designTitle";
const String DESIGN_DESCRIPTION = "designDescription";
const String DESIGN_BUDGET = "designBudget";
const String NEGOTIABLE = "negotiable";

const String FACE_OF_THE_WEEK = "faceOfTheWeek";
//const String FACE_OF_THE_WEEK = "faceOfTheWeek";
const String PREVIOUS_FACES = "prevFaces";
const String FACE_ITEM = "faceItem";
const String FACE_SETTINGS = "faceSettings";
const String FACE_TYPE = "face Type";
const String FACE_FREQ = "face Frequency";

const String BID_COUNT = "BidCount";
const String BID_COST = "BidCost";
const String BID_COST_USD = "BidCostUsd";
const String BID_COLOR = "BidColor";
const String BID_SETTINGS = "BidSettings";
const String BID_PLAN = "BidPlan";
const String BID_INDEX = "BidIndex";
const String BID_LEFT = "BidLeft";
//const String BID_USED = "BidUsed";
const String BID_PLAN_LEFT = "BidPlanLeft";
const String BID_PLAN_ACTIVE = "BidPlanActive";
const String BID_PLAN_EXPIRY = "BidPlanExpiry";

const int FACE_TYPE_AUTO = 0;
const int FACE_TYPE_MANUAL = 1;

const String CONTACT_NAME = "cName";
const String CONTACT_CITY = "cCity";
const String CONTACT_ADDRESS = "cAddress";
const String CONTACT_STATE = "cState";
const String CONTACT_LANDMARK = "cLand";
const String CONTACT_PHONE = "cPhone";
const String CONTACT_EMAIL = "cEmail";
const String CONTACT_WHATS = "cWhats";
const String CONTACT_GEO = "cGeo";

const String ACTION_LIST = "actionList";
const String ACTION_LIST_NAMES = "actionListNames";
const String ACTION_TEXT = "actionText";
const String ACTION_LINK = "actionLink";
const String ACTION_TEXT_CLICKED = "actionTextClicked";

const String DUMMY_IDS = "dummyIds";
const String SUB_CATS = "subCats1";
const String CONTACT_US = "Contact Us";

const String AUTHOR = "AUTHOR";
const String ITEM_NAME = "ItemName";
const String MCR = "mcr";
const String MCR_IDS = "mcrIds";
const String PROFILE_STATUS = "profileStatus";

const String IS_BLOCKED = "isBlocked";
const String IS_PUBLIC = "isPublic";
const String IS_GROUP = "isGroup";
const String IS_CONVERSATION = "isConversation";
const String IS_TREE = "isTree";
const String HAS_ROOM = "hasRoom";
const String IS_ROOM = "isRoom";
const String ROOM_COLOR = "roomColor";
const String ROOM_SORT = "roomSort";
const String IS_SUGGESTION = "isSuggestion";
const String CHURCH_VERIFIED = "churchVerified";
const String MY_CONNECT = "myConnect";
const String CONNECTIONS = "connections";
const String SHARE_COUNT = "shareCount";
const String FRIENDS = "friends";
const String ACHIEVEMENTS = "achievements";
const String REQUESTS = "requests";
const String SENT_REQUESTS = "sentRequests";
const String RECEIVED_REQUESTS = "receivedRequests";
const String BLOCKED = "blocked";
const String REPORTED = "reported";

const String IS_TYPING = "isTyping";
const String CHAT_DATA = "chatData";
const String ROOM_ID = "roomId";
const String CHAT_DETAILS = "chatDetails";
const String GROUP_DETAILS = "groupDetails";
const String GROUP_ADMINS = "groupAdmins";
const String MESSAGE = "message";
const String MESSAGE_TYPE = "messageType";
const String MESSAGE_STATUS = "messageStatus";
const String UPLOADING_DATA = "uploadingData";
const String SHOW_REPLY = "showReply";
const String SHOW_REMOVED = "showRemoved";
const String SHOW_ADDED = "showAdded";
const String SHOW_LEFT = "showLeft";
const String SHOW_CREATED = "showCreated";
const String IS_MUTUAL = "isMutual";
const String MUTUAL_COUNT = "mutualCount";
const String IS_GROUP_PRIVATE = "isGroupPrivate";
const String IS_GROUP_VISIBLE = "isGroupVisible";
const String CAN_POST_ON_WALL = "canPostOnWall";
const String IS_SUSPENDED = "suspendGroup";
const String SHOW_CREATED_AT = "showCreatedAt";
const String SHOW_REPLY_AT = "showReplyAt";
const String REPLY = "reply";
const String IS_ARTIST = "isArtist";
const String IS_VERIFIED = "isVerified";
const String IS_SEEN = "isSeen";
const String DECLINED = "declined";
const String ACCEPTED = "accepted";
const String ATTENDING = "attending";
const String ATTENDING_USERS = "attendingUsers";
const String REASON = "reason";
const String IS_CHURCH_UPDATED = "isChurchUpdated";
const String IS_PERSONAL_UPDATED = "isPersonalUpdated";
const String CHURCH_ADDRESS = "churchAddress";
const String CHURCH_VICINITY = "churchVicinity";
const String CHURCH_LAT = "churchLat";
const String CHURCH_LONG = "churchLong";

//STRIPE API
const String STRIPE_BASE_URL = "https://api.stripe.com/v1/";
const String STRIPE_TOKENS_URL = "${STRIPE_BASE_URL}tokens";
const String CARD_NUMBER = "card[number]";
const String CARD_EXP_MONTH = "card[exp_month]";
const String CARD_EXP_YEAR = "card[exp_year]";
const String CARD_CVC = "card[cvc]";
const String ERROR = "error";
const String ERROR_MESSAGE = "message";
const String ERROR_TYPE = "type";

const int NONE = 0;
const int TEXT_ALONE = 1;
const int TEXT_IMAGES = 2;
const int TEXT_VIDEOS = 3;
const int IMAGES_ALONE = 4;
const int VIDEOS_ALONE = 5;
const int TEXT_IMAGES_VIDEOS = 6;
const int IMAGES_VIDEOS = 7;
const int IMAGES_GIF = 8;

const int MESSAGE_TYPE_GIF = 00;
const int MESSAGE_TYPE_DATA = 11;
const int MESSAGE_TYPE_TEXT = 22;

const int MESSAGE_NOT_SEEN = -1;
const int MESSAGE_SEEN = -2;
const int MESSAGE_READ = -3;
const int GROUP_CREATED = -4;

const String PUSH_NOTIFICATION_TOKEN = "pushNotificationToken";
const String NOTIFICATION = "notification";
const String NOTIFICATION_PAYLOAD = "notificationPayload";
const String NOTIFICATION_SEND_TO = "notificationSendTo";
const String NOTIFICATION_BODY = "body";
const String NOTIFICATION_TITLE = "title";
const String NOTIFICATION_CLICK_ACTION = "click_action";
const String NOTIFICATION_ID = "id";
const String NOTIFICATION_PRIORITY = "priority";
const String NOTIFICATION_DATA = "data";
const String NOTIFICATION_STATUS = "status";
const String NOTIFICATION_SENDER_NAME = "senderName";
const String NOTIFICATION_TO = "to";
const String NOTIFICATION_TYPE = "notificationType";

const int CHAT_TYPE_TEXT = 0;
const int CHAT_TYPE_IMAGE = 1;
const int CHAT_TYPE_GIF = 2;
const int CHAT_TYPE_DOC = 3;
const int CHAT_TYPE_VIDEO = 4;

const String IMAGE_URL = "imageUrl";
const String IMAGES_PATH = "imagePath";

const String icon_file_doc = 'assets/icon_file_doc.png';
const String icon_file_pdf = 'assets/icon_file_pdf.png';
const String icon_file_text = 'assets/icon_file_text.png';
const String icon_file_video = 'assets/icon_file_video.png';
const String icon_file_xls = 'assets/icon_file_xls.png';
const String icon_file_ppt = 'assets/icon_file_ppt.png';
const String icon_file_unknown = 'assets/icon_file_unknown.png';
const String icon_file_photo = 'assets/icon_file_photo.png';
const String icon_file_zip = 'assets/icon_file_zip.png';
const String icon_file_xml = 'assets/icon_file_xml.png';
const String icon_file_audio = 'assets/icon_file_audio.png';

const String VIDEO_LENGTH = "videoLength";
const String VIDEO_URL = "videoUrl";
const String THUMBNAIL_URL = "thumbUrl";
const String THUMBNAIL_PATH = "thumbPath";
const String GIF_PATH = "gifPath";
const String GIF_URL = "gifUrl";
const String VIDEO_PATH = "videoPath";
const String VIDEO_DURATION = "videoDuration";

const String IMAGE_PATH = "imagePath";
//const String IMAGES = "images";

const String IMPRESSIONS = "impressions";
const String SHOWN = "shown";
const String HIDDEN = "hidden";
const String COUNT = "count";
const String IS_ADS = "isAds";
const String CLICKS = "clicks";

const String NEW_APP = "newApp1";
const String IS_ADMIN = "isAdmin";

const String CHAT_NOTIFICATION = "chatNotification";
const String CHAT_ONLINE_STATUS = "chatOnlineStatus";
const String GROUP_NOTIFICATION = "groupNotification";
const String MESSAGE_NOTIFICATION = "messageNotification";

const String COMMENTS_COUNT = "commentCount";
const String FOLLOWERS = "followers";
const String FOLLOWING = "following";
const String UNREAD_COUNT = "unreadCount";

const String RECENT_SEARCH = "recentSearch";

const int NOTIFICATION_NOT_SEEN = -1;
const int NOTIFICATION_SEEN = -2;
const int NOTIFICATION_READ = -3;

const int OFFLINE = 0;
const int ONLINE = 1;
const int AWAY = 2;

const int STATUS_UNDONE = 0;
const int STATUS_COMPLETED = 1;
const int STATUS_FAILED = 2;

const String FILE_URL = "fileUrl";
const String FILE_PATH = "filePath";
const String FILE_EXTENSION = "fileExtension";
const String FILE_ORIGINAL_PATH = "fileOriginalPath";
const String FILE_NAME = "fileName";
const String FILE_SIZE = "fileSize";
const String VIDEO_SIZE = "videoSize";
const String REFERENCE = "reference";

const String CREATED_AT = "createdAt";
const String TIME = "time";
const String TIME_UPDATED = "timeUpdated";
const String DATABASE_NAME = "databaseName";
const String SHOW_DATE = "showDate";
const String UPDATED_AT = "updatedAt";
//const String OBJECT_ID = "objectId";
const String USERNAME = "username";
//const String USER_ID = "userId";
const String READ = "read";
const String USER_IMAGE = "userImage";
const String ADD = "add";
const String VALUE = "value";

const String SESSION_COUNT = "sessionCount";
const String SESSION_MSG_COUNT = "sessionMsgCount";

const String PLACE_NAME = "placeName";
const String PLACE_DESCRIPTION = "placeDescription";
const String PLACE_VICINITY = "placeVicinity";
const String PLACE_LAT = "placeLat";
const String PLACE_LONG = "placeLong";

const String SEARCH_DATA = "searchData";

const String ASSET_TYPE = "assetType";
const String ASSET_FILE = "assetFile";

const String TYPING_BY = "typingBy";

const String CHAT_ID = "chatId";
const String MY_CHATS = "myChatsList13";
const String MY_OPINIONS = "myOpinions1";
const String MY_SESSIONS = "mySessions";

const String STATUS = "status";
const String REJECTED_MESSAGE = "rejectedMessage";

const String READ_ITEMS = "readItems";
const String RECEIVER_ID = "receiverId";
const String ICONS = "icons";
const String COLORS = "colors";

const String DELETED = "deleted";
const String IS_ONLINE = "isOnline1";
const String TIME_ONLINE = "timeOnline";
const String FILES_TO_UPLOAD = "filesToUpload";

const int PENDING = 0;
const int APPROVED = 1;
const int REJECTED = 2;
const int INACTIVE = 3;
const int COMPLETED = 4;

const int PROFILE_STATUS_EMPTY = 0;
const int PROFILE_STATUS_PENDING = 1;
const int PROFILE_STATUS_VERIFIED = 2;

const String PACKAGE_NAME = "packageName1";
const String WEBSITE = "website1";
const String ABOUT_LINK = "aboutLink1";
const String PRIVACY_LINK = "privacyLink1";
const String TERMS_LINK = "termsLink1";
const String DEFAULT_WEBSITE = "https://maugosttasn.firebaseapp.com";
const String VERSION_CODE = "versionCode";
const String APP_FEATURES = "appFeatures";
const String FORCE_UPDATE = "forceUpdate";
const String PLATFORM = "platform";
const String SUPPORT_EMAIL = "supportEmail";

const int ASSET_TYPE_VIDEO = 2;
const int ASSET_TYPE_IMAGE = 1;
const int ASSET_TYPE_OTHER = 0;

const String UPLOAD_URL = "uploadURL";
const String IS_NETWORK_IMAGE = "isNetworkImage";

//FOR COLORS
const Color plinkdColor = Color(0XFFe46514);
const Color plinkTxtColor = Color(0XFFf79836);
const Color plinkBtnColor = Color(0XFF2e2f33);
const Color plinkdColor1 = Color(0XFFf79836);

const Color brown0 = Color(0xffa52a2a);
const Color brown1 = Color(0xff942525);
const Color brown1b = Color(0xfff3842121);
const Color brown2 = Color(0xff842121);
const Color brown3 = Color(0xff731d1d);
const Color brown4 = Color(0xff631919);
const Color brown5 = Color(0xff521515);
const Color brown6 = Color(0xff421010);
const Color brown7 = Color(0xff310c0c);
const Color brown8 = Color(0xff210808);
const Color brown9 = Color(0xff100404);

const Color brown01 = Color(0xffae3f3f);
const Color brown02 = Color(0xffb75454);
const Color brown03 = Color(0xffc06969);
const Color brown04 = Color(0xffc97f7f);
const Color brown05 = Color(0xffd29494);
const Color brown06 = Color(0xffdba9a9);
const Color brown07 = Color(0xffe4bfbf);
const Color brown08 = Color(0xffedd4d4);
const Color brown09 = Color(0xff1ef6e9e9);

const Color blue0 = Color(0xff8470ff);
const Color blue1 = Color(0xff7664e5);
const Color blue2 = Color(0xff6959cc);
const Color blue3 = Color(0xff5c4eb2);
const Color blue4 = Color(0xff4f4399);
const Color blue5 = Color(0xff42387f);
const Color blue6 = Color(0xff342c66);
const Color blue7 = Color(0xff27214c);
const Color blue8 = Color(0xff1a1633);
const Color blue9 = Color(0xff0d0b19);

const Color blue01 = Color(0xff8470ff);
const Color blue02 = Color(0xff907eff);
const Color blue03 = Color(0xff928cff);
const Color blue04 = Color(0xffa89aff);
const Color blue05 = Color(0xffb5a9ff);
const Color blue06 = Color(0xffc1b7ff);
const Color blue07 = Color(0xffcdc5ff);
const Color blue08 = Color(0xff08534949);
const Color blue09 = Color(0xff0f534949);

const Color black = Color(0xff000000);
const Color white = Color(0xffffffff);
const Color transparent = Color(0xff00000000);
const Color default_white = Color(0xfffff3f3f3);

const Color tang0 = Color(0xffffa500);
const Color tang = Color(0xffC0C0C0);

const Color orang0 = Color(0xffe46514);
const Color orang1 = Color(0xfff79836);
//const Color orang2 = Color(0xffee6723);

const Color orange0 = Color(0xffffa500);
const Color orange1 = Color(0xffe59400);
const Color orange2 = Color(0xffcc8400);
const Color orange3 = Color(0xffb27300);
const Color orange4 = Color(0xff996300);
const Color orange5 = Color(0xff7f5200);
const Color orange6 = Color(0xff664200);
const Color orange7 = Color(0xff4c3100);
const Color orange8 = Color(0xff332100);
const Color orange9 = Color(0xff191000);

const Color orange01 = Color(0xffffa500);
const Color orange02 = Color(0xffffae19);
const Color orange03 = Color(0xffffb732);
const Color orange04 = Color(0xffffc04c);
const Color orange05 = Color(0xffffc966);
const Color orange06 = Color(0xffffd27f);
const Color orange07 = Color(0xffffdb99);
const Color orange08 = Color(0xffffe4b2);
const Color orange09 = Color(0xffffedcc);
const Color orange010 = Color(0xfffff6e5);

const Color yellow0 = Color(0xffffff00);
const Color yellow1 = Color(0xffe5e500);
const Color yellow2 = Color(0xffcccc00);
const Color yellow3 = Color(0xffb2b200);
const Color yellow4 = Color(0xff999900);
const Color yellow5 = Color(0xff7f7f00);
const Color yellow6 = Color(0xff666600);
const Color yellow7 = Color(0xff4c4c00);
const Color yellow8 = Color(0xff333300);
const Color yellow9 = Color(0xff191900);

const Color yellow01 = Color(0xffffff00);
const Color yellow02 = Color(0xffffff19);
const Color yellow03 = Color(0xffffff32);
const Color yellow04 = Color(0xffffff4c);
const Color yellow05 = Color(0xffffff66);
const Color yellow06 = Color(0xffffff7f);
const Color yellow07 = Color(0xffffff99);
const Color yellow08 = Color(0xffffffb2);
const Color yellow09 = Color(0xffffffcc);
const Color yellow010 = Color(0xffffffe5);

const Color red0 = Color(0xffff0000);
const Color red1 = Color(0xffe50000);
const Color red2 = Color(0xffcc0000);
const Color red3 = Color(0xffb20000);
const Color red4 = Color(0xff990000);
const Color red5 = Color(0xff7f0000);
const Color red6 = Color(0xff660000);
const Color red7 = Color(0xff4c0000);
const Color red8 = Color(0xff330000);
const Color red9 = Color(0xff190000);

const Color red00 = Color(0xffff0000);
const Color red01 = Color(0xffff1919);
const Color red02 = Color(0xffff3232);
const Color red03 = Color(0xffff4c4c);
const Color red04 = Color(0xffff6666);
const Color red05 = Color(0xffff7f7f);
const Color red06 = Color(0xffff9999);
const Color red07 = Color(0xffffb2b2);
const Color red08 = Color(0xffffcccc);
const Color red09 = Color(0xffffe5e5);

const Color dark_green0 = Color(0xff006400);
const Color dark_green1 = Color(0xff005a00);
const Color dark_green2 = Color(0xff005000);
const Color dark_green3 = Color(0xff004600);
const Color dark_green4 = Color(0xff003c00);
const Color dark_green5 = Color(0xff003200);
const Color dark_green6 = Color(0xff002800);
const Color dark_green7 = Color(0xff001e00);
const Color dark_green8 = Color(0xff001400);
const Color dark_green9 = Color(0xff000a00);
const Color dark_green10 = Color(0xff000000);

const Color dark_green01 = Color(0xff006400);
const Color dark_green02 = Color(0xff197319);
const Color dark_green03 = Color(0xff328332);
const Color dark_green04 = Color(0xff4c924c);
const Color dark_green05 = Color(0xff66a266);
const Color dark_green06 = Color(0xff7fb17f);
const Color dark_green07 = Color(0xff99c199);
const Color dark_green08 = Color(0xffb2d0b2);
const Color dark_green09 = Color(0xffcce0cc);
const Color dark_green010 = Color(0xffe5efe5);

const Color light_green0 = Color(0xff00ff00);
const Color light_green1 = Color(0xff00e500);
const Color light_green2 = Color(0xff00cc00);
const Color light_green3 = Color(0xff00b200);
const Color light_green4 = Color(0xff009900);
const Color light_green5 = Color(0xff007f00);
const Color light_green6 = Color(0xff006600);
const Color light_green7 = Color(0xff004c00);
const Color light_green8 = Color(0xff003300);
const Color light_green9 = Color(0xff001900);
const Color light_green10 = Color(0xff000000);

const Color light_green00 = Color(0xff00ff00);
const Color light_green01 = Color(0xff19ff19);
const Color light_green02 = Color(0xff32ff32);
const Color light_green03 = Color(0xff4cff4c);
const Color light_green04 = Color(0xff66ff66);
const Color light_green05 = Color(0xff7fff7f);
const Color light_green06 = Color(0xff99ff99);
const Color light_green07 = Color(0xffb2ffb2);
const Color light_green08 = Color(0xffccffcc);
const Color light_green09 = Color(0xffe5ffef);
const Color light_green010 = Color(0xffffffff);

const Color pink0 = Color(0xffff69b4);
const Color pink1 = Color(0xffe55ea2);
const Color pink2 = Color(0xffcc5490);
const Color pink3 = Color(0xffb2497d);
const Color pink4 = Color(0xff993f6c);
const Color pink5 = Color(0xff7f345a);
const Color pink6 = Color(0xff662a48);
const Color pink7 = Color(0xff4c1f36);
const Color pink8 = Color(0xff331524);
const Color pink9 = Color(0xff190a12);
const Color pink10 = Color(0xff000000);

const Color pink01 = Color(0xffff78bb);
const Color pink02 = Color(0xffff87c3);
const Color pink03 = Color(0xffff96ca);
const Color pink04 = Color(0xffffa5d2);
const Color pink05 = Color(0xffffb4d9);
const Color pink06 = Color(0xffffc3e1);
const Color pink07 = Color(0xffffd2e8);
const Color pink08 = Color(0xffffe1f0);
const Color pink09 = Color(0xfffff0f7);
const Color pink010 = Color(0xffffffff);

const Color app_blue = Color(0xff0072e5);

const Color blue010 = Color(0xff0f534949);

const Color m_blue0 = Color(0xff0000ff);
const Color m_blue1 = Color(0xff0000e5);
const Color m_blue2 = Color(0xff0000cc);
const Color m_blue3 = Color(0xff0000b2);
const Color m_blue4 = Color(0xff000099);
const Color m_blue5 = Color(0xff00007f);
const Color m_blue6 = Color(0xff000066);
const Color m_blue7 = Color(0xff00004c);
const Color m_blue8 = Color(0xff000033);
const Color m_blue9 = Color(0xff000019);

const Color plain_blue = Color(0xff000064);
const Color m_blue01 = Color(0xff1919ff);
const Color m_blue02 = Color(0xff4c4cff);
const Color m_blue03 = Color(0xff6666ff);
const Color m_blue04 = Color(0xff7f7fff);
const Color m_blue05 = Color(0xff9999ff);
const Color m_blue06 = Color(0xffb2b2ff);
const Color m_blue07 = Color(0xffccccff);
const Color m_blue08 = Color(0xffe5e5ff);

const Color azure_blue00 = Color(0xff007fff);
const Color azure_blue01 = Color(0xff198bff);
const Color azure_blue02 = Color(0xff3298ff);
const Color azure_blue03 = Color(0xff4ca5ff);
const Color azure_blue04 = Color(0xff66b2ff);
const Color azure_blue05 = Color(0xff7fbfff);
const Color azure_blue06 = Color(0xff99cbff);
const Color azure_blue07 = Color(0xffb2d8ff);
const Color azure_blue08 = Color(0xffcce5ff);
const Color azure_blue09 = Color(0xffe5f2ff);

const Color azure_blue0 = Color(0xff007fff);
const Color azure_blue1 = Color(0xff0072e5);
const Color azure_blue2 = Color(0xff0065cc);
const Color azure_blue3 = Color(0xff0058b2);
const Color azure_blue4 = Color(0xff004c99);
const Color azure_blue5 = Color(0xff003f7f);
const Color azure_blue6 = Color(0xff003266);
const Color azure_blue7 = Color(0xff00264c);
const Color azure_blue8 = Color(0xff001933);
const Color azure_blue9 = Color(0xff000c19);

const Color light_grey = Color(0xff14000000);
const Color light_white = Color(0xffc7ffffff);
const Color dark_grey = Color(0xff96000000);
const Color brown00 = Color(0xffa52a2a);
const Color brown010 = Color(0xffffffff);
const Color black1 = Color(0xffcd000000);
const Color brown10 = Color(0xff000000);
const Color white60 = Color(0xffa0ffffff);
const Color white_two = Color(0xffefefef);
const Color white_three = Color(0xffebebeb);
const Color white_four = Color(0xffe0e0e0);
const Color white_five = Color(0xffdadada);
const Color blue = Color(0xff031cd7);
const Color gray = Color(0xff333333);
const Color dark_gray = Color(0xff282a2b);
const Color dark_grey_two = Color(0xff191a1b);
const Color warm_grey = Color(0xff7f7f7f);
const Color warm_grey_two = Color(0xff9c9c9c);
const Color warm_grey_three = Color(0xff8b8b8b);
const Color warm_grey_four = Color(0xff979797);
const Color dark_mint = Color(0xff51c05c);
const Color cornflower_blue_two = Color(0xff4f62d7);
const Color cornflower_blue_two_24 = Color(0xff3d4f62d7);
const Color cornflower_blue_two_dark = Color(0xff475bd4);
const Color cornflower_blue_light_40 = Color(0xff64bec5f7);
const Color cornflower_blue = Color(0xff6274e2);
const Color cornflower_blue_dark = Color(0xff303F9F);
const Color cornflower_blue_darkest = Color(0xff2d3a93);
const Color gray_light = Color(0xffe8e8e8);
const Color gray_transparent = Color(0xffa6efefef);
const Color gray_dark = Color(0xff858585);
const Color gray_dark_transparent = Color(0xffae858585);
const Color gray_darkest = Color(0xffae282828);
const Color black_10 = Color(0xff19000000);
const Color ivory = Color(0xfff8efe6);
const Color ivory_dark = Color(0xfff7e8d9);
const Color green = Color(0xff38be55);
const Color green_dark = Color(0xff2da346);
const Color red = Color(0xffe94f4f);
const Color brown = Color(0xff4e342e);
const Color mat = Color(0xfff35c4eb2);
const Color swap_holo_green_bright = Color(0xff48B94A);
const Color swap_holo_bule_bright = Color(0xff4996e5);
const Color swap_holo_pure_bright = Color(0xffd066b1);
const Color light_white1 = Color(0xff88ffffff);
