/*============================================================================
 PROJECT: SportLocker
 FILE:    SweeepLabel.m
 AUTHOR:  Clark Kent
 DATE:    7/2/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "SweeepLabel.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/


@implementation SweeepLabel

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

- (void)awakeFromNib {
    [super awakeFromNib];
    float size = self.font.pointSize;
    self.font = [UIFont fontWithName:@"Sweeep" size:size];
}

@end
