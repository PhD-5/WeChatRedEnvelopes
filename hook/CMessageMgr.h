@interface WCPayInfoItem : NSObject
@property(retain, nonatomic) NSString *m_c2cNativeUrl; 
@end

@interface CMessageWrap : NSObject
@property(retain, nonatomic) NSString *m_nsContent; 
@property(nonatomic) unsigned long m_uiStatus;
@property(nonatomic) unsigned long m_uiMessageType;
@property(retain, nonatomic) WCPayInfoItem *m_oWCPayInfoItem;
@property(retain, nonatomic) NSString *m_nsFromUsr;
@end

@interface WCRedEnvelopesLogicMgr : NSObject
- (void)OpenRedEnvelopesRequest:(id)arg1;
@end

@interface MMServiceCenter : NSObject   
+ (id)defaultCenter;
- (id)getService:(Class)arg1;
@end

@interface CContactMgr : NSObject
- (id)getSelfContact;
@end

@interface CBaseContact : NSObject
@property(retain, nonatomic) NSString *m_nsHeadImgUrl;
- (id)getContactDisplayName;
@end

@interface WCBizUtil : NSObject
+ (id)dictionaryWithDecodedComponets:(id)arg1 separator:(id)arg2;
@end