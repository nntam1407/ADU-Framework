/*============================================================================
 PROJECT: SportLocker
 FILE:    CustomNavigationBar.h
 AUTHOR:  Ngoc Tam Nguyen
 DATE:    10/11/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>


/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   CustomNavigationBar
 =============================================================================*/

@interface CustomNavigationBar : UIView

@property (strong, nonatomic) UIImageView   *barBackgroundImage;
@property (strong, nonatomic) UILabel       *barTitleLabel;
@property (strong, nonatomic) UIButton      *leftBarButton;
@property (strong, nonatomic) UIButton      *rightBarButton;

@property (assign, nonatomic) float         leftButtonMargin;
@property (assign, nonatomic) float         rightButtonMargin;
@property (assign, nonatomic) float         titlePadding;

#pragma mark - Methods

- (void)createLeftButtonWithImage:(UIImage *)image
                  backgroundImage:(UIImage *)backgroundImage
                            title:(NSString *)title;

- (void)createLeftButtonWithImageName:(NSString *)imageName
                  backgroundImageName:(NSString *)backgroundImageName
                                title:(NSString *)title;

- (void)createRightButtonWithImage:(UIImage *)image
                   backgroundImage:(UIImage *)backgroundImage
                             title:(NSString *)title;

- (void)createRightButtonWithImageName:(NSString *)imageName
                   backgroundImageName:(NSString *)backgroundImageName
                                 title:(NSString *)title;

@end
