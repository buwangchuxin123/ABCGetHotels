//
//  UserModel.m
//  GetHotels
//
//  Created by admin001 on 2017/8/25.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(id)initWithDictionary:(NSDictionary *)dict{
self =[super init];
    if (self) {
    _nick_name =[Utilities nullAndNilCheck:dict[@"nick_name"] replaceBy:@"0"];
    self.gender = [dict[@"gender"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"gender"] integerValue];
     _MemberId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
     self.tel = [dict[@"tel"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"tel"] integerValue];
    }
    return self;
}
@end
