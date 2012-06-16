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

- (void)loadView
{
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_central_button.png"]];
    view.frame = CGRectMake(0.0f, 0.0f, TechRadarSideButtonWidth, TechRadarSideButtonHeight);

    view.center = CGPointMake(TechRadarSideButtonX, TechRadarSideButtonY);
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
