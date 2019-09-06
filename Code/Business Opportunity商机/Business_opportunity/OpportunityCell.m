//
//  OpportunityCell.m
//  Business_opportunity
//
//  Created by fukaixin10 on 2019/4/26.
//  Copyright © 2019 Mantis group. All rights reserved.
//

#import "OpportunityCell.h"
#import "OppCell.h"

@implementation OpportunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo:(NSDictionary *)info {
    
    _titleLabel.text = info[@"first_level_desc"];
    
    
    NSArray *contents = info[@"contents"];
    
    NSString *contentsString = [contents componentsJoinedByString: @"\n"];
    _desLabel.text = contentsString;
}

- (IBAction)pushDetail:(UIButton *)sender {
    self.block(self);
}


//+ (CGFloat)heightForCell:(NSDictionary *)info {
//    NSArray *contents = info[@"contents"];
//    NSString *contentsString = [contents componentsJoinedByString: @"\n"];
//    
//    __block CGFloat height = 35 + 15 +  [OppCell heightOfCellWithIngredientLine:contentsString withSuperviewWidth:CELL_CONTENT_WIDTH];
//    
//    return height + 15;
//}

@end
