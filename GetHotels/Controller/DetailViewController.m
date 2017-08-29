//
//  DetailViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "DetailViewController.h"
#import "HotelsModel.h"

@interface DetailViewController (){
    NSInteger pageNum;
    NSInteger pageSize;
    NSInteger startId;
    NSInteger priceId;
}
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *starDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *starDayLbl;
@property (weak, nonatomic) IBOutlet UIButton *endDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *endDayLbl;
@property (weak, nonatomic) IBOutlet UIImageView *UIimage;
@property (weak, nonatomic) IBOutlet UIButton *roomTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *breakfastLbl;
@property (weak, nonatomic) IBOutlet UILabel *bedTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *roomArea;
@property (weak, nonatomic) IBOutlet UILabel *parkLbl;
@property (weak, nonatomic) IBOutlet UILabel *pickUpLbl;//接机
@property (weak, nonatomic) IBOutlet UILabel *fitnessLbl;//健身
@property (weak, nonatomic) IBOutlet UILabel *freeProductLbl;//免费洗漱品
@property (weak, nonatomic) IBOutlet UILabel *freeWifi;
@property (weak, nonatomic) IBOutlet UILabel *wakeUpLbl;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLbl;
@property (weak, nonatomic) IBOutlet UILabel *luggageLbl;//行李寄存
@property (weak, nonatomic) IBOutlet UILabel *checkInTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *isCarrayPetLbl;
- (IBAction)roomTypeAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)ChatAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)purchaseAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (strong,nonatomic)UIActivityIndicatorView *avi;

@property (strong,nonatomic)NSString *sortingId;
@property (strong,nonatomic)NSString *wxlongitude;
@property (strong,nonatomic)NSString *wxlatitude;
@property (strong,nonatomic)NSString *city_name;
@property (strong,nonatomic)NSString *inTime;
@property (strong,nonatomic)NSString *outTime;

@property (strong, nonatomic) NSMutableArray *firstResArr;
@property (strong, nonatomic) NSMutableArray *AdImgarr;
@property (strong, nonatomic) NSMutableArray *AdImgarr1;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _AdImgarr  =   [NSMutableArray new];
    _firstResArr = [NSMutableArray new];
    _AdImgarr1  = [[NSMutableArray alloc]initWithObjects:@"http://ac-tscmo0vq.clouddn.com/2a4957a871985ea0b0ec.png",@"http://ac-tscmo0vq.clouddn.com/8060e54840115e3dc743.png",@"http://ac-tscmo0vq.clouddn.com/1cbe1d0ad3bae6214d59.jpg",@"http://ac-tscmo0vq.clouddn.com/b3ca642f7a9297e907c7.jpg",@"http://ac-tscmo0vq.clouddn.com/5c1f5d0dd16e0888ecd0.jpg",nil];

    pageNum = 1;
    pageSize = 10;
    startId = 1;
    priceId = 1;
    _sortingId = @"1";
    _city_name = @"无锡";
    _wxlongitude = @"120.300000";
    _wxlatitude = @"31.570000";
    _inTime = @"2017-08-25";
    _outTime = @"2017-08-26";
    [self naviConfig];
    [self netRequest];
    [self addZLImageViewDisPlayView:_AdImgarr1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    self.navigationItem.title = @"酒店预订";
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
-(void) addZLImageViewDisPlayView:(NSArray *)arr{
    
    
    CGRect frame = CGRectMake(0,0, UI_SCREEN_W, 160);
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = arr;
    imageViewDisplay.scrollInterval = 3;
    imageViewDisplay.animationInterVale = 0.6;
    [_adView addSubview:imageViewDisplay];
    
}

- (void)netRequest{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city_name":_city_name,@"pageNum":@(pageNum),@"pageSize":@(pageSize),@"startId":@(startId),@"priceId":@(priceId),@"sortingId":_sortingId,@"inTime":_inTime,@"outTime":_outTime,@"wxlatitude":_wxlatitude ,@"wxlongitude":_wxlongitude};
    [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        
        if([responseObject[@"result"] integerValue] == 1){
            NSDictionary *content = responseObject[@"content"];
            NSArray *result = content[@"hotel"][@"list"];
            NSArray *Adarr  = content[@"advertising"];
            for (NSDictionary *dict in Adarr) {
                HotelsModel *resultModel = [[HotelsModel alloc] initWithDict:dict];
           //     [ self.AdImgarr addObject:resultModel.AdImg];
                NSLog(@"网址：%@",resultModel.AdImg);
                
                //  [_AdImgarr addObject:dict[@"ad_img"]];
                // _AdImgarr = dict[@"ad_img"];//copy;
                // NSLog(@"网址是：%@",dict[@"ad_img"]);
                
            }
            for (NSDictionary *dict in result) {
                HotelsModel *resultModel = [[HotelsModel alloc] initWithDict:dict];
                //  NSLog(@"结果：%@",resultModel.hotel_name);
                //  NSLog(@"距离：%@",resultModel.distance);
                //  NSLog(@"图片地址：%@",resultModel.hotel_img);
             //   [_firstResArr addObject:resultModel];
            }
            
         //   [_hotelsTableView reloadData];
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)roomTypeAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)ChatAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)purchaseAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
