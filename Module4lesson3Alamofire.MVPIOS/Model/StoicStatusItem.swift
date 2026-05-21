import Foundation

class BaseUrlResponse {
    static let baseURL = "https://stoic.tekloon.net/stoic-quote"
}

struct StoicQuoteResponse: Decodable {
    let data: StoicQuote
    
    init(data: StoicQuote = StoicQuote()) {
        self.data = data
    }
}

struct StoicQuote: Decodable {
    let author: String
    let quote: String
    
    init(author: String = "", quote: String = "") {
        self.author = author
        self.quote = quote
    }
}
