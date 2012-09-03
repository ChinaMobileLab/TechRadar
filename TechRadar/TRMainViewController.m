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

@synthesize contentViewController = _contentViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initItems];
        
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
