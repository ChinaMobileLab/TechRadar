//
//  TRMainViewController.m
//  TechRadar
//
//  Created by Cyril Wei on 6/11/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRMainViewController.h"
#import "TechRadarConstants.h"
#import <QuartzCore/QuartzCore.h>

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
        _isCoverView = YES;
        
        [self initItems];
        
        [self loadHandleViewController];
        [self loadCoverViewController];
        [self loadContentViewController];
    }
    return self;
}

- (id)init
{
    return [self initWithNibName:nil bundle:nil];
}

- (void)dealloc
{
    [items release];
    [super dealloc];
}

- (void)loadHandleViewController
{
    TRHandleViewController *handleController = [[TRHandleViewController alloc] init];
    
    handleController.moveCancelled = ^(id sender, CGFloat percent) {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat duration = 0.5f * log10(fabs(10.0f * fabs(1.0f - percent) + 1.0f));
        [UIView animateWithDuration:duration animations:^ {
            self.handleViewController.view.frame = CGRectMake(TechRadarCentralButtonX - TechRadarCentralButtonWidth/2, TechRadarCentralButtonY - TechRadarCentralButtonHeight/2, TechRadarCentralButtonWidth, TechRadarCentralButtonHeight);
            [self.coverViewController changeToPercent:1.0f sender:sender];
            self.coverViewController.view.alpha = 1.0f;
        }];
    };
    
    handleController.moveDone = ^(id sender, CGFloat percent) {
        CGFloat duration = 3.0f * fabs(percent);
        [UIView animateWithDuration:duration animations:^{
            self.handleViewController.view.frame = CGRectMake(TechRadarSideButtonX - TechRadarSideButtonWidth/2, TechRadarSideButtonY - TechRadarSideButtonHeight/2, TechRadarSideButtonWidth, TechRadarSideButtonHeight);
            [self.coverViewController changeToPercent:0.0f sender:sender];
            self.coverViewController.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.view sendSubviewToBack:self.coverViewController.view];
            [self changeToMenuViewController];
        }];
    };
    
    handleController.moveToPercent = ^(id sender, CGFloat percent) {
        [self.coverViewController changeToPercent:percent sender:sender];
        self.coverViewController.view.alpha = percent;
        self.handleViewController.view.frame = CGRectMake(0.0f, 0.0f, 
            TechRadarSideButtonWidth + (TechRadarCentralButtonWidth - TechRadarSideButtonWidth) * percent, 
            TechRadarSideButtonHeight + (TechRadarCentralButtonHeight - TechRadarSideButtonHeight) * percent);
        [self.handleViewController.view setCenter:CGPointMake(TechRadarCentralButtonX * percent, TechRadarCentralButtonY)];
    };
    
    self.handleViewController = handleController;
    [handleController release];
}

- (void)loadMenuViewController
{
    TRMenuViewController *menuController = [[TRMenuViewController alloc] init];
    
    menuController.moveStart = ^(id sender, CGFloat percent) {
        [self.view sendSubviewToBack:self.contentViewController.view];
    };
    
    menuController.moveCancelled = ^(id sender, CGFloat percent) {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat duration = fabs(0.5f * log10(fabs(10.0f * fabs(percent) + 1.0f)));
        if (duration > 0.5f) {
            duration = 0.5f;
        }
        [UIView animateWithDuration:duration animations:^ {
            self.menuViewController.view.frame = CGRectMake(TechRadarSideButtonX - TechRadarSideButtonWidth/2, TechRadarSideButtonY - TechRadarSideButtonHeight/2, TechRadarSideButtonWidth, TechRadarSideButtonHeight);

            [self.coverViewController changeToPercent:0.0f sender:sender];
            self.coverViewController.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.view sendSubviewToBack:self.coverViewController.view];
        }];
    };
    
    menuController.moveDone = ^(id sender, CGFloat percent) {
        CGFloat duration = 3.0f * fabs(1.0f - percent);
        if (percent > 1.0f) {
            duration = 3.0f * fabs(percent - 1.0f);
        }
        if (duration > 0.5f) {
            duration = 0.5f;
        }
        
        [UIView animateWithDuration:duration animations:^{
            self.menuViewController.view.frame = CGRectMake(TechRadarCentralButtonX - TechRadarCentralButtonWidth/2, TechRadarCentralButtonY - TechRadarCentralButtonHeight/2, TechRadarCentralButtonWidth, TechRadarCentralButtonHeight);
            
            [self.coverViewController changeToPercent:1.0f sender:sender];
            self.coverViewController.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self changeToHandleViewController];
        }];
    };
    
    menuController.moveToPercent = ^(id sender, CGFloat percent) {
        [self.coverViewController changeToPercent:percent sender:sender];
        self.coverViewController.view.alpha = percent;
        self.menuViewController.view.frame = CGRectMake(0.0f, 0.0f,
                                                          TechRadarSideButtonWidth + (TechRadarCentralButtonWidth - TechRadarSideButtonWidth) * percent, 
                                                          TechRadarSideButtonHeight + (TechRadarCentralButtonHeight - TechRadarSideButtonHeight) * percent);
        [self.menuViewController.view setCenter:CGPointMake(TechRadarCentralButtonX * percent, TechRadarCentralButtonY)];
        
    };
    
    self.menuViewController = menuController;
    [menuController release];
}

- (void)changeToMenuViewController
{
    if (self.menuViewController == nil) {
        [self loadMenuViewController];
    } else {
        [self.menuViewController reset];
    }
    
    [self.view addSubview:self.menuViewController.view];
    [self.view bringSubviewToFront:self.menuViewController.view];
    
    [self.handleViewController.view removeFromSuperview];
    [self.contentViewController relayout];
    
    _isCoverView = NO;
}

- (void)changeToHandleViewController
{
    if (self.handleViewController == nil) {
        [self loadHandleViewController];
    } else {
        [self.handleViewController reset];
    }
    
    [self.view addSubview:self.handleViewController.view];
    [self.view bringSubviewToFront:self.handleViewController.view];
    
    [self.menuViewController.view removeFromSuperview];
    
    _isCoverView = YES;
}

- (void)loadCoverViewController
{
    TRCategoryViewController *categoryViewController = [[TRCategoryViewController alloc] init];

    self.coverViewController = categoryViewController;
    [categoryViewController release];
}

- (void)loadContentViewController
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

    WMWheel *wheel = [[WMWheel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 748.0f) center:CGPointMake(-13.0f, 748.0f / 2.0f) radius:213.0f];
    wheel.dataSource = self;
    wheel.delegate = self;
    [self.view addSubview:wheel];
    [wheel release];
    
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


- (void)startAnimation
{
    NSInteger animationFrameInterval = 4;

    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(sendTickTock)];
    [displayLink setFrameInterval:animationFrameInterval];
    
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopAnimation
{
    [displayLink invalidate];

    displayLink = nil;
}

- (void)sendTickTock
{
    NSNotification *tickTock = [NSNotification notificationWithName:TechRadarMainTickTockNotification object:nil];
    
    [[NSNotificationQueue defaultQueue] enqueueNotification:tickTock postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:82.0f/255 green:139.0f/255 blue:217.0f/255 alpha:1.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopAnimation];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    if (_isCoverView) {
        self.menuViewController = nil;
    } else {
        self.handleViewController = nil;
    }
    
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -
#pragma mark WMWheelMenu DataSource
- (void)initItems
{
    items = [[NSMutableArray alloc] initWithCapacity:4];
    WMWheelItem *item = [[WMWheelItem alloc] init];
    item.angle = -45.0f;
    [items addObject:item];
    [item release];

    item = [[WMWheelItem alloc] init];
    item.angle = -15.0f;
    [items addObject:item];
    [item release];

    item = [[WMWheelItem alloc] init];
    item.angle = 15.0f;
    [items addObject:item];
    [item release];

    item = [[WMWheelItem alloc] init];
    item.angle = 45.0f;
    [items addObject:item];
    [item release];
}

- (int)itemsCount
{
    return [items count];
}

- (WMWheelItem *)itemAtIndex:(int)index
{
    return [items objectAtIndex:index];
}

#pragma mark -
#pragma mark WMWheelMenu Delegate

- (void)wheel:(WMWheel *)wheel didRotateToItemAtIndex:(NSNumber *)index
{
    NSLog(@"---------Selected: %d", index.intValue);
}

@end
