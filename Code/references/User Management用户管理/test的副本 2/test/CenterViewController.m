//
//  CenterViewController.m
//  test
//
//  Created by lu on 2019/3/25.
//  Copyright © 2019 lu. All rights reserved.
//

#import "CenterViewController.h"
#import "AppDelegate.h"


@interface CenterViewController ()<UIActionSheetDelegate>

@end

@implementation CenterViewController



- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self showinfo];
    
    //设置注销按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:(UIBarButtonItemStylePlain) target:self action:@selector(logOut)];
    
    self.navigationItem.rightBarButtonItem = item;
}


//注销按钮的点击事件
-(void)logOut{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"确定要注销？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil,nil];
    [sheet showInView:self.view];
}
//actionSheet的点击事件 buttonIndex：从0开始依次递增
-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (void)showinfo{
    
    NSString *str = @"http://47.92.50.218:8881/api1/show_user_info";
    NSString *strurl = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:strurl];
    
    //创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //发送get请求
    request.HTTPMethod = @"get";
    
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //get请求头
    [request setValue:[NSString stringWithFormat:@"%@", myDelegate.token_id] forHTTPHeaderField:@"token-id"];
    
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //发送请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *user_info = dict[@"user_info"];
        NSString *first_username=user_info[@"real_name"];
        NSString *first_company=user_info[@"institution"];
        NSString *first_position=user_info[@"position"];
        NSString *first_sex=user_info[@"office_phone"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI更新代码
            self.username.text = [NSString stringWithFormat:@"%@",first_username];
            self.company.text = [NSString stringWithFormat:@"%@",first_company];
            self.position.text = [NSString stringWithFormat:@"%@",first_position];
            self.sex.text = [NSString stringWithFormat:@"%@",first_sex];
        });
        
        
        NSLog(@"%@!!",[self transformDic:dict]);
    }];
    //7.执行任务
    [dataTask resume];
    
}

@end



