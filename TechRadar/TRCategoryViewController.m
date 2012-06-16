//
//  TRCategoryViewController.m
//  TechRadar
//
//  Created by Zhe Wang on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRCategoryViewController.h"
#import "TechRadarConstants.h"

@interface TRCategoryViewController ()

@end

@implementation TRCategoryViewController

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
}

- (void)changeToPercent:(CGFloat)percent sender:(id)sender
{
    [self changeButton:percent sender:sender];
    [self changeText:percent];
    [self changeLines:percent];
}

- (void)changeText:(float)percent
{
    TechnologyLabel.alpha = percent;
    LanguageLabel.alpha = percent;
    ToolLabel.alpha = percent;
    PlatformLabel.alpha = percent;
}

- (void)changeLines:(float)percent
{
    
}

- (void)changeButton:(float)percent sender:(id)sender
{   
//    CGFloat s = 3;
//    CGAffineTransform tr = CGAffineTransformScale(self.view.transform, 3, 3);
//    CGFloat h = self.view.frame.size.height;
//    CGFloat w = self.view.frame.size.width;

//    [sender view].frame = CGRectMake(0, 0, imgSize.width, imgSize.height);;

    
//    [sender view].transform = tr;
//    [sender view].center = CGPointMake(w-w*s/2,h*s/2);

    
}

- (void)viewDidUnload
{
    [self setTechnologyLabel:nil];
    [self setPlatformLabel:nil];
    [self setToolLabel:nil];
    [self setLanguageLabel:nil];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
