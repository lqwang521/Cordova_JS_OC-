//
//  CordovaViewController.m
//  cordova_example
//
//  Created by wlq on 2016/11/27.
//  Copyright © 2016年 HTMICDVtech. All rights reserved.
//

#import "CordovaViewController.h"

@interface CordovaViewController ()

@end

@implementation CordovaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:@selector(testClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)testClick
{
    NSString *jsStr = @"asyncAlert('哈哈啊哈')";
    [self.commandDelegate evalJs:jsStr];
}

@end
