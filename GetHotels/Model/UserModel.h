//
//  UserModel.h
//  GetHotels
//
//  Created by admin001 on 2017/8/25.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(strong,nonatomic)NSString *gender;
@property(strong,nonatomic)NSString *tel;
@property(strong,nonatomic)NSString *idCard;
@property(strong,nonatomic)NSString * nick_name;
@property(strong,nonatomic)NSString *userId;

-(id)initWithDictionary:(NSDictionary *)dict;
@end
