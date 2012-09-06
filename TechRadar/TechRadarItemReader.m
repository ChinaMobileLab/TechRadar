//
//  Created by twer on 9/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TechRadarItemReader.h"
#import "TRItem.h"


@implementation TechRadarItemReader

+ (void)buildItems: (int) panelNum withBlock: (void (^)(TRItem*))handleItem{

    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"items-%d", panelNum] ofType:@"json"];
    NSData *jsonData =  [NSData dataWithContentsOfFile: filePath];
    NSError *e;
    NSMutableArray *jsonItems = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];

    for (id jsonItem in jsonItems){
        TRItem *item = [[TRItem alloc] initWithLevel:1];
        handleItem(item);
        [item release];
    }


}

@end