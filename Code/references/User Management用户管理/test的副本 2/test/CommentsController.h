//
//  CommentsController.h
//  test
//
//  Created by lu on 2019/5/2.
//  Copyright © 2019 lu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentsController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *send;
@property (strong, nonatomic) IBOutlet UIView *addview;
@property (strong, nonatomic) IBOutlet UIButton *addcomments;
@property (strong, nonatomic) IBOutlet UIButton *fix_info;

@property (strong, nonatomic) IBOutlet UITextField *textfiled;
@end

NS_ASSUME_NONNULL_END
