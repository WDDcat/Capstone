//
//  HMNews.h
//  test
//
//  Created by lu on 2019/4/20.
//  Copyright © 2019 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMNews : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *detail;


+(instancetype)newsWitharray:(NSArray *)dic;

@end

NS_ASSUME_NONNULL_END
