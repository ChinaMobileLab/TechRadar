//
//  TRMainViewController.m
//  TechRadar
//
//  Created by Cyril Wei on 6/11/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRMainViewController.h"
#import "TechRadarConstants.h"

@interface TRMainViewController ()

@end

@implementation TRMainViewController

@synthesize coverViewController = _coverViewController;
@synthesize contentViewController = _contentViewController;
@synthesize handleViewController = _overlayViewController;
@synthesize menuViewController = _menuViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initHandleViewController];
        [self initCoverViewController];
        [self initContentViewController];
    }
    return self;
}

- (id)init
{
    return [self initWithNibName:nil bundle:nil];
}

- (void)initHandleViewController
{
    TRHandleViewController *handleController = [[TRHandleViewController alloc] init];
    
    handleController.moveCancelled = ^(id sender, CGFloat percent) {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat duration = 0.5f * log10(fabs(10.0f * fabs(1.0f - percent) + 1.0f));
        [UIView animateWithDuration:duration animations:^ {
            [self.handleViewController.view setCenter:CGPointMake(TechRadarCentralButtonX, TechRadarCentralButtonY)];
            [self.coverViewController changeToPercent:1.0f sender:sender];
            self.coverViewController.view.alpha = 1.0f;
        }];
    };
    
    handleController.moveDone = ^(id sender, CGFloat percent) {
        CGFloat duration = 3.0f * fabs(percent);
        [UIView animateWithDuration:duration animations:^{
            [self.handleViewController.view setCenter:CGPointMake(TechRadarSideButtonX, TechRadarSideButtonY)];
            [self.coverViewController changeToPercent:0.0f sender:sender];
            self.coverViewController.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.view sendSubviewToBack:self.coverViewController.view];
            [self loadMenuController];
        }];
    };
    
    handleController.moveToPercent = ^(id sender, CGFloat percent) {
        [self.coverViewController changeToPercent:percent sender:sender];
        self.coverViewController.view.alpha = percent;
    };
    
    self.handleViewController = handleController;
    [handleController release];
}

- (void)loadMenuController
{
    TRMenuViewController *menuViewController = [[TRMenuViewController alloc] init];
    self.menuViewController = menuViewController;
    [menuViewController release];
    
    [self.view addSubview:self.menuViewController.view];
    [self.view bringSubviewToFront:self.menuViewController.view];
    
    [self.handleViewController.view removeFromSuperview];
    self.handleViewController = nil;
}

- (void)initCoverViewController
{
    TRCategoryViewController *categoryViewController = [[TRCategoryViewController alloc] init];

    self.coverViewController = categoryViewController;
    [categoryViewController release];
}

- (void)initContentViewController
{
    TRItemsViewController *itemsViewController = [[TRItemsViewController alloc] init];
    
    self.contentViewController = itemsViewController;
    [itemsViewController release];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor blackColor];
    self.view = view;
    [view release];
    
    if (self.contentViewController != nil) {
        [self.view addSubview:self.contentViewController.view];
        [self.view sendSubviewToBack:self.contentViewController.view];
    }
    
    if (self.coverViewController != nil) {
        [self.view addSubview:self.coverViewController.view];
    }
    
    if (self.handleViewController != nil) {
        [self.view addSubview:self.handleViewController.view];
    }
} 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
