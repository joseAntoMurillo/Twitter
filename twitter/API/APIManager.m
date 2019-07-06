//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"5lUJuO5AUpPUCez4ewYDFrtgh";
static NSString * const consumerSecret = @"s5ynGqXzstUZwFPxVyMDkYh197qvHOcVM3kwv1o2TKhS1avCdS";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    // Create a GET Request
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       // Success
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, nil);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // There was a problem
       completion(nil, error);
   }];
    
    /*
     [self GET:@"1.1/statuses/home_timeline.json"
     parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
     
     // Manually cache the tweets. If the request fails, restore from cache if possible.
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
     [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
     completion(tweetDictionaries, nil);
     
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
     NSArray *tweetDictionaries = nil;
     
     // Fetch tweets from cache if possible
     NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
     if (data != nil) {
     tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
     }
     
     completion(tweetDictionaries, error);
     }];
     */
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


- (void)favoriteTweet: (Tweet *)tweet withState:(BOOL)favorited andCompletion:(void (^)(Tweet *,BOOL,NSError *))completion{
    
    NSString *urlString = [[NSString alloc] init];
    
    if (!favorited) {
        urlString = @"1.1/favorites/create.json";
    } else {
        urlString = @"1.1/favorites/destroy.json";
    }
    
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, favorited, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, favorited, error);
    }];
}

- (void)retweet: (Tweet *)tweet withState:(BOOL)retweeted andCompletion:(void (^)(Tweet *, NSError *))completion{
    
    NSString *actualString = [[NSString alloc] init];
    
    if (!retweeted) {
        actualString = [@"1.1/statuses/retweet/" stringByAppendingString:tweet.idStr];
    } else {
        actualString = [@"1.1/statuses/unretweet/" stringByAppendingString:tweet.idStr];
    }
    
    NSString *fullString = [actualString stringByAppendingString:@".json"];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    
    [self POST:fullString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
