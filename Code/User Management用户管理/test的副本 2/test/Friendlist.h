//
//  Friendlist.h
//  test
//
//  Created by lu on 2019/4/24.
//  Copyright © 2019 lu. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface Friendlist : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *user_id;

+(instancetype)newsWitharray:(NSArray *)dic;

@end
NS_ASSUME_NONNULL_END


