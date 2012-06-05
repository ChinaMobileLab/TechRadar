//
//  TechRadarCategoryControllerViewController.m
//  TechRadar
//
//  Created by Zhe Wang on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TechRadarCategoryControllerViewController.h"

@interface TechRadarCategoryControllerViewController ()

@end

@implementation TechRadarCategoryControllerViewController
@synthesize CentralButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CentralButton.userInteractionEnabled = YES;
        UIPanGestureRecognizer *dragingGR = [[UIPanGestureRecognizer alloc] 
                                         initWithTarget:self action:@selector(handlePan:)];
//        dragingGR.delegate = self;
        [CentralButton addGestureRecognizer:dragingGR];
        [dragingGR release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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
    [super dealloc];
}
@end
