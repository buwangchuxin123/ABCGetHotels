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
         self.distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
        self.hotelId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"-1"];
    }
    return self;
}
- (instancetype)initWithAdImgDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
    self.AdImg = [Utilities nullAndNilCheck:dict[@"ad_img"] replaceBy:@" "];
    }
    return self;
}

- (instancetype)initWithDetailDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
    
        self.hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        self.hotel_img =  [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
        self.hotel_address =  [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@""];
        self.price =  [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@""];
        self.distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
        self.hotelId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"-1"];
        
        self.hotel_facilities = [dict[@"hotel_facilities"] isKindOfClass:[NSNull class]] ? @[@"",@"",@" "] :dict[@"hotel_facilities"];

         self.hotel_imgs = [dict[@"hotel_imgs"] isKindOfClass:[NSNull class]] ? @[@"",@"",@" "] :dict[@"hotel_imgs"];
//          self.hotel_imgs = [Utilities nullAndNilCheck:dict[@"hotel_imgs"] replaceBy:@" "];
        
        self.in_time = [Utilities nullAndNilCheck:dict[@"in_time"] replaceBy:@" "];
        self.latitude = [Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:@" "];
        self.longitude = [Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:@" "];
        self.now_price = [Utilities nullAndNilCheck:dict[@"now_price"] replaceBy:@" "];
       self.out_time = [Utilities nullAndNilCheck:dict[@"out_time"] replaceBy:@" "];
       self.remarks = [dict[@"remarks"] isKindOfClass:[NSNull class]] ? @[@"",@""] :dict[@"remarks"];
        self.hotel_types = [dict[@"hotel_types"] isKindOfClass:[NSNull class]] ? @[@"",@"",@" ",@" "] :dict[@"hotel_types"];
          self.is_pet = [Utilities nullAndNilCheck:dict[@"is_pet"] replaceBy:@" "];
//     self.secondResArr = [Utilities nullAndNilCheck:dict[@"content"] replaceBy:@[]];
    }
    return self;
}
@end
