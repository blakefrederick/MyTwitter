import Foundation
import FirebaseFirestore

struct Post: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let text: String
    let imageUrl: String
    let timestamp: Date
}
