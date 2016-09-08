//
//  ViewController.m
//  UploadDemo2
//
//  Created by MengLong Wu on 16/8/30.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)uploadLargeFile:(id)sender
{
    
    NSURL *url =[NSURL URLWithString:@"http://localhost:8080/UploadServlet/upload"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"post"];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"123" ofType:@"dmg"];
    
//    NSInputStream 输入流
//    inputStreamWithFileAtPath 获得某个文件的输入流
    NSInputStream *input = [NSInputStream inputStreamWithFileAtPath:path];
    
//    上传大文件时,不能一次性把所有数据都放入请求体,需要设置输入流
    [request setHTTPBodyStream:input];
    
    unsigned long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    
//    设置请求体大小
    [request addValue:[NSString stringWithFormat:@"%qu",size] forHTTPHeaderField:@"Content-Length"];
    //内容类型
//    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [connection start];
}
//发送数据时调用
//bytesWritten:这次的数据包大小
//totalBytesWritten:一共发送了多少数据
//totalBytesExpectedToWrite:一共想要发送多少数据
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
    
    _progress.progress = progress;
}


@end
