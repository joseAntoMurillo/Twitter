//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;

- (void)favoriteTweet: (Tweet *)tweet withState:(BOOL)favorited andCompletion:(void (^)(Tweet *,BOOL,NSError *))completion;

- (void)retweet: (Tweet *)tweet withState:(BOOL)retweeted andCompletion:(void (^)(Tweet *, NSError *))completion;

@end
