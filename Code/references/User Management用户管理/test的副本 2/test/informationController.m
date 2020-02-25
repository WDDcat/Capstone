//
//  informationController.m
//  test
//
//  Created by lu on 2019/5/1.
//  Copyright © 2019 lu. All rights reserved.
//

#import "informationController.h"
#import "AppDelegate.h"
#import "infomodel.h"

@interface informationController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *infolist;

@end

@implementation informationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getinformation];

     [self.add_info addTarget:self action:@selector(toadd) forControlEvents:UIControlEventTouchUpInside];
}

-(void)toadd{
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    myDelegate.key = TRUE;
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

-(void)getinformation{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *str = @"http://47.92.50.218:8881/api1/get_intelligence";
    
    NSString *strurl = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:strurl];
    
    //创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //发送post请求
    request.HTTPMethod = @"get";
    
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //get请求头
    //[request setValue:[NSString stringWithFormat:@"%@", myDelegate.token_id] forHTTPHeaderField:@"token-id"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *ero = dict[@"error"];
        NSArray *array = dict[@"intelligence_info"];
        
        NSLog(@"%@!!",[self transformDic:dict]);
        
        if([ero isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:100];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                infomodel  *news = [infomodel newsWithDic:obj];
                [mArray addObject:news];
            }];
            self.infolist =mArray.copy;
            NSLog(@"%@",self.infolist);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.infotable reloadData];
            });
        }
    }];
         
    //7.执行任务
    [dataTask resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infolist.count;
}

-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"info";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.textLabel.text = [self.infolist[indexPath.row] detail];
    cell.textLabel.numberOfLines=0;  //可多行显示
    cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    myDelegate.info_uuid = [self.infolist[indexPath.row] uuid];
    myDelegate.commentsinfo = [self.infolist[indexPath.row] comments];
}

@end
