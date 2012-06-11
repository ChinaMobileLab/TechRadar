//
//  TechRadarItemsPanel.m
//  TechRadar
//
//  Created by Cyril Wei on 6/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TechRadarItemsPanel.h"
#import "QuartzCore/QuartzCore.h"

#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees)/ 180)

@implementation TechRadarItemsPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds 
//                                                       byRoundingCorners:UIRectCornerTopLeft
//                                                             cornerRadii:CGSizeMake(10.0, 10.0)];
        self.clipsToBounds = NO;

//        self.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
//        self.layer.shadowColor = [[UIColor grayColor] CGColor];
//        self.layer.shadowPath = maskPath.CGPath;
    }
    return self;
}

- (void)layoutSubviews 
{
//    CGFloat radius = sqrt(pow(self.frame.origin.x + self.frame.size.width, 2) + pow(374.0f, 2));
    CGFloat radius = self.frame.origin.x + self.frame.size.width;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0.0f - self.frame.origin.x, 374.0f) 
                                                            radius:radius 
                                                        startAngle:DEGREES_TO_RADIANS(-75.0f) 
                                                          endAngle:DEGREES_TO_RADIANS(75.0f)
                                                         clockwise:YES];
    
    [maskPath addLineToPoint:CGPointMake(0.0f - self.frame.origin.x, 374.0f)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
