//
//  LoginViewController.m
//  test
//
//  Created by lu on 2019/3/25.
//  Copyright © 2019 lu. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //监听文本框
    [self.usernameField addTarget:self action:@selector(textChange) forControlEvents:(UIControlEventEditingChanged)];
    [self.passwordField addTarget:self action:@selector(textChange) forControlEvents:(UIControlEventEditingChanged)];
    //监听登陆按钮
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
}

//弹出键盘 若模拟器没弹出，command+k即可
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];}

- (NSString *)transformDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =[[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 =[tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =[[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}
//登陆按钮的点击事件
-(void)login{
    
    NSURL *url=[[NSURL alloc]initWithString:@"http://47.92.50.218:8881/api1/login"];
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"mobile=%@&pwd=%@", self.usernameField.text, self.passwordField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    NSError *error = nil;
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"%@",[self transformDic:result]);
    NSNumber *ero=result[@"error"];
    
    if([ero isEqualToNumber:[NSNumber numberWithInt:0]]){
        
        //对全局变量赋值
        AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        myDelegate.token_id = result[@"token_id"];
        
        //NSLog(@"token_id:%@",myDelegate.token_id);
        [self performSegueWithIdentifier:@"login2center" sender:nil];
    }else{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号或密码错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

//文本框内容发生改变的时候调用
-(void)textChange{
    self.loginButton.enabled = self.usernameField.text.length > 0 && self.passwordField.text.length > 0;
}


@end
