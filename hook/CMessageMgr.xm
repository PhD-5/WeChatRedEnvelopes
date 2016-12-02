#import "CMessageMgr.h"
#define PREFERENCEFILE "/private/var/mobile/Library/Preferences/com.yjb.wechatautpredenvelops.plist"

static BOOL shouldHookFromPreference(NSString *preferenceSetting) {
    NSString *preferenceFilePath = @PREFERENCEFILE;
    NSMutableDictionary* plist = [[NSMutableDictionary alloc] initWithContentsOfFile:preferenceFilePath];
    
    if (!plist) { // Preference file not found, don't hook
        NSLog(@"WeChat Red Envelops - Preference file not found.");
        return FALSE;
    }
    else {
        id shouldHook = [plist objectForKey:preferenceSetting];
        if (shouldHook) {
            [plist release];
            return [shouldHook boolValue];
        } 
        else { // Property was not set, don't hook
            NSLog(@"SSL Kill Switch - Preference not set.");
            [plist release];
            return FALSE;
        }
    }
}

%hook CMessageMgr 

- (void)AsyncOnAddMsg:(id)arg1 MsgWrap:(CMessageWrap *)msgWrap{
    
//    NSLog(@"yujianbo: messageType:%lu",(unsigned long)[msgWrap m_uiMessageType]);
    if(msgWrap.m_uiMessageType == 49){
        CContactMgr *contactManager = [[%c(MMServiceCenter) defaultCenter] getService:[%c(CContactMgr) class]];
        CBaseContact *selfContact = [contactManager getSelfContact];

        
        if ([msgWrap.m_nsContent rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao"].location != NSNotFound) { // 红包
            
            NSString *nativeUrl = [[msgWrap m_oWCPayInfoItem] m_c2cNativeUrl];
            nativeUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
            
            NSDictionary *nativeUrlDict = [%c(WCBizUtil) dictionaryWithDecodedComponets:nativeUrl separator:@"&"];

            
            NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
            [args setObject:nativeUrlDict[@"msgtype"] forKey:@"msgType"];
            [args setObject:nativeUrlDict[@"sendid"] forKey:@"sendId"];
            [args setObject:nativeUrlDict[@"channelid"] forKey:@"channelId"];
            [args setObject:[selfContact getContactDisplayName] forKey:@"nickName"];
            [args setObject:[selfContact m_nsHeadImgUrl] forKey:@"headImg"];
            [args setObject:nativeUrl forKey:@"nativeUrl"];
            [args setObject:msgWrap.m_nsFromUsr forKey:@"sessionUserName"];
            

            
            [[[%c(MMServiceCenter) defaultCenter] getService:[%c(WCRedEnvelopesLogicMgr) class]] OpenRedEnvelopesRequest:args];
        }
    }
    %orig;
}

%end // end hook


%ctor { 
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (shouldHookFromPreference(@"autoRedOn")) {
        %init(_ungrouped);
    }
    
    [pool drain];
}