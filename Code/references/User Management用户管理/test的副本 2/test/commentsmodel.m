//
//  commentsmodel.m
//  test
//
//  Created by lu on 2019/5/2.
//  Copyright © 2019 lu. All rights reserved.
//

#import "commentsmodel.h"

@implementation commentsmodel
+(instancetype)newsWithDic:(NSDictionary *)dic{
    commentsmodel *news = [self new];
    news.comment_text = [NSString stringWithFormat:@"评论内容：%@\n                                     %@",dic[@"comment"],dic[@"comment_time"]];
    return news;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(NSString *) description{
    return [NSString stringWithFormat:@"%@{detail:%@,}",[super description],self.comment_text];
}

@end
