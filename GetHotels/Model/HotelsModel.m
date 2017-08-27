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
         self.hotel_img =  [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
         self.hotel_address =  [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@""];
         self.price =  [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@""];
         self.distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"10000000000"];
    }
    return self;
}
@end
