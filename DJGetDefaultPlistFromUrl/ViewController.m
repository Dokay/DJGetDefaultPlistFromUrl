//
//  ViewController.m
//  DJGetDefaultPlistFromUrl
//
//  Created by Dokay on 15/12/2.
//  Copyright © 2015年 ylbd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, weak) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self processBegin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processBegin
{
    self.statusLabel.text = @"begin";
    NSString *url = @"http://alpha.client.ylbd.cn/main/index?sheight=667&dist=ylbd&swidth=375&urid=172&lat=31.17272772941597&logintoken=bykS8_tA4FqBPH-EWKoT3bgjM2IbsKNEwNgdDVlpwqwDOxvG9yoxZXMmi-iT5x2Y4qEuWkXNgdYb19tQaBSaGQ&platform=ios&language=zh-Hans-CN&dosv=9.1&lng=121.3997070330535&network=&v=3.1.1&udid=a1a59a8fbbc55484e1cc35cf1035284e0656efb7";
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        self.statusLabel.text = err.description;
        return;
    }
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dic format:NSPropertyListXMLFormat_v1_0 errorDescription:&err];
    if(err) {
        NSLog(@"转换plist失败：%@",err);
        self.statusLabel.text = err.description;
        return;
    }
    
    if (plistData) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"djPlistGenerate.plist"];
        NSLog(@"存储目录：%@",filePath);
        [plistData writeToFile:filePath atomically:YES];
        NSLog(@"finish......");
        self.statusLabel.text = @"finish......";
    }
}

@end
