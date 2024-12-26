package ru.skillfactory.userservice;

import io.grpc.stub.StreamObserver;
import net.devh.boot.grpc.server.service.GrpcService;

import java.util.HashMap;
import java.util.UUID;

@GrpcService
public class UserService extends UserServiceGrpc.UserServiceImplBase {

    private static final HashMap<String, UserResponse> users = new HashMap<>();

    @Override
    public void createUser(CreateUserRequest request, StreamObserver<UserResponse> responseObserver) {
        String userId = UUID.randomUUID().toString();

        UserResponse response = UserResponse.newBuilder()
                .setUserId(userId)
                .setName(request.getName())
                .setEmail(request.getEmail()).build();

        users.put(userId, response);

        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void getUser(GetUserRequest request, StreamObserver<UserResponse> responseObserver){
        UserResponse response = users.get(request.getUserId());

        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}
