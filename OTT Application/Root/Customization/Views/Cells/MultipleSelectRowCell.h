/*============================================================================
 PROJECT: SportLocker
 FILE:    MutipleSelectRowCell.h
 AUTHOR:  Khoai Nguyen
 DATE:    7/18/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>


/*============================================================================
 MACRO
 =============================================================================*/
@class MultipleSelectRowCell;
typedef void(^MarkDeleteBlock)(MultipleSelectRowCell *cell, BOOL selected);
/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   MutipleSelectRowCell
 =============================================================================*/

@interface MultipleSelectRowCell : UITableViewCell

@property (strong, nonatomic) MarkDeleteBlock markDeleteBlock;
@property (strong, nonatomic) IBOutlet UIView  *containerView;
@property (strong, nonatomic) UIImage *unselectedImage;
@property (strong, nonatomic) UIImage *selectedImage;
@property (assign, nonatomic) CGFloat editingLeftOffset;

- (void)setMarkDelete:(BOOL)markDelete;
- (void)didTouchedOnSelectButton:(UIButton *)sender;
- (void)relayoutSubviews;

@end
