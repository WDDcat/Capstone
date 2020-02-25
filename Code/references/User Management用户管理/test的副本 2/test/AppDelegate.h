//
//  AppDelegate.h
//  test
//
//  Created by lu on 2019/3/25.
//  Copyright © 2019 lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic,strong)NSString *token_id;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) NSArray *commentsinfo;
@property (nonatomic,strong)NSString *info_uuid;

@property (nonatomic,strong)NSString *friend_id1;

@property(nonatomic,strong) NSString *user_id;
@property(nonatomic,strong) NSArray *friendsList;

@property (nonatomic,assign) BOOL *key;
@end



