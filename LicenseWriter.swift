import Foundation

class LicenseWriter {

    struct License {
        let libraryName: String
        let legalText: String

        var title: String {
            return libraryName
        }

        var body: String {
            return legalText
        }
    }

    static let header: String = """
<html><head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width,minimum-scale=1,maximum-scale=1">
    </head>
"""
    static let footer: String = "</html>"

    func getLicense(_ URL: URL) throws -> License {
        let legalText = try String(contentsOf: URL, encoding: String.Encoding.utf8)
        let pathComponents = URL.pathComponents
        let libraryName = pathComponents[pathComponents.count - 2]
        return License(libraryName: libraryName, legalText: legalText)
    }

    func transform(_ license: License) -> String {
        return "<p class='licenseTitle'>\(license.title)</p><p class='licenseBody'>\(license.body)</p>"
    }


    func run() throws {
        let cocoaPodsDir = "Pods/"
        let outputFile = "LICENSES.html"
        let options: FileManager.DirectoryEnumerationOptions = [.skipsPackageDescendants, .skipsHiddenFiles]

        let fileManager = FileManager.default

        guard
            let cocoaPodsDirURL = URL(string: cocoaPodsDir),
            let cocoaPodsEnumerator = fileManager.enumerator(at: cocoaPodsDirURL,
                                                             includingPropertiesForKeys: nil,
                                                             options: options)
        else {
            print("Error: \(cocoaPodsDir) directory not found.")
            return
        }

        guard
            let cocoaPodsURLs = cocoaPodsEnumerator.allObjects as? [URL]
        else {
            print("Unexpected error: Enumerator contained item that is not NSURL.")
            return
        }

        let licenseURLs = cocoaPodsURLs.filter { URL in
            return URL.lastPathComponent.range(of: "LICENSE") != nil ||
                URL.lastPathComponent.range(of: "LICENCE") != nil
        }

        let licenses = licenseURLs.compactMap { try? getLicense($0) }

        // Write each License into outputFile after converting them to HTML

        var html = type(of: self).header
        html.append(
            licenses
            .sorted { return $0.title.compare($1.title) == .orderedAscending }
            .map { transform($0) }
            .joined(separator: "\n")
        )
        html.append(type(of: self).footer)
        
        try html.write(toFile: outputFile, atomically: false, encoding: String.Encoding.utf8)
    }
}

func main() {
    do {
        try LicenseWriter().run()
    } catch let error as NSError {
        print(error.localizedDescription)
    }
}

main()
