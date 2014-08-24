/*============================================================================
 PROJECT: SportLocker
 FILE:    WebViewViewController.m
 AUTHOR:  Huu Tai Ho
 DATE:    9/9/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "WebViewViewController.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/


@interface WebViewViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

- (IBAction)goBack:(id)sender;
- (IBAction)goNext:(id)sender;
- (IBAction)refresh:(id)sender;

@end

@implementation WebViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.title;
}

- (void)viewDidUnload
{
    [self setLoadingIndicatorView:nil];
    [self setRefreshButton:nil];
    [self setBackButton:nil];
    [self setNextButton:nil];
    [self setContentWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)goBack:(id)sender {
    [_contentWebView goBack];
}

- (IBAction)goNext:(id)sender {
    [_contentWebView goForward];
}

- (IBAction)refresh:(id)sender {
    [_contentWebView reload];
}

- (void)didTouchedOnLeftButton:(id)sender {
    if(self.enableCustomizedLeftButtonEvent) {
//        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController animated:YES completion:^(BOOL finished) {
//            
//        }];
    } else {
        [super didTouchedOnLeftButton:sender];
    }
}

#pragma mark - UIWebView delegates

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoadingIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoadingIndicator];
    
    if([_contentWebView canGoBack]) {
        self.backButton.enabled = YES;
    } else {
        self.backButton.enabled = NO;
    }
    
    if([_contentWebView canGoForward]) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadingIndicator];
}

#pragma mark Private
- (void)showLoadingIndicator {
    _refreshButton.hidden = YES;
    [_loadingIndicatorView startAnimating];
}

- (void)hideLoadingIndicator {
    [_loadingIndicatorView stopAnimating];
    _refreshButton.hidden = NO;
}

#pragma mark Public
- (void)loadUrl:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    [_contentWebView loadRequest:request];
}

@end
