//
//  DetailViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
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

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
