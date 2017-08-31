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
    _nick_name =[Utilities nullAndNilCheck:dict[@"nick_name"] replaceBy:@"未命名"];
     _userId=[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0];
    _idCard=[Utilities nullAndNilCheck:dict[@"id_card"] replaceBy:@"未设置"];
     //self.tel = [dict[@"tel"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"tel"] integerValue];
        if([dict[@"gender"] isKindOfClass:[NSNull class]]){
            _gender=@"";
        }
        else{
            switch ([dict[@"gender"] integerValue]) {
                case 1:
                    _gender=@"男";
                    break;
                case 2:
                    _gender=@"女";
                    break;
                default:
                    _gender=@"未设置";
                    break;
            }
        }

    }
    return self;
}
@end
