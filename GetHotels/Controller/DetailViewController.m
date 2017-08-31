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
   NSTimeInterval StartTime;
   NSTimeInterval EndTime;
   NSInteger flag;
    
}
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *StartDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;

@property (weak, nonatomic) IBOutlet UILabel *starDayLbl;

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
- (IBAction)startAction:(UIButton *)sender forEvent:(UIEvent *)event;

- (IBAction)endAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UIView *superView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (strong,nonatomic)UIActivityIndicatorView *avi;


@property (strong, nonatomic) NSMutableArray *firstResArr;
@property (strong, nonatomic) NSMutableArray *AdImgarr;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _AdImgarr  =   [NSMutableArray new];
    _firstResArr = [NSMutableArray new];
    

    [self naviConfig];
     [self netRequest];
    [self addZLImageViewDisPlayView:_AdImgarr];
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
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
     [self.navigationController popViewControllerAnimated:YES];
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
/*
-(void)uiLayout{
    _hotelName.text = _Hotel.hotel_name;
    _price.text = [NSString stringWithFormat:@"¥ %@",_Hotel.now_price];
    _address.text = _Hotel.hotel_address;
    
    NSDate *now = [NSDate date];//调用该行代码的时间
    NSDateFormatter *nowformatter = [[NSDateFormatter alloc] init];
    nowformatter.dateFormat = @"MM-dd";
    NSString *thDate = [nowformatter stringFromDate:now];
    //EndTime = [Utilities cTimestampFromString:thDate format:@"MM-dd"];
    [_StartDateBtn setTitle:thDate forState:UIControlStateNormal];
    
    
    NSDate *tomorrow = [NSDate dateTomorrow];
    NSDateFormatter *tomoformatter = [[NSDateFormatter alloc] init];
    tomoformatter.dateFormat = @"MM-dd";
    NSString *tomoDate = [tomoformatter stringFromDate:tomorrow];
  //  EndTime = [Utilities cTimestampFromString:thDate format:@"MM-dd"];
    [_endDateBtn setTitle:tomoDate forState:UIControlStateNormal];
    
    
    _UIimage.image = [UIImage imageNamed:@"酒店-1"];
    [ _roomTypeBtn setTitle: _Hotel.hotel_types[0] forState:UIControlStateNormal];
    _breakfastLbl.text = _Hotel.hotel_types[1];
    _bedTypeLbl.text = _Hotel.hotel_types[2];
    _roomArea.text = _Hotel.hotel_types[3];
    
    NSArray *array = _Hotel.hotel_facilities;
    for(int i = 0;i< array.count;i++){
        if(i == 0){ _parkLbl.text = array[0];}
        if(i == 1){ _pickUpLbl.text = array[1];}
        if(i == 2){ _fitnessLbl.text = array[2];}
        if(i == 3){ _freeProductLbl.text = array[3];}
        if(i == 4){ _luggageLbl.text = array[4];}
        if(i == 5){ _restaurantLbl.text = array[5];}
        if(i == 6){ _freeWifi.text = array[6];}
        if(i == 7){ _wakeUpLbl.text = array[7];}
    }
    
    _checkInTimeLbl.text = _Hotel.remarks[0];
    _leaveTimeLbl.text = _Hotel.remarks[1];
    NSInteger ispet = [_Hotel.is_pet integerValue];
    if(ispet == 0){
        _isCarrayPetLbl.text = @"不可以携带宠物";
    }
    if(ispet == 1){
    _isCarrayPetLbl.text = @"可以携带宠物";
    }
    
}
 */
- (void)netRequest{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"id":@2};
    [RequestAPI requestURL:@"/findHotelById" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        
        if([responseObject[@"result"] integerValue] == 1){
            NSDictionary *content = responseObject[@"content"];
          _Hotel = [[HotelsModel alloc] initWithDetailDict:content];
          //  [self uiLayout];
            
                [self addZLImageViewDisPlayView:_AdImgarr];
         
//            for (NSDictionary *dict in result) {
//                HotelsModel *resultModel = [[HotelsModel alloc] initWithDict:dict];
//                //  NSLog(@"结果：%@",resultModel.hotel_name);
//                //  NSLog(@"距离：%@",resultModel.distance);
//                //  NSLog(@"图片地址：%@",resultModel.hotel_img);
//             //   [_firstResArr addObject:resultModel];
//           }
//            
//         //   [_hotelsTableView reloadData];
//            
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

- (IBAction)startAction:(UIButton *)sender forEvent:(UIEvent *)event {
     flag = 0;
    _superView.hidden = NO;
    _toolBar.hidden = NO;
    _dataPicker.hidden = NO;
    
    
}

- (IBAction)endAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _superView.hidden = NO;
    _toolBar.hidden = NO;
    _dataPicker.hidden = NO;
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _dataPicker.hidden = YES;
    _superView.hidden = YES;
}
- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    if(flag == 0){
    NSDate *date = _dataPicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd";
    NSString *thDate = [formatter stringFromDate:date];
    
    StartTime = [Utilities cTimestampFromString:thDate format:@"MM-dd"];
    
    [_StartDateBtn setTitle:thDate forState:UIControlStateNormal];
    _superView.hidden = YES;
    _toolBar.hidden = YES;
    _dataPicker.hidden = YES;
    }
  if(flag == 1){
    
        NSDate *date = _dataPicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd";
        NSString *thDate = [formatter stringFromDate:date];
        
        EndTime = [Utilities cTimestampFromString:thDate format:@"MM-dd"];
        
        [_endDateBtn setTitle:thDate forState:UIControlStateNormal];
        _superView.hidden = YES;
        _toolBar.hidden = YES;
        _dataPicker.hidden = YES;
    
    }

}

@end
