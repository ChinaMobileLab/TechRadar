//
//  TRItem.m
//  TechRadar
//
//  Created by Cyril Wei on 7/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRItem.h"

@implementation TRItem

- (id)initWithRadius:(CGFloat)radius
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        CGFloat diameter = radius * 2.0f;
        
        self.frame = CGRectMake(0.0f, 0.0f, diameter, diameter);
        
        self.layer.cornerRadius = radius;
    }
    return self;
}

- (CGFloat)radius
{
    return self.frame.size.width;
}

@end
