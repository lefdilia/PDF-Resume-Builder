//
//  ContextMenu.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 25/2/2022.
//

import Foundation
import UIKit
import CloudKit


protocol ContextMenu {
    
    func performEdit()
    func performDownload()
    func performPreview()
    func performShare()
    func performDelete()

}

extension ContextMenu {
    
    func editAction() -> UIAction {
        return UIAction(title: "Edit", image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis")) { _ in
            self.performEdit()
        }
    }
    
    func downloadAction() -> UIAction {
        return UIAction(title: "Download", image: UIImage(systemName: "arrow.down.circle")) { _ in
            self.performDownload()
        }
    }
    
    func previewAction() -> UIAction {
        return UIAction(title: "Preview", image: UIImage(systemName: "doc.text.magnifyingglass")) { _ in
            self.performPreview()
        }
    }
    
    func shareAction() -> UIAction {
        return UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            self.performShare()
        }
    }
    
    func deleteAction() -> UIAction {
        return UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.performDelete()
        }
    }
    
}
