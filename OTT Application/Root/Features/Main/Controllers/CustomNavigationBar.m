/*============================================================================
 PROJECT: SportLocker
 FILE:    CustomNavigationBar.m
 AUTHOR:  Ngoc Tam Nguyen
 DATE:    10/11/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "CustomNavigationBar.h"
#import <UIKit/UIDevice.h>

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/

#define kDefaultNaviBarBackgroundImage          @"nav"
#define kDefaultLeftButtonMarginLeft            10.0f
#define kDefaultLeftButtonMarginRight           10.0f
#define kDefaultTitlePadding                    10.0f
#define kDefaultButtonFont                      FontArialWithSize(21)

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface CustomNavigationBar()

#pragma mark - Private methods

- (void)createBaseUI;

@end


@implementation CustomNavigationBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createBaseUI];
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

#pragma mark - Overide methods

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createBaseUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect titleFrame = self.barTitleLabel.frame;
    titleFrame.size.width = self.bounds.size.width - self.titlePadding;
    
    // Layout for left bar button
    if(self.leftBarButton) {
        CGRect leftButtonFrame = self.leftBarButton.frame;
        leftButtonFrame.origin.x = self.leftButtonMargin;
        leftButtonFrame.origin.y = (self.bounds.size.height - self.leftBarButton.bounds.size.height) / 2;
        
        self.leftBarButton.frame = leftButtonFrame;
        
        // Cal title frame with
        titleFrame.size.width -= self.leftButtonMargin + leftButtonFrame.size.width;
    }
    
    // Layout for right button
    if(self.rightBarButton) {
        CGRect rightButtonFrame = self.rightBarButton.frame;
        rightButtonFrame.origin.x = self.bounds.size.width - self.rightButtonMargin - rightButtonFrame.size.width;
        rightButtonFrame.origin.y = (self.bounds.size.height - self.rightBarButton.bounds.size.height) / 2;
        
        self.rightBarButton.frame = rightButtonFrame;
        
        // Cal title frame with
        titleFrame.size.width -= self.rightButtonMargin + rightButtonFrame.size.width;
    }
    
    // Layout for title
    titleFrame.size.height = self.bounds.size.height;
    titleFrame.origin.y = 0;
    titleFrame.origin.x = (self.bounds.size.width - titleFrame.size.width) / 2;
    self.barTitleLabel.frame = titleFrame;
}

- (void)setBarTitleLabel:(UILabel *)barTitleLabel {
    if(_barTitleLabel.superview) {
        [_barTitleLabel removeFromSuperview];
    }
    
    if(barTitleLabel) {
        _barTitleLabel = barTitleLabel;
        [self addSubview:_barTitleLabel];
        
        [self setNeedsLayout];
    }
}

- (void)setLeftBarButton:(UIButton *)leftBarButton {
    _leftBarButton = leftBarButton;
    _leftBarButton.showsTouchWhenHighlighted  = YES;
    
    if(_leftBarButton.superview == nil) {
        [self addSubview:self.leftBarButton];
    }
    
    [self setNeedsLayout];
}

- (void)setRightBarButton:(UIButton *)rightBarButton {
    [self.rightBarButton removeFromSuperview];
    
    _rightBarButton = rightBarButton;
    _rightBarButton.showsTouchWhenHighlighted = YES;
    
    if(self.rightBarButton.superview == nil && self.rightBarButton != nil) {
        [self addSubview:self.rightBarButton];
    }
    
    [self setNeedsLayout];
}

- (void)setLeftButtonMargin:(float)leftButtonMargin {
    _leftButtonMargin = leftButtonMargin;
    
    [self setNeedsLayout];
}

- (void)setRightButtonMargin:(float)rightButtonMargin {
    _rightButtonMargin = rightButtonMargin;
    
    [self setNeedsLayout];
}

- (void)setTitlePadding:(float)titlePadding {
    _titlePadding = titlePadding;
    
    [self setNeedsLayout];
}

#pragma mark - Private methods

- (void)createBaseUI {
    self.leftButtonMargin = kDefaultLeftButtonMarginLeft;
    self.rightButtonMargin = kDefaultLeftButtonMarginRight;
    self.titlePadding = kDefaultTitlePadding;
    
    if(!self.barBackgroundImage) {
        self.barBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.barBackgroundImage];
        
        self.barBackgroundImage.image = [[IBHelper sharedUIHelper] middleStretchImage:kDefaultNaviBarBackgroundImage];
    }
    
    if(!self.barTitleLabel) {
        self.barTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.barTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.barTitleLabel.numberOfLines = 1;
        self.barTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.barTitleLabel.font = kDefaultButtonFont;
        self.barTitleLabel.backgroundColor = [UIColor clearColor];
        self.barTitleLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:self.barTitleLabel];
    }
}

#pragma mark - Methods

- (void)createLeftButtonWithImage:(UIImage *)image backgroundImage:(UIImage *)backgroundImage title:(NSString *)title {
    
    CGSize buttonSize = CGSizeZero;
    
    if(image) {
        buttonSize = image.size;
    } else {
        
        if(SupportiOS7) {
            NSDictionary *attributes = @{NSFontAttributeName:kDefaultButtonFont};
            buttonSize = [title sizeWithAttributes:attributes];
        } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
            buttonSize = [title sizeWithFont:kDefaultButtonFont];
#endif
        }
        buttonSize.height = backgroundImage.size.height;
        buttonSize.width += 16; // Left, right padding is 8
    }
    
    if(self.leftBarButton) {
        CGRect leftButtonFrame = self.leftBarButton.frame;
        leftButtonFrame.size = buttonSize;
        self.leftBarButton.frame = leftButtonFrame;
        
        // Relayout button
        [self setNeedsLayout];
    } else {
        self.leftBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
        self.leftBarButton.titleLabel.font = kDefaultButtonFont;
    }
    
    [self.leftBarButton setTitle:title forState:UIControlStateNormal];
    [self.leftBarButton setImage:image forState:UIControlStateNormal];
    [self.leftBarButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (void)createLeftButtonWithImageName:(NSString *)imageName
                  backgroundImageName:(NSString *)backgroundImageName
                                title:(NSString *)title {
    UIImage *image = [[IBHelper sharedUIHelper] loadImage:imageName];
    UIImage *backgroundImage = [[IBHelper sharedUIHelper] middleStretchImage:backgroundImageName];
    
    [self createLeftButtonWithImage:image backgroundImage:backgroundImage title:title];
}

- (void)createRightButtonWithImage:(UIImage *)image backgroundImage:(UIImage *)backgroundImage title:(NSString *)title {
    
    if(image == nil && title.length == 0) {
        return;
    }
    
    CGSize buttonSize = CGSizeZero;
    
    if(image) {
        buttonSize = image.size;
    } else {
        if(SupportiOS7) {
            NSDictionary *attributes = @{NSFontAttributeName:kDefaultButtonFont};
            buttonSize = [title sizeWithAttributes:attributes];
        } else {
            #if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
            buttonSize = [title sizeWithFont:kDefaultButtonFont];
#endif
        }
        buttonSize.height = backgroundImage.size.height;
        buttonSize.width += 16; // Left, right padding is 8
    }
    
    if(self.rightBarButton) {
        CGRect rightButtonFrame = self.rightBarButton.frame;
        rightButtonFrame.size = buttonSize;
        self.rightBarButton.frame = rightButtonFrame;
        
        // Relayout button
        [self setNeedsLayout];
    } else {
        self.rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
        self.rightBarButton.titleLabel.font = kDefaultButtonFont;
    }
    
    [self.rightBarButton setTitle:title forState:UIControlStateNormal];
    [self.rightBarButton setImage:image forState:UIControlStateNormal];
    [self.rightBarButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (void)createRightButtonWithImageName:(NSString *)imageName
                   backgroundImageName:(NSString *)backgroundImageName
                                 title:(NSString *)title {
    UIImage *image = [[IBHelper sharedUIHelper] loadImage:imageName];
    UIImage *backgroundImage = [[IBHelper sharedUIHelper] middleStretchImage:backgroundImageName];
    
    [self createRightButtonWithImage:image backgroundImage:backgroundImage title:title];
}

@end
