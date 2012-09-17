//
//  confign.h
//  Mac
//
//  Created by admin on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Mac_confign_h
#define Mac_confign_h

#define kConsumerName       @"NeverNote"
#define kConsumerKey        @"f377da45ea4991f2a845e748b7a486af"
#define kConsumerSecret     @"1699e09f0ac260bb4767961a2e327561"

#define kNeverNoteServiceName   @"com.youdao" 
#define kNeverNotePrefix        @"NeverNote2"

#endif

//Notification
#define kGetUserInfoNotification        @"kGetUserInfoNotification"
#define kLoadNoteBooksAllNotification   @"kLoadNoteBooksAllNotification"
#define kLoadNoteBookListNotification   @"kLoadNoteBookListNotification"
#define kLoadNoteNotification           @"kLoadNoteNotification"

#ifdef DEBUG
/////////////////////////////////////////////////////////////
//测试环境
/////////////////////////////////////////////////////////////
//OAuth
    #define kOAuthBaseURL           @"http://sandbox.note.youdao.com/oauth"
    #define kOAuthRequestTokenURL   @"http://sandbox.note.youdao.com/oauth/request_token"
    #define kOAuthAuthorizeURL      @"http://sandbox.note.youdao.com/oauth/authorize"
    #define kOAuthAccessTokenURL    @"http://sandbox.note.youdao.com/oauth/access_token"

//笔记本
    #define kUserInfoGetURL         @"http://sandbox.note.youdao.com/yws/open/user/get.json"
    #define kNoteBookAllURL         @"http://sandbox.note.youdao.com/yws/open/notebook/all.json"
    #define kNoteBookListURL        @"http://sandbox.note.youdao.com/yws/open/notebook/list.json"
    #define kNoteBookCreateURL      @"http://sandbox.note.youdao.com/yws/open/notebook/create.json"
    #define kNoteBookDeleteURL      @"http://sandbox.note.youdao.com/yws/open/notebook/delete.json"

//笔记
    #define kNoteCreateURL          @"http://sandbox.note.youdao.com/yws/open/note/create.json"
    #define kNoteDeleteURL          @"http://sandbox.note.youdao.com/yws/open/note/delete.json"
    #define kNoteGetURL             @"http://sandbox.note.youdao.com/yws/open/note/get.json"
    #define kNoteUpdateURL          @"http://sandbox.note.youdao.com/yws/open/note/update.json"
    #define kNoteMoveURL            @"http://sandbox.note.youdao.com/yws/open/note/move.json"
    #define kNotePublishURL         @"http://sandbox.note.youdao.com/yws/open/share/publish.json"

//Resource
    #define kResourceUploadURL      @"http://sandbox.note.youdao.com/yws/open/resource/upload.json"

#else
/////////////////////////////////////////////////////////////
//正式环境
/////////////////////////////////////////////////////////////

//OAuth
    #define kOAuthBaseURL           @"http://note.youdao.com/oauth"
    #define kOAuthRequestTokenURL   @"http://note.youdao.com/oauth/request_token"
    #define kOAuthAuthorizeURL      @"http://note.youdao.com/oauth/authorize"
    #define kOAuthAccessTokenURL    @"http://note.youdao.com/oauth/access_token"

//笔记本
    #define kUserInfoGetURL         @"http://note.youdao.com/yws/open/user/get.json"
    #define kNoteBookAllURL         @"http://note.youdao.com/yws/open/notebook/all.json"
    #define kNoteBookListURL        @"http://note.youdao.com/yws/open/notebook/list.json"
    #define kNoteBookCreateURL      @"http://note.youdao.com/yws/open/notebook/create.json"
    #define kNoteBookDeleteURL      @"http://note.youdao.com/yws/open/notebook/delete.json"

//笔记
    #define kNoteCreateURL          @"http://note.youdao.com/yws/open/note/create.json"
    #define kNoteDeleteURL          @"http://note.youdao.com/yws/open/note/delete.json"
    #define kNoteGetURL             @"http://note.youdao.com/yws/open/note/get.json"
    #define kNoteUpdateURL          @"http://note.youdao.com/yws/open/note/update.json"
    #define kNoteMoveURL            @"http://note.youdao.com/yws/open/note/move.json"
    #define kNotePublishURL         @"http://note.youdao.com/yws/open/share/publish.json"

//Resource
    #define kResourceUploadURL      @"http://note.youdao.com/yws/open/resource/upload.json"
#endif
