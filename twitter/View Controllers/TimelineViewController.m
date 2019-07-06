//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "DetailsView.h"
#import "NSDate+DateTools.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents: UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchTweets {
    // API Manager calls the completion handler passing back data
   [[APIManager shared] getHomeTimelineWithParam:nil WithCompletion:^(NSArray *tweets, NSError *error)  {
        if (tweets) {
            
            // View controller stores the data passed in the completion handler
            self.tweetsArray = (NSMutableArray *)tweets;
            [self.tableView reloadData];
            
            /*
             NSLog(@"😎😎😎 Successfully loaded home timeline");
             for (NSDictionary *dictionary in tweets) {
             NSString *text = dictionary[@"text"];
             NSLog(@"%@", text);
             }
             */
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Creates an objet to represent a cell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    // Objects to hold each tweet's data
    Tweet *tweet = self.tweetsArray[indexPath.row];
    cell.tweet = tweet;
    
    [cell refreshData];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ComposerView"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
    } else {
        // Gets appropiate data corresponding to the tweet that the user selected
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweetsArray[indexPath.row];
        
        // Get the new view controller using [segue destinationViewController].
        DetailsView *detailsView = [segue destinationViewController];
        
        // Pass the selected object to the new view controller
        detailsView.tweet = tweet;
    }
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweetsArray insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (IBAction)clickLogout:(id)sender {
    NSLog(@"0");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"1");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSLog(@"2");
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    NSLog(@"3");
    appDelegate.window.rootViewController = loginViewController;
    NSLog(@"4");
    
    [[APIManager shared] logout];
    NSLog(@"5");
}

-(void)loadMoreData{
    Tweet *lastTweet = [self.tweetsArray lastObject];
    // NSNumber  *aNum = [NSNumber numberWithInteger: [string integerValue]];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:lastTweet.idStr];
    long lastTweetString = [myNumber longValue];
    long actualID = lastTweetString - 1;
    NSNumber *maxID = @(actualID);
    NSDictionary *parameter = @{@"max_id": maxID};
    [[APIManager shared] getHomeTimelineWithParam:(NSDictionary  *)parameter WithCompletion:^(NSArray *tweets, NSError *error){
        
        if (error != nil) {
        }
        else
        {
            // Update flag
            self.isMoreDataLoading = false;
            [self.tweetsArray addObjectsFromArray:tweets];
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            [self.tableView reloadData];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading) {
        // self.isMoreDataLoading = true;
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
}

@end
