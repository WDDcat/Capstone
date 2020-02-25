//
//  ViewController.m
//  Business_opportunity
//
//  Created by fukaixin10 on 2019/4/18.
//  Copyright © 2019 Mantis group. All rights reserved.
//

#import "ViewController.h"
#import "OppCell.h"


#define BaseUrl  @"http://47.92.50.218:8881/api1/business_opportunity?c_id=918551a38b7bb58df883e8df0f156ed4&first_level_name=%@"



@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic) NSArray *opportunity_info;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _token = @"bc53a938667111e9badc00163e02e9cd";
//    _first_level_name = @"additional_financing_chance";
    [self getInfos];
    
}


- (void)getInfos {
    NSString *targetUrl = [NSString stringWithFormat: BaseUrl, _first_level_name];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:targetUrl]];
    [request setHTTPMethod:@"GET"];
    [request addValue:self.token forHTTPHeaderField:@"token-id"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField: @"Accept"];
    
    NSLog(@"%@", request.allHTTPHeaderFields);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,  NSURLResponse * _Nullable response, NSError * _Nullable error) {
          
        NSError *erro = nil;
          if (data!=nil) {
              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&erro ];
              if (json.count > 0) {
                  //self.opportunity_info = json[@"opportunity_info"];
                  self.opportunity_info = [json[@"opportunity_info"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
                      return [object[@"datas"] count] != 0 || [object[@"table_list"] count] != 0;  // Return YES for each object you want in filteredArray.
                  }]];
              }
          }
          dispatch_sync(dispatch_get_main_queue(),^{
              
              [self.table reloadData];
          });
          NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSLog(@"Data received: %@", myString);
      }] resume];
}



//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _opportunity_info.count;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [OppCell heightForCell:_opportunity_info[indexPath.row]];
}


//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OppCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"OppCell"];
    if (cell == nil) {
        cell = [[OppCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"OppCell"];
    }
    
    
    cell.info = _opportunity_info[indexPath.row];
    return cell;
}



@end


