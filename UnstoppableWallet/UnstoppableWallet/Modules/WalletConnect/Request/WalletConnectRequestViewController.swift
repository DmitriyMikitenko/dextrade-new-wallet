import Foundation
import UIKit
import ThemeKit
import RxSwift
import RxCocoa


class WalletConnectRequestViewController: SendEvmTransactionViewController {
    private let viewModel: WalletConnectSendEthereumTransactionRequestViewModel

    private let approveButton = PrimaryButton()
    private let rejectButton = PrimaryButton()

    init(viewModel: WalletConnectSendEthereumTransactionRequestViewModel, transactionViewModel: SendEvmTransactionViewModel, settingsViewModel: EvmSendSettingsViewModel) {
        self.viewModel = viewModel

        super.init(transactionViewModel: transactionViewModel, settingsViewModel: settingsViewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "wallet_connect.request_title".localized
        isModalInPresentation = true

        bottomWrapper.addSubview(approveButton)

        approveButton.set(style: .yellow)
        approveButton.setTitle("wallet_connect.button.confirm".localized, for: .normal)
        approveButton.addTarget(self, action: #selector(onTapApprove), for: .touchUpInside)

        bottomWrapper.addSubview(rejectButton)

        rejectButton.set(style: .gray)
        rejectButton.setTitle("button.reject".localized, for: .normal)
        rejectButton.addTarget(self, action: #selector(onTapReject), for: .touchUpInside)

        subscribe(disposeBag, transactionViewModel.sendEnabledDriver) { [weak self] in self?.approveButton.isEnabled = $0 }
    }

    @objc private func onTapApprove() {
        transactionViewModel.send()
    }

    @objc private func onTapReject() {
        viewModel.reject()

        dismiss(animated: true)
    }
    override func handleSending() {
        HudHelper.instance.show(banner: .approving)
    }

    override func handleSendSuccess(transactionHash: Data) {
        viewModel.approve(transactionHash: transactionHash)
        HudHelper.instance.show(banner: .approved)

        super.handleSendSuccess(transactionHash: transactionHash)
    }

}
