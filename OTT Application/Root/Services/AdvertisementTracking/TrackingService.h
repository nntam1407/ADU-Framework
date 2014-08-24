/*============================================================================
 PROJECT: SportLocker
 FILE:    TrackingService.h
 AUTHOR:  Ngoc Tam Nguyen
 DATE:    10/7/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "Flurry.h"

/*============================================================================
 MACRO
 =============================================================================*/

typedef enum {
    PageViewTypeLogin = 0,
    PageViewTypeSignUp,
    PageViewTypeForgotPassword,
    PageViewTypeCountryCode,
    PageViewTypeInviteFriends,
    PageViewTypeMyDeal,
    PageViewTypeDealDetail,
    PageViewTypeAddNewDeal,
    PageViewTypeReactiveDeal,
    PageViewTypeFilterView,
    PageViewTypeAddNewDealComment,
    PageViewTypeShareToFriends,
    PageViewTypeMapDirection,
    PageViewTypeDealComments,
    PageViewTypePlacesList,
    PageViewTypePlaceDetail,
    PageViewTypeAddNewPlaceComment,
    PageViewTypePlaceComments,
    PageViewTypeAddNewPlace,
    PageViewTypeEditPlace,
    PageViewTypeSearch,
    PageViewTypeSearchMember,
    PageViewTypeSeachLocation,
    PageViewTypeSettings,
    PageViewTypeNotifications,
    PageViewTypeProfile,
    PageViewTypeUserProfile,
    PageViewTypeHistorical,
    PageViewTypeEditProfile,
    PageViewTypeFriends,
    PageViewTypeMessages,
    PageViewTypeFavorites,
    PageViewTypeHelp,
    PageViewTypeGuide,
    PageViewClientFeedback,
    PageViewTypeTopCharts,
    PageViewTypeSelectCategory,
    PageViewTypeUserCheckIn,
    PageViewTypeDetailCheckIn,
    PageViewTypeLeftMenu
} PageViewType;

#define kFlurryAPIKey   IS_IPAD ? @"9965HG7WW2F4YGP6GYDY" : @"MWN3KKH7CPG57MHH8QV9"

#define kPageViews      [NSArray arrayWithObjects:\
@"Login View", @"Sign-up View", @"Forgot Password View", @"Country Code View", @"Invite Friends View", @"My Deals View", \
@"Deal Detail View", @"Add New Deal View", @"Reactive Deal View", @"Filter View", @"Add New Deal Comment View",  @"Share To Friends View", \
@"Map Direction View", @"Deal's Comments View", @"Places List View", @"Place Detail View", \
@"Add New Place Comment View", @"Place's Comments View", @"Add New Place View", @"Edit Place View", @"Search View",\
@"Search Member View", @"Search Location View", @"Settings View", @"Notifications View",\
@"User Profile View", @"Profile View", @"Historical View", @"Edit Profile View", @"Friends View", @"Messages View",\
 @"Favorites View", @"Help View", @"Guide View", @"Client Feedback View", @"Top Charts View", @"Select category View", @"User Check In View", @"Detail Check In View", @"Left Menu View", nil]

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   TrackingService
 =============================================================================*/


@interface TrackingService : NSObject

+ (id)sharedTrackingService;

- (void)startSession;
- (void)registerPushNotification:(NSString *)deviceToken;
- (void)logPageView:(PageViewType)type;
- (void)endTimeAtPageView:(PageViewType)type;
- (void)trackingLocation;

@end
