//
//  Friends.m
//  test
//
//  Created by lu on 2019/4/20.
//  Copyright © 2019 lu. All rights reserved.
//

#import "Friends.h"

@implementation Friends
+(instancetype)newsWitharray:(NSArray *)dic{
    Friends *news = [self new];
    news.title = dic[0];
    news.detail = [NSString stringWithFormat:@"%@\n%@ %@ %@\n%@ %@",dic[3],dic[5],dic[7],dic[8],dic[1],dic[2]];
    return news;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(NSString *) description{
    return [NSString stringWithFormat:@"%@{title:%@,detail:%@}",[super description],self.title,self.detail];
}
@end
