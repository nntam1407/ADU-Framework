/*============================================================================
 PROJECT: SportLocker
 FILE:    ShareLinkedInView.m
 AUTHOR:  vientc
 DATE:    9/26/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "ShareLinkedInView.h"
#import "UIView+PopUp.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
@interface ShareLinkedInView()<IconTextBoxViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, copy) ShareLinkedInCallBack callback;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

- (IBAction)didTouchOnShareButton:(id)sender;
- (IBAction)didTouchOnCancelButton:(id)sender;

@end


@implementation ShareLinkedInView

static ShareLinkedInView *sharedObj = nil;

+ (ShareLinkedInView *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!sharedObj) {
            sharedObj = [[IBHelper sharedUIHelper] loadViewNib:@"ShareLinkedInView"];
        }
    });
    return sharedObj;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.headerImageView.image = [[IBHelper sharedUIHelper] middleStretchCommonImage:@"nav"];
    [self.shareButton setBackgroundImage:[[IBHelper sharedUIHelper] middleStretchImage:@"btn_login"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[[IBHelper sharedUIHelper] middleStretchImage:@"btn_login"] forState:UIControlStateNormal];
    
    self.mainView.layer.cornerRadius = 5.0f;
    self.mainView.layer.borderColor = UIColorFromRGB(kBorderColor).CGColor;
    self.mainView.layer.borderWidth = 0.5;
    
    self.mainView.layer.shadowColor = UIColorFromRGB(0x5a5a5a).CGColor;
    self.mainView.layer.shadowOffset = CGSizeMake(0, 0);
    self.mainView.layer.shadowRadius = 1;
    self.mainView.layer.shadowOpacity = 0.75;
    self.mainView.layer.shouldRasterize = NO;
    
    self.shareContent.layer.borderColor = UIColorFromRGB(0xb8b8b8).CGColor;
    self.shareContent.layer.borderWidth = 1.0f;
    self.shareContent.layer.cornerRadius = 5.0f;
    self.shareContent.backgroundColor = [UIColor whiteColor];
}

- (void)setSharingCallBack:(ShareLinkedInCallBack)callback{
    self.callback = callback;
}

- (IBAction)didTouchOnShareButton:(id)sender {
    if (_callback) {
        _callback(self.shareContent.text, NO);
    }
    [self hide];
}

- (IBAction)didTouchOnCancelButton:(id)sender {
    if (_callback) {
        _callback(self.shareContent.text ,YES);
    }
    [self hide];
}

-(void)showModalWithOpacityOverlay:(CGFloat)opacity{
    [super showModalWithOpacityOverlay:opacity];
    [self.shareContent becomeFirstResponder];
}

@end
