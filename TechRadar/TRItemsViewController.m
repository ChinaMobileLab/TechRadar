//
//  TRItemsViewController.m
//  TechRadar
//
//  Created by Cyril Wei on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRItemsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TRItemsViewController ()

@property (nonatomic, retain) TRItemsPanel *adoptPanel;
@property (nonatomic, retain) TRItemsPanel *trialPanel;
@property (nonatomic, retain) TRItemsPanel *assessPanel;
@property (nonatomic, retain) TRItemsPanel *holdPanel;

@end

@implementation TRItemsViewController

@synthesize adoptPanel = _adoptPanel;
@synthesize trialPanel = _trialPanel;
@synthesize assessPanel = _assessPanel;
@synthesize holdPanel = _holdPanel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        panels = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return self;
}

- (void)dealloc
{
    [panels removeAllObjects];
    [panels release];
    
    [_adoptPanel release];
    [_trialPanel release];
    [_assessPanel release];
    [_holdPanel release];
    
    [super dealloc];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor clearColor];
//    view.backgroundColor = [UIColor colorWithRed:82.0f/255 green:139.0f/255 blue:217.0f/255 alpha:1.0f];
//    528bd9
    self.view = view;
    [view release];

    UIImageView *bkgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:bkgImage];
    [self.view sendSubviewToBack:bkgImage];
    
    self.holdPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(900.0f, 0.0f, [self radiusForWidth:1000.0f] - 900.0f, 748.0f)];
    [self.view addSubview:self.holdPanel];
    
    [panels addObject:self.holdPanel];
        
    self.assessPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(750.0f, 0.0f, [self radiusForWidth:900.0f] - 750.0f, 748.0f)];
    [self.view addSubview:self.assessPanel];
    
    [panels addObject:self.assessPanel];

    self.trialPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(500.0f, 0.0f, [self radiusForWidth:750.0f] - 500.0f, 748.0f)];
    [self.view addSubview:self.trialPanel];
    
    [panels addObject:self.trialPanel];

    self.adoptPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self radiusForWidth:500.0f], 748.0f)];
    self.adoptPanel.delegate = self;
    [self.view addSubview:self.adoptPanel];
    
    [panels addObject:self.adoptPanel];

    for (int i = 0; i < 10; i ++) {
        TRItem *item = [[TRItem alloc] initWithLevel:1];
        [self.adoptPanel addItem:item];
        [item release];
    }
//    TRItem *item = [[TRItem alloc] initWithRadius:50.0f];
//    [item addTarget:self action:@selector(showPopover) forControlEvents:UIControlEventTouchUpInside];
//    [self.adoptPanel addItem:item];
//    [item release];
    
//    UIPanGestureRecognizer *panAdopt = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAdopt:)];
//    panAdopt.minimumNumberOfTouches = 1;
//    panAdopt.maximumNumberOfTouches = 1;
//    [self.adoptPanel addGestureRecognizer:panAdopt];
    
    
    
}

//- (void)panAdopt:(UIGestureRecognizer*)gestureRecognizer
//{
//    static CGRect adoptStartFrame;
//    static CGRect trialStartFrame;
//
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        adoptStartFrame = self.adoptPanel.frame;
//        trialStartFrame = self.trialPanel.frame;
//    }
//    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        CGFloat deltaX = [((UIPanGestureRecognizer *)gestureRecognizer) translationInView:self.view].x;
//        
//        CGRect currentFrame = adoptStartFrame;
////        currentFrame.origin.x += deltaX;
//        currentFrame.size.width += deltaX;
//        self.adoptPanel.frame = currentFrame;
//        
//        currentFrame = trialStartFrame;
//        currentFrame.origin.x += deltaX;
//        currentFrame.size.width -= deltaX * 2;
//        self.trialPanel.frame = currentFrame;
//    }
//    else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
//        self.adoptPanel.frame = adoptStartFrame;
//        self.trialPanel.frame = trialStartFrame;
//    }
////    
////    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
////        CGFloat velocityX = [((UIPanGestureRecognizer *)gestureRecognizer) velocityInView:self.view].x;
////        CGFloat deltaX = [((UIPanGestureRecognizer *)gestureRecognizer) translationInView:self.view].x;
////        
////        CGFloat speedX = fabs(velocityX / deltaX) * 5.0f;
////        speedX = (velocityX > 0) ? speedX : - speedX;
////        
////        NSLog(@"Del: %f, Vel: %f, Spd: %f", deltaX, velocityX, speedX);
////        
////        [UIView animateWithDuration:0.5f animations:^{
////            CGRect currentFrame = self.adoptPanel.frame;
////            //        currentFrame.origin.x += deltaX;
////            currentFrame.size.width += speedX;
////            self.adoptPanel.frame = currentFrame;
////            
////            currentFrame = self.trialPanel.frame;
////            currentFrame.origin.x += speedX;
////            currentFrame.size.width -= speedX * 2;
////            self.trialPanel.frame = currentFrame;
////        }];
////    }
//}

- (void)TRItemsPanelTapped:(TRItemsPanel *)panel
{
    
}

- (CGFloat)radiusForWidth:(CGFloat)width
{
    return sqrt(pow(width, 2) + pow(374.0f, 2));
}

- (void)relayout
{
    [self.adoptPanel relayout];
}

- (void)showPopover
{
    UIViewController *contentController = [[UIViewController alloc] init];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:contentController];
    
    popover.popoverContentSize = CGSizeMake(300.0f, 300.0f);
    
    [popover presentPopoverFromRect:CGRectMake(100.0f, 100.0f, 50.0f, 50.0f) inView:self.adoptPanel permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
