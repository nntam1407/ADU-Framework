/*============================================================================
 PROJECT: SportLocker
 FILE:    MutipleSelectRowCell.m
 AUTHOR:  Khoai Nguyen
 DATE:    7/18/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "MultipleSelectRowCell.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
const NSInteger EDITING_HORIZONTAL_OFFSET = 35;
const NSInteger SELECT_BUTTON_TAG = 99;

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface MultipleSelectRowCell()
- (UIButton *)selectButton;
@end

@implementation MultipleSelectRowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /* add container view */
        _editingLeftOffset = EDITING_HORIZONTAL_OFFSET;
        if(!_containerView) {
            _containerView = [[UIView alloc] initWithFrame:self.bounds];
            [self.contentView addSubview:_containerView];
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _editingLeftOffset = EDITING_HORIZONTAL_OFFSET;
    /* add container view */
    if(!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_containerView];
    }
}

- (UIButton *)selectButton {
    UIButton *selectButton = (UIButton *)[self.contentView viewWithTag:SELECT_BUTTON_TAG];
    if(!selectButton) {
        selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(0, 0, EDITING_HORIZONTAL_OFFSET, self.bounds.size.height);
        selectButton.tag = SELECT_BUTTON_TAG;
        [selectButton addTarget:self action:@selector(didTouchedOnSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView insertSubview:selectButton belowSubview:_containerView];
        selectButton.hidden = YES;
        
    }
    return selectButton;
}

- (void)setMarkDelete:(BOOL)markDelete {
    UIButton *selectButton = [self selectButton];
    selectButton.selected = markDelete;
}

- (void)setUnselectedImage:(UIImage *)unselectedImage {
    UIButton *selectButton = [self selectButton];
    [selectButton setImage:unselectedImage forState:UIControlStateNormal];
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    UIButton *selectButton = [self selectButton];
    [selectButton setImage:selectedImage forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[self setNeedsLayout];
    
    /* show or hide select button */
    UIButton *selectButton = [self selectButton];
    selectButton.hidden = !editing;
}

- (void)layoutSubviews {

    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [super layoutSubviews];
                         
                         if (((UITableView *)self.superview).isEditing) {
                             CGRect contentFrame = self.containerView.frame;
                             contentFrame.origin.x = _editingLeftOffset;
                             self.containerView.frame = contentFrame;
                         }
                         else {
                             CGRect contentFrame = self.containerView.frame;
                             contentFrame.origin.x = 0;
                             self.containerView.frame = contentFrame;
                         }
                         
                         /* relayout subviews */
                         [self relayoutSubviews];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)relayoutSubviews {
    
}

- (void)didTouchedOnSelectButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (_markDeleteBlock != NULL) {
        _markDeleteBlock(self, sender.selected);
    }
}

@end
