//
//  completeViewController.m
//  test
//
//  Created by lu on 2019/3/31.
//  Copyright © 2019 lu. All rights reserved.
//

#import "completeViewController.h"
#import "HWOptionButton.h"
#import "AppDelegate.h"


@interface completeViewController ()<UIPickerViewDelegate,UIDocumentPickerDelegate,HWOptionButtonDelegate>
//@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) HWOptionButton *optionButton1;
@property (nonatomic, weak) HWOptionButton *optionButton2;
@end

@implementation completeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTable];
    //监听提交按钮
    [self.subinfo addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];

    [self creatControl1];
    [self creatControl2];

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
        
    NSURL *url=[[NSURL alloc]initWithString:@"http://47.92.50.218:8881/api1/personal_information"];
    
    NSMutableData *postBody=[NSMutableData data];
    
    [postBody appendData:[[NSString stringWithFormat:@"real_name=%@&institution=%@&department=%@&position=%@&responsibility=%@&office_phone=%@&email=%@", self.username.text,self.jigou.text,_optionButton1.title,_optionButton2.title,self.job.text,self.office.text,self.Emile.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [request setHTTPMethod: @"POST"];
    
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    AppDelegate *mDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [request setValue:[NSString stringWithFormat:@"%@", mDelegate.token_id] forHTTPHeaderField:@"token-id"];
    
    [request setHTTPBody:postBody];
    
    NSError *error = nil;
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"%@",[self transformDic:result]);
    NSNumber *ero=result[@"error"];
    
    if([ero isEqualToNumber:[NSNumber numberWithInt:0]]){
        //跳
        [self performSegueWithIdentifier:@"complete2first" sender:nil];
    }
}
//构造表格
- (void) setTable{
    //画横线
    for(NSInteger i=0;i<8;i++){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 100+i*50, 350, 2.0)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
    }
    //画竖线
    for(NSInteger i=0;i<3;i++){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30+i*175, 100, 2.0, 350)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
    }
    //添加label
    NSArray *array = @[@"姓名",@"金融机构",@"部门",@"职位",@"工作职责",@"办公电话",@"邮件"];
    [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger loc, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, loc*50+75, 130, 100)];
        label.text = obj;
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }];
    
}

- (void)creatControl1
{
    HWOptionButton *optionBtn1 = [[HWOptionButton alloc] initWithFrame:CGRectMake(195, 205, 200, 44)];
    optionBtn1.array = @[@"金融市场部", @"资产管理部", @"投资银行部", @"公司业务部", @"国际业务部", @"战略客户部"];
    optionBtn1.delegate = self;
    optionBtn1.showSearchBar = NO;
    [self.view addSubview:optionBtn1];
    self.optionButton1 = optionBtn1;
    
}

- (void)creatControl2
{
    HWOptionButton *optionBtn2 = [[HWOptionButton alloc] initWithFrame:CGRectMake(195, 255, 200, 44)];
    optionBtn2.array = @[@"总经理", @"副总经理", @"处长", @"副处长", @"行长", @"副行长",@"客户经理",@"经理",@"高级经理",@"副董事",@"董事",@"执行董事",@"董事总经理"];
    optionBtn2.delegate = self;
    optionBtn2.showSearchBar = NO;
    [self.view addSubview:optionBtn2];
    self.optionButton2 = optionBtn2;
    
}


@end
