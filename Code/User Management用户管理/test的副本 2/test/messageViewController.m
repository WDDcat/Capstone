//
//  messageViewController.m
//  test
//
//  Created by lu on 2019/4/19.
//  Copyright © 2019 lu. All rights reserved.
//

#import "messageViewController.h"
#import "AppDelegate.h"
#import "HMNews.h"

@interface messageViewController ()
@property(nonatomic,strong) NSArray *friendList;

@end

@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showfriends];
    // Do any additional setup after loading the view.
    //[self.pass addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)showfriends{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *str = @"http://47.92.50.218:8881/api1/friends_request_list";
    
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
        
        if([info isEqualToString:@"当前无好友请求"])
        {}else{
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:100];
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HMNews *news = [HMNews newsWitharray:obj];
                [mArray addObject:news];
            }];
            self.friendList = mArray.copy;
        }
        
        //NSLog(@"%@!!",[self transformDic:dict]);
        
    }];
    //7.执行任务
    [dataTask resume];
    
}
-(void)agree{
    NSURLSession *session = [NSURLSession sharedSession];
    
     AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *str = [NSString stringWithFormat: @"http://47.92.50.218:8881/api1/receive_friend_request?send_id=%@", myDelegate.friend_id1];
    
    
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
        
        NSString *info = dict[@"info"];
        
        if([info isEqualToString:@"好友添加成功"])
        {
            
        }
        
        NSLog(@"%@!!",[self transformDic:dict]);
        
    }];
    //7.执行任务
    [dataTask resume];
}





-(void)setFriendList:(NSArray *)friendList{
    _friendList = friendList;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendList.count;
}


-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"friendrequest";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    //HMNews *news = self.friendList[indexPath.row];
    //NSLog(@"%@？？？%@",news.title,news.detail);
    cell.textLabel.text = [self.friendList[indexPath.row] title];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"同意加为好友" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            //操作
            //NSLog(@"您点击了%@",[self.friendList[indexPath.row] title]);
            AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            NSURLSession *session = [NSURLSession sharedSession];
            
            NSString *str = [NSString stringWithFormat: @"http://47.92.50.218:8881/api1/receive_friend_request?send_id=%@", [self.friendList[indexPath.row] detail]];
            
            
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
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [alertController addAction:noAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });}

@end
