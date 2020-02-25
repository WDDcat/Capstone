//
//  friendViewController.m
//  test
//
//  Created by lu on 2019/4/18.
//  Copyright © 2019 lu. All rights reserved.
//

#import "friendViewController.h"
#import "AppDelegate.h"
#import "Friends.h"

@interface friendViewController ()<UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic,strong) NSArray *friendList;

@end

@implementation friendViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    [self.dosearch addTarget:self action:@selector(getuser) forControlEvents:UIControlEventTouchUpInside];
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


- (void)getuser{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *str = [NSString stringWithFormat: @"http://47.92.50.218:8881/api1/search_users?department=%@", self.search.text];
    
    
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
        
        NSNumber *ero = dict[@"error"];
        NSArray *array = dict[@"select_list"];
        
        NSLog(@"%@!!",[self transformDic:dict]);
    
        if([ero isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:100];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Friends *news = [Friends newsWitharray:obj];
            [mArray addObject:news];
            }];
            self.friendList =mArray.copy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
            });
        }
    }];
    //7.执行任务
    [dataTask resume];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendList.count;
}


-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"friends";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    //Friends *news = self.friendList[indexPath.row];
    //NSLog(@"%@？？？%@",news.title,news.detail);
    cell.textLabel.text = [self.friendList[indexPath.row] detail];
    //cell.detailTextLabel.text = [self.friendList[indexPath.row] detail];
    cell.textLabel.numberOfLines=0;  //可多行显示
    cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    
    return cell;
}
//滚动时 收回键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"加为好友" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            //操作
            //NSLog(@"您点击了%@",[self.friendList[indexPath.row] title]);
            AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            NSURLSession *session = [NSURLSession sharedSession];
            
            NSString *str = [NSString stringWithFormat: @"http://47.92.50.218:8881/api1/send_friend_request?rec_id=%@", [self.friendList[indexPath.row] title]];
            
            
            NSString *strurl = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *url = [NSURL URLWithString:strurl];
            
            //创建可变的请求对象
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            //发送post请求
            request.HTTPMethod = @"get";
            
            
            //get请求头
            [request setValue:[NSString stringWithFormat:@"%@", myDelegate.token_id] forHTTPHeaderField:@"token-id"];
            
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@!!",[self transformDic:dict]);
            }];
            [dataTask resume];
        }];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [alertController addAction:noAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });}
@end

