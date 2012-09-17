//
//  HALoginViewController.m
//  NeverNote2
//
//  Created by admin on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HALoginViewController.h"

@interface HALoginViewController ()

@end

@implementation HALoginViewController

@synthesize webView = _webView;
@synthesize verifier = _verifier;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    DLog(@"dealloc");
    self.verifier = nil;
    
    [super dealloc];
}

- (void)showLoginView:(NSString *)url
{
    [self.webView setFrameLoadDelegate:self];
    [self.webView setMainFrameURL:url];
}

- (void)webView:(WebView *)wv didStartProvisionalLoadForFrame:(WebFrame *)frame
{
//    DLog(@"start provisional load");
}

- (void)webView:(WebView *)wv didFinishLoadForFrame:(WebFrame *)frame
{
    DLog(@"finish load:\n %@", [wv mainFrameURL]);
    
    NSString *urlStr = [wv mainFrameURL];
    
    if ([urlStr isEqualToString:@"http://sandbox.note.youdao.com/oauth/authorize"]) {
        DLog(@"Success: %@", _verifier);
        
        if (_delegate && [_delegate respondsToSelector:@selector(didLogin:withVerifier:)]) {
            [_delegate didLogin:self withVerifier:_verifier];
        }
        
        return;
    }
    
    NSArray *pairs = [urlStr componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if ([[elements objectAtIndex:0] isEqualToString:@"oauth_verifier"]) {
            DLog(@"verifier: %@", [elements objectAtIndex:1]);
            self.verifier = [elements objectAtIndex:1];
        }
    }
}

- (void)webView:(WebView *)wv didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
//    DLog(@"failed provisional load");
}

- (void)webView:(WebView *)wv didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    DLog(@"failed load");
}
@end
