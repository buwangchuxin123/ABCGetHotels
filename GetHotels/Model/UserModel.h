//
//  UserModel.h
//  GetHotels
//
//  Created by admin001 on 2017/8/25.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic) NSInteger gender;
@property(nonatomic)NSInteger tel;
@property (strong, nonatomic)NSString *MemberId;
@property(strong,nonatomic)NSString * nick_name;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
