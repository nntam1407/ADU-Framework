/*============================================================================
 PROJECT: SportLocker
 FILE:    MultiSelectPickerView.m
 AUTHOR:  MACBOOK PRO
 DATE:    2/22/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "MultiSelectPickerView.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/


@implementation MultiSelectPickerView

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
        [self baseInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self baseInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self baseInit];
}

- (void)baseInit {
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_multiSelectDataSource) {
        return [_multiSelectDataSource numberOfComponentsInPickerView:self];
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_multiSelectDataSource) {
        return  [_multiSelectDataSource multiPickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_multiSelectDataSource) {
        return [_multiSelectDataSource multiPickerView:self titleForRow:row forComponent:component];
    }
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UITableViewCell *cell = (UITableViewCell *)view;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBounds: CGRectMake(0, 0, cell.frame.size.width -60 , 44)];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSelection:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [cell addGestureRecognizer:singleTapGestureRecognizer];
    }
    cell.tag = row;
    
    if (!_selectedIndixes) {
        self.selectedIndixes = [NSMutableArray array];
        for (int i = 0; i < [self numberOfRowsInComponent:0]; i++) {
            ArrAddObj(_selectedIndixes, Num4Bool(FALSE));
        }
    }
    
    NSNumber *number = ArrObj4Idx(_selectedIndixes, row);
    if (Num2Bool(number) == TRUE) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    cell.textLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return cell;
}

- (void)toggleSelection:(UITapGestureRecognizer *)recognizer {
    NSInteger row = recognizer.view.tag;
    
    NSNumber *number = ArrObj4Idx(_selectedIndixes, row);
    if (Num2Bool(number) == TRUE) {
        ArrRepObj(_selectedIndixes, row, Num4Bool(FALSE));
        [(UITableViewCell *)(recognizer.view) setAccessoryType:UITableViewCellAccessoryNone];
        if (_multiSelectDelegate) {
            [_multiSelectDelegate multiPickerView:self didSelectRow:row selected:NO];
        }
    } else {
        ArrRepObj(_selectedIndixes, row, Num4Bool(TRUE));
        [(UITableViewCell *)(recognizer.view) setAccessoryType:UITableViewCellAccessoryCheckmark];
        if (_multiSelectDelegate) {
            [_multiSelectDelegate multiPickerView:self didSelectRow:row selected:YES];
        }
    }
    
}

@end
