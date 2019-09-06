//
//  completeinfoController.m
//  test
//
//  Created by lu on 2019/5/2.
//  Copyright © 2019 lu. All rights reserved.
//

#import "completeinfoController.h"
#import "HWOptionButton.h"
#import "AppDelegate.h"

@interface completeinfoController ()<UIPickerViewDelegate,UIDocumentPickerDelegate,HWOptionButtonDelegate>

@property (nonatomic, weak) HWOptionButton *optionButton;

@end

@implementation completeinfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTable];
    [self creatControl];
    
    //监听提交按钮
    [self.info_submit addTarget:self action:@selector(infosubmit) forControlEvents:UIControlEventTouchUpInside];

}

-(void)infosubmit{
    
    AppDelegate *mDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSURL *url=[[NSURL alloc]initWithString:@"http://47.92.50.218:8881/api1/insert_intelligence"];
    
    NSMutableData *postBody=[NSMutableData data];
    
    if(mDelegate.key == TRUE)
    {
        [postBody appendData:[[NSString stringWithFormat:@"t_level=%@&i_issuer=%@&i_place=%@&i_date=%@&regis_amount=%@&i_amount=%@&grading=%@&face_rate=%@&term=%@&guar_way=%@&integral=%@", self.info_level.text,self.info_name.text,_optionButton.title,self.info_data.text,self.info_money.text,self.info_issue.text,self.info_line.text,self.info_interest.text,self.info_deadline.text,self.info_way.text,self.info_grade.text] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    else{
        [postBody appendData:[[NSString stringWithFormat:@"uuid=%@&t_level=%@&i_issuer=%@&i_place=%@&i_date=%@&regis_amount=%@&i_amount=%@&grading=%@&face_rate=%@&term=%@&guar_way=%@&integral=%@",mDelegate.info_uuid, self.info_level.text,self.info_name.text,_optionButton.title,self.info_data.text,self.info_money.text,self.info_issue.text,self.info_line.text,self.info_interest.text,self.info_deadline.text,self.info_way.text,self.info_grade.text] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [request setHTTPMethod: @"POST"];
    
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"%@", mDelegate.token_id] forHTTPHeaderField:@"token-id"];
    
    [request setHTTPBody:postBody];
    
    NSError *error = nil;
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSNumber *ero=result[@"error"];
    
    if([ero isEqualToNumber:[NSNumber numberWithInt:0]]){
        //跳
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

//构造表格
- (void) setTable{
    //画横线
    for(NSInteger i=0;i<12;i++){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 100+i*50, 350, 2.0)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
    }
    //画竖线
    for(NSInteger i=0;i<3;i++){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30+i*175, 100, 2.0, 550)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
    }
    //添加label
    NSArray *array = @[@"发行人",@"发行日期",@"发行场所",@"注册金额",@"发行金额",@"分级",@"票面利率",@"期限",@"担保方式",@"情报等级",@"积分"];
    [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger loc, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, loc*50+75, 130, 100)];
        label.text = obj;
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }];
    
}

- (void)creatControl
{
    HWOptionButton *optionBtn = [[HWOptionButton alloc] initWithFrame:CGRectMake(195, 205, 200, 44)];
    optionBtn.array = @[@"银行间交易商协会", @"上海证券交易所", @"深圳证券交易所", @"北京金融资产交易所"];
    optionBtn.delegate = self;
    optionBtn.showSearchBar = NO;
    [self.view addSubview:optionBtn];
    self.optionButton = optionBtn;
}

@end
