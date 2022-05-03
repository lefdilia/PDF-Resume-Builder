//
//  CreateResume.swift
//  TemplatesTest
//
//  Created by Lefdili Alaoui Ayoub on 13/12/2021.
//

import Foundation
import PDFKit


enum ResumeSize: Int, CaseIterable {
    /*
     The U.S. versions of MS Word have the default paper size set to 8.5 by 11 inches (A4).
     */
    case A4
    case USLetter
    case Legal
    case Tabloid
    
    var size: (width: CGFloat, height: CGFloat ) {
        switch self {
            
        case .A4:
            return (width: 793.92, height: 1122.24) // (8.27 x 11.69 in)
            
        case .USLetter:
            return (width: 816, height: 1056) // (8.5 x 11 in)
            
        case .Legal:
            return (width: 816, height: 1344) // (8.5 x 14.0 in)
            
        case .Tabloid:
            return (width: 1056, height: 1632) // (11.0 x 17.0 in)
        }
    }
    
    var title : String {
        switch self {
        case .A4:
            return "A4"
            
        case .USLetter:
            return "US Letter"
            
        case .Legal:
            return "Legal"
            
        case .Tabloid:
            return "Tabloid"

        }
    }
}

enum Templates {
    case Cascade(size: ResumeSize, imageType: ImageType, font: Fonts, colorOptions: TemplatesColors, data: ResumeData?)
    case Enfold(size: ResumeSize, imageType: ImageType, font: Fonts, colorOptions: TemplatesColors, data: ResumeData?)
}

func usedTemplate(template: Templates, isScrollEnabled: Bool = false) -> UIView {
    switch template {
    case .Cascade(size: let size, imageType: let imageType, font: let font, colorOptions: let colorOptions, data: let data):
        let bsg = CascadeTemplate(size: size, imageType: imageType, font: font, colorOptions: colorOptions, data: data)
        bsg.scrollView.showsVerticalScrollIndicator = false
        bsg.scrollView.isScrollEnabled = isScrollEnabled
        return bsg
        
    case .Enfold(size: let size, imageType: let imageType, font: let font, colorOptions: let colorOptions, data: let data):
        let bsg = EnfoldTemplate(size: size, imageType: imageType, font: font, colorOptions: colorOptions, data: data)
        bsg.scrollView.isScrollEnabled = isScrollEnabled
        bsg.scrollView.showsVerticalScrollIndicator = false
        return bsg
    }
}

class CreateResume {
    
    static var shared = CreateResume()
    
    func generate(scrollView: UIScrollView, filename: String? = nil , completion: (URL?, Error?)->() ) -> Void {
        
        var _filename = filename ?? UUID().uuidString
        
        let path = URL(fileURLWithPath: _filename).pathExtension
        if path.isEmpty || path != "pdf" {
            _filename = "\(_filename).pdf"
        }
        
        let pdfMetaData = [
            kCGPDFContextTitle : "\(filename ?? "Lefdili Alaoui Ayoub") (Resume)",
            kCGPDFContextSubject: Bundle.main.appName,
            kCGPDFContextCreator: Bundle.main.appName,
            kCGPDFContextAuthor: "lefdilia@gmail.com"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(origin: .zero, size: scrollView.contentSize)
        scrollView.clipsToBounds = false
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
                
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let outputFileURL = documentDirectory.appendingPathComponent(_filename)
                
        do {
            
            try renderer.writePDF(to: outputFileURL, withActions: { (context) in
                context.beginPage()
                let _context = context.cgContext
                
                scrollView.layer.render(in: _context)
                scrollView.clipsToBounds = true
                
                completion(outputFileURL, nil)
            })

        } catch {
            let error = "Could not create PDF file: \(error.localizedDescription)"
            completion(nil, error as? Error)
        }
        
    }
    
    func PDFToImage(url: URL, withName: String? = nil) -> URL? {
        
        guard let document = PDFDocument(url: url) else {
            return nil }     // Instantiate a `CGPDFDocument` from the PDF file's URL.
        
        guard let page = document.page(at: 0) else { return nil }  // Get the first page of the PDF document.
        let pageRect = page.bounds(for: .mediaBox)     // Fetch the page rect for the page we want to render.
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(CGRect(x: 0, y: 0, width: pageRect.width, height: pageRect.height))
            ctx.cgContext.translateBy(x: -pageRect.origin.x, y: pageRect.size.height - pageRect.origin.y)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            page.draw(with: .mediaBox, to: ctx.cgContext)
        }
        
        if let data = img.jpegData(compressionQuality: 0.8) {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            
            let outputFileURL = documentDirectory.appendingPathComponent("\(withName ?? UUID().uuidString).png")
                        
            do {
                try data.write(to: outputFileURL)
            } catch {}
            
            return outputFileURL
        }
        
        return nil
    }
    
}
