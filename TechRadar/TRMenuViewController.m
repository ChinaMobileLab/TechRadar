//
//  TRMenuViewController.m
//  TechRadar
//
//  Created by Cyril Wei on 6/16/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRMenuViewController.h"
#import "TechRadarConstants.h"

@interface TRMenuViewController ()

@end

@implementation TRMenuViewController

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
    self.view = view;
    [view release];
        
    [self reset];
    [self initPanGestureRecognizer];    
}


- (void)reset
{
    self.view.frame = CGRectMake(0.0f, 0.0f, TechRadarSideButtonWidth, TechRadarSideButtonHeight);
    
    self.view.center = CGPointMake(TechRadarSideButtonX, TechRadarSideButtonY);
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

        if (self.moveStart != nil) {
            self.moveStart(sender, 0.0f);
        }
    }
    
    float percent = [self moveHandleTo:translatedPoint sender:sender];
    
    if (state == UIGestureRecognizerStateChanged) {
        if (self.moveToPercent != nil) {
            self.moveToPercent(sender, percent);
        }
    }
    
    if((state == UIGestureRecognizerStateCancelled)
       || (state == UIGestureRecognizerStateEnded
           && [sender view].center.x < (TechRadarCentralButtonX - TechRadarCentralButtonAcceptedX))) {
           if (self.moveCancelled != nil) {
               self.moveCancelled(sender, percent);
           }
       }
    
    if (state == UIGestureRecognizerStateEnded
        && [sender view].center.x >= (TechRadarCentralButtonX - TechRadarCentralButtonAcceptedX)) {
        if (self.moveDone != nil) {
            self.moveDone(sender, percent);
        }
    }
}

- (float)moveHandleTo:(CGPoint)translatedPoint sender:(id)sender
{
    float restDistancePercent = 1.0f;
    if(translatedPoint.x >= 0){
        translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY);
        [[sender view] setCenter:translatedPoint];
        restDistancePercent = translatedPoint.x / TechRadarCentralButtonX;
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
	return YES;
}

@end
