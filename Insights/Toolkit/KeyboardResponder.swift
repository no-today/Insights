//
//  KeyboardResponder.swift
//  Insights
//
//  Created by whoog on 2024/5/26.
//

import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0 {
        didSet {
            print(currentHeight)
        }
    }
    
    private var cancellable: AnyCancellable?

    init() {
        self.cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in
                rect.height
            }
            .assign(to: \.currentHeight, on: self)
    }

    deinit {
        self.cancellable?.cancel()
    }
}
