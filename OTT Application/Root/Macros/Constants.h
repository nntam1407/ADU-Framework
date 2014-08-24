/*============================================================================
 PROJECT: SportLocker
 FILE:    Contants.h
 AUTHOR:  Khoai Nguyen
 =============================================================================*/

#define kUserId                                 @"kUserId"
#define SLMainStoryboard                        @"MainStoryboard"
#define SLLeagueStoryboard                      @"LeagueStoryboard"
#define SLScoreStatusPostGame                   @"PostGame"
#define SLScoreStatusLiveGame                   @"LiveGame"
#define SLScoreStatusPreGame                    @"PreGame"



/* depredecations */
typedef enum {
    MKTextAlignmentLeft = 0,
    MKTextAlignmentCenter,
    MKTextAlignmentRight,
} MKTextAlignment;

typedef enum {
    MKLineBreakModeWordWrap = 0,            // Wrap at word boundaries
    MKLineBreakModeCharacterWrap,           // Wrap at character boundaries
    MKLineBreakModeClip,                    // Simply clip when it hits the end of the rect
    MKLineBreakModeHeadTruncation,          // Truncate at head of line: "...wxyz". Will truncate multiline text on first line
    MKLineBreakModeTailTruncation,          // Truncate at tail of line: "abcd...". Will truncate multiline text on last line
    MKLineBreakModeMiddleTruncation,        // Truncate middle of line:  "ab...yz". Will truncate multiline text in the middle
} MKLineBreakMode;

#define SupportiOS(x)                           [[UIDevice currentDevice] hasSupportVersion:x]
#define SupportiOS7                             SupportiOS(7)
// iOS version checks
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define mainAppDelegate ((ATAppDelegate *)[[UIApplication sharedApplication] delegate])

#define STRING_USER_DEFAULT_ORIENTATION                         @"user_default_orientation"

/* common color */
#define kDarkGrayColor                          0x484848
#define kLightGrayColor                         0xb1b1b1
#define kGreenColor                             0x91c519
#define kColorLabelInTextField                  0x7b5c18
#define kColorTextField                         0x5c5c5c
#define kColorDescriptionText                   0xcccccc
#define kBorderColor                            0xb8b8b8
#define kTextColor                              0x191717
#define kLineColor                              0xe4e4e4
#define kLightBlueColor                         0x005c9c
#define kAvatarBorderColor                      0xaeaeae
#define SLCommonRedColor                        UIColorFromRGB(0xd62727)
#define SLCommonBlackColor(x)                      [UIColor colorWithRed:18.0f/255 green:19.0f/255 blue:20.0f/255 alpha:x]


/*----------------------------------------------------------------------------
 Animations
 -----------------------------------------------------------------------------*/
#define kAnimationDuration                      0.25f

/*----------------------------------------------------------------------------
 Method:      Tamnn's code   NexleSoft
 -----------------------------------------------------------------------------*/

#define kProfileImageBlurRadius                 50.0f
#define KReceiveMessageNotification             @"KReceiveMessageNotification"
#define KSendMessageNotification                @"KSendMessageNotification"
#define kXMPPRoomDidJoint                       @"kXMPPRoomDidJoint"
#define kXMPPRoomDidCreate                      @"kXMPPRoomDidCreate"
#define kXMPPUserDidJointToConversation         @"kXMPPUserDidJointToConversation"
#define kXMPPOccupantDidJoin                    @"kXMPPOccupantDidJoin"
#define kXMPPOccupantDidLeave                   @"kXMPPOccupantDidLeave"

/* size macros */
#define kCornerRadius                           IS_IPAD ? 10 : 5
#define kIconPadding                            IS_IPAD ? 17 : 5
#define kTextFieldPadding                       IS_IPAD ? 80 : 40
#define kTextFontSize                           IS_IPAD ? 24 : 13
#define kBorderHeight                           IS_IPAD ? 0.5 : 0.5
#define kLeftMarginTextBox                      IS_IPAD ? 20 : 10
#define kKeyboardKeyboardIphone                 216.0f                        

/*----------------------------------------------------------------------------
 Notifications in the app
 -----------------------------------------------------------------------------*/
#define kAuthenticationSucceededEventNotification   @"kAuthenticationSucceededEventNotification"
#define kAuthenticationFailedEventNotification      @"kAuthenticationFailedEventNotification"
#define kUpdatedProfileInformationNotification      @"kUpdatedProfileInformationNotification"
#define kChangedSelectedPlaceNotification           @"kChangedSelectedPlaceNotification"
#define kAddedNewPlaceCommentNotification           @"kAddedNewPlaceCommentNotification"
#define kAddedNewDealCommentNotification            @"kAddedNewDealCommentNotification"
#define kDeactivatedDealNotification                @"kDeactivatedDealNotification"
#define kReactivatedDealNotification                @"kReactivatedDealNotification"

/*----------------------------------------------------------------------------
Common Texts
 -----------------------------------------------------------------------------*/
#define kNotAvailableString                     NSLocalizedString(@"Not Available", @"Error Message")
#define kNotHavePermissionMessage               NSLocalizedString(@"You don't have permission to access this function.", @"Error Message")
/*----------------------------------------------------------------------------
 Static Arrays
 -----------------------------------------------------------------------------*/
#define SLMainNavigatorItems                   @[ NSLocalizedString(@"Trending", nil), NSLocalizedString(@"Favorites", nil), NSLocalizedString(@"Scores", nil), NSLocalizedString(@"News", nil), NSLocalizedString(@"Born today", nil), NSLocalizedString(@"On this day", nil), NSLocalizedString(@"Submissions", nil) ]

#define SLiPhoneMainNavigatorItems             @[ NSLocalizedString(@"Submissions", nil), NSLocalizedString(@"Born today", nil), NSLocalizedString(@"Scores", nil), NSLocalizedString(@"Trending", nil), NSLocalizedString(@"Sports", nil), NSLocalizedString(@"Favorites", nil),  NSLocalizedString(@"News", nil),  NSLocalizedString(@"On this day", nil) ]

#define SLLeageNavigatorItems             @[ NSLocalizedString(@"Scores", nil), NSLocalizedString(@"Standings", nil), NSLocalizedString(@"Draft", nil), NSLocalizedString(@"Odds", nil), NSLocalizedString(@"Injuries", nil), NSLocalizedString(@"Venues", nil),  NSLocalizedString(@"Leaders", nil),  NSLocalizedString(@"Numbers",  nil), NSLocalizedString(@"All Time Records",  nil), NSLocalizedString(@"Aways",  nil), NSLocalizedString(@"Super Bowl",  nil) ]

