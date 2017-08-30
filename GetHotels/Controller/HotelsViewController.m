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
@property (strong, nonatomic) NSMutableArray *AdImgarr;
@property (strong, nonatomic) NSMutableArray *AdImgarr1;
@property (weak, nonatomic) IBOutlet UITableView *hotelsTableView;

@property (weak, nonatomic) IBOutlet UIView *CycleAdView;

@end

@implementation HotelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _AdImgarr  =   [NSMutableArray new];
    _firstResArr = [NSMutableArray new];
    _AdImgarr1  = [[NSMutableArray alloc]initWithObjects:@"http://ac-tscmo0vq.clouddn.com/2a4957a871985ea0b0ec.png",@"http://ac-tscmo0vq.clouddn.com/8060e54840115e3dc743.png",@"http://ac-tscmo0vq.clouddn.com/1cbe1d0ad3bae6214d59.jpg",@"http://ac-tscmo0vq.clouddn.com/b3ca642f7a9297e907c7.jpg",@"http://ac-tscmo0vq.clouddn.com/5c1f5d0dd16e0888ecd0.jpg",nil];
    pageNum = 1;
    pageSize = 10;
    startId = 1;
    priceId = 1;
    _inTime = @"2017-08-25";
    _outTime = @"2017-08-26";
    _sortingId = @"1";
    _city_name = @"无锡";
    _wxlongitude = @"120.300000";
    _wxlatitude = @"31.570000";
    [self naviConfig];
    [self netRequest];
    
  // NSLog(@"数组里的是:%@",_AdImgarr[2]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
     self.navigationItem.title = @"GetHotels";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(20, 124, 236);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    
}
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//重设初始响应器
    return YES;
}

-(void) addZLImageViewDisPlayView:(NSArray *)arr{
    
    
    CGRect frame = CGRectMake(0,0, UI_SCREEN_W, 160);
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = arr;
    imageViewDisplay.scrollInterval = 3;
    imageViewDisplay.animationInterVale = 0.6;
    [_CycleAdView addSubview:imageViewDisplay];

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
//    _arr = [NSMutableArray new];
//    //创建菊花膜
//    _aIV = [Utilities getCoverOnView:self.view];
  //  [self refreshPage];
    
}


- (void)netRequest{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city_name":_city_name,@"pageNum":@(pageNum),@"pageSize":@(pageSize),@"startId":@(startId),@"priceId":@(priceId),@"sortingId":_sortingId,@"inTime":_inTime,@"outTime":_outTime,@"wxlatitude":_wxlatitude ,@"wxlongitude":_wxlongitude};
    [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
     //   NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        
        if([responseObject[@"result"] integerValue] == 1){
            NSDictionary *content = responseObject[@"content"];
            NSArray *result = content[@"hotel"][@"list"];
            NSArray *Adarr  = content[@"advertising"];
            for (NSDictionary *dict in Adarr) {
              HotelsModel *resultModel = [[HotelsModel alloc] initWithAdImgDict:dict];
              [ _AdImgarr addObject:resultModel.AdImg];
                
               
              
               
            }
            NSLog(@"网址：%@",_AdImgarr[2]);
            [self addZLImageViewDisPlayView:_AdImgarr];
            for (NSDictionary *dict in result) {
              HotelsModel *resultModel = [[HotelsModel alloc] initWithDict:dict];
              NSLog(@"结果：%@",resultModel.hotelId);
             
              [_firstResArr addObject:resultModel];
              
            }
        
            [_hotelsTableView reloadData];
            
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
//设置组的头标题文字
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return ;
//}
- (UIView*) tableView:(UITableView *)_tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 30)];
    headerView.backgroundColor = UIColorFromRGB(250, 250, 250);
   
    UIButton *btn1 =[[UIButton alloc] initWithFrame:CGRectMake(15,5,UI_SCREEN_W/4, 25)];
     [btn1 setTitle:@"入住03-24"  forState:UIControlStateNormal];
      btn1.titleLabel.font  = [UIFont systemFontOfSize: 12];
      btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      [btn1 setTitleColor:UIColorFromRGB(112, 128, 144) forState:UIControlStateNormal];
      UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_W/4-15,15,5,5)];
     img1.image = [UIImage imageNamed:@"menu_down"];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(UI_SCREEN_W/4,0,1, 30) ];
    view1.backgroundColor = UIColorFromRGB(241, 241, 241);
//    [btn1 addTarget:self action:@selector(onClick1:)
//     forControlEvents:UIControlEventTouchUpInside];
    [headerView  addSubview:view1];
    [headerView  addSubview:img1];
    [headerView addSubview:btn1];
    
    UIButton *btn2 =[[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W/4 +10,5,UI_SCREEN_W/4, 25)];
    [btn2 setTitle:@"离店03-28"  forState:UIControlStateNormal];
    btn2.titleLabel.font  = [UIFont systemFontOfSize: 12];
    btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn2 setTitleColor:UIColorFromRGB(112, 128, 144) forState:UIControlStateNormal];
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_W/2-15,15,5,5)];
    img2.image = [UIImage imageNamed:@"menu_down"];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(UI_SCREEN_W/2,0,1, 30) ];
    view2.backgroundColor = UIColorFromRGB(241, 241, 241);
    //    [btn1 addTarget:self action:@selector(onClick1:)
    //     forControlEvents:UIControlEventTouchUpInside];
    [headerView  addSubview:view2];
    [headerView  addSubview:img2];
    [headerView addSubview:btn2];
    
    UIButton *btn3 =[[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W/2 +10,5,UI_SCREEN_W/4, 25)];
    [btn3 setTitle:@"智能排序"  forState:UIControlStateNormal];
    btn3.titleLabel.font  = [UIFont systemFontOfSize: 12];
    btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn3 setTitleColor:UIColorFromRGB(112, 128, 144) forState:UIControlStateNormal];
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_W - UI_SCREEN_W/4 -15,15,5,5)];
    img3.image = [UIImage imageNamed:@"menu_down"];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(UI_SCREEN_W - UI_SCREEN_W/4,0,1, 30) ];
    view3.backgroundColor = UIColorFromRGB(241, 241, 241);
    //    [btn1 addTarget:self action:@selector(onClick1:)
    //     forControlEvents:UIControlEventTouchUpInside];
    [headerView  addSubview:view3];
    [headerView  addSubview:img3];
    [headerView addSubview:btn3];
    
    UIButton *btn4 =[[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W - UI_SCREEN_W/4 +10,5,UI_SCREEN_W/4, 25)];
    [btn4 setTitle:@"  筛选"  forState:UIControlStateNormal];
    btn4.titleLabel.font  = [UIFont systemFontOfSize: 12];
    btn4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn4 setTitleColor:UIColorFromRGB(112, 128, 144) forState:UIControlStateNormal];
    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_W - 15,15,5,5)];
    img4.image = [UIImage imageNamed:@"menu_down"];
    
    //    [btn1 addTarget:self action:@selector(onClick1:)
    //     forControlEvents:UIControlEventTouchUpInside];
       [headerView  addSubview:img4];
    [headerView addSubview:btn4];
    return headerView;
}
//设置section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _firstResArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    HotelsModel *hotelsModel =  _firstResArr[indexPath.row];
    cell.HotelsName.text = hotelsModel.hotel_name;
    
    cell.address.text = hotelsModel.hotel_address;
    NSString *price = [NSString stringWithFormat:@"¥ %@",hotelsModel.price];
    cell.price.text = price;
    NSString *Str = hotelsModel.distance;
    double Kilometer  = [Str doubleValue];
    NSString *distance = [NSString stringWithFormat:@"距离我%.1f公里",(Kilometer/1000)];
    cell.distance.text = distance;
 
    NSURL *URL = [NSURL URLWithString:hotelsModel.hotel_img];
  
    NSString *userAgent = @"";
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    /////////////////////////
    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                                 forHTTPHeaderField:@"Accept"];
    [cell.HotelsImg sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"酒店-1"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      //  NSLog(@"=====error=%@",error);
    }];
    return cell;
}


//设置每一组中没一行被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
          //[self.navigationController popViewControllerAnimated:YES];
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


- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
