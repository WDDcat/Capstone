//
//  friendViewController.h
//  test
//
//  Created by lu on 2019/4/18.
//  Copyright © 2019 lu. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface friendViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *search;
@property (strong, nonatomic) IBOutlet UIButton *dosearch;
-(void)buttonClicke;

@end

NS_ASSUME_NONNULL_END
