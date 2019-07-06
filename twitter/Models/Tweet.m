//
//  Tweet.m
//  twitter
//
//  Created by josemurillo on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@implementation Tweet

// Method initializaes the object and returns a tweet
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        // initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        // Configure output format
        NSDate *convertedDate = [formatter dateFromString:createdAtOriginalString];
        NSDate *todayDate = [NSDate date];
        double ti = [convertedDate timeIntervalSinceDate:todayDate];
        ti = ti * -1;
        if(ti < 1) {
            self.createdAtString = @"never";
        } else  if (ti < 60) {
            self.createdAtString = @"less than a minute ago";
        } else if (ti < 3600) {
            int diff = round(ti / 60);
            self.createdAtString = [NSString stringWithFormat:@"%d minutes ago", diff];
        } else if (ti < 86400) {
            int diff = round(ti / 60 / 60);
            self.createdAtString = [NSString stringWithFormat:@"%d minutes ago", diff];
        } else if (ti < 2629743) {
            int diff = round(ti / 60 / 60 / 24);
            self.createdAtString = [NSString stringWithFormat:@"%d minutes ago", diff];
        } else {
            formatter.dateStyle = NSDateFormatterShortStyle;
            formatter.timeStyle = NSDateFormatterNoStyle;
            // Convert Date to String
            self.createdAtString = [formatter stringFromDate:date];
        }
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
