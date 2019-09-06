//
//  OppCell.m
//  Business_opportunity
//
//  Created by fukaixin10 on 2019/4/18.
//  Copyright © 2019 Mantis group. All rights reserved.
//

#import "OppCell.h"
#import "NALLabelsMatrix.h"

#define FONT_SIZE 14.0f

@interface OppCell() {
    UILabel *suggLabel;
    UILabel *tableNameLabel;
}

@end


@implementation OppCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubView];
    }
    return self;
}

#pragma mark 初始化视图
-(void)initSubView {
    suggLabel=[[UILabel alloc]init];
    suggLabel.textColor=[UIColor grayColor];
    suggLabel.numberOfLines = 0;
    suggLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    //[_titleLabel.superview addSubview:suggLabel];
    
    tableNameLabel=[[UILabel alloc]init];
    tableNameLabel.textColor=[UIColor grayColor];
    tableNameLabel.numberOfLines = 0;
    tableNameLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    //[_titleLabel.superview addSubview:tableNameLabel];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setInfo:(NSDictionary *)info {
    [_titleLabel.superview addSubview:suggLabel];
    [_titleLabel.superview addSubview:tableNameLabel];
    
    _titleLabel.text = info[@"title"];
    
    
    NSArray *datas = info[@"datas"];
    NSMutableString *sugg = [[NSMutableString alloc] initWithString:@""];
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *item = sugg.length > 0 ? [NSString stringWithFormat:@"\n%@", obj[@"suggest_content" ]] : obj[@"suggest_content" ];
        [sugg appendString: item];
    }];
    
    CGFloat height = [OppCell heightOfCellWithIngredientLine:sugg withSuperviewWidth:CELL_CONTENT_WIDTH];
    suggLabel.frame = CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + 15, CELL_CONTENT_WIDTH - 30, height);
   
    
    NSArray *list = info[@"table_list"];
    
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *item =  obj[@"table_name" ];
        CGFloat height = [OppCell heightOfCellWithIngredientLine:item withSuperviewWidth:CELL_CONTENT_WIDTH];
        self->tableNameLabel.frame = CGRectMake(15, CGRectGetMaxY(self->suggLabel.frame) + 15, CELL_CONTENT_WIDTH - 30, height);
        self->tableNameLabel.text = item;
        
        NSArray *table_data = obj[@"table_data"];
        
 
        for (int i = 0; i < table_data.count; i++) {
            NSArray *row_name = table_data[i][@"row_name"];
            NSArray *info = table_data[i][@"info"];

            NSMutableArray *widths = [[NSMutableArray alloc] init];
            for (int i = 0; i < row_name.count;  i ++) {
                [widths addObject: @( CELL_CONTENT_WIDTH / row_name.count)];
            }
            NALLabelsMatrix* matrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self->tableNameLabel.frame) + 15, CELL_CONTENT_WIDTH - 30, info.count * 50 + 50) andColumnsWidths: widths];
            [matrix addRecord:row_name];
            [self->_titleLabel.superview addSubview:matrix];
            if (info.count > 0) {
                [matrix addRecord:info[0]];
            }
            
            [info enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [matrix addRecord:obj];
            }];
        }
    }];
    
}

+ (CGFloat)heightForCell:(NSDictionary *)info {
    NSArray *datas = info[@"datas"];
    NSMutableString *sugg = [[NSMutableString alloc] initWithString:@""];
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *item = sugg.length > 0 ? [NSString stringWithFormat:@"\n%@", obj[@"suggest_content" ]] : obj[@"suggest_content" ];
        [sugg appendString: item];
    }];
    
    __block CGFloat height = 35 + 15 +  [OppCell heightOfCellWithIngredientLine:sugg withSuperviewWidth:CELL_CONTENT_WIDTH];
    
    NSArray *list = info[@"table_list"];
    
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *item =  obj[@"table_name" ];
        height += 15 + [OppCell heightOfCellWithIngredientLine:item withSuperviewWidth:CELL_CONTENT_WIDTH];
        
        NSArray *table_data = obj[@"table_data"];
        
        for (int i = 0; i < table_data.count; i++) {
            NSArray *row_name = table_data[i][@"row_name"];
            NSArray *info = table_data[i][@"info"];
            
            NSMutableArray *widths = [[NSMutableArray alloc] init];
            for (int i = 0; i < row_name.count;  i ++) {
                [widths addObject: @( CELL_CONTENT_WIDTH / row_name.count)];
            }
            NALLabelsMatrix* matrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake(15, 0, CELL_CONTENT_WIDTH - 30, info.count * 50 + 50) andColumnsWidths: widths];
            [matrix addRecord:row_name];
            if (info.count > 0) {
                [matrix addRecord:info[0]];
            }
            
            [info enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [matrix addRecord:obj];
            }];
            
            height += matrix.frame.size.height;
        }
    }];
    return height + 15;
}

+ (CGFloat)heightOfCellWithIngredientLine:(NSString *)ingredientLine withSuperviewWidth:(CGFloat)superviewWidth {
    CGFloat labelWidth                  = superviewWidth - 30.0f;
    //    use the known label width with a maximum height of 100 points
    CGSize labelContraints              = CGSizeMake(labelWidth, 10000.0f);
    
    NSStringDrawingContext *context     = [[NSStringDrawingContext alloc] init];
    
    CGRect labelRect = [ingredientLine boundingRectWithSize:labelContraints
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: FONT_SIZE]}
                                                                       context:context];
    
    //    return the calculated required height of the cell considering the label
    return labelRect.size.height;
}
@end
