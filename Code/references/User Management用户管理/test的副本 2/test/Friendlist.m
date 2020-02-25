//
//  Friendlist.m
//  test
//
//  Created by lu on 2019/4/24.
//  Copyright © 2019 lu. All rights reserved.
//

#import "Friendlist.h"
@implementation Friendlist
+(instancetype)newsWitharray:(NSArray *)dic{
    Friendlist *news = [self new];
    news.title = dic[0];
    news.user_id = dic[1];
    return news;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(NSString *) description{
    return [NSString stringWithFormat:@"%@{title:%@,id:%@}",[super description],self.title,self.user_id];
}
@end


