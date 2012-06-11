//
//  TechRadarContent.m
//  TechRadar
//
//  Created by Zhe Wang on 6/11/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "TechRadarContent.h"


@implementation TechRadarContent

@dynamic name;
@dynamic category;
@dynamic level;
@dynamic isNew;
@dynamic issued;
@dynamic distance;

- (void)saveTechRadarContent
{
    
}

- (TechRadarContent *)fetchTechRadarContent
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TechRadarContent"
//                                              inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    for (FailedBankInfo *info in fetchedObjects) {
//        NSLog(@"Name: %@", info.name);
//        FailedBankDetails *details = info.details;
//        NSLog(@"Zip: %@", details.zip);
//    }
    return nil;
}

@end
