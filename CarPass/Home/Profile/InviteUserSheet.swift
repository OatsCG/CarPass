//
//  InviteUserSheet.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-20.
//

import SwiftUI

struct InviteUserSheet: View {
    @Environment(User.self) var user
    @Binding var showingInviteSheet: Bool
    @State var userid: String = ""
    @State var fetchInviteUser: FetchInviteUserModel = FetchInviteUserModel()
    var body: some View {
        VStack(spacing: 35) {
            Spacer()
            TextField("User ID to Invite...", text: $userid)
                .font(.headline .weight(.medium))
                .onChange(of: userid) { oldValue, newValue in
                    userid = userid.uppercased()
                    fetchInviteUser.fetchData(userID: newValue)
                }
                .submitLabel(.done)
                .multilineTextAlignment(.center)
                .autocorrectionDisabled()
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background {
                    ZStack {
                        Capsule().fill(.backgroundsecondary)
                            .stroke(.quaternary)
                        HStack {
                            Spacer()
                            Image(systemName: "pencil")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                }
            
            Button(action: {
                user.invite_user(userID: userid)
                showingInviteSheet = false
            }) {
                if (fetchInviteUser.isFetching) {
                    CapsuleButton(text: Text("Fetching..."), lit: false, color: fetchInviteUser.userColor)
                } else if (fetchInviteUser.wasfound) {
                    CapsuleButton(text: Text("Invite **\(fetchInviteUser.username)**"), lit: true, color: fetchInviteUser.userColor)
                } else {
                    CapsuleButton(text: Text("Invite User"), lit: false, color: fetchInviteUser.userColor)
                }
            }
            .buttonStyle(.plain)
            .disabled(fetchInviteUser.isFetching || !fetchInviteUser.wasfound)
            .foregroundStyle((fetchInviteUser.isFetching || !fetchInviteUser.wasfound) ? .secondary : .primary)
            
            Spacer()
        }
        .safeAreaPadding()
        .background(.custombackground)
    }
}

@Observable class FetchInviteUserModel {
    var isFetching: Bool = false
    var wasfound: Bool = false
    var username: String = ""
    var userColor: CustomColor = .blue
    var userID: UserID = ""
    var fetchHash: UUID = UUID()
    
    func fetchData(userID: UserID) {
        self.fetchHash = UUID()
        withAnimation {
            self.isFetching = true
        }
        fetchServerEndpoint(endpoint: "getuser?id=\(userID)", fetchHash: self.fetchHash, decodeAs: FetchedUser.self) { (result, returnHash) in
            switch result {
            case .success(let data):
                if returnHash == self.fetchHash {
                    withAnimation {
                        self.username = data.name
                        self.userColor = strtocc(data.color)
                        self.userID = data.id
                        self.wasfound = true
                        self.isFetching = false
                    }
                }
                print(self.wasfound)
            case .failure(_):
                if returnHash == self.fetchHash {
                    withAnimation {
                        self.wasfound = false
                        self.isFetching = false
                    }
                }
                print(self.wasfound)
            }
        }
    }
}



#Preview {
    InviteUserSheet(showingInviteSheet: .constant(true))
}
