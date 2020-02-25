//
//  SubmitViewController.h
//  test
//
//  Created by lu on 2019/3/25.
//  Copyright © 2019 lu. All rights reserved.


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubmitViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *photoImage;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UIButton *renew;
-(void)tips:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
