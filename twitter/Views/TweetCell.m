//
//  TweetCell.m
//  twitter
//
//  Created by Milto Geleta on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    // Update the local tweet model
    if (self.tweet.favorited == YES) {
        self.tweet.favoriteCount -= 1;
        self.tweet.favorited = NO;
        [self.favoritesButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        // Send a POST request to the POST unfavorite
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    else {
        self.tweet.favoriteCount += 1;
        self.tweet.favorited = YES;
        [self.favoritesButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        // Send a POST request to the POST favorite
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    
    // Update cell UI
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
    // Update the local tweet model
    if (self.tweet.retweeted == YES) {
        self.tweet.retweetCount -= 1;
        self.tweet.retweeted = NO;
        [self.retweetsButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        // Send a POST request to the POST unretweet
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
    else {
        self.tweet.retweetCount += 1;
        self.tweet.retweeted = YES;
        [self.retweetsButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        // Send a POST request to the POST favorite
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
    
    // Update cell UI
    [self refreshData];
}

-(void)refreshData {
    
    self.nameLabel.text = self.tweet.user.name;
    NSString *at = @"@";
    self.atLabel.text = [at stringByAppendingString:self.tweet.user.screenName];
    self.tweetLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.createdAtString;
    
    NSString *rtcount = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    [self.retweetsButton setTitle:rtcount forState:UIControlStateNormal];
    
    NSString *fvcount = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    [self.favoritesButton setTitle:fvcount forState:UIControlStateNormal];
    
    NSString *URLString = self.tweet.user.profilePicture;
    [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profileView.image = [UIImage imageWithData:urlData];
    
}

@end
