//
//  infomodel.h
//  test
//
//  Created by lu on 2019/5/1.
//  Copyright © 2019 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface infomodel : NSObject
@property(nonatomic,copy) NSArray *comments;
@property(nonatomic,copy) NSString *user_id;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *detail;

+(instancetype)newsWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
