//
//  URL+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 6/3/2022.
//

import UIKit

extension URL {
    
    var attributes: [FileAttributeKey : Any]? {
        return try? FileManager.default.attributesOfItem(atPath: path)
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date //as! Date
    }
    
    var bsType: String? {
        return attributes?[.type] as? String //as! Date
    }

    func createLinkToFile(withName fileName: String) -> URL? {
        let fileManager = FileManager.default
        let tempDirectoryURL = fileManager.temporaryDirectory
        let linkURL = tempDirectoryURL.appendingPathComponent(fileName)
        do {
            if fileManager.fileExists(atPath: linkURL.path) {
                try fileManager.removeItem(at: linkURL)
            }
            try fileManager.linkItem(at: self, to: linkURL)
            return linkURL
        } catch {
            return nil
        }
    }
    
}
