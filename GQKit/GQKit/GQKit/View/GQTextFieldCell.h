

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,GQTextFieldType)
{
    GQTextFieldTypeOfOther, // 其他
    GQTextFieldTypeOfPhone, // 电话
    GQTextFieldTypeOfMsgCode, // 短信验证码
    GQTextFieldTypeOfYanzhenCode, // 验证码
    GQTextFieldTypeOfPassword, // 密码
    GQTextFieldTypeOfBankCard, // 银行卡
};


@interface GQTextFieldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImView;
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
/** 最后面contentV的宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVCons;
@property (nonatomic, assign) GQTextFieldType gq_textFieldType;
/** GQTextFieldTypeOfOther的输入长度 默认无限 */
@property (nonatomic, assign) NSInteger gq_typeOfOtherMaxLength;
/** 设置textF占位 */
- (void)gq_setPlaceColor:(UIColor *)placeColor placeStr:(NSString *)placeStr;
/** GQTextFieldTypeOfMsgCode 获取验证码回调 */
@property (nonatomic, copy) void(^gq_msgBtnBlock)(UIButton *msgBtn);

/** textF文本改变回调 */
@property (nonatomic, copy) void(^gq_textFBlock)(NSString *text);
/** textF开始编辑回调 */
@property (copy, nonatomic) void (^gq_textFBeginBlock)(NSString *text);
/** textF结束编辑回调 */
@property (nonatomic, copy) void(^gq_textFEndBlock)(NSString *text);
/** textF点击键盘完成回调 */
@property (nonatomic, copy) void(^gq_textFieldShouldReturnBlock)(UITextField *);

/** 验证码按钮点击后的UI改变 */
- (void)gq_msgBtnUIChangeWhenClick;
@end
