//
//  FAQViewController.m
//  TreeHacks
//
//  Created by Divyahans Gupta on 2/3/15.
//  Copyright (c) 2015 divyahansg. All rights reserved.
//

#import "FAQViewController.h"
#import "ColorScheme.h"
#import <Parse/Parse.h>
#import <Masonry/Masonry.h>

@interface FAQViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;


@end

@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.barTintColor = [ColorScheme redColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    UILabel *titleLabel = [UILabel new];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:22.0],
                                 NSKernAttributeName: @2};
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"FAQ" attributes:attributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"FAQ"];
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
    NSString *title = [obj objectForKey:@"question"];
    CGSize expectedLabelSize = [title sizeWithFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15] constrainedToSize:CGSizeMake(self.view.frame.size.width-40, 999) lineBreakMode:NSLineBreakByWordWrapping];
    int x = expectedLabelSize.height;
    NSString *description = [obj objectForKey:@"answer"];
    expectedLabelSize = [description sizeWithFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-40, 999) lineBreakMode:NSLineBreakByWordWrapping];
    x += expectedLabelSize.height;
    
    return x + 50;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    [v setBackgroundColor:[UIColor whiteColor]];
    return v;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *obj = [self.data objectAtIndex:indexPath.row];
    UITableViewCell  *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"FAQCell"];

    if(cell == nil) {
        cell = [[UITableViewCell alloc] init];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *title = [obj objectForKey:@"question"];
        CGSize expectedLabelSize = [title sizeWithFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15] constrainedToSize:CGSizeMake(self.view.frame.size.width-40, 999) lineBreakMode:NSLineBreakByWordWrapping];
        int x = expectedLabelSize.height;
        
        NSString *desc = [obj objectForKey:@"answer"];
        expectedLabelSize = [desc sizeWithFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-40, 999) lineBreakMode:NSLineBreakByWordWrapping];
        int y = expectedLabelSize.height;
        
        
        UIView *titleBG = [[UIView alloc] initWithFrame:CGRectZero];
        titleBG.backgroundColor = [UIColor whiteColor];
        [cell addSubview:titleBG];

        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15]];

        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setNumberOfLines:0];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [titleBG addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0).with.offset(20);;
            make.right.equalTo(@0).with.offset(-20);;
            make.height.equalTo([NSNumber numberWithInt:(x+10)]);
        }];
        
        [titleBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).with.offset(5);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.width.equalTo(cell);
            make.height.equalTo(titleLabel);
        }];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [ColorScheme orangeColor];
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleBG.mas_bottom).with.offset(5);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@1);
        }];
        
        
        UILabel *descriptionLabel = [[UILabel alloc] init];
        [descriptionLabel setTextAlignment:NSTextAlignmentLeft];
        [descriptionLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14]];
        [cell addSubview:descriptionLabel];
        [descriptionLabel setTextColor:[ColorScheme fontColor]];
        [descriptionLabel setNumberOfLines:0];
        [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(10);
            make.left.equalTo(@0).with.offset(20);;
            make.right.equalTo(@0).with.offset(-20);;
            make.height.lessThanOrEqualTo([NSNumber numberWithInt:(y+20)]);
        }];
        
        [titleLabel setText:[obj objectForKey:@"question"]];
        [descriptionLabel setText:[obj objectForKey:@"answer"]];

    }
    return cell;
}


@end
