//
//  WalkThroughViewController.swift
//  OctoEye
//
//  Created by mzp on 2017/08/06.
//  Copyright © 2017 mzp. All rights reserved.
//

import EAIntroView
import Ikemen
import UIKit

internal class WalkThroughViewController: UIViewController, EAIntroDelegate {
    private var rippleView: SMRippleView?
    private let ripplePoints: [UInt:CGPoint] = [
        1: CGPoint(x: 257, y: 187),
        2: CGPoint(x: 224, y: 267)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let page1 = page(title: "Empower Files with Github",
                         imageName: "introduction",
                         description: """
                            OctoEye allow files to access repositories hosted on Github.
                            And more, other apps can access via file open dialog.
                         """.replacingOccurrences(of: "\n", with: ""))

        let page2 = page(title: "Add favorited repositories",
                         imageName: "repositories",
                         description: """
                            You can add your own repositories, or started repositories,
                            or any repositories which you can access.
                         """.replacingOccurrences(of: "\n", with: ""))

        let page3 = page(title: "Github location is available",
                         imageName: "location",
                         description: """
                            Github location is available on Files.
                            The location contains all your favorited repositories.
                         """)

        view.backgroundColor = UIColor.white
        let introView = EAIntroView(frame: view.frame, andPages: [page1, page2, page3])
        introView?.bgViewContentMode = .center
        introView?.skipButton.setTitleColor(UIColor.black, for: .normal)
        introView?.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        introView?.pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.6642268896, green: 0.6642268896, blue: 0.6642268896, alpha: 1)
        introView?.delegate = self
        introView?.show(in: view, animateDuration: 0.0)
    }

    private func page(title: String, imageName: String, description: String) -> EAIntroPage {
        return EAIntroPage() ※ {
            $0.title = title
            $0.desc = description
            $0.titleColor = UIColor.black
            $0.descColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 0.8)
            $0.bgColor = UIColor.white
            $0.bgImage = UIImage(named: imageName)
        }
    }

    // MARK: - EAIntroDelegate
    // swiftlint:disable:next implicitly_unwrapped_optional
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        let viewController = LoginViewController()
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true) {}
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    func intro(_ introView: EAIntroView!, pageAppeared page: EAIntroPage!, with pageIndex: UInt) {
        NSLog("pageAppered")
        self.rippleView?.stopAnimation()
        self.rippleView?.removeFromSuperview()

        guard let point = hintPoint(introView, pageIndex: pageIndex) else {
            return
        }
        let v = SMRippleView(frame: CGRect(origin: point,
                                           size: CGSize(width: 44, height: 44)),
                             color: #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 0.2),
                             interval: 2,
                             duration: 4)
        view.addSubview(v)

        rippleView = v
    }

    private func hintPoint(_ introView: EAIntroView, pageIndex: UInt) -> CGPoint? {
        guard let point = ripplePoints[pageIndex] else {
            return nil
        }
        guard let page = introView.pages[Int(pageIndex)] as? EAIntroPage else {
            return nil
        }
        let parentSize = view.bounds.size
        let imageSize = page.bgImage.size
        return point.applying(
            CGAffineTransform(translationX: parentSize.width / 2 - imageSize.width / 2,
                              y: parentSize.height / 2 - imageSize.height / 2))
    }
}
