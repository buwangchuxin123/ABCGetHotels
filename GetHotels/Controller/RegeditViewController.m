//
//  RegeditViewController.m
//  GetHotels
//
//  Created by admin001 on 2017/8/24.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "RegeditViewController.h"

@interface RegeditViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
- (IBAction)regeditBtn:(UIButton *)sender forEvent:(UIEvent *)event;
//@property (strong, nonatomic) CLLocationManager *locMgr;
@property (weak, nonatomic) IBOutlet UIButton *regeditBtn;
@property (strong,nonatomic)UIActivityIndicatorView *avi;
@end

@implementation RegeditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//这个方法专门做导航条的控制
- (void)naviConfig{
    
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
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
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)networkRequest{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para = @{@"tel":_phoneTextField.text,@"pwd":_passwordTextField.text};
    NSLog(@"参数:%@",para);
    [RequestAPI requestURL:@"/register" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] ==1) {
            NSLog(@"responseObject:%@", responseObject);
            [Utilities popUpAlertViewWithMsg:@"恭喜你注册成功" andTitle:nil onView:self];
            [self performSegueWithIdentifier:@"RegeditToLogin" sender:self];
        } else{
            [_avi stopAnimating];
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject [@"result"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:@"提示" onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:nil onView:self];
    }];

}
- (IBAction)regeditBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    
    if(_phoneTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    
    if(_passwordTextField.text.length == 0 ){
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self];
        return;
    }
    if(_passwordTextField.text.length < 6 ||_passwordTextField.text.length > 18){
        [Utilities popUpAlertViewWithMsg:@"您输入密码必须在6—18之间" andTitle:@"nil" onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if(_phoneTextField.text.length < 11 || [_phoneTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    if(_confirmPwdTextField.text.length == 0 ){
        [Utilities popUpAlertViewWithMsg:@"请输入确认密码" andTitle:nil onView:self];
        return;
    }
    if(![_passwordTextField.text isEqualToString:_confirmPwdTextField.text]){
        [Utilities popUpAlertViewWithMsg:@"两次密码不一致，请重新输入" andTitle:nil onView:self];
        
        return;
        
    }
    [self networkRequest];
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

@end
