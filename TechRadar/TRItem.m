//
//  TRItem.m
//  TechRadar
//
//  Created by Cyril Wei on 7/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TRItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation TRItem {


@private
    NSString *_itemTitle;
}

@synthesize itemTitle = _itemTitle;


- (id)initWithLevel:(NSInteger)level title:(NSString *)itemTitle
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", level]]];

        UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 32.0f, 250.0f, 40.0f)];
        title.text = [itemTitle copy];
        [title setTextColor:[UIColor whiteColor]];
        self.radius = 138.0f;
        [self addSubview:image];
        [self addSubview:title];
        
        [itemTitle release];
        [image release];
        [title release];
    }
    return self;
}

- (void)setRadius:(CGFloat)radius
{
    CGFloat diameter = radius * 2.0f;
    self.frame = CGRectMake(self.center.x - radius, self.center.y - radius, diameter, diameter);

}

- (CGFloat)radius
{
    return self.frame.size.width;
}




@end
