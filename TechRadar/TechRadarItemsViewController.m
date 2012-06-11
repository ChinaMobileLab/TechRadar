//
//  TechRadarItemsViewController.m
//  TechRadar
//
//  Created by Cyril Wei on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TechRadarItemsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TechRadarItemsViewController ()

@property (nonatomic, retain) TechRadarItemsPanel *adoptPanel;
@property (nonatomic, retain) TechRadarItemsPanel *trialPanel;
@property (nonatomic, retain) TechRadarItemsPanel *assessPanel;
@property (nonatomic, retain) TechRadarItemsPanel *holdPanel;

@end

@implementation TechRadarItemsViewController

@synthesize adoptPanel = _adoptPanel;
@synthesize trialPanel = _trialPanel;
@synthesize assessPanel = _assessPanel;
@synthesize holdPanel = _holdPanel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_adoptPanel release];
    [_trialPanel release];
    [_assessPanel release];
    [_holdPanel release];
    
    [super dealloc];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor redColor];
    self.view = view;
    [view release];
    
    self.holdPanel = [[TechRadarItemsPanel alloc] initWithFrame:CGRectMake(900.0f, 0.0f, [self radiusForWidth:1000.0f] - 900.0f, 748.0f)];
    self.holdPanel.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.holdPanel];
        
    self.assessPanel = [[TechRadarItemsPanel alloc] initWithFrame:CGRectMake(750.0f, 0.0f, [self radiusForWidth:900.0f] - 750.0f, 748.0f)];
    self.assessPanel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.assessPanel];

    self.trialPanel = [[TechRadarItemsPanel alloc] initWithFrame:CGRectMake(500.0f, 0.0f, [self radiusForWidth:750.0f] - 500.0f, 748.0f)];
    self.trialPanel.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.trialPanel];

    self.adoptPanel = [[TechRadarItemsPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self radiusForWidth:500.0f], 748.0f)];
    self.adoptPanel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.adoptPanel];
    
    UIPanGestureRecognizer *panAdopt = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAdopt:)];
    panAdopt.minimumNumberOfTouches = 1;
    panAdopt.maximumNumberOfTouches = 1;
    [self.adoptPanel addGestureRecognizer:panAdopt];
    
}

- (void)panAdopt:(UIGestureRecognizer*)gestureRecognizer;
{
    static CGRect adoptStartFrame;
    static CGRect trialStartFrame;

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        adoptStartFrame = self.adoptPanel.frame;
        trialStartFrame = self.trialPanel.frame;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat deltaX = [((UIPanGestureRecognizer *)gestureRecognizer) translationInView:self.view].x;
        
        CGRect currentFrame = adoptStartFrame;
//        currentFrame.origin.x += deltaX;
        currentFrame.size.width += deltaX;
        self.adoptPanel.frame = currentFrame;
        
        currentFrame = trialStartFrame;
        currentFrame.origin.x += deltaX;
        currentFrame.size.width -= deltaX * 2;
        self.trialPanel.frame = currentFrame;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.adoptPanel.frame = adoptStartFrame;
        self.trialPanel.frame = trialStartFrame;
    }
//    
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        CGFloat velocityX = [((UIPanGestureRecognizer *)gestureRecognizer) velocityInView:self.view].x;
//        CGFloat deltaX = [((UIPanGestureRecognizer *)gestureRecognizer) translationInView:self.view].x;
//        
//        CGFloat speedX = fabs(velocityX / deltaX) * 5.0f;
//        speedX = (velocityX > 0) ? speedX : - speedX;
//        
//        NSLog(@"Del: %f, Vel: %f, Spd: %f", deltaX, velocityX, speedX);
//        
//        [UIView animateWithDuration:0.5f animations:^{
//            CGRect currentFrame = self.adoptPanel.frame;
//            //        currentFrame.origin.x += deltaX;
//            currentFrame.size.width += speedX;
//            self.adoptPanel.frame = currentFrame;
//            
//            currentFrame = self.trialPanel.frame;
//            currentFrame.origin.x += speedX;
//            currentFrame.size.width -= speedX * 2;
//            self.trialPanel.frame = currentFrame;
//        }];
//    }
}

- (CGFloat)radiusForWidth:(CGFloat)width
{
    return sqrt(pow(width, 2) + pow(374.0f, 2));
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
