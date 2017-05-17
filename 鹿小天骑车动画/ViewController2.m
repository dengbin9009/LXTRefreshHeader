//
//  ViewController2.m
//  鹿小天骑车动画
//
//  Created by DaBin on 2017/5/11.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)closeAction:(id)sender;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
