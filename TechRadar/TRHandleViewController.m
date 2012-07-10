//
//  TRHandleViewController.m
//  TechRadar
//
//  Created by Cyril Wei on 6/16/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRHandleViewController.h"
#import "TechRadarConstants.h"

@interface TRHandleViewController ()

@end

@implementation TRHandleViewController

@synthesize moveCancelled = _moveCancelled;
@synthesize moveDone = _moveDone;
@synthesize moveToPercent = _moveToPercent;

- (void)initPanGestureRecognizer
{
    self.view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] 
                                             initWithTarget:self action:@selector(handlePan:)];
    [panRecognizer setDelegate:self];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panRecognizer];
    [panRecognizer release];
}

- (void)loadView
{
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_central_button.png"]];
    view.autoresizesSubviews = YES;
    self.view = view;
    [view release];
    
    shiningView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shining.png"]];
    shiningView.alpha = 0.0f;
    shiningView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:shiningView];
    
    [self reset];
    [self initPanGestureRecognizer];
    
    decrease = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tickTockReceived) name:TechRadarMainTickTockNotification object:nil];
}

- (void)viewDidUnload
{
    [shiningView release];
    shiningView = nil;
    
    [super viewDidUnload];
}

- (void)tickTockReceived
{
    if (decrease) {
        if (delay >= 15) {
            shiningView.alpha -= 0.025f;
            if (shiningView.alpha <= 0.0f) {
                shiningView.alpha = 0.0f;
                decrease = NO;
                delay = 0;
            }
        } else {
            ++ delay;
        }
        
    } else {
        if (delay >= 60) {
            shiningView.alpha += 0.05f;
            if (shiningView.alpha >= 1.0f) {
                shiningView.alpha = 1.0f;
                decrease = YES;
                delay = 0;
            }
        } else {
            ++ delay;
        }
    }
}

- (void)reset
{
    CGRect buttonFrame = CGRectMake(0.0f, 0.0f, TechRadarCentralButtonWidth, TechRadarCentralButtonHeight);
    
    CGPoint buttonCenter = CGPointMake(TechRadarCentralButtonX, TechRadarCentralButtonY);
    
    self.view.frame = buttonFrame;
    
    self.view.center = buttonCenter;

//    shiningView.frame = self.view.bounds;
}

- (void)handlePan:(id)sender
{
    //    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    UIGestureRecognizerState state = [(UIPanGestureRecognizer*)sender state];
    
    if(state == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    
    float percent = [self moveHandleTo:translatedPoint sender:sender];

    if (state == UIGestureRecognizerStateChanged) {
        if (self.moveToPercent != nil) {
            self.moveToPercent(sender, percent);
        }
    }
    
    if((state == UIGestureRecognizerStateCancelled)
       || (state == UIGestureRecognizerStateEnded
           && [sender view].center.x > TechRadarCentralButtonAcceptedX)) {
        if (self.moveCancelled != nil) {
            self.moveCancelled(sender, percent);
        }
    }
    
    if (state == UIGestureRecognizerStateEnded
        && [sender view].center.x <= TechRadarCentralButtonAcceptedX) {
        if (self.moveDone != nil) {
            self.moveDone(sender, percent);
        }
    }
}

- (float)moveHandleTo:(CGPoint)translatedPoint sender:(id)sender
{
    float restDistancePercent = 1.0f;
    if(translatedPoint.x <= 0){
        translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY);
        [[sender view] setCenter:translatedPoint];
        restDistancePercent = translatedPoint.x / firstX;
    }
    return restDistancePercent;
}

- (void)dealloc
{
    [_moveToPercent release];
    [_moveDone release];
    [_moveCancelled release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
