//
//  chatpageViewController.m
//  test
//
//  Created by lu on 2019/4/30.
//  Copyright © 2019 lu. All rights reserved.
//

#import "chatpageViewController.h"
#import "AppDelegate.h"
#import "MessageModel.h"
#import "mymodel.h"

@interface chatpageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *messages;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UITextField *input;


@property(nonatomic,strong) NSArray *mymessage;

@end

@implementation chatpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMessage];
   
    [self.textfiled addTarget:self action:@selector(textChange) forControlEvents:(UIControlEventEditingChanged)];
    
    [self.send addTarget:self action:@selector(sendmessage) forControlEvents:UIControlEventTouchUpInside];
    
    //cell不可选中
    self.table.allowsSelection = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // Do any additional setup after loading the view.
}
/*
2019-04-30 21:44:27.627646+0800 test[7689:297428] -----{
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.25";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {414, 346}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {207, 1040}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {207, 723}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 896}, {414, 288}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 550}, {414, 346}}";
    UIKeyboardIsLocalUserInfoKey = 1;
}
2019-04-30 21:44:29.297408+0800 test[7689:297428] -----{
    UIKeyboardAnimationCurveUserInfoKey = 7;
    UIKeyboardAnimationDurationUserInfoKey = "0.25";
    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {414, 346}}";
    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {207, 723}";
    UIKeyboardCenterEndUserInfoKey = "NSPoint: {207, 1069}";
    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 550}, {414, 346}}";
    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 896}, {414, 346}}";
    UIKeyboardIsLocalUserInfoKey = 1;
}
*/
-(void)sendmessage{
    
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSURL *url=[[NSURL alloc]initWithString:@"http://47.92.50.218:8881/api1/send_friends_message"];
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"rec_id=%@&content=%@", myDelegate.user_id, self.textfiled.text] dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    NSError *error = nil;
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    
    NSNumber *ero=result[@"error"];
    
    if([ero isEqualToNumber:[NSNumber numberWithInt:0]]){
        //跳
        [self getMessage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });
        if(self.textfiled.text.length > 0)
            self.textfiled.text = nil;
    }
}


-(void)KeyboardDidChangeFrame:(NSNotification *)noti
{
    //NSLog(@"-----%@",noti.userInfo);
    //键盘改变时 改变window颜色
    self.view.window.backgroundColor = self.table.backgroundColor;
    
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //键盘实时的y
    CGFloat keyY = frame.origin.y;
    
    CGFloat keyDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat screemH = [[UIScreen mainScreen]bounds].size.height;
    
    [UIView animateWithDuration:keyDuration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyY - screemH);
    }];
}

//滚动时 收回键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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


#pragma mark - Table view data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mymessage.count;
}

-(NSMutableArray *)messages{
    if(_messages == nil){
    }
    return _messages;
}
-(void)getMessage{
    
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *str = [NSString stringWithFormat: @"http://47.92.50.218:8881/api1/receive_friends_message?send_id=%@", myDelegate.user_id];
    
    
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
        
        NSNumber *ero = dict[@"error"];
        NSArray *friend_array = dict[@"friend_message_list"];
        NSArray *me_array = dict[@"me_message_list"];
        
        
         if([ero isEqualToNumber:[NSNumber numberWithInt:0]])
         {
         
         NSMutableArray *fArray = [NSMutableArray arrayWithCapacity:100];
         [friend_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         MessageModel *news = [MessageModel newsWitharray:obj];
         [fArray addObject:news];
         }];
         [me_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         mymodel *news = [mymodel newsWitharray:obj];
         [fArray addObject:news];
         }];
         self.mymessage=fArray.copy;
             
             
         dispatch_async(dispatch_get_main_queue(), ^{
         [self.table reloadData];
         });
         
         }
    }];
    //7.执行任务
    [dataTask resume];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     /*
    for(id ob in self.mymessage)
    {
        NSLog(@"my %@",ob);
    }
    */
    static NSString *reuseId = @"message";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = [self.mymessage[indexPath.row] message];
    //cell.detailTextLabel.text = [self.mymessage[indexPath.row] time];
    cell.textLabel.numberOfLines=0;  //可多行显示
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    return cell;
}

-(void)textChange{
    self.send.enabled = self.textfiled.text.length > 0 ;
}



@end
