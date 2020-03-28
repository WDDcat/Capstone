//
//  OpportunityIndexViewController.m
//  Business_opportunity
//
//  Created by fukaixin10 on 2019/4/26.
//  Copyright © 2019 Mantis group. All rights reserved.
//

#import "OpportunityIndexViewController.h"
#import "OpportunityCell.h"
#import "ViewController.h"
#import "PDFPreviewViewController.h"

#define OppoBaseUrl  @"http://47.92.50.218:8881/api1/opportunity_abstract?c_id=%@"

#define PDFUrl @"http://47.92.50.218:8881/api1/get_opportunity_pdf?c_id=%@&type=pdf"

#define First_level_name_with_Str @{@"增量融资机会": @"additional_financing_chance", @"存量融资机会": @"existing_financing_chance", @"成本优化机会": @"cost_optimization_chance", @"期限优化机会": @"commitment_optimization_chance", @"财报结构优化机会": @"financial_structure_optimization_chance"}



@interface OpportunityIndexViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic) NSArray *opportunity_info;


@end

@implementation OpportunityIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _token = @"7c585ac67d6a11e9ac9700163e02e9cd";
    
    self.table.estimatedRowHeight = 100;
    self.table.rowHeight = UITableViewAutomaticDimension;
    
    [self getInfos];
}

- (void)getInfos {
    
    NSString *url = [NSString stringWithFormat:OppoBaseUrl, _c_id];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    //访问方式为get
    [request setHTTPMethod:@"GET"];
    //包头加入token-id
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
                  self.opportunity_info = json[@"abstract_info"];
//                  self.opportunity_info = [json[@"abstract_info"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
//                      return [object[@"contents"] count] != 0;  // Return YES for each object you want in filteredArray.
//                  }]];
              }
          }
          dispatch_sync(dispatch_get_main_queue(),^{
              
              [self.table reloadData];
          });
          NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSLog(@"Data received: %@", myString);
      }] resume];
}

- (void)downloadPDF {
    NSString *targetUrl = [NSString stringWithFormat: PDFUrl, _c_id];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:targetUrl]];
    [request setHTTPMethod:@"GET"];
    [request addValue:self.token forHTTPHeaderField:@"token-id"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"%@", request.allHTTPHeaderFields);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,  NSURLResponse * _Nullable response, NSError * _Nullable error) {
          
          if (data!=nil) {
              //  二进制流写入文件
              NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
              NSFileManager *fileManger = [NSFileManager defaultManager];
              NSString *testDirectory = [documentsDirectory stringByAppendingString:@"/PDF"];

              //  创建目录
              [fileManger createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
              //  创建文件
              NSString *testPath = [testDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.pdf", self.title]];
              //  写入文件
              
              [fileManger createFileAtPath:testPath contents:data attributes:nil];
              
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [self openPDF];
              });
              
          }
      }] resume];
}

- (void)openPDF {
    PDFPreviewViewController *vc =  (PDFPreviewViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"PDFPreviewViewController"];
    vc.c_id = self.c_id;
    vc.title  = @"";
    [self.navigationController pushViewController:vc animated: YES];
}

//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _opportunity_info.count;
}

//设置cell的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [OpportunityCell heightForCell:_opportunity_info[indexPath.row]];
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    btn.frame = CGRectMake(0, 0, 160, 40);
    btn.center = view.center;
    [btn setTitle:@"生成PDF"  forState:UIControlStateNormal];
    [btn setTitleColor: UIColor.blackColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(downloadPDF) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}


//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OpportunityCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"OpportunityCell"];
    if (cell == nil) {
        cell = [[OpportunityCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"OpportunityCell"];
    }
    
    __weak OpportunityIndexViewController *weakSelf = self;
    cell.block = ^(OpportunityCell * _Nonnull cell) {
        int index = [weakSelf.table indexPathForCell:cell].row ;  
        ViewController *vc =  (ViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        NSString *level = weakSelf.opportunity_info[index][@"first_level_desc"];
        vc.first_level_name = First_level_name_with_Str[level];
        vc.token = weakSelf.token;
        vc.title  = level;
        [self.navigationController pushViewController:vc animated: YES];
    };
    
    cell.info = _opportunity_info[indexPath.row];
    return cell;
}

@end
