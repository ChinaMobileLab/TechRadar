//
//  TechRadarCategoryControllerViewController.m
//  TechRadar
//
//  Created by Zhe Wang on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TechRadarCategoryControllerViewController.h"
#import "TechRadarConstants.h"

@interface TechRadarCategoryControllerViewController ()

@end

@implementation TechRadarCategoryControllerViewController
@synthesize CentralButton;
@synthesize TechnologyLabel;
@synthesize PlatformLabel;
@synthesize ToolLabel;
@synthesize LanguageLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CentralButton.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] 
                                         initWithTarget:self action:@selector(handlePan:)];
    [panRecognizer setDelegate:self];
    [panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
    [CentralButton addGestureRecognizer:panRecognizer];
    [CentralButton setCenter:CGPointMake(TechRadarButtonX, TechRadarButtonY)]; 
    [panRecognizer release];
}

- (float)moveCentralButton:(CGPoint)translatedPoint sender:(id)sender
{
    float restDistancePercent = 1.0f;
    if(translatedPoint.x <= 0){
        translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY);
        [[sender view] setCenter:translatedPoint];
        restDistancePercent = translatedPoint.x / firstX;
        NSLog([[NSNumber numberWithFloat:restDistancePercent] stringValue]);
    }
    return restDistancePercent;
}

- (void)moveText:(float)percent
{
    TechnologyLabel.alpha = percent;
    LanguageLabel.alpha = percent;
    ToolLabel.alpha = percent;
    PlatformLabel.alpha = percent;
}

- (void)handlePan:(id)sender
{
//    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    
    float percent = [self moveCentralButton:translatedPoint sender:sender];
    [self moveText:percent];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
//        CGFloat finalX = translatedPoint.x + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
//		CGFloat finalY = translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.35];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//		[[sender view] setCenter:CGPointMake(finalX, finalY)];
		[UIView commitAnimations];
    }
}

- (void)viewDidUnload
{
    [self setCentralButton:nil];
    [self setTechnologyLabel:nil];
    [self setPlatformLabel:nil];
    [self setToolLabel:nil];
    [self setLanguageLabel:nil];
    [self setCentralButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [CentralButton release];
    [TechnologyLabel release];
    [PlatformLabel release];
    [ToolLabel release];
    [LanguageLabel release];
    [CentralButton release];
    [super dealloc];
}
@end
