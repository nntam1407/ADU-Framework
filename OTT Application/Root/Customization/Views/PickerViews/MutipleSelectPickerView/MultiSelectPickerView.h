/*============================================================================
 PROJECT: SportLocker
 FILE:    MultiSelectPickerView.h
 AUTHOR:  MACBOOK PRO
 DATE:    2/22/13
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
@class MultiSelectPickerView; 
@protocol MultiSelectPickerViewDataSource <NSObject>
@optional
- (NSInteger)numberOfComponentsInPickerView:(MultiSelectPickerView *)pickerView;
- (NSInteger)multiPickerView:(MultiSelectPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)multiPickerView:(MultiSelectPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (UIView *)multiPickerView:(MultiSelectPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

@end

@protocol MultiSelectPickerViewDelegate <NSObject>
-(void)multiPickerView:(MultiSelectPickerView *)pickerView didSelectRow:(NSInteger)row selected:(BOOL)selected;

@optional


@end
/*============================================================================
 Interface:   MultiSelectPickerView
 =============================================================================*/

@interface MultiSelectPickerView : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) id<MultiSelectPickerViewDataSource> multiSelectDataSource;
@property (weak, nonatomic) id<MultiSelectPickerViewDelegate> multiSelectDelegate;
@property (nonatomic, strong) NSMutableArray  *selectedIndixes;
@end
