//
//  TechRadarCategoryControllerViewController.h
//  TechRadar
//
//  Created by Zhe Wang on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TechRadarCategoryControllerViewController : UIViewController <UIGestureRecognizerDelegate>
{
    CGFloat firstX;
    CGFloat firstY;
}

@property (retain, nonatomic) IBOutlet UIImageView *CentralButton;


@property (retain, nonatomic) IBOutlet UILabel *TechnologyLabel;
@property (retain, nonatomic) IBOutlet UILabel *PlatformLabel;
@property (retain, nonatomic) IBOutlet UILabel *ToolLabel;
@property (retain, nonatomic) IBOutlet UILabel *LanguageLabel;
@end
