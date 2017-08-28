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
         self.hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
         self.hotel_img =  [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@"http://ac-tscmo0vq.clouddn.com/2a4957a871985ea0b0ec.png"];
         self.hotel_address =  [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@""];
         self.price =  [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@""];
         self.distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"10000000000"];
             self.AdImg = [Utilities nullAndNilCheck:dict[@"ad_img"] replaceBy:@" "];
    }
    return self;
}
@end
