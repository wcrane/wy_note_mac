//
//  HAAppDelegate.m
//  NeverNote2
//
//  Created by wcrane on 9/11/12.
//  Copyright (c) 2012 HappyApp小分队. All rights reserved.
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
    
    [_engine syncRequestToken];
    
//    NSString *queryURL = [NSString stringWithFormat:@"%@?oauth_token=%@", kOAuthAuthorizeURL, _engine.requestToken.key];
//    DLog(@"queryURL: %@", queryURL);
//    NSURL *url = [NSURL URLWithString:queryURL];
//    [[NSWorkspace sharedWorkspace] openURL:url];
    
    self.popover = [[NSPopover alloc] init];
    _popover.delegate = self;
    
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
    
    [_loginCtrl showLoginView:queryURL];
}

- (void)didLogin:(HALoginViewController *)loginCtrl withVerifier:(NSString *)oauth_verifier
{
    if (oauth_verifier) {
        DLog(@"verifier: %@", oauth_verifier);
        
        self.engine.requestToken.verifier = oauth_verifier;
        
        [self.engine syncAccessToken];
        
        [self.engine asyncGetUserInfo];
        
        [self loadData];
        
        [_popover close];
    }
}
@end
