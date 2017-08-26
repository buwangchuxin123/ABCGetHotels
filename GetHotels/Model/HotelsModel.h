//
//  HotelsModel.h
//  GetHotels
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelsModel : NSObject

@property (strong,nonatomic)NSArray *hotelsArr;
@property (strong,nonatomic)NSString *hotel_name;
- (instancetype)initWithDict: (NSDictionary *)dict;
@end
