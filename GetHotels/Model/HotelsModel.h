//
//  HotelsModel.h
//  GetHotels
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelsModel : NSObject

//@property (strong,nonatomic)NSArray  *hotelsArr;
@property (strong,nonatomic)NSString *hotel_name;
@property (strong,nonatomic)NSString * distance;
@property (strong,nonatomic)NSString *hotel_img;
@property (strong,nonatomic)NSString *price;
@property (strong,nonatomic)NSString *hotel_address;
@property (strong,nonatomic)NSString *AdImg;
@property (strong,nonatomic)NSString *hotelId;

@property (strong,nonatomic)NSArray *hotel_facilities;
@property (strong,nonatomic)NSArray *hotel_imgs;
@property (strong,nonatomic)NSString *in_time;
@property (strong,nonatomic)NSString *latitude;
@property (strong,nonatomic)NSString *longitude;
@property (strong,nonatomic)NSString *now_price;
@property (strong,nonatomic)NSString *out_time;
@property (strong,nonatomic)NSArray *remarks;
@property (strong,nonatomic)NSArray *hotel_types;
@property (strong,nonatomic)NSString *is_pet;


- (instancetype)initWithDict: (NSDictionary *)dict;
- (instancetype)initWithAdImgDict: (NSDictionary *)dict;
- (instancetype)initWithDetailDict: (NSDictionary *)dict;

@end
