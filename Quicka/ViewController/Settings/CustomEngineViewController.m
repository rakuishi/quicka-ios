//
//  CustomEngineViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/31/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "CustomEngineViewController.h"
#import "QuickaUtil.h"

@interface CustomEngineViewController ()

@property (nonatomic) UITextField *urlField;

@end

@implementation CustomEngineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LSTR(@"Edit");
    [self.tableView registerNib:[UINib nibWithNibName:@"URLCell" bundle:nil] forCellReuseIdentifier:@"URLCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelButtonItemTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(saveButtonItemTapped)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)cancelButtonItemTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonItemTapped
{
    [QuickaUtil setCustomEngineURL:self.urlField.text];
    [self.delegate didEditCustomEngine];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"URLCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    if (self.urlField == nil) {
        self.urlField = (UITextField *)[cell viewWithTag:2];
        self.urlField.delegate = self;
        self.urlField.returnKeyType = UIReturnKeyDone;
        self.urlField.text = [QuickaUtil getCustomEngineURL];
        self.urlField.placeholder = @"URL";
    }
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.urlField resignFirstResponder];
    return YES;
}

@end
