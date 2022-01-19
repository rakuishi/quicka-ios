//
//  ContainerViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/14/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "ContainerViewController.h"

#define MARGIN 40.f

@interface ContainerViewController ()

@property (nonatomic) UINavigationController *mainNavigationController;
@property (nonatomic) UINavigationController *subNavigationController;
@property (nonatomic) MainViewController *mainViewController;
@property (nonatomic) SubViewController *subViewController;

@property (nonatomic, assign) BOOL isActiveMainView;
@property (nonatomic, assign) BOOL shouldMoveViewPosition;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat width;

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.width = [[UIScreen mainScreen] bounds].size.width;

    self.mainViewController = [[MainViewController alloc] initWithStyle:UITableViewStylePlain];
    self.mainViewController.isActive = YES;
    self.mainViewController.delegate = self;
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.mainNavigationController.toolbar.translucent = NO;
    [self.mainNavigationController setToolbarHidden:NO];
    
    self.subViewController = [SubViewController new];
    self.subViewController.delegate = self;
    self.subNavigationController = [[UINavigationController alloc] initWithRootViewController:self.subViewController];
    self.subNavigationController.toolbar.translucent = NO;
    [self.subNavigationController setToolbarHidden:NO];
    
    // MainViewController
    [self addChildViewController:self.mainNavigationController];
    [self.view addSubview:self.mainNavigationController.view];

    // SubViewController
    [self addChildViewController:self.subNavigationController];
    CGRect frame = self.subNavigationController.view.frame;
    frame.origin.x = self.width;
    self.subNavigationController.view.frame = frame;
    [self.view addSubview:self.subNavigationController.view];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:self.panGesture];
    
    self.isActiveMainView = YES;
    self.shouldMoveViewPosition = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePanGestureEnable:) name:QKApplicationEnablePanGesture object:nil];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QKApplicationEnablePanGesture object:nil];
}

#pragma mark - NSNotificationCenter

- (void)handlePanGestureEnable:(NSNotification *)notification
{
    if ([notification.userInfo[@"enable"] boolValue]) {
        [self.view addGestureRecognizer:self.panGesture];
    } else {
        [self.view removeGestureRecognizer:self.panGesture];
    }
}

#pragma mark - SubViewController

- (void)scrollToMainViewControllerWithQuery:(NSString *)query
{
    [self moveToMainViewController];
    [self performSelector:@selector(mainViewControllerSearchBarBecomeFirstResponderWithQuery:) withObject:query afterDelay:0.25f];
}

- (void)mainViewControllerSearchBarBecomeFirstResponderWithQuery:(NSString *)query
{
    if (query) {
        [self.mainViewController.searchBar setText:query];
    }
}

#pragma mark - MainViewControllerDelegate

- (void)scrollToSubViewControllerWithQuery:(NSString *)query
{
    [self moveToSubViewController];
    [self performSelector:@selector(subViewControllerSearchWithQuery:) withObject:query afterDelay:0.25f];
}

- (void)subViewControllerSearchWithQuery:(NSString *)query
{
    [self.subViewController searchWithQuery:query];
}

#pragma mark -

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    CGFloat x = [gesture locationInView:self.view].x;
    CGFloat moveX = [gesture translationInView:self.view].x;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if ([QuickaUtil getBrowserIndex] == kBrowserTypeQuickaBrowser) {
            [self.mainViewController hideSoftwareKeyboard];
            if (x > self.width - MARGIN && self.isActiveMainView == YES) {
                self.shouldMoveViewPosition = YES;
            } else if (x < MARGIN && self.isActiveMainView == NO) {
                self.shouldMoveViewPosition = YES;
            } else {
                self.shouldMoveViewPosition = NO;
            }
        } else {
            self.shouldMoveViewPosition = NO;
        }
        
        if (self.shouldMoveViewPosition == YES) {
            CALayer *layer = self.subNavigationController.view.layer;
            [self animateShadowOpacityWithLayer:layer fromValue:0.f toValue:0.4f];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged && self.shouldMoveViewPosition == YES) {
        
        CGRect frame = self.subNavigationController.view.frame;
        frame.origin.x = (self.isActiveMainView) ? self.width + moveX : MAX(moveX, 0.f);
        self.subNavigationController.view.frame = frame;
        
        frame = self.mainNavigationController.view.frame;
        frame.origin.x = (self.isActiveMainView) ? MIN(moveX / 3.f, 0.f) : moveX / 3.f - 106.7f;
        self.mainNavigationController.view.frame = frame;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded && self.shouldMoveViewPosition == YES) {
        
        CGFloat endedX = self.subNavigationController.view.frame.origin.x;
        
        if (endedX > self.width / 2.f) {
            [self moveToMainViewController];
        } else {
            [self moveToSubViewController];
        }
    }
}

- (void)moveToMainViewController
{
    self.isActiveMainView = YES;
    self.view.userInteractionEnabled = NO;
    
    CALayer *layer = self.subNavigationController.view.layer;
    [self animateShadowOpacityWithLayer:layer fromValue:0.4f toValue:0.f];
    
    [UIView animateWithDuration:0.25f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.subNavigationController.view.frame;
                         frame.origin.x = self.width;
                         self.subNavigationController.view.frame = frame;
                         
                         frame = self.mainNavigationController.view.frame;
                         frame.origin.x = 0.f;
                         self.mainNavigationController.view.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.view.userInteractionEnabled = YES;
                         
                         self.mainViewController.isActive = YES;
                         if (@available(iOS 13.0, *)) {
                             self.mainViewController.searchBar.searchTextField.enabled = YES;
                         }
                         [self.mainViewController showSoftwareKeyboardIfPossible];
                     }];
}

- (void)moveToSubViewController
{
    self.isActiveMainView = NO;
    self.view.userInteractionEnabled = NO;
    
    CALayer *layer = self.subNavigationController.view.layer;
    [self animateShadowOpacityWithLayer:layer fromValue:0.4f toValue:0.f];

    [UIView animateWithDuration:0.25f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.subNavigationController.view.frame;
                         frame.origin.x = 0.f;
                         self.subNavigationController.view.frame = frame;
                         
                         frame = self.mainNavigationController.view.frame;
                         frame.origin.x = - 106.7f;
                         self.mainNavigationController.view.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.view.userInteractionEnabled = YES;

                         // スクロール途中で searchbar に becomeFirstResponder して挙動がおかしくなるのを防ぐ
                         self.mainViewController.isActive = NO;
                         if (@available(iOS 13.0, *)) {
                             self.mainViewController.searchBar.searchTextField.enabled = NO;
                         }
                     }];
}

#pragma mark - CABasicAnimation

- (void)animateShadowOpacityWithLayer:(CALayer *)layer
                            fromValue:(CGFloat)fromValue
                              toValue:(CGFloat)toValue
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:fromValue];
    anim.toValue = [NSNumber numberWithFloat:toValue];
    anim.duration = 0.25f;

    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        // ...
    }];
    [layer addAnimation:anim forKey:@"shadowOpacity"];
    [CATransaction commit];
    
    layer.shadowOpacity = toValue;
}

@end
