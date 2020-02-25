//
//  MessageModel.h
//  test
//
//  Created by lu on 2019/4/30.
//  Copyright © 2019 lu. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

@property(nonatomic,copy) NSString *name;

@property(nonatomic,copy) NSString *time;

@property(nonatomic,copy) NSString *message;
 

+(instancetype)newsWitharray:(NSArray *)dic;

@end

NS_ASSUME_NONNULL_END

