//
//  CommentsController.m
//  test
//
//  Created by lu on 2019/5/2.
//  Copyright © 2019 lu. All rights reserved.
//

#import "CommentsController.h"
#import "AppDelegate.h"
#import "commentsmodel.h"

@interface CommentsController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UITextField *input;

@property(nonatomic,strong) NSArray *list;

@end


@implementation CommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self getinformation];
    
    [self.textfiled addTarget:self action:@selector(textChange) forControlEvents:(UIControlEventEditingChanged)];
    
    [self.send addTarget:self action:@selector(sendmessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fix_info addTarget:self action:@selector(tofix) forControlEvents:UIControlEventTouchUpInside];


    [self.addcomments addTarget:self action:@selector(addinfo) forControlEvents:UIControlEventTouchUpInside];

    //cell不可选中
    self.table.allowsSelection = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

-(void)addinfo{
    self.addview.hidden = NO;
}

-(void)tofix{
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    myDelegate.key = FALSE;
}


-(void)sendmessage{
    
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSURL *url=[[NSURL alloc]initWithString:@"http://47.92.50.218:8881/api1/comment_intelligence"];
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"uuid=%@&content=%@", myDelegate.info_uuid, self.textfiled.text] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@!!%@",myDelegate.info_uuid,self.textfiled.text);
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    NSError *error = nil;
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@!!",[self transformDic:result]);
    NSNumber *ero=result[@"error"];
    
    if([ero isEqualToNumber:[NSNumber numberWithInt:0]]){
        //跳
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });
        if(self.textfiled.text.length > 0)
            self.textfiled.text = nil;
    }
}


-(void)KeyboardDidChangeFrame:(NSNotification *)noti
{
 
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
    self.addview.hidden = YES;
}
/*
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
    [request setValue:[NSString stringWithFormat:@"%@", myDelegate.token_id] forHTTPHeaderField:@"token-id"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *ero = dict[@"error"];
        NSArray *array1 = dict[@"intelligence_info"];
        NSDictionary *array2 = array1[0];
        NSArray *array = array2[@"comments"];
        
       // NSLog(@"%@???",array);
        
       // NSLog(@"%@!!",[self transformDic:dict]);
        
        if([ero isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:100];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                commentsmodel  *news = [commentsmodel newsWithDic:obj];
                [mArray addObject:news];
            }];
            self.list =mArray.copy;
           // NSLog(@"%@",self.list);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
            });
        }
    }];
    
    //7.执行任务
    [dataTask resume];
}
*/

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
   
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return myDelegate.commentsinfo.count;
}





-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:100];
    NSLog(@"%@",myDelegate.commentsinfo);
    [myDelegate.commentsinfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        commentsmodel  *news = [commentsmodel newsWithDic:obj];
        [mArray addObject:news];
    }];
    self.list =mArray.copy;
    
    static NSString *reuseId = @"comment";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.textLabel.text = [self.list[indexPath.row] comment_text];
    cell.textLabel.numberOfLines=0;  //可多行显示
    cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    return cell;
}

-(void)textChange{
    self.send.enabled = self.textfiled.text.length > 0 ;
}



@end

