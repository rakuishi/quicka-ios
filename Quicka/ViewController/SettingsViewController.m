//
//  SettingsViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/2/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "SettingsViewController.h"
#import "SearchEngineViewController.h"
#import "QuickaUtil.h"

typedef enum kSection : NSUInteger {
    kSectionSettingsMain,
    kSectionSettingsSub,
    kSectionCache,
    kSectionAbout,
    kSectionFeedback,
    kSectionLisence,
    kSectionCount
} kSection;

@interface SettingsViewController ()

@property (nonatomic, strong) UISwitch *clearTextAfterSearchSwitch;
@property (nonatomic, strong) UISwitch *useSuggestViewSwitch;
@property (nonatomic, strong) NSString *cacheSizeDescription;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = LSTR(@"Settings");
    self.cacheSizeDescription = @"\n";

    self.useSuggestViewSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.useSuggestViewSwitch setTag:0];
    [self.useSuggestViewSwitch setOn:[QuickaUtil isOnForKey:kQuickaUseSuggestView]];
    [self.useSuggestViewSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];

    self.clearTextAfterSearchSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.clearTextAfterSearchSwitch setTag:1];
    [self.clearTextAfterSearchSwitch setOn:[QuickaUtil isOnForKey:kQuickaClearTextAfterSearch]];
    [self.clearTextAfterSearchSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonItemTapped)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    
    [self loadCacheSizeDescriptionOnAsync];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)doneButtonItemTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchValueChanged:(UISwitch *)view
{
    switch (view.tag) {
        case 0:
            [QuickaUtil setOn:view.on forKey:kQuickaUseSuggestView];
            break;
        case 1:
            [QuickaUtil setOn:view.on forKey:kQuickaClearTextAfterSearch];
            break;
        default:
            break;
    }
}

- (void)loadCacheSizeDescriptionOnAsync
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.cacheSizeDescription = [NSString stringWithFormat:LSTR(@"%.1lf MB Used"), [QuickaUtil getCacheSizeInMegaBytes]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kSectionCache] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kSectionSettingsMain:
            return 3;
        case kSectionSettingsSub:
            return 1;
        case kSectionAbout:
            return 4;
        default:
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kSectionAbout:
            return @"About Quicka2";
        case kSectionLisence:
            return @"3rd Party Licenses";
        default:
            return nil;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == kSectionCache) {
        return self.cacheSizeDescription;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == kSectionLisence) ? 150.f : 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kSectionSettingsMain: {
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"EngineCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                cell.textLabel.text = LSTR(@"Search Engine");
                cell.detailTextLabel.text = [QuickaUtil getSearchEngineName];
                return cell;
            } else {
                static NSString *CellIdentifier = @"BasicCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                switch (indexPath.row) {
                    case 1:
                        cell.accessoryView = self.clearTextAfterSearchSwitch;
                        cell.textLabel.text = LSTR(@"Clear After Search");
                        break;
                    case 2:
                        cell.accessoryView = self.useSuggestViewSwitch;
                        cell.textLabel.text = LSTR(@"Use Suggest");
                        break;
                    default:
                        break;
                }
                return cell;
            }
        }
        case kSectionSettingsSub : {

            if (indexPath.row == 0) {
                
                static NSString *CellIdentifier = @"BrowserCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                cell.textLabel.text = LSTR(@"Browser");
                cell.detailTextLabel.text = LSTR([QuickaUtil getBrowserName]);
                return cell;
                
            }
        }
        case kSectionCache: {
            
            static NSString *CellIdentifier = @"CenterCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = LSTR(@"Clear Cache");
            return cell;
        }
        case kSectionAbout: {

            static NSString *CellIdentifier = @"AboutCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (indexPath.row == 0) {
                cell.textLabel.text = LSTR(@"Version");
                cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = LSTR(@"Developed by");
                cell.detailTextLabel.text = @"rakuishi";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = LSTR(@"Support");
                cell.detailTextLabel.text = @"rakuishi.com/quicka2/";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                cell.textLabel.text = LSTR(@"Privacy Policy");
                cell.detailTextLabel.text = @"";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            
            return cell;
        }
        case kSectionFeedback: {
            
            static NSString *CellIdentifier = @"CenterCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = LSTR(@"Feedback");
            return cell;
        }
        default: {
            
            static NSString *CellIdentifier = @"LisenceCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kSectionSettingsMain:
            break;
        case kSectionSettingsSub:
            break;
        case kSectionAbout:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if (indexPath.row == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rakuishi.com"] options:@{} completionHandler:nil];
            } else if (indexPath.row == 2) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rakuishi.com/quicka2/"] options:@{} completionHandler:nil];
            } else if (indexPath.row == 3) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://rakuishi.github.io/privacy-policy/quicka2.html"] options:@{} completionHandler:nil];
            }
            break;
        case kSectionCache:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [QuickaUtil removeCache];
            [self loadCacheSizeDescriptionOnAsync];
            [self.tableView reloadData];
            break;
        case kSectionFeedback:
            [self sendFeedback];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        default:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
    }
}

#pragma mark -

- (void)sendFeedback
{
    // メール下準備
    MFMailComposeViewController *composeViewController = [MFMailComposeViewController new];
    composeViewController.mailComposeDelegate = self;

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *body = @"";
    body = [body stringByAppendingString:@"\n\n\n"];
    body = [body stringByAppendingFormat:@"Device: %@\n", [self platform]];
    body = [body stringByAppendingFormat:@"iOS: %@\n", [[UIDevice currentDevice] systemVersion]];
    body = [body stringByAppendingFormat:@"App: Quicka2 %@", version];

    [composeViewController setMessageBody:body isHTML:NO];
    [composeViewController setSubject:@"[Quicka2 Feedback]"];
    [composeViewController setToRecipients:@[@"rakuishi@gmail.com"]];
    [self presentViewController:composeViewController animated:YES completion:nil];
}

- (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
