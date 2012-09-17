//
//  HAAppDelegate.m
//  NeverNote2
//
//  Created by admin on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HAAppDelegate.h"
#import "HANoteBooksViewController.h"
#import "HANotesViewController.h"
#import "HASingleNoteViewController.h"

#import "HANoteEngine.h"
#import "HANoteBook.h"

#import "config.h"

@interface HAAppDelegate()

- (void)loadSubControllers;

- (void)loadUserInfo;
- (void)loadData;
@end

@implementation HAAppDelegate

@synthesize window = _window;
@synthesize mainSplitView = _mainSplitView;
@synthesize contentSplitView = _contentSplitView;

@synthesize engine = _engine;
@synthesize loginCtrl = _loginCtrl;
@synthesize popover = _popover;

@synthesize noteBooksCtrl = _noteBooksCtrl;
@synthesize notesCtrl = _notesCtrl;
@synthesize singleNoteCtrl = _singleNoteCtrl;

- (void)dealloc
{
    self.engine = nil;
    self.loginCtrl = nil;
    self.popover = nil;
    
    self.noteBooksCtrl = nil;
    self.notesCtrl = nil;
    self.singleNoteCtrl = nil;
    
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    [self loadSubControllers];
    
    self.engine = [[[HANoteEngine alloc] initWithConsumerKey:kConsumerKey secret:kConsumerSecret] autorelease];
    if ([_engine isLogin]) {
        [self loadUserInfo];
        [self loadData];
    }
}

- (void)loadSubControllers
{
    self.noteBooksCtrl = [[[HANoteBooksViewController alloc] initWithNibName:@"HANoteBooksViewController" bundle:nil] autorelease];
    [self.mainSplitView replaceSubview:[[self.mainSplitView subviews] objectAtIndex:0] with:_noteBooksCtrl.view];
    
    self.notesCtrl = [[[HANotesViewController alloc] initWithNibName:@"HANotesViewController" bundle:nil] autorelease];
    [self.contentSplitView replaceSubview:[[self.contentSplitView subviews] objectAtIndex:0] with:_notesCtrl.view];
    
    self.singleNoteCtrl = [[[HASingleNoteViewController alloc] initWithNibName:@"HASingleNoteViewController" bundle:nil] autorelease];
    [self.contentSplitView replaceSubview:[[self.contentSplitView subviews] objectAtIndex:1] with:_singleNoteCtrl.view];
}

- (void)loadUserInfo
{
    [self.engine asyncGetUserInfo];
}

- (void)loadData
{
    [self loadDataFromLocal];
    
    [self loadDataFromInternet];
}

- (void)loadDataFromLocal
{
    [_noteBooksCtrl refreshData];
}

- (void)loadDataFromInternet
{
    //load notebooks
    [_engine asyncNoteBookAll];
}

- (void)showNoteBook:(HANoteBook *)notebook
{
    [_engine asyncNoteBookList:notebook];
}

- (IBAction)didLogAccount:(id)sender
{
    DLog(@"Click Account...");
    
    //第一步，获取OAuth 1.0的Request Token，使用的同步请求
    [_engine syncRequestToken];
    
//    NSString *queryURL = [NSString stringWithFormat:@"%@?oauth_token=%@", kOAuthAuthorizeURL, _engine.requestToken.key];
//    DLog(@"queryURL: %@", queryURL);
//    NSURL *url = [NSURL URLWithString:queryURL];
//    [[NSWorkspace sharedWorkspace] openURL:url];
    
    self.popover = [[NSPopover alloc] init];
    _popover.delegate = self;
    
    //第二步，使用上一步获取的Request Token请求Access Token，展示登陆页面
    self.loginCtrl = [[[HALoginViewController alloc] initWithNibName:@"HALoginViewController" bundle:nil] autorelease];
    self.loginCtrl.delegate = self;
    
    _popover.contentViewController = _loginCtrl;
    
    [_popover showRelativeToRect:NSMakeRect(0, 0, 300, 400) ofView:_mainSplitView preferredEdge:NSMaxXEdge];
}

- (void)popoverDidShow:(NSNotification *)notification
{
//    DLog(@"popover did show");
    
    NSString *queryURL = [NSString stringWithFormat:@"%@?oauth_token=%@", kOAuthAuthorizeURL, _engine.requestToken.key];
//    DLog(@"queryURL: %@", queryURL);
    
    //第二步的请求开始
    [_loginCtrl showLoginView:queryURL];
}

- (void)didLogin:(HALoginViewController *)loginCtrl withVerifier:(NSString *)oauth_verifier
{
    //获取服务器返回的验证信息获取Access Token
    if (oauth_verifier) {
        DLog(@"verifier: %@", oauth_verifier);
        
        self.engine.requestToken.verifier = oauth_verifier;
        
        //第三步，真正的获取Access　Token的一步，同步请求
        [self.engine syncAccessToken];
        
        //以后的步骤，用Access Token获取服务器上的资源，没有检查是否获取成功，直接获取用户信息（或有问题的）
        [self.engine asyncGetUserInfo];
        
        [self loadData];
        
        [_popover close];
    }
}
@end
