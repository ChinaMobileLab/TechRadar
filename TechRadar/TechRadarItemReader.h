//
//  Created by twer on 9/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class TRItem;


@interface TechRadarItemReader : NSObject
+ (void) buildItems:(int) panelNum withBlock:(void (^)(NSArray*))handleItem;
@end