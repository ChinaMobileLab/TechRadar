//
//  TechRadarContent.h
//  TechRadar
//
//  Created by Zhe Wang on 6/11/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TechRadarContent : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSNumber * isNew;
@property (nonatomic, retain) NSDate * issued;
@property (nonatomic, retain) NSNumber * distance;

- (void)saveTechRadarContent;

- (TechRadarContent *)fetchTechRadarContent;

@end
