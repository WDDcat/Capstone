//
//  commentsmodel.h
//  test
//
//  Created by lu on 2019/5/2.
//  Copyright © 2019 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface commentsmodel : NSObject


@property(nonatomic,copy) NSString *comment_text;


+(instancetype)newsWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
