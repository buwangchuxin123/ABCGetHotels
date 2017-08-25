//
//  MyInfoViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"
#import "UserModel.h"
@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITableView *myInfoTableView;
- (IBAction)loginBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic)NSArray *myInfoArr;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myInfoArr = @[@{@"leftIcon":@"酒店",@"title":@"我的酒店"},@{@"leftIcon":@"航班",@"title":@"我的航空"},@{@"leftIcon":@"我的消息",@"title":@"我的消息"},@{@"leftIcon":@"账户设置",@"title":@"账户设置"},@{@"leftIcon":@"使用协议",@"title":@"使用协议"},@{@"leftIcon":@"联系客服",@"title":@"联系客服"}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([Utilities loginCheck]) {
        //已登录
        _loginBtn.hidden = YES;
        _userNameLabel.hidden = NO;
        _levelLabel.hidden = NO;
        _headImage.image = [UIImage imageNamed:@"icon"];
        //用一个model承接存在单例化全局变量中的Model
        UserModel *user = [[StorageMgr singletonStorageMgr] objectForKey:@"UserInfo"];
        
        _userNameLabel.text = user.nick_name;
        
    }else{
        _loginBtn.hidden = NO;
        _userNameLabel.hidden = YES;
        _levelLabel.hidden = YES;
        _headImage.image = [UIImage imageNamed:@"默认头像"];
        _userNameLabel.text = @"未登录";
    }
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//细胞有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
   
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    if(indexPath.section == 0){
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myInfoArr[indexPath.row];
    cell.leftIcon.image = [UIImage imageNamed:dict[@"leftIcon"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
    }else{
        NSDictionary *dict = _myInfoArr[indexPath.row + 3];
        cell.leftIcon.image = [UIImage imageNamed:dict[@"leftIcon"]];
        cell.titleLabel.text = dict[@"title"];
      return cell;
    }
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}


- (IBAction)loginBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
