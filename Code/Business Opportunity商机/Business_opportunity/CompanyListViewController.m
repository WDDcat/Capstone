//
//  CompanyListViewController.m
//  Business_opportunity
//
//  Created by fukaixin10 on 2019/5/2.
//  Copyright © 2019 Mantis group. All rights reserved.
//

#import "CompanyListViewController.h"
#import "OpportunityIndexViewController.h"

#define CompListBaseUrl  @"http://47.92.50.218:8881/api1/companylist"

@interface CompanyListViewController () <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (nonatomic) NSArray *list;

@property (nonatomic) NSArray *searchList;

@property BOOL searching;

@end

@implementation CompanyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司";
    [self getList];
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
}

- (void)getList {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:CompListBaseUrl]];
    [request setHTTPMethod:@"GET"];
    //[request addValue:self.token forHTTPHeaderField:@"token-id"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField: @"Accept"];
    
    NSLog(@"%@", request.allHTTPHeaderFields);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,  NSURLResponse * _Nullable response, NSError * _Nullable error) {
          
          NSError *erro = nil;
          if (data!=nil) {
              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&erro ];
              if (json.count > 0) {
                  self.list = json[@"list"];
              }
          }
          dispatch_sync(dispatch_get_main_queue(),^{
              
              [self.tableView reloadData];
          });
          NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSLog(@"Data received: %@", myString);
      }] resume];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OpportunityIndexViewController *vc =  (OpportunityIndexViewController *)[ self.storyboard instantiateViewControllerWithIdentifier:@"OpportunityIndexViewController"];
    NSDictionary *info;
    if (_searching) {
        info = _searchList[indexPath.row];
    } else {
        info = _list[indexPath.row];
    }
    vc.c_id = info[@"c_id"];;
//    vc.token = weakSelf.token;
    vc.title  = info[@"name"];
    [self.navigationController pushViewController:vc animated: YES];
}

//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _searching ? _searchList.count : _list.count;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    if (_searching) {
        cell.textLabel.text = _searchList[indexPath.row][@"name"];
    } else {
        cell.textLabel.text = _list[indexPath.row][@"name"];
    }
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        self.searchList = [_list filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
            return [object[@"name"] rangeOfString:searchText].location != NSNotFound ;  
        }]];
        _searching = YES; // activates the searching characteristics of the app
        [_tableView reloadData];
    } else {
        self.searchList = @[];
        _searching = NO; // activates the searching characteristics of the app
        [_tableView reloadData];
    }

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    for (id cencelButton in [searchBar.subviews[0] subviews]) {
        if([cencelButton isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor: UIColor.blackColor forState:UIControlStateNormal];
        }
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searching = NO;
    self.searchList = @[];
    searchBar.text = @"";
    [_tableView reloadData];
}

@end
