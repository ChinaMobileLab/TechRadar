//
//  Created by twer on 9/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TechRadarItemReader.h"
#import "TRItem.h"


@implementation TechRadarItemReader

+ (void)buildItems: (int) panelNum withBlock: (void (^)(NSArray*))handleItem{
    NSLog(@"---------randering: items-%d", panelNum);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"items-%d", panelNum] ofType:@"json"];
    NSData *jsonData =  [NSData dataWithContentsOfFile: filePath];
    NSError *e;
    NSMutableArray *jsonItems = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];

    handleItem(jsonItems);
}

@end