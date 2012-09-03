//
//  TRItem.h
//  TechRadar
//
//  Created by Cyril Wei on 7/5/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRItem : UIButton

@property (nonatomic) CGFloat radius;

- (id)initWithLevel:(NSInteger)level;

@end
