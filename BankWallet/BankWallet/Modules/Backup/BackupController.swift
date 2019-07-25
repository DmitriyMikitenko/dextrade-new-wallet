import UIKit
import SnapKit

class BackupController: WalletViewController {
    private let delegate: IBackupViewDelegate

    private let subtitleLabel = UILabel()
    private let cancelButton = UIButton()
    private let proceedButton = UIButton()

    init(delegate: IBackupViewDelegate) {
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "backup.intro.title".localized

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        view.addSubview(subtitleLabel)
        subtitleLabel.text = "backup.intro.subtitle".localized(delegate.coinCodes.localized)
        subtitleLabel.font = BackupTheme.descriptionFont
        subtitleLabel.textColor = BackupTheme.descriptionColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(BackupTheme.sideMargin)
            maker.trailing.equalToSuperview().offset(-BackupTheme.sideMargin)
            maker.top.equalTo(self.view.snp.topMargin).offset(BackupTheme.introDescriptionTopMargin)
        }

        view.addSubview(cancelButton)
        cancelButton.setTitle("backup.intro.later".localized, for: .normal)
        cancelButton.cornerRadius = BackupTheme.buttonCornerRadius
        cancelButton.setBackgroundColor(color: BackupTheme.laterButtonBackground, forState: .normal)
        cancelButton.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        cancelButton.setTitleColor(BackupTheme.buttonTitleColor, for: .normal)
        cancelButton.titleLabel?.font = BackupTheme.buttonTitleFont
        cancelButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(BackupTheme.sideMargin)
            maker.bottom.equalToSuperview().offset(-BackupTheme.sideMargin)
            maker.size.equalTo(CGSize(width: BackupTheme.laterButtonWidth, height: BackupTheme.buttonHeight))
        }

        view.addSubview(proceedButton)
        proceedButton.setTitle("backup.intro.backup_now".localized, for: .normal)
        proceedButton.cornerRadius = BackupTheme.buttonCornerRadius
        proceedButton.setBackgroundColor(color: BackupTheme.backupButtonBackground, forState: .normal)
        proceedButton.addTarget(self, action: #selector(proceedDidTap), for: .touchUpInside)
        proceedButton.setTitleColor(BackupTheme.buttonTitleColor, for: .normal)
        proceedButton.titleLabel?.font = BackupTheme.buttonTitleFont
        proceedButton.snp.makeConstraints { maker in
            maker.leading.equalTo(cancelButton.snp.trailing).offset(BackupTheme.buttonsGap)
            maker.trailing.equalToSuperview().offset(-BackupTheme.sideMargin)
            maker.bottom.equalToSuperview().offset(-BackupTheme.sideMargin)
            maker.height.equalTo(BackupTheme.buttonHeight)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppTheme.statusBarStyle
    }

    @objc func proceedDidTap() {
        delegate.proceedDidTap()
    }

    @objc func cancelDidTap() {
        delegate.cancelDidClick()
    }

}
