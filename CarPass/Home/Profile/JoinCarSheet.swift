//
//  JoinCarSheet.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-20.
//

import SwiftUI

struct JoinCarSheet: View {
    @Environment(User.self) var user
    @Binding var showingJoinSheet: Bool
    @State var carid: String = ""
    @State var fetchInviteUser: FetchInviteCarModel = FetchInviteCarModel()
    @State var showingNewCarAlert: Bool = false
    var body: some View {
        VStack(spacing: 35) {
            Spacer()
            TextField("Car ID to Join...", text: $carid)
                .font(.headline .weight(.medium))
                .onChange(of: carid) { oldValue, newValue in
                    carid = carid.uppercased()
                    fetchInviteUser.fetchData(carID: newValue)
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
                user.force_accept_invite(carID: carid)
                showingJoinSheet = false
            }) {
                if (fetchInviteUser.isFetching) {
                    CapsuleButton(text: Text("Fetching..."), lit: false, color: .red)
                } else if (fetchInviteUser.wasfound) {
                    CapsuleButton(text: Text("Join **\(fetchInviteUser.carname)**"), lit: false, color: .red)
                } else {
                    CapsuleButton(text: Text("Join Car"), lit: false, color: .red)
                }
            }
            .buttonStyle(.plain)
            .disabled(fetchInviteUser.isFetching || !fetchInviteUser.wasfound)
            .foregroundStyle((fetchInviteUser.isFetching || !fetchInviteUser.wasfound) ? .secondary : .primary)
            Button(action: {
                showingNewCarAlert = true
            }) {
                CapsuleButton(text: Text("New Car..."), lit: false, color: .red)
            }
            .buttonStyle(.plain)
            .alert(isPresented: $showingNewCarAlert) {
                Alert(
                    title: Text("Do you want to leave your current car and start a new car?"),
                    primaryButton: .default(Text("Yes")) {
                        //user.update_ihavecar()
                        user.new_car_for_me()
                        showingJoinSheet = false
                    },
                    secondaryButton: .cancel()
                )
            }
            Spacer()
        }
        .safeAreaPadding()
        .background(.custombackground)
    }
}

@Observable class FetchInviteCarModel {
    var isFetching: Bool = false
    var wasfound: Bool = false
    var carname: String = ""
    var carID: CarID = ""
    var fetchHash: UUID = UUID()
    
    func fetchData(carID: CarID) {
        self.fetchHash = UUID()
        withAnimation {
            self.isFetching = true
        }
        fetchServerEndpoint(endpoint: "getcar?id=\(carID)", fetchHash: self.fetchHash, decodeAs: FetchedCar.self) { (result, returnHash) in
            switch result {
            case .success(let data):
                if returnHash == self.fetchHash {
                    withAnimation {
                        self.carname = data.name
                        self.carID = data.id
                        self.wasfound = true
                        self.isFetching = false
                    }
                }
            case .failure(_):
                if returnHash == self.fetchHash {
                    withAnimation {
                        self.wasfound = false
                        self.isFetching = false
                    }
                }
            }
        }
    }
}


#Preview {
    //testview()
    ProfileSheet(showingProfileSheet: .constant(true))
        .environment(User())
}
