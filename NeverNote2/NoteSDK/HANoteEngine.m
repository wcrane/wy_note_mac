//
//  HANoteEngine.m
//  NeverNote2
//
//  Created by admin on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HANoteEngine.h"

#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OAAsynchronousDataFetcher.h"

#import "JSON.h"

#import "HAUser.h"
#import "HANoteBook.h"
#import "HASingleNote.h"

#import "config.h"

static HANoteEngine *sharedInstance = nil;

@interface HANoteEngine()

- (void)readAccessToken;
@end

@implementation HANoteEngine

@synthesize consumerKey;
@synthesize consumerSecret;
@synthesize requestToken;
@synthesize accessToken;

- (id)initWithConsumerKey:(NSString *)key secret:(NSString *)secret
{
    self = [super init];
    if (self) {
        self.consumerKey = key;
        self.consumerSecret = secret;
        
        [self readAccessToken];
    }
    
    return self;
}

+ (HANoteEngine *)sharedEngine
{
    if (sharedInstance == nil) {
        sharedInstance = [[HANoteEngine alloc] initWithConsumerKey:kConsumerKey secret:kConsumerSecret];
    }
    
    return sharedInstance;
}

+ (HANoteEngine *)sharedEngineWithKey:(NSString *)key secret:(NSString *)secret
{
    if (sharedInstance == nil) {
        sharedInstance = [[HANoteEngine alloc] initWithConsumerKey:key secret:secret];
    }
    
    return sharedInstance;
}

- (void)dealloc
{
    self.consumerKey = nil;
    self.consumerSecret = nil;
    self.requestToken = nil;
    self.accessToken = nil;
    
    [super dealloc];
}

- (void)readAccessToken
{
    self.accessToken = [[[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kNeverNoteServiceName prefix:kNeverNotePrefix] autorelease];
}

- (BOOL)isLogin
{
    if (self.accessToken.key && self.accessToken.secret) {
        return YES;
    }
    
    return NO;
}

- (void)syncRequestToken
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumerKey secret:consumerSecret];
    
    NSURL *url = [NSURL URLWithString:kOAuthRequestTokenURL];
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url 
                                                                   consumer:consumer 
                                                                      token:nil 
                                                                      realm:nil 
                                                          signatureProvider:nil] autorelease];
    
//    [request setOAuthParameterName:@"oauth_callback" withValue:@"http://happyapp.tk"]; //添加回调地址
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request 
                         delegate:self 
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)syncAccessToken
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumerKey secret:consumerSecret];
    
    NSURL *url = [NSURL URLWithString:kOAuthAccessTokenURL];
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url 
                                                                    consumer:consumer 
                                                                       token:requestToken 
                                                                       realm:nil 
                                                           signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(accessTokenTicket:didFinishWithData:) didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
}

//获取RequestToken
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

        DLog(@"Data: %@", responseBody);
        
        self.requestToken = [[[OAToken alloc] initWithHTTPResponseBody:responseBody] autorelease];
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)error
{
    DLog(@"Error: %@", error);
}

//获取AccessToken
- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed) {
        NSString *responseBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        
        DLog(@"Data: %@", responseBody);
        
        self.accessToken = [[[OAToken alloc] initWithHTTPResponseBody:responseBody] autorelease];
        [self.accessToken storeInUserDefaultsWithServiceProviderName:kNeverNoteServiceName prefix:kNeverNotePrefix];
    }
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)error
{
    DLog(@"access error: %@", error);
}

//获取资源
- (OAMutableURLRequest *)_getAccessRequestURL:(NSString *)urlStr method:(NSString *)method params:(NSDictionary *)dict
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumerKey secret:consumerSecret];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] initWithURL:url 
                                                                    consumer:consumer 
                                                                       token:accessToken 
                                                                       realm:nil 
                                                           signatureProvider:nil] autorelease];
    
    if (method) {
        [request setHTTPMethod:method];
    }else {
        [request setHTTPMethod:@"GET"];
    }
    
    if (dict) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[dict count]];
        for (NSString *key in [dict allKeys]) {
            [array addObject:[OARequestParameter requestParameterWithName:key value:[dict objectForKey:key]]];
        }
        [request setParameters:array];
    }
    
    return request;
}

- (void)_startAsyncRequest:(OAMutableURLRequest *)request
{
    OAAsynchronousDataFetcher *dataFetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:request 
                                                                                              delegate:self 
                                                                                     didFinishSelector:@selector(_fetchDataTicket:didFinishWithData:) 
                                                                                       didFailSelector:@selector(_fetchDataTicket:didFailWithError:)];
    
    [dataFetcher start];
}

- (void)asyncGetUserInfo
{
    OAMutableURLRequest *request = [self _getAccessRequestURL:kUserInfoGetURL method:@"GET" params:nil];
    [self _startAsyncRequest:request];
}

- (void)asyncNoteBookAll
{
    OAMutableURLRequest *request = [self _getAccessRequestURL:kNoteBookAllURL method:@"POST" params:nil];
    [self _startAsyncRequest:request];
}

- (void)asyncNoteBookList:(HANoteBook *)notebook
{
    OAMutableURLRequest *request = [self _getAccessRequestURL:kNoteBookListURL method:@"POST" params:[NSDictionary dictionaryWithObjectsAndKeys:notebook.path, @"notebook", nil]];
    [self _startAsyncRequest:request];
}

- (void)asyncGetNoteFromPath:(NSString *)path
{
    OAMutableURLRequest *request = [self _getAccessRequestURL:kNoteGetURL method:@"POST" params:[NSDictionary dictionaryWithObjectsAndKeys:path, @"path", nil]];
    [self _startAsyncRequest:request];
}

- (void)_postNotificationOnMain:(NSDictionary *)dictionary
{
    NSString *notifName = [dictionary objectForKey:@"notifName"];
    id userInfo = [dictionary objectForKey:@"userInfo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:notifName object:nil userInfo:[NSDictionary dictionaryWithObject:userInfo forKey:@"userInfo"]];
}

- (void)_fetchDataTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"%@", responseBody);
        
        NSString *url = [NSString stringWithFormat:@"%@", [ticket.request URL]];
        DLog(@"%@", url);
        
        id userInfo = nil;
        NSString *notifName = nil;
        if ([url isEqualToString:kUserInfoGetURL]) {
            notifName = kGetUserInfoNotification;
            
            SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
            NSDictionary *dict = [parser objectWithString:responseBody];
            DLog(@"%@", dict);
            
            userInfo = [HAUser getUserFromJsonDict:dict];
        }
        else if ([url isEqualToString:kNoteBookAllURL]) {
            notifName = kLoadNoteBooksAllNotification;
            
            SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
            NSArray *array = [parser objectWithString:responseBody];
            DLog(@"%@", array);
            
            if (array && [array count] > 0) {
                NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (NSDictionary *dict in array) {
                    HANoteBook *notebook = [HANoteBook getNoteBookFromJsonDict:dict];
                    [tmpArray addObject:notebook];
                }
                
                userInfo = tmpArray;
            }
        }
        else if ([url isEqualToString:kNoteBookListURL]) {
            notifName = kLoadNoteBookListNotification;
            
            SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
            NSArray *array = [parser objectWithString:responseBody];
            
            if (array && [array count] > 0) {
                NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (NSString *path in array) {
                    HASingleNote *note = [HASingleNote getNoteFromPath:path];
                    [tmpArray addObject:note];
                }
                
                userInfo = tmpArray;
            }
        }
        else if ([url isEqualToString:kNoteGetURL]) {
            notifName = kLoadNoteNotification;
            
        }
        
        if (userInfo && notifName) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", notifName, @"notifName", nil];
            [self performSelectorOnMainThread:@selector(_postNotificationOnMain:) withObject:dict waitUntilDone:NO];
        }
    }else {
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"%@", responseBody);
        
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        NSDictionary *dict = [parser objectWithString:responseBody];

        NSString *error = [dict objectForKey:@"error"];
        if ([error isEqualToString:@"307"]) {
            
        }
    }
}

- (void)_fetchDataTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)error
{
    DLog(@"access error: %@", error);
}
@end
