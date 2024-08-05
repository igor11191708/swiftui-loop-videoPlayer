//
//  URL+.swift
//
//
//  Created by Igor  on 05.08.24.
//

import Foundation

/// Validates a string as a well-formed HTTP or HTTPS URL and returns a URL object if valid.
///
/// - Parameter urlString: The string to validate as a URL.
/// - Returns: An optional URL object if the string is a valid URL.
/// - Throws: An error if the URL is not valid or cannot be created.
extension URL {
    static func validURLFromString(_ string: String) -> URL? {
        let pattern = "^(https?:\\/\\/)(([a-zA-Z0-9-]+\\.)*[a-zA-Z0-9-]+\\.[a-zA-Z]{2,})(:\\d{1,5})?(\\/[\\S]*)?$"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])

        let matches = regex?.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))

        guard let _ = matches, !matches!.isEmpty else {
            // If no matches are found, the URL is not valid
            return nil
        }
        
        // If a match is found, attempt to create a URL object
        return URL(string: string)
    }
}
