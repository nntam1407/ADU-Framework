/*============================================================================
 PROJECT: SportLocker
 FILE:    IconTextBoxView.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "IconTextBoxView.h"
#import "WarningNotifyControl.h"
#import "NSStringExtension.h"
/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kContentLeftMargin  25
#define kWarningButtonRightMargin  3

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation IconTextBoxView
@synthesize iconImage, iconSize;
@synthesize delegate;
@synthesize iconLeftMargin, iconTopMargin;
@synthesize iconView;
@synthesize contentLeftMargin;
@synthesize warningMessage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createBaseUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createBaseUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /* get bounds of view */
    CGRect bounds = self.bounds;
    
    /* relayout for icon view */
    CGRect rect = iconView.frame;
    rect.size = self.iconSize;
    rect.origin.x = iconLeftMargin;
    rect.origin.y = (iconTopMargin > 0 ? iconTopMargin : (bounds.size.height - self.iconSize.height)/2);
    iconView.frame = rect;
    
    /* layout for warning button */
    rect = warningButton.frame;
    rect.origin.x = bounds.size.width - rect.size.width - kIconRightMargin;
    rect.origin.y = (bounds.size.height - rect.size.height)/2;
    warningButton.frame = rect;
}

/*----------------------------------------------------------------------------
 Method:      createBaseUI
 Description: create basic subviews
 ----------------------------------------------------------------------------*/
- (void)createBaseUI {
    /* set content left margin */
    contentLeftMargin = kContentLeftMargin;
    iconLeftMargin = kIconLeftMargin;
    
    self.contentTopMargin = 0;
    self.iconTopMargin = 0;
    
    /* settings for the view */
    self.backgroundColor = [UIColor clearColor];
    
    /* create background view */
    backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundView.image = [[IBHelper sharedUIHelper] middleStretchImage:@"box_text"];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:backgroundView];
    
    /* create icon view */
    iconView = [[UIImageView alloc] init];
    [self addSubview:iconView];
    
    /* add warning button */
    warningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [warningButton setImage:[[IBHelper sharedUIHelper] loadImage:@"icon_check"] forState:UIControlStateSelected];
    [warningButton setImage:[[IBHelper sharedUIHelper] loadImage:@"icon_error"] forState:UIControlStateNormal];
    [warningButton addTarget:self action:@selector(didTouchedOnWarningButton:) forControlEvents:UIControlEventTouchUpInside];
    warningButton.frame = CGRectMake(0, 0, 20, 20);
    warningButton.hidden = YES;
    [self addSubview:warningButton];
}

- (void)allowToAutoResizeView:(BOOL)status {
    /* auto resize subviews */
    if(status) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
}

- (void)didTouchedOnWarningButton:(id)sender {
    CallTarget(delegate, @selector(textBoxDidTouchedOnWarning:), self);
    
    /* show warning message here */
    [[WarningNotifyControl sharedWarningNotifyControl] showNotifyWithTitle:nil
                                                                   message:warningMessage
                                                                    onView:sender];
}

- (void)showWarningStatus:(WarningStatus)status {
    /* show or hide warning status */
    warningButton.hidden = (status == WarningStatusHide);
    
    /* show error or ok status */
    warningButton.selected = (status == WarningStatusShowOK);
    warningButton.userInteractionEnabled = (status == WarningStatusShowError);
    
    /* bring warning button to front */
    [self bringSubviewToFront:warningButton];
    
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 1;
    
    if (status == WarningStatusShowError) {
        self.layer.shadowColor = [UIColor redColor].CGColor;
    } else {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
    }
    /* reload layout */
    [self setNeedsLayout];
}

- (void)hideKeyboard {
    
}

- (BOOL)needToShowOneOfErrorMessages:(NSArray *)errorMessages
                    ifInvalidAtLeast:(NSInteger)atLeast
                              atMost:(NSInteger)atMost
            usingMoreValidationBlock:(void(^)(BOOL *valid))block {
    
    BOOL status = YES;
    
    /* get string value from compare field */
    NSString *stringValue = self.text;
    ValidationType type;
    
    if (!stringValue) {
        type = kValidationTypeEmpty;
    } else {
        type = [stringValue validInAtLeastThreshold:atLeast atMostThreshold:atMost];
    }
    
    if(type != kValidationTypeNormal) {
        self.warningMessage = errorMessages[type - 1];
    }

    status = (type == kValidationTypeNormal);
    
    /* additional check */
    if(block != NULL) {
        block(&status);
    }
    
    //    [self showWarningStatus:(status ? WarningStatusShowOK : WarningStatusShowError)];
    /* TaiHH: remove green checked icon for DealHits */
    [self showWarningStatus:(status ? WarningStatusHide : WarningStatusShowError)];
    return status;
}

- (BOOL)needToShowOneOfErrorMessages:(NSArray *)errorMessages
            usingMoreValidationBlock:(void(^)(BOOL *valid))block {
    
    BOOL isValid = [self needToShowOneOfErrorMessages:errorMessages
                                     ifInvalidAtLeast:0
                                               atMost:MAXFLOAT
                             usingMoreValidationBlock:block];
    return isValid;
}
/*----------------------------------------------------------------------------
 Method:      setIconImage
 Description: set new image for icon view and relayout it
 ----------------------------------------------------------------------------*/
- (void)setIconImage:(UIImage *)icon {
    if(iconView && icon) {
        iconView.image = icon;
        [self setIconSize:icon.size];
        [self setNeedsLayout];
    }
}

/*----------------------------------------------------------------------------
 Method:      setIconSize
 Description: set new size for icon
 ----------------------------------------------------------------------------*/
- (void)setIconSize:(CGSize)size {
    iconSize = size;
    [self setNeedsLayout];
}

/*----------------------------------------------------------------------------
 Method:      setIconLeftMargin
 Description: set new left margin for icon
 ----------------------------------------------------------------------------*/
- (void)setIconLeftMargin:(CGFloat)f {
    iconLeftMargin = f;
    [self setNeedsLayout];
}

/*----------------------------------------------------------------------------
 Method:      setIconTopMargin
 Description: set new top margin for icon
 ----------------------------------------------------------------------------*/
- (void)setIconTopMargin:(CGFloat)f {
    iconTopMargin = f;
    [self setNeedsLayout];
}

/*----------------------------------------------------------------------------
 Method:      setBackgroundImage
 Description: set image for background image
 ----------------------------------------------------------------------------*/
- (void)setBackgroundImage:(UIImage *)image {
    backgroundView.image = image;
}

/*----------------------------------------------------------------------------
 Method:      setContentLeftMargin
 Description: set new margin value to content view
 ----------------------------------------------------------------------------*/
- (void)setContentLeftMargin:(CGFloat)margin {
    /* will be overridden in subclasses */
    contentLeftMargin = margin;
    [self setNeedsLayout];
}

/*----------------------------------------------------------------------------
 Method:      contentLeftMargin
 Description: get content left margin
 ----------------------------------------------------------------------------*/
- (CGFloat)contentLeftMargin {
    return contentLeftMargin;
}

/*----------------------------------------------------------------------------
 Method:      setContentTopMargin   set top margin for content
 -----------------------------------------------------------------------------*/
-(void)setContentTopMargin:(CGFloat)f
{
    contentTopMargin = f;
    
    [self setNeedsLayout];
}

/*----------------------------------------------------------------------------
 Method:      contentTopMargin   get top margin
 -----------------------------------------------------------------------------*/
-(CGFloat)contentTopMargin
{
    return contentTopMargin;
}
@end
