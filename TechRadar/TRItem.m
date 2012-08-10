//
//  TRItem.m
//  TechRadar
//
//  Created by Cyril Wei on 7/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation TRItem

- (id)initWithRadius:(CGFloat)radius
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self setRadius:radius];
    }
    return self;
}

- (void)setRadius:(CGFloat)radius
{
    CGFloat diameter = radius * 2.0f;
    self.frame = CGRectMake(self.center.x - radius, self.center.y - radius, diameter, diameter);

    self.layer.cornerRadius = radius;
}

- (CGFloat)radius
{
    return self.frame.size.width;
}

@end
