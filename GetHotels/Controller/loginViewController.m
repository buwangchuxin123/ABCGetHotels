//
//  loginViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "loginViewController.h"
#import "UserModel.h"
@interface loginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
- (IBAction)loginBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;


@property (strong, nonatomic) UIActivityIndicatorView *avi;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self uiLayout];
    _loginBtn.enabled = NO;
    [self setShadow];
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
- (void)setShadow {
    
    _shadowImageView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _shadowImageView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _shadowImageView.layer.shadowOpacity = 0.7f;//阴影透明度，默认0
    _shadowImageView.layer.shadowRadius = 4.f;//阴影半径，默认3
}

//这个方法做导航条的基本属性设置
-(void)naviConfig{
    self.navigationItem.title = @"会员登录";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(23, 124, 236);
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
    if (![[Utilities getUserDefaults:@"nick_name"]isKindOfClass:[NSNull class]]) {
        if ([Utilities getUserDefaults:@"nick_name"]!=nil) {
            //将它显示在用户名输入框
            _phoneTextField.text = [Utilities getUserDefaults:@"nick_name"];
        }
    }
    //添加事件监听当输入框的内容改变时调用textChange:方法
    [_phoneTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_passwordTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
}
//输入框内容改变的监听事件
- (void)textChange: (UITextField *)textField{
    //当文本框中的内容改变时判断内容长度是否为0，是：禁用按钮   否：启用按钮
    if (_phoneTextField.text.length != 0 && _passwordTextField.text.length != 0) {
        _loginBtn.enabled = YES;
        _loginBtn.backgroundColor = UIColorFromRGB(99, 163, 210);
    }else{
        _loginBtn.enabled = NO;
        _loginBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    }
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
 
    [RequestAPI requestURL:@"/login" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
         [_avi stopAnimating];
        NSLog(@"LOGIN=%@",responseObject);
        if([responseObject[@"result"] integerValue]==1){
            NSDictionary *result = responseObject[@"content"];
            UserModel *user = [[UserModel alloc]initWithDictionary:result];
            //将登录获取到用户信息打包存储到单例化全局变量中
            [[StorageMgr singletonStorageMgr]addKey:@"UserInfo" andValue:user];
            //单独将用户的ID也存储进单例化全局变量来作为用户是否已经登录的判断依据，同时也方便其他所有页面跟快捷的是用用户ID这个参数
            [[StorageMgr singletonStorageMgr]addKey:@"MemberId" andValue:user.MemberId];
            //如果键盘还打开着让它收起
            [self.view endEditing:YES];
            //清空密码输入框的内容
            _passwordTextField.text = @"";
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:_passwordTextField.text];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"result"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:@"提示" onView:self];
        }

            
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
