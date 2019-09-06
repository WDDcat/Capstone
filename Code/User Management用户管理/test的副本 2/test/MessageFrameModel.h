//
//  MessageFrameModel.h
//  test
//
//  Created by lu on 2019/4/30.
//  Copyright © 2019 lu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MessageModel;
@interface MessageFrameModel : NSObject


@property(nonatomic,assign)Rect *textViewF;

@property(nonatomic,assign)Rect *timeF;

@property(nonatomic,assign)Rect *iconF;

@property(nonatomic,assign)float *cellH;
//数据模型
@property(nonatomic,strong)MessageModel *message;

@end

NS_ASSUME_NONNULL_END
