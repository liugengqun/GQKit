//
//  GQSocketRocketManager.m
//  GQKit
//
//  Created by Apple on 5/3/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import "GQSocketRocketManager.h"
#import "GQKit.h"
NSString * const GQNotification_SocketRocketDidOpen = @"GQNotification_SocketRocketDidOpen";
NSString * const GQNotification_SocketRocketDidClose = @"GQNotification_SocketRocketDidClose";
NSString * const GQNotification_SocketRocketDidReceive = @"GQNotification_SocketRocketDidReceive";

@interface GQSocketRocketManager()<SRWebSocketDelegate>

@property (nonatomic,strong) SRWebSocket *socket;

@property (nonatomic,strong) NSTimer *heartBeat;

@property (nonatomic,assign) NSTimeInterval reConnectTime;

@property (nonatomic,copy) NSString *urlString;
@end

@implementation GQSocketRocketManager

+ (instancetype)gq_shareInstance {
    static GQSocketRocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GQSocketRocketManager alloc] init];
    });
    return instance;
}

- (void)gq_openWithURLString:(NSString *)urlString {
    if (self.socket) {
        return;
    }
    if (!urlString) {
        return;
    }
    self.urlString = urlString;
    self.socket = [[SRWebSocket alloc] initWithURLRequest:
                   [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    self.socket.delegate = self;
    [self.socket open];
}

- (void)gq_close {
    if (self.socket){
        [self.socket close];
        self.socket = nil;
        [self destoryHeartBeat];
    }
}

- (void)gq_sendData:(id)data {
    __weak __typeof(self) weakSelf = self;
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    dispatch_async(queue, ^{
        if (weakSelf.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (weakSelf.socket.readyState == SR_OPEN) {
                [weakSelf.socket send:data];    // 发送数据
                
            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
                GQLog(@"正在连接中");
                [self reConnect];
            } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
                [self reConnect];
            }
        } else {
            
        }
    });
}

//重连机制
- (void)reConnect {
    [self gq_close];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self gq_openWithURLString:self.urlString];
    });
    
    if (self.reConnectTime == 0) {
        self.reConnectTime = 2;
    }
}

//取消心跳
- (void)destoryHeartBeat {
    GQ_dispatch_main_async_safe(^{
        if (self.heartBeat) {
            if ([self.heartBeat respondsToSelector:@selector(isValid)]){
                if ([self.heartBeat isValid]){
                    [self.heartBeat invalidate];
                    self.heartBeat = nil;
                }
            }
        }
    })
}

//初始化心跳
- (void)initHeartBeat {
    GQ_dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        self.heartBeat = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.heartBeat forMode:NSRunLoopCommonModes];
    })
}

-(void)sentheart {
    //发送心跳
    [self gq_sendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //每次正常连接的时候清零重连时间
    self.reConnectTime = 0;
    //开启心跳
    [self initHeartBeat];
    if (webSocket == self.socket) {
        GQLog(@"socket连接成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:GQNotification_SocketRocketDidOpen object:nil];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (webSocket == self.socket) {
        GQLog(@"socket连接失败");
        _socket = nil;
        [self reConnect];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (webSocket == self.socket) {
        GQLog(@"socket连接断开 被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
        [self reConnect];
    }
}

/*该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
 在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
 用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息，
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
//    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (webSocket == self.socket) {
        GQLog(@"socket收到数据message:%@",message);
        [[NSNotificationCenter defaultCenter] postNotificationName:GQNotification_SocketRocketDidReceive object:message];
    }
}

- (SRReadyState)socketReadyState {
    return self.socket.readyState;
}

@end
