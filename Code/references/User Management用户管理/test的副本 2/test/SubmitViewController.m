//
//  SubmitViewController.m
//  test
//
//  Created by lu on 2019/3/25.
//  Copyright © 2019 lu. All rights reserved.
//

#import "SubmitViewController.h"
#import "AppDelegate.h"
#import <AFNetworking.h>


@interface SubmitViewController ()
@property (strong, nonatomic) IBOutlet UITextField *mobileField;
@property (strong, nonatomic) IBOutlet UITextField *keyField;
@property (strong, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *repasswordField;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *getmessage;
@end

@implementation SubmitViewController

-(void)tips:(NSString *)str{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",str] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self Read_ImageData];
    //监听文本框
    [self.mobileField addTarget:self action:@selector(textChange) forControlEvents:(UIControlEventEditingChanged)];
    [self.keyField addTarget:self action:@selector(textChange) forControlEvents:(UIControlEventEditingChanged)];
    [self.messageField addTarget:self action:@selector(textChange) forControlEvents:(UIControlEventEditingChanged)];
    [self.passwordField addTarget:self action:@selector(textChange) forControlEvents:(UIControlEventEditingChanged)];
    [self.repasswordField addTarget:self action:@selector(textChange) forControlEvents:(UIControlEventEditingChanged)];
    //监听登陆按钮
    [self.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    //监听短信验证码按钮
    [self.getmessage addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    //监听图片验证码按钮
    [self.renew addTarget:self action:@selector(Read_ImageData) forControlEvents:UIControlEventTouchUpInside];
    
}



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


//提交按钮的点击事件
-(void)submit{
    
    bool que = [self.passwordField.text isEqualToString:self.repasswordField.text];
    if(!que){
        [self tips:@"密码输入不一致"];
    }else{
    
    //获得网址名称存入url
    NSURL *url=[[NSURL alloc]initWithString:@"http://47.92.50.218:8881/api1/register"];
    
    NSMutableData *postBody=[NSMutableData data];
    
    [postBody appendData:[[NSString stringWithFormat:@"mobile=%@&pwd=%@&message_code=%@", self.mobileField.text, self.passwordField.text,self.messageField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [request setHTTPMethod: @"POST"];
    
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postBody];
    
    NSError *error = nil;
    
    NSHTTPURLResponse* urlResponse = nil;
        
    
    
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];

    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    
    NSNumber *ero = result[@"error"];
    
    if([ero isEqualToNumber:[NSNumber numberWithInt:0]]){
        AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        myDelegate.token_id = result[@"token_id"];
        NSLog(@"token_id:%@",myDelegate.token_id);
        //跳
        [self performSegueWithIdentifier:@"submit2complete" sender:nil];
    }else{
        [self tips:@"注册失败"];
        [self performSelector:@selector(Read_ImageData)];
    }
    NSLog(@"%@",[self transformDic:result]);
    }
    
}

//文本框内容发生改变的时候调用
-(void)textChange{
    self.submitButton.enabled = self.mobileField.text.length > 0 && self.keyField.text.length > 0 && self.messageField.text.length > 0 && self.passwordField.text.length > 0 && self.repasswordField.text.length > 0;
}

//弹出键盘 若模拟器没弹出，command+k即可
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];}

//短信验证码按钮事件
-(void)get{
    
    NSURL *url=[[NSURL alloc]initWithString:@"http://47.92.50.218:8881/api1/message_code"];
    
    NSMutableData *postBody=[NSMutableData data];
    
    [postBody appendData:[[NSString stringWithFormat:@"mobile=%@&img_code=%@", self.mobileField.text, self.keyField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [request setHTTPMethod: @"POST"];
    
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postBody];
    
    NSError *error = nil;
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];

    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSNumber *ero=result[@"error"];
    
    if([ero isEqualToNumber:[NSNumber numberWithInt:505]]){
        [self tips:@"该用户已注册"];
    }
    BOOL a = [ero isEqualToNumber:[NSNumber numberWithInt:502]];
    if(a || self.mobileField.text.length < 11 ){
        [self tips:@"手机号码或图形验证码错误"];
    }
    
    BOOL b = [ero isEqualToNumber:[NSNumber numberWithInt:0]];
   // NSLog(@"%@!!!",[self transformDic:result]);
    
    __block NSInteger time = 59; //倒计时时间
    NSInteger len = self.mobileField.text.length;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0 || !b || len < 11){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.getmessage setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.getmessage setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                self.getmessage.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.getmessage setTitle:[NSString stringWithFormat:@"重新发送(%.2ds)", seconds] forState:UIControlStateNormal];
                [self.getmessage setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                self.getmessage.userInteractionEnabled = NO;
            });
            time--; }
    });
    dispatch_resume(_timer);
    
}

//图片验证码
-(void)Read_ImageData
{
    NSString *urlString = @"http://47.92.50.218:8881/api1/img_code";
    
    //1.创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //3.设置接受的响应数据类型
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    //做get请求
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.picture.image = responseObject;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}


@end

