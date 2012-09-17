//
//  HANoteEngine.h
//  NeverNote2
//
//  Created by wcrane on 9/11/12.
//  Copyright (c) 2012 HappyApp小分队. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OAToken.h"

@class HANoteBook;

@interface HANoteEngine : NSObject
{
    NSString *consumerKey;
    NSString *consumerSecret;
    
    OAToken *requestToken;
    OAToken *accessToken;
}
@property (nonatomic, copy) NSString *consumerKey;
@property (nonatomic, copy) NSString *consumerSecret;
@property (nonatomic, retain) OAToken *requestToken;
@property (nonatomic, retain) OAToken *accessToken;

- (id)initWithConsumerKey:(NSString *)key secret:(NSString *)secret;

+ (HANoteEngine *)sharedEngine;
+ (HANoteEngine *)sharedEngineWithKey:(NSString *)key secret:(NSString *)secret;

- (BOOL)isLogin;

- (void)syncRequestToken;
- (void)syncAccessToken;

- (void)asyncGetUserInfo;
- (void)asyncNoteBookAll;
- (void)asyncNoteBookList:(HANoteBook *)notebook;
- (void)asyncGetNoteFromPath:(NSString *)path;

@end
