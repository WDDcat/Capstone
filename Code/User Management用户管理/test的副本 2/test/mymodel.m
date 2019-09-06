//
//  mymodel.m
//  test
//
//  Created by lu on 2019/4/30.
//  Copyright © 2019 lu. All rights reserved.
//

#import "mymodel.h"

@implementation mymodel
+(instancetype)newsWitharray:(NSArray *)dic{
    mymodel *news = [self new];
    news.name = dic[0];
    news.time = dic[1];
    news.message = [NSString stringWithFormat:@"                        %@\n\n我： %@",dic[1],dic[2]];
    return news;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(NSString *) description{
    return [NSString stringWithFormat:@"%@{name:%@,time:%@,message:%@}",[super description],self.name,self.time,self.message];
}
@end
