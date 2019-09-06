//
//  HMNews.m
//  test
//
//  Created by lu on 2019/4/20.
//  Copyright © 2019 lu. All rights reserved.
//

#import "HMNews.h"

@implementation HMNews

+(instancetype)newsWitharray:(NSArray *)dic{
    HMNews *news = [self new];
    news.title = dic[0];
    news.detail = dic[1];
    return news;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(NSString *) description{
    return [NSString stringWithFormat:@"%@{title:%@,detail:%@}",[super description],self.title,self.detail];
}
@end
