//
//  ErrorHandler.m
//  Jianshenhui
//
//  Created by ZIYAO YANG on 16/7/14.
//  Copyright © 2016年 ZIYAO YANG. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

+ (NSString *)getProperErrorString:(NSInteger)code {
    switch (code) {
        case 1:
            return @"成功";
            break;
        case -100:
            return @"失败";
            break;
        case -101:
            return @"参数为空";
            break;
        case -102:
            return @"用户不存在";
            break;
        case -103:
            return @"酒店已经预定";
            break;
        case -104:
            return @"酒店已删除";
            break;
        case -105:
            return @"异常处理";
            break;
        case -106:
            return @"验证码错误";
            break;
        case -107:
            return @"验证码发送失败";
            break;
        case -204:
            return @"参数错误";
            break;
        case -207:
            return @"手机格式错误";
            break;
        case 0:
            return @"数据为空";
            break;
        case 8014:
            return @"参数为空";
            break;
        case 8015:
            return @"注册码获取超出次数,请明天再获取";
            break;
        case 8016:
            return @"该号已注册";
            break;
        case 8017:
            return @"该号码不存在，请先注册";
            break;
        case 8018:
            return @"操作失败";
            break;
        case 8019:
            return @"操作失败";
            break;
        case 8020:
            return @"暂无数据";
            break;
        case 8021:
            return @"暂无订单";
            break;
        case 8022:
            return @"该会员卡不存在";
            break;
        case 8023:
            return @"暂无订单";
            break;
        case 8024:
            return @"会所不存在";
            break;
        case 8025:
            return @"暂无优惠券";
            break;
        case 8026:
            return @"此优惠券不存在";
            break;
        case 8027:
            return @"该会员不存在";
            break;
        case 8028:
            return @"该号码不存在";
            break;
        case 8029:
            return @"密码错误";
            break;
        case 8030:
            return @"该手机未获得验证码";
            break;
        case 8031:
            return @"对应特色数据不存在";
            break;
        case 8032:
            return @"金额校验失败";
            break;
        default:
            return @"操作失败";
            break;
    }
}

@end
