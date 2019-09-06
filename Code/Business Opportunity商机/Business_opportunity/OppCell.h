//
//  OppCell.h
//  Business_opportunity
//
//  Created by fukaixin10 on 2019/4/18.
//  Copyright © 2019 Mantis group. All rights reserved.
//

#import <UIKit/UIKit.h>


#define CELL_CONTENT_WIDTH UIScreen.mainScreen.bounds.size.width
#define CELL_CONTENT_MARGIN 10.0f

NS_ASSUME_NONNULL_BEGIN

@interface OppCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *info;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (CGFloat)heightForCell:(NSDictionary *)info ;

+ (CGFloat)heightOfCellWithIngredientLine:(NSString *)ingredientLine withSuperviewWidth:(CGFloat)superviewWidth ;
@end

NS_ASSUME_NONNULL_END

