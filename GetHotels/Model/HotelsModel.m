//
//  HotelsModel.m
//  GetHotels
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "HotelsModel.h"

@implementation HotelsModel
- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
         self.hotelsArr = [Utilities nullAndNilCheck:dict[@"list"] replaceBy:@[]];
         
    }
    return self;
}
@end
