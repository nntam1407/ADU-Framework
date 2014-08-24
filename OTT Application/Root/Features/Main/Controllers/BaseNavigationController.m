/*============================================================================
 PROJECT: SportLocker
 FILE:    BaseNavigationController.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    2/21/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "BaseNavigationController.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldAsapFontWithSize:20]}];
    [[UINavigationBar appearance] setTintColor:[UIColor lightTextColor]];
    
//    [[UISegmentedControl appearance] setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldAsapFontWithSize:12]} forState:UIControlStateNormal];
    
	// Do any additional setup after loading the view.
    /*if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [[IBHelper sharedUIHelper] middleStretchCommonImage:@"nav_background"];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }*/
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
