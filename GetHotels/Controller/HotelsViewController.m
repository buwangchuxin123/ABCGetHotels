//
//  HotelsViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "HotelsViewController.h"
#import "HotelsTableViewCell.h"
#import "HotelsModel.h"
#import <CoreLocation/CoreLocation.h>//使用该框架才可以使用定位功能
@interface HotelsViewController ()<UITableViewDataSource ,UITableViewDelegate, CLLocationManagerDelegate>{
    BOOL isLoding;//判断是不是在加载中
    BOOL firstVisit;
    NSInteger pageNum;
    NSInteger pageSize;
    NSInteger startId;
    NSInteger priceId;

    
    
    
    }
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *weather;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;
@property (strong, nonatomic) CLLocationManager *locMgr;
@property (strong, nonatomic) CLLocation *location;
@property (strong,nonatomic)NSString *city_name;
@property (strong,nonatomic)NSString *inTime;
@property (strong,nonatomic)NSString *outTime;
@property (strong,nonatomic)NSString *sortingId;
@property (strong,nonatomic)NSString *wxlongitude;
@property (strong,nonatomic)NSString *wxlatitude;
@property (strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong, nonatomic) NSMutableArray *firstResArr;

@property (weak, nonatomic) IBOutlet UILabel *price;

@end

@implementation HotelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    pageNum = 1;
    pageSize = 1 ;
    startId = 1;
    priceId = 1;
    _inTime = @"2017-08-25";
    _outTime = @"2017-08-26";
    _sortingId = @"1";
    _city_name = @"无锡";
    _wxlongitude = @"";
    _wxlatitude = @"";
    [self naviConfig];
    [self locationConfig];
    [self netRequest];
    NSLog(@"数组长度为：%lu",(unsigned long)_firstResArr.count);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//每次将要来到这个页面的时候
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationConfig];
    [self locationStart];
    [self dataInitialize];
    
}
//每次将要离开这个页面的时候
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关掉开关
    [_locMgr stopUpdatingLocation];
}
- (void)naviConfig{
    // self.navigationItem.title = @"GetHotels";
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
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    //    self.navigationItem.leftBarButtonItem = left;
}


//这个方法专门做数据的处理
- (void)dataInitialize{
    BOOL appInit = NO;
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //说明是第一次打开APP
        appInit = YES;
    } else {
        if ([Utilities getUserDefaults:@"UserCity"] == nil) {
            //也说明是第一次打开APP
            appInit = YES;
        }
    }
    if (appInit) {
        NSString *userCity = _cityBtn.titleLabel.text;
        
        [Utilities setUserDefaults:@"UserCity" content:userCity];
        
    } else {
        //不是第一次来到APP则将记忆城市与按钮上的城市名反向同步
        NSString *userCity = [Utilities getUserDefaults:@"UserCity"];
        [_cityBtn setTitle:userCity forState:UIControlStateNormal];
    }
    
    firstVisit = YES;
    isLoding = NO;
       // _arr = [NSMutableArray new];
   
    
}

- (void)netRequest{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city_name":_city_name,@"pageNum":@(pageNum),@"pageSize":@(pageSize),@"startId":@(startId),@"priceId":@(priceId),@"sortingId":_sortingId,@"inTime":_inTime,@"outTime":_outTime,@"wxlatitude":_wxlatitude,@"wxlongitude":_wxlongitude};
    [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        
        if([responseObject[@"result"] integerValue] == 1){
           NSArray *result = responseObject[@"content"][@"hotel"][@"list"];
            for (NSDictionary *dict in result) {
              HotelsModel *resultModel = [[HotelsModel alloc] initWithDict:dict];
              NSLog(@"结果：%@",resultModel);
              [_firstResArr addObject:resultModel];
            }
           // NSArray
            
            
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
         [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];

}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _firstResArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelsCell" forIndexPath:indexPath];
    HotelsModel *hotelsModel =  _firstResArr[indexPath.row];
    cell.HotelsName.text = hotelsModel.hotel_name;
    
    cell.address.text = hotelsModel.hotel_address;
    cell.price.text = hotelsModel.price;
    cell.distance.text = @"距离我100m";
    
    
    return cell;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - location

//这个方法专门处理定位的基本设置
- (void) locationConfig {
    _locMgr = [CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //定位到的设备位移多少距离进行一次识别
    _locMgr.distanceFilter = kCLHeadingFilterNone;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
}

//这个方法处理开始定位
- (void) locationStart {
    //（判断用户是否选择过定位）
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //询问用户是否愿意打开定位
#ifdef __IPHONE_8_0
        if ([_locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            //使用“使用中打开定位”这个策略去运用定位功能
            [_locMgr requestWhenInUseAuthorization];
        }
        
#endif
    }
    //打开定位服务的开关（开始定位）
    [_locMgr startUpdatingLocation];
}
//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿到城市
    if (firstVisit) {
        firstVisit = !firstVisit;
        //根据定位拿到城市
        [self getRegeoViaCoordinate];
    }
    
}
- (void) getRegeoViaCoordinate {
    //duration表示从now开始过3个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    //用duration这个设置好的策略去做某些事
    dispatch_after(duration, dispatch_get_main_queue(), ^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                NSLog(@"locDict:%@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"LocCity"];
                //将定位到的城市存进单例化全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"LocCity" andValue:cityStr];
                if (![cityStr isEqualToString:_cityBtn.titleLabel.text]) {
                    //当定位到的城市和当前选择的城市不一样的时候，弹窗询问是否要切换城市
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的城市为%@,是否切换",cityStr] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
                        //修改用户选择的城市
                        [Utilities removeUserDefaults:@"UserCity"];
                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
                        //重新进行网络请求
                        //  [self networkRequest];
                        
                    }];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertView addAction:yesAction];
                    [alertView addAction:noAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                }
            }
        }];
        //关掉开关
        [_locMgr stopUpdatingLocation];
    });
}


- (void) checkCityState:(NSNotification *)note {
    NSString *cityStr = note.object;
    if (![cityStr isEqualToString:_cityBtn.titleLabel.text]) {
        //修改城市按钮标题
        [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
        //修改用户选择的城市
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //重新进行网络请求
       // [self networkRequest];
    }
    
}

- (void)backAction{
    
}

- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
