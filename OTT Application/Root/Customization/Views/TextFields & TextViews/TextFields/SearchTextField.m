/*============================================================================
 PROJECT: SportLocker
 FILE:    SearchTextField.m
 AUTHOR:  Khoai Nguyen
 DATE:    7/16/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "SearchTextField.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/


@implementation SearchTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchIconImage = [[IBHelper sharedUIHelper] loadImage:@"icon_search"];
    UIImageView *searchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _searchIconImage.size.width, self.bounds.size.height)];
    searchView.contentMode = UIViewContentModeScaleAspectFit;
    searchView.image = _searchIconImage;
    self.leftView = searchView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    return CGRectMake(8, 0, self.leftView.bounds.size.width, self.leftView.bounds.size.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(25, 0, bounds.size.width - 50, bounds.size.height);
//    return CGRectInset(bounds, 25, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(25, 0, bounds.size.width - 50, bounds.size.height);
//    return CGRectInset(bounds, 25, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(25, 0, bounds.size.width - 50, bounds.size.height);
//    return CGRectInset(bounds, 25, 0);
}

@end
