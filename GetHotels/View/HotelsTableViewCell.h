//
//  HotelsTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *HotelsImg;
@property (weak, nonatomic) IBOutlet UILabel *HotelsName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
