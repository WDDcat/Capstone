//
//  showTableViewController.m
//  test
//
//  Created by lu on 2019/4/20.
//  Copyright © 2019 lu. All rights reserved.
//

#import "chatTableViewController.h"
#import "AppDelegate.h"
#import "Friendlist.h"


@interface chatTableViewController() <UIActionSheetDelegate>

@property(nonatomic,strong) NSArray *friliat;

@end

@implementation chatTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self showfriend];
    

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




- (void)showfriend{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *str = @"http://47.92.50.218:8881/api1/friends_list";
    
    NSString *strurl = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:strurl];
    
    //创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //发送post请求
    request.HTTPMethod = @"get";
    
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //get请求头
    [request setValue:[NSString stringWithFormat:@"%@", myDelegate.token_id] forHTTPHeaderField:@"token-id"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *info = dict[@"info"];
        NSArray *array = dict[@"request_list"];
        
        if([info isEqualToString:@"当前无好友"])
        {}else{
            
           // NSArray *array = dict[@"request_list"];
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:100];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Friendlist  *news = [Friendlist newsWitharray:obj];
                [mArray addObject:news];
            }];
            self.friliat =mArray.copy;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            myDelegate.friendsList = mArray.copy;
            //NSLog(@"%@?????",myDelegate.friendsList);
            });
            
        }
        
    }];
    //7.执行任务
    [dataTask resume];
    
}
-(void)setFriliat:(NSArray *)friliat{
    _friliat = friliat;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friliat.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    myDelegate.user_id = [myDelegate.friendsList[indexPath.row]user_id];
   // NSLog(@"%@!!%@",myDelegate.user_id,myDelegate.token_id);
}

-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"chat";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    Friendlist *news = self.friliat[indexPath.row];
    cell.textLabel.text = news.title;
    return cell;
}



@end
