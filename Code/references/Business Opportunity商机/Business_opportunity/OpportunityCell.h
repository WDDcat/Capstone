//
//  OpportunityCell.h
//  Business_opportunity
//
//  Created by fukaixin10 on 2019/4/26.
//  Copyright © 2019 Mantis group. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OpportunityCell;

typedef void(^OpportunityCellBlock)(OpportunityCell *cell);

@interface OpportunityCell : UITableViewCell

@property (nonatomic, copy)OpportunityCellBlock block;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (nonatomic,strong) NSDictionary *info;


//+ (CGFloat)heightForCell:(NSDictionary *)info ;
@end

NS_ASSUME_NONNULL_END
