//
//  PayViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "PayViewController.h"
#import "PayTableViewCell.h"
#import "DetailViewController.h"
@interface PayViewController ()
@property (strong,nonatomic)NSArray *arr;
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *PayBtn;
- (IBAction)PayAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *PayTableView;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = @[@"支付宝支付",@"微信支付",@"银联支付"];
    [self naviConfig];
    [self uiLayout];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    self.navigationItem.title = @"支付";
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 15, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
//   // [self.navigationController popViewControllerAnimated:YES];
//    PayViewController *PayVc = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"Pay"];
//    UINavigationController *Pc = [[UINavigationController alloc] initWithRootViewController:PayVc];
//    //2.用某种方式跳转到上述页面（这里用Model方式跳转）
  //  [self presentViewController:Pc animated:YES completion:nil];
}

- (void)uiLayout{
    _hotelNameLbl.text = _payModel.hotel_name;
    _priceLbl.text = [NSString stringWithFormat:@"%@元",_payModel.price];
    NSString *startTime = [[StorageMgr singletonStorageMgr]objectForKey:@"startTime"];
    NSString *endTime = [[StorageMgr singletonStorageMgr]objectForKey:@"endTime"];
    _dateLbl.text = [NSString stringWithFormat:@"%@——%@",startTime,endTime];
    self.PayTableView.tableFooterView = [UIView new];
   //将表格视图设置为“编辑”
    self.PayTableView.editing = YES;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码表示视图中的某个cell
    [self.PayTableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
}

//设置每一行被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //遍历表格视图中选中状态下的cell
    for(NSIndexPath *eachIP in tableView.indexPathsForSelectedRows){
        //当选中的cell不是当前正在按得时候
        if(eachIP != indexPath)
            //取消cell选中状态
            [tableView deselectRowAtIndexPath:eachIP animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
    
    cell.PayTypeLbl.text = _arr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
//设置组的头标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"支付方式";
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)PayAction:(UIButton *)sender forEvent:(UIEvent *)event {
     [Utilities popUpAlertViewWithMsg:@"支付还未上线，敬请期待" andTitle:@"提示" onView:self];
}
@end
