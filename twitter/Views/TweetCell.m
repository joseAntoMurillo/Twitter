//
//  TweetCell.m
//  twitter
//
//  Created by josemurillo on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
- (IBAction)didTapFavor:(id)sender {
    if (self.tweet.favorited){
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self.favorIcon setSelected:NO];
                [self refreshData];
            }
        }];
        
    } else {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                [self.favorIcon setSelected:YES];
                [self refreshData];
            }
        }];
    }
}
*/

- (IBAction)didTapFavor:(id)sender {
    [[APIManager shared] favoriteTweet:self.tweet withState:self.tweet.favorited andCompletion:^(Tweet *tweet, BOOL hasRetweeted, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            if (hasRetweeted) {
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self.favorIcon setSelected:NO];
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
            else {
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                [self.favorIcon setSelected:YES];
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
            [self refreshData];
        }
    }];
}

- (IBAction)didTapRetweet:(id)sender {
    [[APIManager shared] retweet:self.tweet withState:self.tweet.retweeted andCompletion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            if (self.tweet.retweeted) {
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self.retweetIcon setSelected:NO];
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
            else {
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self.retweetIcon setSelected:YES];
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
           }
            [self refreshData];
        }
    }];
}

- (void)refreshData {
    
    User *tweetUser = self.tweet.user;
    
    self.authorView.text = tweetUser.name;
    NSString *username = [@"@" stringByAppendingString: tweetUser.screenName];
    self.userView.text = username;
    self.dateView.text = self.tweet.createdAtString;
    self.tweetView.text = self.tweet.text;
    [self.favorIcon setTitle:[NSString stringWithFormat:@"%d",self.tweet.favoriteCount] forState:UIControlStateNormal];
    [self.retweetIcon setTitle:[NSString stringWithFormat:@"%d",self.tweet.retweetCount] forState:UIControlStateNormal];
    
    NSString *profileImg = tweetUser.profileURL;
    NSURL *profileURL = [NSURL URLWithString:profileImg];
    self.posterView.image = nil;
    [self.posterView setImageWithURL:profileURL];
    
    [self.favorIcon setImage: [UIImage imageNamed:@"favor-icon"]
                    forState: UIControlStateNormal];
    [self.favorIcon setImage: [UIImage imageNamed:@"favor-icon-red"]
                    forState: UIControlStateSelected];
    [self.retweetIcon setImage: [UIImage imageNamed:@"retweet-icon"]
                      forState: UIControlStateNormal];
    [self.retweetIcon setImage: [UIImage imageNamed:@"retweet-icon-green"]
                      forState: UIControlStateSelected];
}

@end
