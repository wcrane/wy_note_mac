//
//  HALoginViewController.h
//  NeverNote2
//
//  Created by admin on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class HALoginViewController;

@protocol HALoginViewDelegate <NSObject>

@optional
- (void)didLogin:(HALoginViewController *)loginCtrl withVerifier:(NSString *)oauth_verifier;

@end

@interface HALoginViewController : NSViewController
{
    WebView *webView;
    
    NSString *verifier;
    
    id<HALoginViewDelegate> delegate;
}
@property (nonatomic, assign) IBOutlet WebView *webView;
@property (nonatomic, copy) NSString *verifier;
@property (nonatomic, assign) id<HALoginViewDelegate> delegate;

- (void)showLoginView:(NSString *)url;
@end
