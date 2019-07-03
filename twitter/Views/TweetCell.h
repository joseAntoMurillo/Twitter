//
//  TweetCell.h
//  twitter
//
//  Created by josemurillo on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateView;
@property (weak, nonatomic) IBOutlet UILabel *userView;
@property (weak, nonatomic) IBOutlet UILabel *authorView;
@property (weak, nonatomic) IBOutlet UILabel *tweetView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIButton *favorIcon;
@property (weak, nonatomic) IBOutlet UIButton *retweetIcon;
@property (weak, nonatomic) IBOutlet UILabel *heartCount;
@property (weak, nonatomic) IBOutlet UILabel *arrowCount;

@property (strong, nonatomic) Tweet *tweet;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
