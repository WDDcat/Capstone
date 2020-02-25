//
//  ViewController.m
//  test
//
//  Created by lu on 2019/3/25.
//  Copyright © 2019 lu. All rights reserved.
//
/*
#import "ViewController.h"
#import "AppDelegate.h"
#import "Friends.h"
#import "friendViewController.h"


@interface ViewController () <AddViewControllerDelegate>
@property(nonatomic,strong) NSArray *friendList;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.friendList = myDelegate.friendsList;

    // Do any additional setup after loading the view, typically from a nib.
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




-(void)setFriendList:(NSArray *)friendList{
    _friendList = friendList;
    [self.tableView reloadData];
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
    
    Friends *news = self.friendList[indexPath.row];
    //NSLog(@"%@？？？%@",news.title,news.detail);
    cell.textLabel.text = [self.friendList[indexPath.row] detail];
    //cell.detailTextLabel.text = [self.friendList[indexPath.row] detail];
    cell.textLabel.numberOfLines=0;  //可多行显示
    cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    

    return cell;
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
*/
