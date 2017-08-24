//
//  loginViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *regeditBtn;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
   
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
//这个方法做导航条的基本属性设置
-(void)naviConfig{
    self.navigationItem.title = @"会员登录";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor =[UIColor blueColor];
    //设置导航栏标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条阿按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航栏左上角创建一个按钮
    UIBarButtonItem *left =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}
//用model的方式返回上一页
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)uiLayout{


}


- (IBAction)loginBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_phoneTextField.text.length  == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    if (_passwordTextField.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle: nil onView:self];
        return;
    }
    if (_passwordTextField.text.length < 6 || _passwordTextField.text.length > 16) {
        [Utilities popUpAlertViewWithMsg:@"您输入的密码应该在6-18位" andTitle:nil onView:self];
        return;
    }if (_phoneTextField.text.length <11) {
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否都是每个字符都是数字
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if ([_phoneTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound||_phoneTextField.text.length<11) {
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号" andTitle:nil onView:self];
        return;
    }
    //无输入异常，开始正式登录接口
    [self networkRequest];
    
}
-(void)networkRequest{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para = @{@"tel":_phoneTextField.text,@"pwd":_passwordTextField.text};
    NSLog(@"参数:%@",para);
    [RequestAPI requestURL:@"/login" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:nil onView:self];
}];
}
//按键盘上的return键收起键盘
-(BOOL)textfieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
@end
