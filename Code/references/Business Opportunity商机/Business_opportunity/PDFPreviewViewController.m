//
//  PDFPreviewViewController.m
//  Business_opportunity
//
//  Created by fukaixin10 on 2019/5/7.
//  Copyright © 2019 Mantis group. All rights reserved.
//

#import "PDFPreviewViewController.h"
#import <WebKit/WebKit.h>

@interface PDFPreviewViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webview;

@end

@implementation PDFPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *testDirectory = [documentsDirectory stringByAppendingString:@"/PDF"];
    NSString *path = [testDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.pdf", self.c_id]];

    NSLog(@"存放pdf路径:%@",NSHomeDirectory());//沙盒路径
    
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSData * data = [NSData dataWithContentsOfURL:targetURL];
    
    [_webview loadData:data MIMEType:@"application/pdf" characterEncodingName:@"" baseURL:targetURL.URLByDeletingLastPathComponent];
    
    //NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    //[_webview loadRequest:request];
    
}


@end
