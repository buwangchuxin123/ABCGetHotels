//
//  HotelsViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "HotelsViewController.h"

@interface HotelsViewController (){
    
    }
@end

@implementation HotelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   // [self naviConfig];
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviConfig{
   // self.navigationItem.title = @"GetHotels";
    //设置导航条的颜色（风格颜色）
   // self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
//    self.navigationItem.leftBarButtonItem = left;
}

- (void)backAction{

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
