//
//  HonorwallDetailViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/8.
//

#import "HonorwallDetailViewController.h"
#import "HonorWallTableViewCell.h"

@interface HonorwallDetailViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *describLabel;
@property (nonatomic, strong) UIImageView *photoOneIV;
@property (nonatomic, strong) UIImageView *photoTwoIV;
@property (nonatomic, strong) UIImageView *photoThrIV;
@property (nonatomic, strong) HonorWallModel *honorModel;

@end

@implementation HonorwallDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"荣誉详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"荣誉详情"];
    
}

- (void)loadData {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0022",@"applicationId":@"H017"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
    [HttpRequest postPath:@"/phone/v1/honor/info" params:@{@"id":self.honorId} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"荣誉墙详情 == %@",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.honorModel = [HonorWallModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self configUI];
        }
    }];
    
}

- (void)configUI {
    
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    [self.view addSubview:self.scrollView];
    [self headerView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
    
}

- (void)headerView {
    
    UIView *contentView = [[UIView alloc]init];
    [self.scrollView addSubview:contentView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    self.nameLabel.font = RFONT(16);
    self.nameLabel.text = self.honorModel.honorName;
    [contentView addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = UIColorFromRGB(0x999999);
    self.timeLabel.font = RFONT(12);
    self.timeLabel.text = [NSString stringWithFormat:@"上传时间：%@",self.honorModel.createTime];
    [contentView addSubview:self.timeLabel];
    
    self.deleteBtn = [[UIButton alloc]init];
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.deleteBtn];
    
    self.describLabel = [[UILabel alloc]init];
    self.describLabel.font = RFONT(12);
    self.describLabel.textColor = UIColorFromRGB(0x666666);
    self.describLabel.numberOfLines = 0;
    self.describLabel.text = self.honorModel.honorRemark;
    [contentView addSubview:self.describLabel];
    
    self.photoOneIV = [[UIImageView alloc]init];
    [self.photoOneIV sd_setImageWithURL:[NSURL URLWithString:self.honorModel.honorPhotoOne]];
    self.photoOneIV.layer.cornerRadius = 8;
    self.photoOneIV.clipsToBounds = YES;
    self.photoOneIV.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:self.photoOneIV];
    
    
    self.photoTwoIV = [[UIImageView alloc]init];
    [self.photoTwoIV sd_setImageWithURL:[NSURL URLWithString:self.honorModel.honorPhotoTwo]];
    self.photoTwoIV.layer.cornerRadius = 8;
    self.photoTwoIV.clipsToBounds = YES;
    self.photoTwoIV.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:self.photoTwoIV];
    
    self.photoThrIV = [[UIImageView alloc]init];
    [self.photoThrIV sd_setImageWithURL:[NSURL URLWithString:self.honorModel.honorPhotoThree]];
    self.photoThrIV.layer.cornerRadius = 8;
    self.photoThrIV.clipsToBounds = YES;
    self.photoThrIV.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:self.photoThrIV];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15.5);
        make.right.equalTo(contentView.mas_right).offset(-15.5);
        make.top.equalTo(contentView.mas_top).offset(20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15.5);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.5);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.top.equalTo(contentView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.describLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(18);
    }];
    
    NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.honorModel.honorPhotoOne]];
    UIImage *image1 = [UIImage imageWithData:data1];
    CGSize imageSize1 = image1.size;
    
    [self.photoOneIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.top.equalTo(self.describLabel.mas_bottom).offset(20);
//        make.height.equalTo((SCREEN_WIDTH - 64) * 0.58);
        make.height.mas_equalTo(imageSize1.height / imageSize1.width * (SCREEN_WIDTH - 32));
    }];
    
    NSData *data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.honorModel.honorPhotoOne]];
    UIImage *image2 = [UIImage imageWithData:data2];
    CGSize imageSize2 = image2.size;
    [self.photoTwoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.top.equalTo(self.photoOneIV.mas_bottom).offset(20);
//        make.height.equalTo((SCREEN_WIDTH - 64) * 0.58);
        make.height.mas_equalTo(imageSize2.height / imageSize2.width * (SCREEN_WIDTH - 32));
    }];
    
    
    NSData *data3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.honorModel.honorPhotoOne]];
    UIImage *image3 = [UIImage imageWithData:data3];
    CGSize imageSize3 = image3.size;
    [self.photoThrIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.top.equalTo(self.photoTwoIV.mas_bottom).offset(20);
//        make.height.equalTo((SCREEN_WIDTH - 64) * 0.58);
        make.height.mas_equalTo(imageSize3.height / imageSize3.width * (SCREEN_WIDTH - 32));
    }];
    
    UIImageView *lastIV = self.photoOneIV;
    if (self.honorModel.honorPhotoThree.length > 0) {
        lastIV = self.photoThrIV;
    }else if (self.honorModel.honorPhotoTwo.length > 0) {
        lastIV = self.photoTwoIV;
    }
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastIV.mas_bottom).offset(10);
    }];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
//        _tableView.tableHeaderView = [self headerView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
    
}

- (void)deleteClicked {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否删除当前荣誉" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [HttpRequest postPath:@"/phone/v1/honor/del" params:@{@"id":self.honorId} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            
            NSLog(@" 删除荣誉墙 == %@ ",responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteHonorDetail)]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.delegate deleteHonorDetail];
                }
            }
            
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:confirmAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
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
