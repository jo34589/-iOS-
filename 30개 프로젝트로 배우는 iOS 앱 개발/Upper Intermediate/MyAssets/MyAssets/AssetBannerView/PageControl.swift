//
//  PageControl.swift
//  MyAssets
//
//  Created by 엔나루 on 2022/04/28.
//

import SwiftUI
import UIKit

struct PageControl: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    typealias UIViewType = UIPageControl
    
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(_:)),
            for: .valueChanged)
        
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    class Coordinator: NSObject{
        var control: PageControl
        init(_ control: PageControl) {
            self.control = control
        }
        
        @objc func updateCurrentPage(_ sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}
