//
//  FAQViewController.m
//  TreeHacks
//
//  Created by Divyahans Gupta on 2/3/15.
//  Copyright (c) 2015 divyahansg. All rights reserved.
//

#import "AnnounceViewController.h"
#import "ColorScheme.h"
#import <Parse/Parse.h>
#import <Masonry/Masonry.h>


@interface AnnounceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;


@end

@implementation AnnounceViewController

- (void) viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
    
    
    self.navigationController.navigationBar.barTintColor = [ColorScheme redColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    UILabel *titleLabel = [UILabel new];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:22.0],
                                 NSKernAttributeName: @2};
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"NOTIFICATIONS" attributes:attributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Push"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            self.data = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void) refresh:(id)sender
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Push"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            self.data = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *obj = [self.data objectAtIndex:indexPath.row];
    NSString *title = [obj objectForKey:@"title"];
    CGSize expectedLabelSize = [title sizeWithFont:[UIFont fontWithName:@"AvenirNext-Regular" size:18] constrainedToSize:CGSizeMake(self.view.frame.size.width-140, 999) lineBreakMode:NSLineBreakByWordWrapping];
    int x = expectedLabelSize.height;
    NSString *description = [obj objectForKey:@"description"];
    if(description != nil && description.length > 0) {
        expectedLabelSize = [description sizeWithFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-40, 999) lineBreakMode:NSLineBreakByWordWrapping];
        x += expectedLabelSize.height;
        x += 5;
    }
    
    return x + 20;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *obj = [self.data objectAtIndex:indexPath.row];
    UITableViewCell  *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"FAQCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] init];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *title = [obj objectForKey:@"title"];
        CGSize expectedLabelSize = [title sizeWithFont:[UIFont fontWithName:@"AvenirNext-Regular" size:18] constrainedToSize:CGSizeMake(self.view.frame.size.width-140, 999) lineBreakMode:NSLineBreakByWordWrapping];
        int x = expectedLabelSize.height;
        
        NSString *desc = [obj objectForKey:@"description"];
        expectedLabelSize = [desc sizeWithFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-40, 999) lineBreakMode:NSLineBreakByWordWrapping];
        int y = expectedLabelSize.height;
        
        
        UIView *titleBG = [[UIView alloc] initWithFrame:CGRectZero];
        [cell addSubview:titleBG];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:18]];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:12]];
        [timeLabel setTextColor:[ColorScheme fontColor]];
        [titleBG addSubview:timeLabel];
        
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setNumberOfLines:0];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [titleBG addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0).with.offset(20);;
            make.right.equalTo(timeLabel.mas_left);
            make.height.equalTo([NSNumber numberWithInt:(x+5)]);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(titleLabel.mas_right).with.offset(0);
            make.right.equalTo(@0).with.offset(-20);
            make.width.equalTo(@100);
            make.height.equalTo([NSNumber numberWithInt:(x+5)]);
        }];
        
        
        [titleBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).with.offset(5);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.width.equalTo(cell);
            make.height.equalTo(titleLabel);
        }];
        UILabel *descriptionLabel;
        BOOL hasDescription = false;
        if(desc != nil && desc.length > 0) {
            hasDescription = true;
            descriptionLabel = [[UILabel alloc] init];
            [descriptionLabel setTextAlignment:NSTextAlignmentLeft];
            [descriptionLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14]];
            [cell addSubview:descriptionLabel];
            [descriptionLabel setTextColor:[ColorScheme fontColor]];
            [descriptionLabel setNumberOfLines:0];
            [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleBG.mas_bottom).offset(5);
                make.left.equalTo(@0).with.offset(20);;
                make.right.equalTo(@0).with.offset(-20);;
                make.height.lessThanOrEqualTo([NSNumber numberWithInt:(y+10)]);
            }];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [ColorScheme orangeColor];
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@1);
            make.bottom.equalTo(@0);
        }];
        
        
        
        [titleLabel setText:[obj objectForKey:@"title"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
        [dateFormatter setDateFormat:@"EEE h:mm a"];
        NSDate *created = [obj updatedAt];
        NSMutableString *result = [NSMutableString string];
        NSDateComponents *dateDiff = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit
                                                                     fromDate:created
                                                                       toDate:[NSDate date]
                                                                      options:0];
        
        NSInteger minutes = ([dateDiff second] / 60);
        NSInteger hours = (([dateDiff second] / 60) / 60);
        if([dateDiff second] < 10) {
            [result appendString:@"Just now"];
        } else if ([dateDiff second] < 60*60) {
            [result appendFormat:@"%ld mins ago",
             (minutes + 1)];
        } else if ([dateDiff second] < (60*60 * 12)) {
            [result appendFormat:@"%ld hour%@ ago",
             (long)(hours+1),
             (hours < 1) ? @"" : @"s"];
        } else {
            result = [[NSMutableString alloc] initWithString:[dateFormatter stringFromDate:created]];
        }

        [timeLabel setText:result];
        
        
        
        if([obj objectForKey:@"description"] != nil) {
            [descriptionLabel setText:[obj objectForKey:@"description"]];
        } else {
            [descriptionLabel setText:@""];
        }
        
    }
    return cell;
}


@end
