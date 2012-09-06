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

    [TechRadarItemReader buildItems:panelNum withBlock: ^(TRItem *item){
        [self.adoptPanel addItem:item];
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

@end
