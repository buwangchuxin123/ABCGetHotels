//
//  MyHotelsViewController.m
//  GetHotels
//
//  Created by admin001 on 2017/8/27.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "MyHotelsViewController.h"
#import "HMSegmentedControl.h"
@interface MyHotelsViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger allOrderOpenid;
    NSInteger allOrderid;
}
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITableView *allOrderTableView;
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong, nonatomic)NSMutableArray *allOrderArr;
@end

@implementation MyHotelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _allOrderArr = [NSMutableArray new];
    [self naviConfig];
    [self setSegment];
    _allOrderTableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(23, 124, 236);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
    //用push返回上一页
}

//初始化菜单栏的方法
- (void)setSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部订单",@"可使用",@"已过期"]];
    //设置位置
    _segmentedControl.frame = CGRectMake(0, UI_SCREEN_H - 600 -60, UI_SCREEN_W, 40);
    //设置默认选中的项
    _segmentedControl.selectedSegmentIndex = 0;
    //设置菜单栏的背景色
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    //设置线的高度
    _segmentedControl.selectionIndicatorHeight = 2.5f;
    //设置选中状态的样式
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    //选中时的标记的位置
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //设置未选中的标题样式
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(230, 230, 230, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    //选中时的标题样式
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(154, 154, 154, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
    
    __weak typeof(self) weakSelf = self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.ScrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * index, 0, UI_SCREEN_W, 200) animated:YES];
    }];
    
    [self.view addSubview:_segmentedControl];
}
//网络请求
-(void)allOrderRequest{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para = @{@"openid":@(allOrderOpenid),@"id":@(allOrderid)};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"%ld",(long)responseObject);
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:nil onView:self];
    }];

    
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
