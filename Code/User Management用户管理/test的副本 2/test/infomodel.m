//
//  infomodel.m
//  test
//
//  Created by lu on 2019/5/1.
//  Copyright © 2019 lu. All rights reserved.
//

#import "infomodel.h"

@implementation infomodel
+(instancetype)newsWithDic:(NSDictionary *)dic{
    infomodel *news = [self new];
    
    news.detail = [NSString stringWithFormat:@"情报等级:   %@\n发行人    :   %@\n发行场所:   %@\n发行日期:   %@\n注册金额:   %@\n发行金额:   %@\n分级        :   %@\n票面利率:   %@\n期限        :   %@\n担保方式:   %@\n积分        :   %@\n",dic[@"t_level"],dic[@"i_issuer"],dic[@"i_place"],dic[@"i_date"],dic[@"regis_amount"],dic[@"i_amount"],dic[@"grading"],dic[@"face_rate"],dic[@"term"],dic[@"guar_way"],dic[@"integral"]];
    news.comments = dic[@"comments"];
    news.user_id = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    news.uuid = [NSString stringWithFormat:@"%@",dic[@"uuid"]];
    return news;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(NSString *) description{
    return [NSString stringWithFormat:@"%@{detail:%@,user_id:%@,uuid:%@,comments:%@}",[super description],self.detail,self.user_id,self.uuid,self.comments];
}

@end
