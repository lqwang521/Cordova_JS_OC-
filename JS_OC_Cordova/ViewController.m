//
//  ViewController.m
//  JS_OC_Cordova
//
//  Created by Harvey on 16/9/28.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import "ViewController.h"

#import "CordovaViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    //    self.startPage = @"http://www.baidu.com";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 这里空出的20，是为了不显示使用导航控制器时，控制背景色来改变状态栏背景色
    //    self.webView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 20);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:@selector(testClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString * strPath = docDir;
    NSLog(@"11111111111111111111%@",strPath);
    
    NSString * dir = [NSString stringWithFormat:@"%@/www/index.html",docDir];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dir];
    
    CordovaViewController * cdvv = [[CordovaViewController alloc]init];
    if (existed) {
        
        cdvv.startPage = [NSString stringWithFormat:@"file://%@",dir];
        [self.navigationController pushViewController:cdvv animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)testClick
{
    NSString *jsStr = @"asyncAlert('哈哈啊哈')";
    [self.commandDelegate evalJs:jsStr];
}


@end
