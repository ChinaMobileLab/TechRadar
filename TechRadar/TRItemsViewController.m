//
//  TRItemsViewController.m
//  TechRadar
//
//  Created by Cyril Wei on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRItemsViewController.h"
#import "TechRadarItemReader.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees)/ 180)

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

- (void)initTRItems: (int)panelNum {
    [self.adoptPanel clearItems];

    [TechRadarItemReader buildItems:panelNum withBlock: ^(id jsonItem){

        TRItem *item = [[TRItem alloc] initWithLevel:1];
        [self.adoptPanel addItem:item];
        [item release];
    }];
    
    [self.assessPanel clearItems];
    [TechRadarItemReader buildItems:panelNum withBlock: ^(id jsonItem){
        TRItem *item = [[TRItem alloc] initWithLevel:3];
        [self.assessPanel addItem:item];
        [item release];
    }];
    
    [self.holdPanel clearItems];
    [TechRadarItemReader buildItems:panelNum withBlock: ^(id jsonItem){
        TRItem *item = [[TRItem alloc] initWithLevel:4];
        [self.holdPanel addItem:item];
        [item release];
    }];
    
    [self.trialPanel clearItems];
    [TechRadarItemReader buildItems:panelNum withBlock: ^(id jsonItem){
        TRItem *item = [[TRItem alloc] initWithLevel:2];
        [self.trialPanel addItem:item];
        [item release];
    }];
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
    self.view = view;
    [view release];

    UIImageView *bkgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:bkgImage];
    [self.view sendSubviewToBack:bkgImage];

    UIBezierPath *adoptRightEdge= [UIBezierPath bezierPathWithArcCenter:CGPointMake(-94.0f, 374.0f)
                                   radius:425.0f
                               startAngle:DEGREES_TO_RADIANS(-75.0f)
                                 endAngle:DEGREES_TO_RADIANS(75.0f)
                                clockwise:YES];

    UIBezierPath *trialRightEdge = [UIBezierPath bezierPathWithArcCenter:CGPointMake(-94.0f, 374.0f)
                                                                 radius:690.0f
                                                             startAngle:DEGREES_TO_RADIANS(-75.0f)
                                                               endAngle:DEGREES_TO_RADIANS(75.0f)
                                                                clockwise:YES];

    UIBezierPath *assessRightEdge = [UIBezierPath bezierPathWithArcCenter:CGPointMake(-94.0f, 374.0f)
                                                                  radius:835.0f
                                                              startAngle:DEGREES_TO_RADIANS(-75.0f)
                                                                endAngle:DEGREES_TO_RADIANS(75.0f)
                                                               clockwise:YES];

    UIBezierPath *holdRightEdge = [UIBezierPath bezierPathWithRect: CGRectMake(0.0f, 0.0f, 1024.0f, 748.0f) ];

//    self.holdPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(741.0f, 0.0f, 283.0f , 748.0f) leftEdge: assessRightEdge rightEdge: holdRightEdge ];
//
//    [self.view addSubview:self.holdPanel];
//    
//    [panels addObject:self.holdPanel];
//        
//    self.assessPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(596.0f, 0.0f, 145.0f, 748.0f) leftEdge: trialRightEdge rightEdge: assessRightEdge ];
//    [self.view addSubview:self.assessPanel];
//    
//    [panels addObject:self.assessPanel];
//
//    self.trialPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(331.0f, 0.0f, 265.0f, 748.0f) leftEdge: adoptRightEdge rightEdge: trialRightEdge  ];
//    [self.view addSubview:self.trialPanel];
//    
//    [panels addObject:self.trialPanel];
//
//    self.adoptPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 331.0f, 748.0f)
//                                            leftEdge:[self BuildLeftEdgePath]
//                                            rightEdge:adoptRightEdge];
//    self.adoptPanel.delegate = self;
//    [self.view addSubview:self.adoptPanel];
    
    self.holdPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 748.0f) leftEdge:assessRightEdge rightEdge:holdRightEdge theCenterXOffset:929.5f];
    
    [self.view addSubview:self.holdPanel];
    
    [panels addObject:self.holdPanel];
    
    self.assessPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 748.0f) leftEdge:trialRightEdge rightEdge:assessRightEdge theCenterXOffset:762.5f];
    [self.view addSubview:self.assessPanel];
    
    [panels addObject:self.assessPanel];
    
    self.trialPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 666.0f, 748.0f) leftEdge:adoptRightEdge rightEdge:trialRightEdge theCenterXOffset:498.5f];
    [self.view addSubview:self.trialPanel];
    
    [panels addObject:self.trialPanel];
    
    self.adoptPanel = [[TRItemsPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 331.0f, 748.0f) leftEdge:[self BuildLeftEdgePath] rightEdge:adoptRightEdge theCenterXOffset:270.5f];
    self.adoptPanel.delegate = self;
    [self.view addSubview:self.adoptPanel];
    
    [panels addObject:self.adoptPanel];
    //[self initTRItems];
}

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

- (UIBezierPath *)BuildLeftEdgePath {
    UIBezierPath *buttonPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(-13.0f, 748.0f / 2.0f)
                                                              radius:210.0f
                                                          startAngle:DEGREES_TO_RADIANS(-65.0f)
                                                            endAngle:DEGREES_TO_RADIANS(65.0f)
                                                           clockwise:YES];
    [buttonPath addLineToPoint:CGPointMake(178.0f, 748)];
    [buttonPath addLineToPoint:CGPointMake(0, 748)];
    [buttonPath addLineToPoint:CGPointMake(0, 0)];
    [buttonPath addLineToPoint:CGPointMake(178, 0)];
    [buttonPath closePath];
    return buttonPath;
}

@end
