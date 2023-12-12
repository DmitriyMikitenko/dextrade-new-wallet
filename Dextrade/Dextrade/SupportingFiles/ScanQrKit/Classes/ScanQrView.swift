import UIKit
import AVFoundation
import UIExtensions

public class ScanQrView: UIView {
    private let scanQueue = DispatchQueue(label: "io.horizontalsystems.lightning.scan_view", qos: .default)
    private let sideMargin: CGFloat = .margin24

    public weak var delegate: IScanQrCodeDelegate?

    private var captureSession: AVCaptureSession!
    private var metadataOutput: AVCaptureMetadataOutput?
    private let previewLayer: AVCaptureVideoPreviewLayer

    private let bottomInset: CGFloat
    private let blurView: ScanQrBlurView
    private let alertView = ScanQrAlertView()

    private var initiallySetUp = false

    override open var bounds: CGRect {
        didSet {
            previewLayer.frame = layer.bounds
        }
    }

    public init(bottomInset: CGFloat) {
        captureSession = AVCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        self.bottomInset = bottomInset
        blurView = ScanQrBlurView(sideMargin: sideMargin, bottomInset: bottomInset)

        super.init(frame: .zero)

        previewLayer.frame = layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        layer.addSublayer(previewLayer)

        addSubview(blurView)
        blurView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        let alertWrapper = UIView()

        addSubview(alertWrapper)
        alertWrapper.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
            maker.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(bottomInset)
        }

        alertWrapper.addSubview(alertView)
        alertView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(sideMargin)
            maker.height.equalTo(alertView.snp.width)
        }

        alertView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        scanQueue.async { () -> Void in
            do {
                guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
                    self.failed()
                    return
                }
                let videoInput: AVCaptureDeviceInput

                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                guard self.captureSession.canAddInput(videoInput) else {
                    self.failed()
                    return
                }
                self.captureSession.addInput(videoInput)

                let metadataOutput = AVCaptureMetadataOutput()
                self.metadataOutput = metadataOutput
                if (self.captureSession.canAddOutput(metadataOutput)) {
                    self.captureSession.addOutput(metadataOutput)

                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr]
                    DispatchQueue.main.async {
                        self.updateRectOfInterest()
                    }
                } else {
                    self.failed()
                }
            } catch {
            }
        }
    }

    private func updateRectOfInterest() {
        guard !width.isZero && !height.isZero else {
            return
        }

        let maskSize = width - sideMargin * 2
        let bottomPadding = safeAreaInsets.bottom + bottomInset
        let verticalContainerHeight = height - bottomPadding
        let verticalMargin = (verticalContainerHeight - maskSize) / 2

        let rect = CGRect(x: sideMargin, y: verticalMargin, width: maskSize, height: maskSize)
        metadataOutput?.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: rect)
    }

    private func failed() {
        captureSession = nil
        DispatchQueue.main.async {
            self.showAlert(title: "access_camera.not_supported".localized)
        }
    }

    private func showAlert(title: String, actionText: String? = nil, action: (() -> ())? = nil) {
        blurView.isHidden = true
        alertView.isHidden = false
        alertView.bind(title: title, actionTitle: actionText, action: action)
    }

    public func start() {
        scanQueue.async {
            if !self.initiallySetUp {
                self.initiallySetUp = true

                ScanKitPermissionsHelper.performWithCameraPermission { [weak self] success in
                    if success {
                        self?.initialSetup()
                    } else {
                        self?.showAlert(title: "access_camera.message".localized, actionText: "access_camera.settings".localized) {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
            }
        }
    }

    public func startCaptureSession() {
        if let captureSession = self.captureSession, !captureSession.isRunning {
            DispatchQueue.main.async {
                captureSession.startRunning()
            }
        }
    }

    public func stop() {
        if let captureSession = captureSession, captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

}

extension ScanQrView: AVCaptureMetadataOutputObjectsDelegate {

    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {

            delegate?.didScan(string: stringValue)
        }
    }

}
