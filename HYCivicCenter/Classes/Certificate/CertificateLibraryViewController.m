//
//  CertificateLibraryViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/9.
//

#import "CertificateLibraryViewController.h"
#import "CertificateLibraryTableViewCell.h"
#import "CertificateDetailViewController.h"
#import <CTID_Verification/CTID_Verification.h>
#import "MyCtidViewController.h"
#import "HYCivicCenterCommand.h"

@interface CertificateLibraryViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;

@end

NSString *const certificateCellLibrary = @"certificateCell";
@implementation CertificateLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest postPath:@"/phone/v2/idPhoto/getIdPhotoList" params:@{@"idPhotoType":self.type == 0 ? @"personal" : @"enterprise"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 证件照== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [CertificateModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.type == 0) {
                NSString *CTID = [[NSUserDefaults standardUserDefaults]objectForKey:@"CTID"];
                CtidVerifySdk *ctidVerifyTool = [[CtidVerifySdk alloc]init];
                NSDictionary *dict = [ctidVerifyTool getCtidNum:CTID];
                NSLog(@" 网证编号和有效期 == %@ ",dict);
                
                CertificateModel *model = [[CertificateModel alloc]init];
                model.name = @"居民身份网络可信凭证";
                if (CTID.length > 0) {
                    model.id_code = [NSString stringWithFormat:@"网证编号 %@",dict[@"SerialNumber"]];
                }else {
                    model.id_code = [NSString stringWithFormat:@"网证编号 暂未获取网证或网证已过期"];
                }
                model.holder_identity_num = @"110";
                model.license_item_code = @"110";
                [self.datasArr insertObject:model atIndex:0];
            }
            
            [self.tableView reloadData];
        }

    }];
    
}

- (void)configUI {
    
//    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightbutton addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
//    [rightbutton setTitle:@"亮证设置" forState:UIControlStateNormal];
//    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rightbutton.titleLabel.font = RFONT(15);
//    rightbutton.frame = CGRectMake(0 , 0, 60, 44);
//
//    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:rightbutton];
//
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//
//    spaceItem.width = -15;
//    self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CertificateLibraryTableViewCell class] forCellReuseIdentifier:certificateCellLibrary];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

#pragma TableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CertificateLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:certificateCellLibrary];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.datasArr[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CertificateModel *model = self.datasArr[indexPath.row];
    if ([model.holder_identity_num isEqualToString:@"110"]) {// 网证
        
        MyCtidViewController *ctidVC = [[MyCtidViewController alloc]init];
        [self.navigationController pushViewController:ctidVC animated:YES];
        
    }else {
        
        CertificateDetailViewController *detailVC = [[CertificateDetailViewController alloc]init];
        detailVC.cardName = model.name;
        detailVC.cardNum = model.id_code;
        detailVC.holder_identity_num = model.holder_identity_num_encrypt;
        detailVC.license_item_code = model.license_item_code;
        detailVC.idPhoneType = self.type == 0 ? @"personal" : @"enterprise";
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if (scrollView.contentOffset.y > sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

- (void)rightClicked {
    
    
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = (SCREEN_WIDTH - 90) * 0.41 + 52;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
    
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [[NSMutableArray alloc]init];
    }
    return _datasArr;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
